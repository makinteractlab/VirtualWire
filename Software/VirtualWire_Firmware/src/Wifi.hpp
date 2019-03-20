#ifndef __WIFI__H__
#define __WIFI__H__

#include "WiFiEsp.h"


class Wifi
{
    private:
    int status;

    void printWifiData();
    void printCurrentNet();
    
    public: 
    Wifi();
    void init(int baudRate);
    void connect(char *ssid, char *password);
    void connect(String ssid, String password);
    void printWifiStats();
    inline int getStatus (){ return status; }
};

#endif