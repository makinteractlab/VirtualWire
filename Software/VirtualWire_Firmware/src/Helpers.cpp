#include "Helpers.hpp"
#include <EEPROMex.h>
#include <ArduinoJson.h>

InternalMemory::InternalMemory(byte memBase, byte memSize, byte maxWrite) : writeSize(maxWrite)
{
    EEPROM.setMemPool(memBase, memSize);
    EEPROM.setMaxAllowedWrites(writeSize);
    ssidAddr = EEPROM.getAddress(sizeof(char) * writeSize);
    passAddr = EEPROM.getAddress(sizeof(char) * writeSize);
}

void InternalMemory::saveSSID(char ssid[])
{
    EEPROM.writeBlock<char>(ssidAddr, ssid, writeSize);
}

void InternalMemory::savePW(char pass[])
{
    EEPROM.writeBlock<char>(passAddr, pass, writeSize);
}

String InternalMemory::getSSID()
{
    char output[writeSize];
    EEPROM.readBlock<char>(ssidAddr, output, writeSize);
    return String(output);
}

String InternalMemory::getPW()
{
    char output[writeSize];
    EEPROM.readBlock<char>(passAddr, output, writeSize);
    return String(output);
}




// Command input

CommandInput::CommandInput(const SwitchArray &mt, const byte bufferSize): 
                            m(mt), input(""), jsonBufferSize(bufferSize) {}


bool CommandInput::updateInput(char inChar)
{
    if (inChar == '\n')
        return true;
    input += inChar;
    if (input.length() > jsonBufferSize)
        return true;
    return false;
}

void CommandInput::clearInput()
{
    input="";
}

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
