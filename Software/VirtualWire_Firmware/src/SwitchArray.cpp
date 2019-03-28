#include "SwitchArray.hpp"

SwitchArray::SwitchArray(const uint8_t& pclkPin, const uint8_t& sclkPin, const uint8_t& sinPin): 
                    sm(SwitchMatrix<CHIPS>(pclkPin,sclkPin,sinPin)) {}

void SwitchArray::reset()
{
    sm.closeAllSwitches();
}

void SwitchArray::update()
{
    sm.update();
}



void SwitchArray::connect (const BREADBOARD_PINS& x, const BREADBOARD_PINS& y)
{
    sm.twoWaysConnect (static_cast<int>(x), static_cast<int>(y), BREADBOARD_PINS_CHIP);
}

void SwitchArray::connect (const BREADBOARD_PINS& x, const ARDUINO_DIGITAL_PINS& y)
{
    sm.connect(static_cast<int>(x), static_cast<int>(y), ARDUINO_DIGITAL_PINS_CHIP);
}

void SwitchArray::connect (const BREADBOARD_PINS& x, const ARDUINO_ANALOG_PINS& y)
{
    sm.connect(static_cast<int>(x), static_cast<int>(y), ARDUINO_ANALOG_PINS_CHIP);
}

void SwitchArray::connect (const ARDUINO_DIGITAL_PINS& y, const BREADBOARD_PINS& x)
{
    sm.connect(static_cast<int>(x), static_cast<int>(y), ARDUINO_DIGITAL_PINS_CHIP);
}

void SwitchArray::connect (const ARDUINO_ANALOG_PINS& y, const BREADBOARD_PINS& x)
{
    sm.connect(static_cast<int>(x), static_cast<int>(y), ARDUINO_ANALOG_PINS_CHIP);
}



void SwitchArray::disconnect (const BREADBOARD_PINS& x, const BREADBOARD_PINS& y)
{
    sm.disconnect(static_cast<int>(x), static_cast<int>(y),BREADBOARD_PINS_CHIP);
}

void SwitchArray::disconnect (const BREADBOARD_PINS& x, const ARDUINO_DIGITAL_PINS& y)
{
    sm.disconnect(static_cast<int>(x), static_cast<int>(y), ARDUINO_DIGITAL_PINS_CHIP);
}

void SwitchArray::disconnect (const BREADBOARD_PINS& x, const ARDUINO_ANALOG_PINS& y)
{
    sm.disconnect(static_cast<int>(x), static_cast<int>(y), ARDUINO_ANALOG_PINS_CHIP);
}

void SwitchArray::disconnect (const ARDUINO_DIGITAL_PINS& y, const BREADBOARD_PINS& x)
{
    sm.connect(static_cast<int>(x), static_cast<int>(y), ARDUINO_DIGITAL_PINS_CHIP);
}

void SwitchArray::disconnect (const ARDUINO_ANALOG_PINS& y, const BREADBOARD_PINS& x)
{
    sm.connect(static_cast<int>(x), static_cast<int>(y), ARDUINO_ANALOG_PINS_CHIP);
}




void SwitchArray::areConnected (const BREADBOARD_PINS& x, const BREADBOARD_PINS& y)
{
    sm.areConnected(static_cast<int>(x), static_cast<int>(y), BREADBOARD_PINS_CHIP);
}

void SwitchArray::areConnected(const BREADBOARD_PINS& x, const ARDUINO_DIGITAL_PINS& y)
{
    sm.areConnected(static_cast<int>(x), static_cast<int>(y), ARDUINO_DIGITAL_PINS_CHIP);
}

void SwitchArray::areConnected(const BREADBOARD_PINS& x, const ARDUINO_ANALOG_PINS& y)
{
    sm.areConnected(static_cast<int>(x), static_cast<int>(y), ARDUINO_ANALOG_PINS_CHIP);
}

void SwitchArray::areConnected(const ARDUINO_DIGITAL_PINS& y, const BREADBOARD_PINS& x)
{
    sm.areConnected(static_cast<int>(x), static_cast<int>(y), ARDUINO_DIGITAL_PINS_CHIP);
}

void SwitchArray::areConnected(const ARDUINO_ANALOG_PINS& y, const BREADBOARD_PINS& x)
{
    sm.areConnected(static_cast<int>(x), static_cast<int>(y), ARDUINO_ANALOG_PINS_CHIP);
}