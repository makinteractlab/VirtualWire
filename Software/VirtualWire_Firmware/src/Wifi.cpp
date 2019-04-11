#include "Wifi.hpp"
#include "WiFiEsp.h"

// Default port is 80
#define DEFAULT_PORT 80

Wifi::Wifi() : status(WL_IDLE_STATUS), debugOn(false), server(WiFiEspServer(DEFAULT_PORT)), buffer("") {}

Wifi& Wifi::baud(uint32_t baudRate)
{
  this->baudRate = baudRate;
  return *this;
}

Wifi& Wifi::port(uint16_t portNum)
{
  this->portNum = portNum;
  return *this;
}

Wifi& Wifi::debug(boolean d)
{
  this->debugOn = d;
  return *this;
}

Wifi& Wifi::registerMsgReadyCallback (const MsgReadyCallback cb)
{
  callbackEvent= cb;
  return *this;
}

void Wifi::init(const char *ssid, const IP &ip)
{
  server = WiFiEspServer(portNum);
  Serial3.begin(baudRate);
  WiFi.init(&Serial3);
  status = WL_IDLE_STATUS;

  if (WiFi.status() == WL_NO_SHIELD)
  {
    Serial.println("WiFi shield not present");
    while (true)
      ; // don't continue
  }

  IPAddress localIp(ip.p1, ip.p2, ip.p3, ip.p4);
  WiFi.configAP(localIp);

  // start access point
  status = WiFi.beginAP(ssid);
  if (debugOn)
    printWifiStats();

  // start the web server on port 80
  server.begin();
}

void Wifi::listenToRequets()
{
  WiFiEspClient client = server.available();

  if (client)
  {
    // Serial.println("New client");
    while (client.connected())
    {
      if (client.available())
      {
        char c = client.read();
        buffer+= c;
        
        if (c == '\n') {
          (*callbackEvent)(buffer, &client);
          buffer=""; // clear buffer
          break;
        }
      }
    }
  }
  
}

void Wifi::printWifiStats()
{
  printCurrentNet();
  printWifiData();
}

void Wifi::printWifiData()
{
  // print your WiFi shield's IP address
  IPAddress ip = WiFi.localIP();
  Serial.print("IP Address: ");
  Serial.println(ip);

  // print your MAC address
  byte mac[6];
  WiFi.macAddress(mac);
  char buf[20];
  sprintf(buf, "%02X:%02X:%02X:%02X:%02X:%02X", mac[5], mac[4], mac[3], mac[2], mac[1], mac[0]);
  Serial.print("MAC address: ");
  Serial.println(buf);
}

void Wifi::printCurrentNet()
{
  // print the SSID of the network you're attached to
  Serial.print("SSID: ");
  Serial.println(WiFi.SSID());

  // print the MAC address of the router you're attached to
  byte bssid[6];
  WiFi.BSSID(bssid);
  char buf[20];
  sprintf(buf, "%02X:%02X:%02X:%02X:%02X:%02X", bssid[5], bssid[4], bssid[3], bssid[2], bssid[1], bssid[0]);
  Serial.print("BSSID: ");
  Serial.println(buf);

  // print the received signal strength
  long rssi = WiFi.RSSI();
  Serial.print("Signal strength (RSSI): ");
  Serial.println(rssi);
}
