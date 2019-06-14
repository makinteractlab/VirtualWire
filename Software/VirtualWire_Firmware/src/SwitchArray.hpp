#ifndef __SWITCH_ARRAY__H__
#define __SWITCH_ARRAY__H__

// Wrap class for SwitchMatrix

#include "SwitchMatrix.hpp"

#define CHIPS 3
#define SWITCHES 16

#define BREADBOARD_ROWS_CHIP 0
#define ARDUINO_DIGITAL_PINS_CHIP 1
#define ARDUINO_ANALOG_PINS_CHIP 2

// The order of these pins is very important
enum class PINS {ROW1, ROW2, ROW3, ROW4, ROW5, ROW6, ROW7, ROW8, ROW9, ROW10, ROW11, ROW12, ROW13, ROW14, ROW15, ROW16, 
                 D0, D1, D2, D3, D4, D5, D6, D7, D8, D9, D10, D11, D12, D13, AREF, GND1,  
                 A0, A1, A2, A3, A4, A5, VIN, A5V, A3V, RESET, IOREF, DAC, ADC, PWM, GND2, GND3, NO_SELECTION};


class SwitchArray
{
    SwitchMatrix<CHIPS> sm;

    public:
      SwitchArray(const uint8_t& pclkPin, const uint8_t& sclkPin, const uint8_t& sinPin);
      void reset();
      void update();

      // These routines will not check wheather the connection is possible.
      // They assume a correct input from the clinet device
      bool connect (const uint16_t& x, const uint16_t& y);
      bool connect (const String& x, const String& y);
      bool connect (const PINS& x, const PINS& y);

      bool disconnect (const uint16_t& x, const uint16_t& y);
      bool disconnect (const String& x, const String& y);
      bool disconnect (const PINS& x, const PINS& y);

      bool areConnected (const uint16_t& x, const uint16_t& y);
      bool areConnected (const String& x, const String& y);
      bool areConnected (const PINS& x, const PINS& y);

    private:
      PINS stringToPIN (const String& s);
};

#endif 