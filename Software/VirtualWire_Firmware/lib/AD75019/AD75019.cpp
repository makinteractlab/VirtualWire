#include "Arduino.h"
#include "AD75019.h"

AD75019::AD75019 (byte pclkPin, byte sclkPin, byte sinPin): pclk(pclkPin), sclk(sclkPin), sin(sinPin)
{
  pinMode(pclk, OUTPUT);
  pinMode(sclk, OUTPUT);
  pinMode(sin, OUTPUT);
  closeAllSwitches();
}


void AD75019::reset()
{
  memset(connections, NONE, sizeof(connections));
}


void AD75019::connect (byte x, byte y)
{
  if (x < 0 || x > 15) return;
  if (y < 0 || y > 15) return;

  connections[x] |= (1 << y); // set the pin
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

  unsigned int mask = 0xFFFF ^ ( 1 << y);
  connections[x] &= mask; // set the pin
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

  return ((connections[x] >> y) & 1) == 1;
}


void AD75019::closeAllSwitches()
{
  reset();
  writeSwitches();
  updateSwitches();
}

void AD75019::dbg()
{
  for (int x=MSIZE-1; x>=0; x--)
  {
    for (int y=MSIZE-1; y>=0; y--)
    {
      if (areConnected (x, y)) Serial.print(1); //digitalWrite(sin, HIGH);
      else Serial.print(0); //digitalWrite(sin, LOW);
    }
  }
  Serial.println("");
  Serial.println("====");

}


void AD75019::writeSwitches()
{
  for (int x=MSIZE-1; x>=0; x--)
  {
    for (int y=MSIZE-1; y>=0; y--)
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
  // tail
  delay(1);
  digitalWrite(pclk, LOW);
  delay(1);
  digitalWrite(pclk, HIGH);
}


