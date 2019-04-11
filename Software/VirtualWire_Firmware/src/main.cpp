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

  // Reset the switches (done by default)
  //  switches.reset();

  // Wifi
  Wifi::getInstance().baud(BAUD_RATE).port(PORT).debug(true);
  Wifi::getInstance().registerMsgReadyCallback (&onMessageReady);
  Wifi::getInstance().init((const char*)(F("VirtualWire")), IP(IP_ADDRESS));

  // App manager
  AppManager::getInstance().init(&switches);

  // Statust OK
  AppManager::getInstance().blinkStatusLed();

  // Test Voltage
  // AppManager::getInstance().setVoltage(1260);
}

void loop()
{
  Wifi::getInstance().listenToRequets();  
}


void onMessageReady (const String& msg, WiFiEspClient* const client)
{
  if (!client) return;
  // Serial.println (F("Incoming message:"));
  // Serial.println (msg);
  AppManager::getInstance().parseCommand(msg, client);
}




