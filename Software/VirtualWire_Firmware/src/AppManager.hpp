#ifndef __APP_MANAGER__H__
#define __APP_MANAGER__H__

#include <Arduino.h>
#include "SwitchArray.hpp"
#include "WiFiEsp.h"
#include "constants.hpp"

enum WAVE {SQUARE_WAVE, SIN_WAVE, TRIANGLE_WAVE, SAW_WAVE};
typedef void (*TimerCallback)();


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
        
        // DAC
        void setVoltage (uint16_t milliVolt);
        uint16_t readVoltage ();


    private:
       
        void ackError (WiFiEspClient* const client);
        void ackOk (WiFiEspClient* const client);

        AppManager();  
        SwitchArray* sa;

    public:
        // Do not implement
        AppManager(AppManager const&)      = delete;
        void operator=(AppManager const&)  = delete;
};


#endif