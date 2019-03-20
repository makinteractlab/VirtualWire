#include "SwitchArray.hpp"

SwitchArray::SwitchArray (AD75019 *chip1, AD75019 *chip2, AD75019 *chip3):
                        c1(chip1), c2(chip2), c3(chip3)
{

}

void SwitchArray::reset()
{
    c3->closeAllSwitches();
    c2->closeAllSwitches();
    c1->closeAllSwitches();
    c1->updateSwitches();
}

void SwitchArray::connect (BREADBOARD_PINS x, BREADBOARD_PINS y)
{
    c1->twoWaysConnect (static_cast<int>(x), static_cast<int>(y));
}

void SwitchArray::connect (BREADBOARD_PINS x, ARDUINO_DIGITAL_PINS y)
{
    c2->connect(static_cast<int>(x), static_cast<int>(y));
}

void SwitchArray::connect (BREADBOARD_PINS x, ARDUINO_ANALOG_PINS y)
{
    c3->connect(static_cast<int>(x), static_cast<int>(y));
}

void SwitchArray::disconnect (BREADBOARD_PINS x, BREADBOARD_PINS y)
{
    c1->twoWaysDisonnect(static_cast<int>(x), static_cast<int>(y));
}

void SwitchArray::disconnect (BREADBOARD_PINS x, ARDUINO_DIGITAL_PINS y)
{
    c2->disconnect(static_cast<int>(x), static_cast<int>(y));
}

void SwitchArray::disconnect (BREADBOARD_PINS x, ARDUINO_ANALOG_PINS y)
{
    c3->disconnect(static_cast<int>(x), static_cast<int>(y));
}

void SwitchArray::areConnected (BREADBOARD_PINS x, BREADBOARD_PINS y)
{
    c1->areConnected(static_cast<int>(x), static_cast<int>(y));
}

void SwitchArray::areConnected(BREADBOARD_PINS x, ARDUINO_DIGITAL_PINS y)
{
    c2->areConnected(static_cast<int>(x), static_cast<int>(y));
}

void SwitchArray::areConnected(BREADBOARD_PINS x, ARDUINO_ANALOG_PINS y)
{
    c3->areConnected(static_cast<int>(x), static_cast<int>(y));
}

void SwitchArray::update()
{
    c3->writeSwitches();
    c2->writeSwitches();
    c1->writeSwitches();
    c1->updateSwitches();
}