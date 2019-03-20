#ifndef __SWITCH_ARRAY__H__
#define __SWITCH_ARRAY__H__

#include <AD75019.h>


enum class BREADBOARD_PINS {P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, P14, P15, P16};
enum class ARDUINO_DIGITAL_PINS {D0, D1, D2, D3, D4, D5, D6, D7, D8, D9, D10, D11, D12, D13, AREF, GND1};
enum class ARDUINO_ANALOG_PINS {A0, A1, A2, A3, A4, A5, VIN, A5V, A3V, ARESET, IOREF, DAC, ADC, PWM, GND2, GND3};

class SwitchArray
{
    AD75019 c1, c2, c3;

    public:
      // order is important (chip1 is the head of the chain)
      SwitchArray(const AD75019& chip1, const AD75019& chip2, const AD75019& chip3);
      void reset();

      void connect (BREADBOARD_PINS x, BREADBOARD_PINS y);
      void connect (BREADBOARD_PINS x, ARDUINO_DIGITAL_PINS y);
      void connect (BREADBOARD_PINS x, ARDUINO_ANALOG_PINS y);
      void disconnect (BREADBOARD_PINS x, BREADBOARD_PINS y);
      void disconnect (BREADBOARD_PINS x, ARDUINO_DIGITAL_PINS y);
      void disconnect (BREADBOARD_PINS x, ARDUINO_ANALOG_PINS y);
      void areConnected (BREADBOARD_PINS x, BREADBOARD_PINS y);
      void areConnected (BREADBOARD_PINS x, ARDUINO_DIGITAL_PINS y);
      void areConnected (BREADBOARD_PINS x, ARDUINO_ANALOG_PINS y);
      void update();
};

#endif 