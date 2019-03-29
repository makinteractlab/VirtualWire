#include <Arduino.h>
#include "constants.hpp"
#include "SwitchArray.hpp"
#include "Wifi.hpp"
#include "AppManager.hpp"


// FORWARD DECLARATIONS
void onMessageReady (const String& msg, WiFiEspClient* const client);


// GLOBALS
SwitchArray switches (PCLK, SCLK, SIN);

void setup()
{
  Serial.begin(BAUD_RATE);

  // Testing the switching matrix
  // switches.connect (BREADBOARD_PINS::P4, BREADBOARD_PINS::P9);
  // switches.connect (BREADBOARD_PINS::P3, ARDUINO_DIGITAL_PINS::D4);
  // switches.update();


  // Wifi
  Wifi::getInstance().baud(BAUD_RATE).port(PORT).debug(true);
  Wifi::getInstance().registerMsgReadyCallback (&onMessageReady);
  Wifi::getInstance().init((const char*)(F("VirtualWire")), IP(IP_ADDRESS));


  // App manager
  AppManager::getInstance().init(&switches);

  // Statust OK
  AppManager::getInstance().blinkStatusLed();

}

void loop()
{
  Wifi::getInstance().listenToRequets();
}


void onMessageReady (const String& msg, WiFiEspClient* const client)
{
  AppManager::getInstance().parseCommand(msg, client);
}





