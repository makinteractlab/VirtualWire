#include "AppManager.hpp"
#include "ArduinoJson.h"
#include "MsTimer2.h"
#include "functionGenerator.h"

AppManager::AppManager() : type(SIN_WAVE), period(1000), amplitude(0), offset(0)
{
    pinMode(STATUS_LED, OUTPUT);
    analogWriteResolution(DAC_RESOLUTION);
}

void AppManager::init(SwitchArray *const switchArray, TimerCallback call)
{
    sa = switchArray;
    timerCallback= call;
}

void AppManager::parseCommand(const String &msg, WiFiEspClient *const client)
{
    StaticJsonDocument<BUFFER_SIZE> json;
    DeserializationError error = deserializeJson(json, msg);

    // Test if parsing succeeds.
    if (error)
    {
        // Serial.print(F("JSON parse fail"));
        if (client)
            client->print("JSON parse fail\r\n");
        return;
    }
    //  Serial.println(msg);

    // Parse JSON
    if (json["cmd"] == F("connect") || json["cmd"] == F("disconnect"))
    {
        JsonArray data = json["data"].as<JsonArray>();
        uint16_t sz = data.size();

        if (sz & 1) // Error: odd number of elements in the array
        {
            ackError(client);
            return;
        }
        for (uint16_t i = 0; i < sz; i += 2)
        {
            bool result = false;
            if (json["cmd"] == F("connect"))
                result = sa->connect(data[i].as<int>(), data[i + 1].as<int>());
            else
                result = sa->disconnect(data[i].as<int>(), data[i + 1].as<int>());

            if (result) // ok
            {
                sa->update();
                ackOk(client);
            }
            else
            {
                ackError(client);
            }
        }
    }
    else if (json["cmd"] == F("reset"))
    {
        sa->reset();
        ackOk(client);
    }
    else
    {
        ackError(client);
    }
}

void AppManager::blinkStatusLed(uint16_t times, uint16_t ms)
{
    for (uint16_t i = 0; i < times; i++)
    {
        digitalWrite(STATUS_LED, HIGH);
        delay(ms);
        digitalWrite(STATUS_LED, LOW);
        delay(ms);
    }
}

void AppManager::ackError(WiFiEspClient *const client)
{
    if (!client)
        return;
    client->print(F("ERR\r\n"));
    blinkStatusLed(3, 500);
}

void AppManager::ackOk(WiFiEspClient *const client)
{
    if (!client)
        return;
    client->print(F("OK\r\n"));
    blinkStatusLed(1, 500);
}

void AppManager::setVoltage(uint16_t milliVolt)
{
    analogWrite(DAC_PIN, map(milliVolt, 0, VOLT_MAX, 0, DAC_MAX));
}

void AppManager::setWave(WAVE type, uint16_t freq, uint16_t amplitudeMvPP)
{
    this->type = type;
    if (freq < MIN_FREQ) freq= MIN_FREQ;
    if (freq > MAX_FREQ) freq= MAX_FREQ;
    period = 1000/freq;

    amplitude = amplitudeMvPP/2;
    if (amplitude > VOLT_MAX_HALF) amplitude= VOLT_MAX_HALF;

    offset = amplitude;
}

void AppManager::startWave()
{
    if (timerCallback)
    {
        MsTimer2::set(DAC_TICK_MS, timerCallback);
        MsTimer2::start();
    }
}
void AppManager::stopWave()
{
    MsTimer2::stop();
}

void AppManager::timerTick()
{
    uint32_t now = millis() % period;
    float val = 0;
    switch (type)
    {
    case SQUARE_WAVE:
        val = fgsqr(now, period);
        break;
    case SAW_WAVE:
        val = fgsaw(now, period);
        break;
    case TRIANGLE_WAVE:
        val = fgtri(now, period);
        break;
    case SIN_WAVE:
        val = fgsin(now, period);
        break;
    }
    
    // transform value
    val = offset + amplitude* val;
    analogWrite (DAC_PIN, (int)val);
}
