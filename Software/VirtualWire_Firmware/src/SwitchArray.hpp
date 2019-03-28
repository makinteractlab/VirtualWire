#ifndef __SWITCH_ARRAY__H__
#define __SWITCH_ARRAY__H__

// Wrap class for SwitchMatrix

#include "SwitchMatrix.hpp"

#define CHIPS 3

#define BREADBOARD_PINS_CHIP 0
#define ARDUINO_DIGITAL_PINS_CHIP 1
#define ARDUINO_ANALOG_PINS_CHIP 2

enum class BREADBOARD_PINS {P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, P14, P15, P16};
enum class ARDUINO_DIGITAL_PINS {D0, D1, D2, D3, D4, D5, D6, D7, D8, D9, D10, D11, D12, D13, DAREF, DGND};
enum class ARDUINO_ANALOG_PINS {A0, A1, A2, A3, A4, A5, AVIN, A5V, A3V, ARESET, AIOREF, ADAC, ADC, APWM, AGND1, AGND2};

class SwitchArray
{
    SwitchMatrix<CHIPS> sm;

    public:
      SwitchArray(const uint8_t& pclkPin, const uint8_t& sclkPin, const uint8_t& sinPin);
      void reset();
      void update();

      void connect (const BREADBOARD_PINS& x, const BREADBOARD_PINS& y);
      void connect (const BREADBOARD_PINS& x, const ARDUINO_DIGITAL_PINS& y);
      void connect (const BREADBOARD_PINS& x, const ARDUINO_ANALOG_PINS& y);
      void connect (const ARDUINO_DIGITAL_PINS& y, const BREADBOARD_PINS& x);
      void connect (const ARDUINO_ANALOG_PINS& y, const BREADBOARD_PINS& x);

      void disconnect (const BREADBOARD_PINS& x, const BREADBOARD_PINS& y);
      void disconnect (const BREADBOARD_PINS& x, const ARDUINO_DIGITAL_PINS& y);
      void disconnect (const BREADBOARD_PINS& x, const ARDUINO_ANALOG_PINS& y);
      void disconnect (const ARDUINO_DIGITAL_PINS& y, const BREADBOARD_PINS& x);
      void disconnect (const ARDUINO_ANALOG_PINS& y, const BREADBOARD_PINS& x);

      void areConnected (const BREADBOARD_PINS& x, const BREADBOARD_PINS& y);
      void areConnected (const BREADBOARD_PINS& x, const ARDUINO_DIGITAL_PINS& y);
      void areConnected (const BREADBOARD_PINS& x, const ARDUINO_ANALOG_PINS& y);
      void areConnected(const ARDUINO_DIGITAL_PINS& y, const BREADBOARD_PINS& x);
      void areConnected(const ARDUINO_ANALOG_PINS& y, const BREADBOARD_PINS& x);
};

#endif 