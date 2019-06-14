#include <Arduino.h>
#include "constants.hpp"
#include "SwitchArray.hpp"
#include "Wifi.hpp"
#include "AppManager.hpp"



// FORWARD DECLARATIONS
void onMessageReady (const String& msg, Stream* const client);


// GLOBALS
SwitchArray switches (PCLK, SCLK, SIN);
String buffer ="";

void setup()
{
  Serial.begin(BAUD_RATE);

  // Wifi
  Wifi::getInstance().baud(BAUD_RATE).port(PORT).debug(true);
  Wifi::getInstance().registerMsgReadyCallback (&onMessageReady);
  Wifi::getInstance().init((const char*)(F("VirtualWire")), IP(IP_ADDRESS));

  // App manager
  AppManager::getInstance().init(&switches);

  // Statust OK
  AppManager::getInstance().blinkStatusLed();

  // Test Voltage example
  // AppManager::getInstance().setVoltage(1260);

  // Ready
  Serial.println("Ready");
}

void loop()
{
  // Wifi
  Wifi::getInstance().listenToRequets();  

  // Serial
  while (Serial.available())
  {
    char inChar = (char)Serial.read();
    if (inChar == '\n')
    {
      onMessageReady(buffer, &Serial);
      buffer = "";
    }
    else
    {
      buffer += inChar;
    }
  }
}


void onMessageReady (const String& msg, Stream* const client)
{
  if (!client) return;
  // Serial.println (F("Incoming message:"));
  // Serial.println (msg);
  AppManager::getInstance().parseCommand(msg, client);
}




