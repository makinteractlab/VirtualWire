#ifndef __HELPERS__H__
#define __HELPERS__H__

#include <Arduino.h>
#include <ArduinoJson.h>
#include "SwitchArray.hpp"

class InternalMemory
{

    private:
    byte ssidAddr, passAddr, writeSize;

    public:
      InternalMemory(byte memBase, byte memSize, byte maxWrite);
      void saveSSID(char ssid[]);
      void savePW(char ssid[]);
      String getSSID();
      String getPW();
};


class CommandInput
{
  public:
    CommandInput(const SwitchArray &mt, const byte bufferSize);
    bool updateInput(char inChar);
    void executeCommand(const String &str, Stream *stream);
    void clearInput();

  private:
    void handleBoardInfo(const JsonObject &in, Stream *stream);
    void handleConnection(const JsonObject &in, Stream *stream);
   

    SwitchArray m;
    String input;
    byte jsonBufferSize;
};

#endif