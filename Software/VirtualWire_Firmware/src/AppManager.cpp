#include "AppManager.hpp"
#include "ArduinoJson.h"

AppManager::AppManager() 
{
    pinMode(STATUS_LED, OUTPUT);
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
        if (client) client->print("JSON parse fail\r\n");
        return;
    }
    Serial.println(msg);

    JsonArray array = json["data"].as<JsonArray>();
    JsonObject start= array.getElement(0);
    JsonVariant value = start["type"];
    Serial.println (value.as<String>());


    // Example
    // {"cmd":"c|d", "from":"P1", "to":"P2"}
    // c = connect, d= disconnect
    // String from = json["c"][0];
    // String to = json["c"][1];
    // Serial.println(from);
    // Serial.println(to);
}


void AppManager::blinkStatusLed(uint16_t times, uint16_t ms)
{
  for (uint16_t i=0; i<times; i++)
  {
    digitalWrite(STATUS_LED, HIGH);
    delay(ms);
    digitalWrite(STATUS_LED, LOW);
    delay(ms);
  }
}


// Command input
/*


void CommandInput::executeCommand(const String &str, Stream *stream)
{
    StaticJsonDocument<200> doc;
    uint8_t ii[] = {223, 0, 0, 0, 1, 165, 113, 117, 101, 114, 121, 169, 116, 101, 115, 116, 65, 103, 97, 105, 110};

    Serial.println("testint");
    DeserializationError error = deserializeMsgPack(doc, ii);// deserializeJson(doc, input.c_str());
    // stream->println(input);


    // Test if parsing succeeds.
    if (error)
    {
        stream->println(F("{\"Status\":\"Parse ERR\"}"));
        Serial.println(error.c_str());
        clearInput();
        return;
    }

    const char *a = doc["query"];
     stream->println(a);
     clearInput();

         // if (!root.success())
         //     stream->println(F("{\"Status\":\"Parse ERR\"}"));
         // else if (root["query"] == "info")
         //     stream->println(F("Info requested"));
         //     handleBoardInfo(root, stream); // info
         // else if (root["query"] == "V")
         //     readVoltage(root, stream); // voltage
         // else if (root["set"] == "Rst")
         //     handleReset(root, stream); // rset
         // else if (root["set"] == "X")
         //     handleConnection(root, stream); // connection
         // else if (root["set"] == "X2")
         //     handleDoubleConnection(root, stream); // connection
         // else if (root["set"] == "R")
         //     handleResistor(root, stream); // res
         // else if (root["set"] == "C")
         //     handleCapacitor(root, stream); // cap
         // else if (root["set"] == "L")
         //     handleInductor(root, stream); // inductor

         // clean input
         input = "";
}

void CommandInput::handleBoardInfo(const JsonObject &in, Stream *stream)
{
// #ifdef DEBUG
//     Serial.println(F("Info"));
// #endif
//     stream->print(F("{\"BoardID\":\""));
//     stream->print(getBoardID());
//     stream->println(F("\"}"));
}


void CommandInput::handleConnection(const JsonObject &in, Stream *stream)
{
// #ifdef DEBUG
//     Serial.println(F("Connection"));
// #endif
//     boolean on = in["on"] == 1;
//     int moduloPin = in["M"];
//     int boardPin = in["B"];

//     if (on)
//     {
//         m.connect(moduloPin, boardPin);
//     }
//     else
//     {
//         m.disconnect(moduloPin, boardPin);
//     }
//     m.update();

//     stream->println(F("{\"Status\":\"Ok\"}"));
}


*/