#ifndef __WIFI__H__
#define __WIFI__H__

#include <Arduino.h>
#include "WiFiEsp.h"

// Define the callback
typedef void (*MsgReadyCallback)(const String&, WiFiEspClient* const);

class IP
{
    public:
    uint8_t p1, p2, p3, p4;
    IP (uint8_t a, uint8_t b, uint8_t c, uint8_t d): p1(a), p2(b), p3(c), p4(d) {}
};


class Wifi
{
    public:
        inline static Wifi& getInstance()
        {
            static Wifi instance;
            return instance;
        }

        void init(const char* ssid, const IP& ip);
        void printWifiStats();
        void listenToRequets();

        Wifi& baud(uint32_t baudRate);
        Wifi& port(uint16_t portNum);
        Wifi& debug(boolean d);
        Wifi& registerMsgReadyCallback (const MsgReadyCallback cb);

    private:
        uint16_t status, portNum;
        uint32_t baudRate;
        bool debugOn;
        WiFiEspServer server;
        String buffer;
        MsgReadyCallback callbackEvent;

        Wifi();       
        void printWifiData();
        void printCurrentNet();

    public:
        // Do not implement
        Wifi(Wifi const&)            = delete;
        void operator=(Wifi const&)  = delete;
};

#endif