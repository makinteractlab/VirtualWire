#include <Arduino.h>
#include "constants.hpp"
#include "SwitchArray.hpp"
#include "Wifi.hpp"
#include "AppManager.hpp"


// FORWARD DECLARATIONS
void onMessageReady (const String& msg, WiFiEspClient* const client);
void onTimerTick ();

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
  AppManager::getInstance().init(&switches, onTimerTick);

  // Statust OK
  AppManager::getInstance().blinkStatusLed();

  // Test Voltage
  // AppManager::getInstance().setVoltage(1260);

  AppManager::getInstance().setWave (SIN_WAVE, 100, VOLT_MAX);
  AppManager::getInstance().startWave();
}

void loop()
{
  Wifi::getInstance().listenToRequets();  
}


void onMessageReady (const String& msg, WiFiEspClient* const client)
{
  Serial.println (F("Incoming message:"));
  Serial.println (msg);
  AppManager::getInstance().parseCommand(msg, client);
}

void onTimerTick()
{
  AppManager::getInstance().timerTick();
}



