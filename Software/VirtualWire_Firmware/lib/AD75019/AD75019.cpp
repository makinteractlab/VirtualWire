#include "Arduino.h"
#include "AD75019.h"

AD75019::AD75019 (byte pclkPin, byte sclkPin, byte sinPin): 
                  pclk(pclkPin), sclk(sclkPin), sin(sinPin), updatable(true)
{
  pinMode(pclk, OUTPUT);
  pinMode(sclk, OUTPUT);
  pinMode(sin, OUTPUT);
  closeAllSwitches();
}

AD75019::AD75019(byte sclkPin, byte sinPin) : 
                  pclk(NONE), sclk(sclkPin), sin(sinPin), updatable(false)
{
  pinMode(sclk, OUTPUT);
  pinMode(sin, OUTPUT);
  closeAllSwitches();
}

void AD75019::resetMatrix()
{
  memset(connections, OFF, sizeof(connections));
}


void AD75019::connect (byte x, byte y)
{
  if (x < 0 || x > 15) return;
  if (y < 0 || y > 15) return;

  connections[y] |= (ON << x); // set the pin
}

void AD75019::twoWaysConnect (byte x, byte y)
{
  connect (x, y);
  connect (y, x);
}

void AD75019::disconnect (byte x, byte y)
{
  if (x < 0 || x > 15) return;
  if (y < 0 || y > 15) return;

  unsigned int mask = 0xFFFF ^ ( ON << x);
  connections[y] &= mask; // set the pin
}

void AD75019::twoWaysDisonnect (byte x, byte y)
{
  disconnect (x, y);
  disconnect (y, x);
}

bool AD75019::areConnected (byte x, byte y)
{
  if (x < 0 || x > 15) return false;
  if (y < 0 || y > 15) return false;

  return ((connections[y] >> x) & 1) == ON;
}


void AD75019::closeAllSwitches()
{
  resetMatrix();
  writeSwitches();
}

// void AD75019::dbg()
// {
//   Serial.println("Print DBG");
//   for (int y=MATRIX_SIZE-1; y>=0; y--)
//   {
//     for (int x=MATRIX_SIZE-1; x>=0; x--)
//     {
//       if (areConnected (x, y)) Serial.print(ON);
//       else Serial.print(OFF); 
//     }
//   }
//   Serial.println("=====================");
// }


void AD75019::writeSwitches()
{
  for (int y=MATRIX_SIZE-1; y>=0; y--)
  {
    for (int x=MATRIX_SIZE-1; x>=0; x--)
    {
      if (areConnected (x, y)) digitalWrite(sin, HIGH);
      else digitalWrite(sin, LOW);

      delay(1);
      digitalWrite(sclk, HIGH);
      delay(1);
      digitalWrite(sclk, LOW);
    }
  }
}

void AD75019::updateSwitches()
{
  // Update the chip
  if (!updatable)
  {
    Serial.println("Cannot update the chip");
    return;
  }
  delay(1);
  digitalWrite(pclk, LOW);
  delay(1);
  digitalWrite(pclk, HIGH);
}


