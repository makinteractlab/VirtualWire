#ifndef __APP_MANAGER__H__
#define __APP_MANAGER__H__

#include <Arduino.h>
#include "SwitchArray.hpp"
#include "WiFiEsp.h"
#include "constants.hpp"


class AppManager
{
    public:
        inline static AppManager& getInstance()
        {
            static AppManager instance;
            return instance;
        }

        void init (SwitchArray* const switchArray);
        void parseCommand (const String& msg, WiFiEspClient* const client);
        void blinkStatusLed(uint16_t times=1, uint16_t ms=1000);
      
    private:
       
        AppManager();  
        SwitchArray* sa;

    public:
        // Do not implement
        AppManager(AppManager const&)            = delete;
        void operator=(AppManager const&)  = delete;
};



/*
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
*/
#endif