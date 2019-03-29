#include "AppManager.hpp"
#include "ArduinoJson.h"


AppManager::AppManager()
{
    pinMode(STATUS_LED, OUTPUT);
    analogWriteResolution(DAC_RESOLUTION);
    analogReadResolution(ADC_RESOLUTION);
}

void AppManager::init(SwitchArray *const switchArray)
{
    sa = switchArray;
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
    
    }else if (json["cmd"] == F("dac")){
        setVoltage (json["data"].as<int>());
        ackOk(client);

    }else if (json["cmd"] == F("adc")){
        uint32_t volt= readVoltage();
        client->print (volt);
        client->print("\r\n");
        
    }else if (json["cmd"] == F("")){

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


uint16_t AppManager::readVoltage()
{
    return map(analogRead (ADC_PIN), 0, ADC_MAX, 0, VOLT_MAX);
}