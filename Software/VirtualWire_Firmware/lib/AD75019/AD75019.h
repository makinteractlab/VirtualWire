/*
  AD75019.h - Library for controlling AD75019 Crosspoint switch pairs
  Created by Andrea Bianchi, April 16 2018.
*/

#ifndef AD75019_h
#define AD75019_h

#include "Arduino.h"
#define MATRIX_SIZE 16
#define NONE -1
#define OFF 0
#define ON 1

class AD75019
{
  private:
    byte pclk, sclk, sin;
    bool updatable;
    unsigned int connections [MATRIX_SIZE]; // 2 bytes x 16

    void resetMatrix();

  public:
    AD75019 (byte pclkPin, byte sclkPin, byte sinPin);
    AD75019 (byte sclkPin, byte sinPin); // this cannot udpate
    
    void connect (byte x, byte y);
    void twoWaysConnect (byte x, byte y);
    void disconnect (byte x, byte y);
    void twoWaysDisonnect (byte x, byte y);
    bool areConnected (byte x, byte y);

    void closeAllSwitches();
    void writeSwitches();
    void updateSwitches();
    // void dbg();
};

#endif