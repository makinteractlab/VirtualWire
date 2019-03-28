/*
  SwitchMatrix.hpp - Library for controlling AD75019 Crosspoint switch pairs
  Created by Andrea Bianchi, April 16 2018.
*/

#ifndef __SWITCHMATRIX__H__
#define __SWITCHMATRIX__H__

#include "Arduino.h"

#define MATRIX_SIZE 16
#define NONE -1
#define OFF 0
#define ON 1


template <uint8_t N_CHIPS>
class SwitchMatrix
{
  private:
    uint8_t pclk, sclk, sin;
    // CONNECTIONS = 2 bytes (uint16_t) x 16 (slots) x N_CHIPS in chain
    static const uint8_t CONNECTIONS = MATRIX_SIZE * N_CHIPS;
    uint16_t connections [CONNECTIONS];
    void resetMatrix();
    void oneWayDisconnect (const uint8_t& x, const uint8_t& y, const uint8_t& chipNumber = 0);

  public:
    SwitchMatrix (const uint8_t& pclkPin, const uint8_t& sclkPin, const uint8_t& sinPin);

    void closeAllSwitches();
    void update();
    
    bool areConnected(const uint8_t& x, const uint8_t& y, const uint8_t& chipNumber = 0);
    void connect (const uint8_t& x, const uint8_t& y, const uint8_t& chipNumber = 0);
    void twoWaysConnect (const uint8_t& x, const uint8_t& y, const uint8_t& chipNumber = 0);
    void disconnect (const uint8_t& x, const uint8_t& y, const uint8_t& chipNumber = 0);

    // void dbg();
};





template <uint8_t N_CHIPS>
SwitchMatrix<N_CHIPS>::SwitchMatrix(const uint8_t& pclkPin, const uint8_t& sclkPin, const uint8_t& sinPin) : pclk(pclkPin), sclk(sclkPin), sin(sinPin)
{
  pinMode(pclk, OUTPUT);
  pinMode(sclk, OUTPUT);
  pinMode(sin, OUTPUT);
  closeAllSwitches();
}

template <uint8_t N_CHIPS>
void SwitchMatrix<N_CHIPS>::resetMatrix()
{
  memset(connections, OFF, sizeof(connections));
}

template <uint8_t N_CHIPS>
void SwitchMatrix<N_CHIPS>::closeAllSwitches()
{
  resetMatrix();
  update();
}

template <uint8_t N_CHIPS>
void SwitchMatrix<N_CHIPS>::update ()
{
  for (uint8_t chip= N_CHIPS; chip>0; chip--)
  {
    for (uint8_t y = MATRIX_SIZE; y > 0; y--) 
    {
      for (uint8_t x = MATRIX_SIZE; x > 0; x--)
      {
        // write
        if (areConnected(x-1, y-1, chip-1)) digitalWrite(sin, HIGH);
        else digitalWrite(sin, LOW);

        // update pin
        delay(1);
        digitalWrite(sclk, HIGH);
        delay(1);
        digitalWrite(sclk, LOW);
      }
    }
  }

  // Update matrix  
  delay(1);
  digitalWrite(pclk, LOW);
  delay(1);
  digitalWrite(pclk, HIGH);
}



template <uint8_t N_CHIPS>
bool SwitchMatrix<N_CHIPS>::areConnected (const uint8_t& x, const uint8_t& y, const uint8_t& chipNumber)
{
    if (x < 0 || x > 15) return false;
    if (y < 0 || y > 15) return false;
    if (chipNumber < 0 || chipNumber >= N_CHIPS) return false; // [0, N_CHIPS-1]

    uint8_t yy = chipNumber * MATRIX_SIZE + y;
    return ((connections[yy] >> x) & 1) == ON;
}

template <uint8_t N_CHIPS>
void SwitchMatrix<N_CHIPS>::connect (const uint8_t& x, const uint8_t& y, const uint8_t& chipNumber)  {
  if (x < 0 || x > 15) return;
  if (y < 0 || y > 15) return;
  if (chipNumber < 0 || chipNumber >= N_CHIPS) return; // [0, N_CHIPS-1]

  uint8_t yy = chipNumber * MATRIX_SIZE + y;
  connections[yy] |= (ON << x); // set the pin  
}

template <uint8_t N_CHIPS>
void SwitchMatrix<N_CHIPS>::twoWaysConnect (const uint8_t& x, const uint8_t& y, const uint8_t& chipNumber)
{
  connect (x, y, chipNumber);
  connect (y, x, chipNumber);
}

template <uint8_t N_CHIPS>
void SwitchMatrix<N_CHIPS>::oneWayDisconnect (const uint8_t& x, const uint8_t& y, const uint8_t& chipNumber)
{
  if (x < 0 || x > 15) return;
  if (y < 0 || y > 15) return;
  if (chipNumber < 0 || chipNumber >= N_CHIPS) return; // [0, N_CHIPS-1]

  uint16_t mask = 0xFFFF ^ ( ON << x);
  uint8_t yy = chipNumber * MATRIX_SIZE + y;
  connections[yy] &= mask; // set the pin
}

template <uint8_t N_CHIPS>
void SwitchMatrix<N_CHIPS>::disconnect (const uint8_t& x, const uint8_t& y, const uint8_t& chipNumber)
{
  oneWayDisconnect (x, y, chipNumber);
  oneWayDisconnect (y, x, chipNumber);
}


/*
template <uint8_t N_CHIPS>
void SwitchMatrix<N_CHIPS>::dbg ()
{
  for (uint8_t chip= N_CHIPS; chip>0; chip--)
  {
    for (uint8_t y = MATRIX_SIZE; y > 0; y--) 
    {
      for (uint8_t x = MATRIX_SIZE; x > 0; x--)
      {
        // write
        if (areConnected(x-1, y-1, chip-1)) Serial.print(ON);
        else Serial.print(OFF);
      }
      Serial.println("");
    }
    Serial.println("============");
  }
}
*/

#endif