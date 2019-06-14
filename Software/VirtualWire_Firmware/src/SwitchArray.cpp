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

// CONNECT

bool SwitchArray::connect (const uint16_t& x, const uint16_t& y)
{
    if (x < 0 || x >SWITCHES) return false;
    uint16_t chipID = y / SWITCHES;
    if (chipID < 0 || chipID >CHIPS) return false;
    uint16_t yy = y % SWITCHES;

    if (chipID == 0) sm.twoWaysConnect (x, yy, chipID);
    else sm.connect (x, yy, chipID);
    return true;
}

bool SwitchArray::connect (const String& x, const String& y)
{
    PINS xx= stringToPIN (x);
    PINS yy= stringToPIN (y);
    if (xx == PINS::NO_SELECTION || yy == PINS::NO_SELECTION) return false;
    return connect (xx, yy);
}

bool SwitchArray::connect (const PINS& x, const PINS& y)
{
    uint16_t xx= static_cast<int>(x);
    uint16_t yy= static_cast<int>(y);
    if (xx == yy) return true;
    if (xx < yy) return connect (xx, yy);
    // else
    return connect (yy, xx);
}

// DISCONNECT

bool SwitchArray::disconnect (const uint16_t& x, const uint16_t& y)
{
    if (x < 0 || x >SWITCHES) return false;
    uint16_t chipID = y / SWITCHES;
    if (chipID < 0 || chipID >CHIPS) return false;
    uint16_t yy = y % SWITCHES;
    
    sm.disconnect (x, yy, chipID);
    return true;
}

bool SwitchArray::disconnect (const String& x, const String& y)
{
    PINS xx= stringToPIN (x);
    PINS yy= stringToPIN (y);
    if (xx == PINS::NO_SELECTION || yy == PINS::NO_SELECTION) return false;
    return disconnect (xx, yy);
}

bool SwitchArray::disconnect (const PINS& x, const PINS& y)
{
    uint16_t xx= static_cast<int>(x);
    uint16_t yy= static_cast<int>(y);
    if (xx == yy) return true;
    if (xx < yy) return disconnect (xx, yy);
    // else
    return disconnect (yy, xx);
}

// ARE CONNECTED

bool SwitchArray::areConnected (const uint16_t& x, const uint16_t& y)
{
    if (x < 0 || x >SWITCHES) return false;
    uint16_t chipID = y / SWITCHES;
    if (chipID < 0 || chipID >CHIPS) return false;
    uint16_t yy = y % SWITCHES;
    
    return sm.areConnected (x, yy, chipID);
}

bool SwitchArray::areConnected (const String& x, const String& y)
{
    PINS xx= stringToPIN (x);
    PINS yy= stringToPIN (y);
    if (xx == PINS::NO_SELECTION || yy == PINS::NO_SELECTION) return false;
    return areConnected (xx, yy);
}

bool SwitchArray::areConnected (const PINS& x, const PINS& y)
{
    uint16_t xx= static_cast<int>(x);
    uint16_t yy= static_cast<int>(y);
    if (xx == yy) return true;
    if (xx < yy) return areConnected (xx, yy);
    // else
    return areConnected (yy, xx);
}

// HELPERS

PINS SwitchArray::stringToPIN (const String& s)
{
    if (s==F("IOREF")) return PINS::IOREF;
    else if (s==F("RESET")) return PINS::RESET;
    else if (s==F("A3V")) return PINS::A3V;
    else if (s==F("A5V")) return PINS::A5V;
    else if (s==F("GND1")) return PINS::GND1;
    else if (s==F("GND2")) return PINS::GND2;
    else if (s==F("GND3")) return PINS::GND3;
    else if (s==F("VIN")) return PINS::VIN;
    else if (s==F("A0")) return PINS::A0;
    else if (s==F("A1")) return PINS::A1;
    else if (s==F("A2")) return PINS::A2;
    else if (s==F("A3")) return PINS::A3;
    else if (s==F("A4")) return PINS::A4;
    else if (s==F("A5")) return PINS::A5;
    else if (s==F("AREF")) return PINS::AREF;
    else if (s==F("D0")) return PINS::D0;
    else if (s==F("D1")) return PINS::D1;
    else if (s==F("D2")) return PINS::D2;
    else if (s==F("D3")) return PINS::D3;
    else if (s==F("D4")) return PINS::D4;
    else if (s==F("D5")) return PINS::D5;
    else if (s==F("D6")) return PINS::D6;
    else if (s==F("D7")) return PINS::D7;
    else if (s==F("D8")) return PINS::D8;
    else if (s==F("D9")) return PINS::D9;
    else if (s==F("D10")) return PINS::D10;
    else if (s==F("D11")) return PINS::D11;
    else if (s==F("D12")) return PINS::D12;
    else if (s==F("D13")) return PINS::D13;
    else if (s==F("ROW1")) return PINS::ROW1;
    else if (s==F("ROW2")) return PINS::ROW2;
    else if (s==F("ROW3")) return PINS::ROW3;
    else if (s==F("ROW4")) return PINS::ROW4;
    else if (s==F("ROW5")) return PINS::ROW5;
    else if (s==F("ROW6")) return PINS::ROW6;
    else if (s==F("ROW7")) return PINS::ROW7;
    else if (s==F("ROW8")) return PINS::ROW8;
    else if (s==F("ROW9")) return PINS::ROW9;
    else if (s==F("ROW10")) return PINS::ROW10;
    else if (s==F("ROW11")) return PINS::ROW11;
    else if (s==F("ROW12")) return PINS::ROW12;
    else if (s==F("ROW13")) return PINS::ROW13;
    else if (s==F("ROW14")) return PINS::ROW14;
    else if (s==F("ROW15")) return PINS::ROW15;
    else if (s==F("ROW16")) return PINS::ROW16;
    else if (s==F("DAC")) return PINS::DAC;
    else if (s==F("ADC")) return PINS::ADC;
    else if (s==F("PWM")) return PINS::PWM;
    return PINS::NO_SELECTION; 
}




