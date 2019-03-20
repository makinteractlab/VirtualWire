#include <Arduino.h>
#include <AD75019.h>
#include "constants.hpp"
#include "SwitchArray.hpp"
#include "Wifi.hpp"


AD75019 chip1 (PCLK, SCLK, SIN); // breadboard matrix
AD75019 chip2 (SCLK, SIN); // breadboard matrix to Arduino digital
AD75019 chip3 (SCLK, SIN); // breadboard matrix to Arduino analog
SwitchArray switches (&chip1, &chip2, &chip3);
Wifi wifi;

char ssid[] = "MAKinteract";
char pass[] = "make5555";


void setup()
{
  Serial.begin(BAUD_RATE);

  // setup status LED
  pinMode(STATUS_LED, OUTPUT);
  digitalWrite (STATUS_LED, HIGH);

  // Testing the switching matrix
  switches.connect (BREADBOARD_PINS::P4, BREADBOARD_PINS::P9);
  switches.connect (BREADBOARD_PINS::P1, BREADBOARD_PINS::P2);
  switches.connect (BREADBOARD_PINS::P3, ARDUINO_DIGITAL_PINS::D4);
  switches.connect (BREADBOARD_PINS::P8, ARDUINO_ANALOG_PINS::ARESET);
  switches.connect (BREADBOARD_PINS::P8, ARDUINO_ANALOG_PINS::IOREF);
  switches.update();

  digitalWrite(STATUS_LED, LOW);

  wifi.init(BAUD_RATE);
  wifi.connect (ssid, pass);
  wifi.printWifiStats();
}

void loop()
{
  // Serial.println("fds"); delay(1000);
  // Serial.println("hello");  // while (Serial.available()) Serial3.write(Serial.read());
  // while (Serial3.available()) Serial.write(Serial3.read());
}
