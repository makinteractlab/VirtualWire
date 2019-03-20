/*
  AD75019.h - Library for controlling AD75019 Crosspoint switch pairs
  Created by Andrea Bianchi, April 16 2018.
*/

#ifndef AD75019_h
#define AD75019_h

#include "Arduino.h"
// Matrix size
#define MSIZE 16


class AD75019
{
  private:
    byte pclk, sclk, sin;
    unsigned int connections [MSIZE]; // 2 bytes x 16
    static const unsigned int NONE= 0;  

  public:
    AD75019 (byte pclkPin, byte sclkPin, byte sinPin);
    void reset();
    void connect (byte x, byte y);
    void twoWaysConnect (byte x, byte y);
    void disconnect (byte x, byte y);
    void twoWaysDisonnect (byte x, byte y);
    bool areConnected (byte x, byte y);

    inline byte size(){ return MSIZE; }
    void writeSwitches();
    void updateSwitches();
    void dbg();
    void closeAllSwitches();
};

#endif