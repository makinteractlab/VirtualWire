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

        void init (SwitchArray* const switchArray, TimerCallback call);
        void parseCommand (const String& msg, WiFiEspClient* const client);
        void blinkStatusLed(uint16_t times=1, uint16_t ms=1000);
        
        // DAC
        void setVoltage (uint16_t milliVolt);
        void setWave (WAVE type, uint16_t freq, uint16_t amplitudeMv);
        void startWave();
        void stopWave();
        void timerTick(); 

    private:
       
        void ackError (WiFiEspClient* const client);
        void ackOk (WiFiEspClient* const client);

        AppManager();  
        SwitchArray* sa;

        // DAC
        TimerCallback timerCallback;
        WAVE type;
        uint16_t period, amplitude, offset;

    public:
        // Do not implement
        AppManager(AppManager const&)      = delete;
        void operator=(AppManager const&)  = delete;
};


#endif