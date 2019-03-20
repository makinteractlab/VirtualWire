#ifndef __WIFI__H__
#define __WIFI__H__

#include <Arduino.h>

class Wifi
{
    private:
    int status;

    void printWifiData();
    void printCurrentNet();
    
    public: 
    Wifi();
    void init(int baudRate);
    void connect(const char *ssid, const char *password);
    void connect(const String ssid, const String password);
    void printWifiStats();
    inline int getStatus (){ return status; }
};

#endif