#include <Arduino.h>
#include <AD75019.h>
#include "constants.hpp"
#include "SwitchArray.hpp"
#include "Wifi.hpp"
#include "Helpers.hpp"


AD75019 chip1 (PCLK, SCLK, SIN); // breadboard matrix
AD75019 chip2 (SCLK, SIN); // breadboard matrix to Arduino digital
AD75019 chip3 (SCLK, SIN); // breadboard matrix to Arduino analog
SwitchArray switches (chip1, chip2, chip3);
InternalMemory memory(EEPROM_MEM_BASE, EEPROM_SIZE, EEPROM_MAX_WRITE);
Wifi wifi;
CommandInput  parser (switches, JSON_BUFFER_SIZE);



void setup()
{
  Serial.begin(BAUD_RATE);

  // setup status LED
  pinMode(STATUS_LED, OUTPUT);
  digitalWrite (STATUS_LED, HIGH);

  // Testing the switching matrix
  /*switches.connect (BREADBOARD_PINS::P4, BREADBOARD_PINS::P9);
  switches.connect (BREADBOARD_PINS::P1, BREADBOARD_PINS::P2);
  switches.connect (BREADBOARD_PINS::P3, ARDUINO_DIGITAL_PINS::D4);
  switches.connect (BREADBOARD_PINS::P8, ARDUINO_ANALOG_PINS::ARESET);
  switches.connect (BREADBOARD_PINS::P8, ARDUINO_ANALOG_PINS::IOREF);
  switches.update();
  */

  // Testing writing on memory
  // memory.saveSSID("MAKinteract");
  // memory.savePW("make5555");
  // Serial.println(memory.getSSID());
  // Serial.println(memory.getPW());

  // Testing wifi
  // wifi.init(BAUD_RATE);
  // wifi.connect(memory.getSSID(), memory.getPW());
  // wifi.printWifiStats();


  // Ready
  digitalWrite(STATUS_LED, LOW);
}

void loop()
{

  // Handle configurations through USB serial
  while (Serial.available())
  {
    char inChar = (char)Serial.read();
    if (parser.updateInput(inChar))
    {
      parser.executeCommand("", &Serial);
    }
  }
}



