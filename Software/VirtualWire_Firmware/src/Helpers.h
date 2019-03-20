#ifndef __HELPERS__H__
#define __HELPERS__H__

#include <Arduino.h>

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

#endif