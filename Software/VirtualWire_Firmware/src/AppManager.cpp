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

bool AppManager::parseCommand(const String &msg, Stream *const client)
{
    StaticJsonDocument<BUFFER_SIZE> json;
    DeserializationError error = deserializeJson(json, msg);

    // Test if parsing succeeds.
    if (error)
    {
        // Serial.print(F("JSON parse fail"));
        ack (client, "JSON parse fail");
        return false;
    }

    // Parse JSON
    if (json["cmd"] == F("connect") || json["cmd"] == F("disconnect"))
    {
        if (!json.containsKey("data")) 
        {
            ack(client,"NoData");
            return false;
        }
        
        JsonArray data = json["data"].as<JsonArray>();
        uint16_t sz = data.size();

        if (sz & 1) // Error: odd number of elements in the array
        {
            ack (client, "JSON parse fail");
            return false;
        }
        for (uint16_t i = 0; i < sz; i += 2)
        {
            bool result = false;
            if (json["cmd"] == F("connect"))
                result = sa->connect(data[i].as<String>(), data[i + 1].as<String>());
            else
                result = sa->disconnect(data[i].as<String>(), data[i + 1].as<String>());

            if (!result) // not ok
            {
                ack (client, "JSON parse fail");
                return false;
            }
        }
            
        sa->update();
        ack (client, "OK");
        
    }
    else if (json["cmd"] == F("status"))
    {
        if (!json.containsKey("data")) 
        {
            ack(client,"NoData");
            return  false;
        }
        JsonArray data = json["data"].as<JsonArray>();
        uint16_t sz = data.size();

        if (sz != 2) // Error: only pairs are ok
        {
            ack (client, "JSON parse fail");
            return false;
        }

        bool result = sa->areConnected(data[0].as<String>(), data[1].as<String>());
        if (result) ack (client, "Connected");
        else ack (client, "Disconnected");
    }
    else if (json["cmd"] == F("reset"))
    {
        sa->reset();
        ack(client, "OK");
    
    }else if (json["cmd"] == F("dac")){
        if (!json.containsKey("data")) 
        {
            ack(client,"NoData");
            return false;
        }
        setVoltage (json["data"].as<int>());
        ack(client,"OK");

    }else if (json["cmd"] == F("adc")){
        uint32_t volt= readVoltage();
        sendValue (client, volt);
        
    } else
    {
        ack(client,"Parse Fail");
        return false;
    }

    // all cases left
    return true;
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

void AppManager::ack(Stream *const client,  const String& msg)
{
    if (!client) return;
    String tosend= "{\"ack\":\"" + msg + "\"}\n";
    client->print(tosend);
    blinkStatusLed(3, 500);
}

void AppManager::sendValue(Stream *const client,  uint32_t value)
{
    if (!client) return;
    String tosend= "{\"value\":\"" + String(value) + "\"}\n";
    client->print(tosend);
    blinkStatusLed(3, 500);
}

void AppManager::setVoltage(uint16_t milliVolt)
{
    analogWrite(DAC_PIN, map(milliVolt, 0, VOLT_MAX, 0, DAC_MAX));
}


uint16_t AppManager::readVoltage()
{
    return map(analogRead (ADC_PIN), 0, ADC_MAX, 0, VOLT_MAX);
}