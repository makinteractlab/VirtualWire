#include "Wifi.hpp"

Wifi::Wifi(): status(WL_IDLE_STATUS) {}

void Wifi::init(int baudRate)
{
    Serial3.begin(baudRate);
    WiFi.init(&Serial3);
    status= WL_IDLE_STATUS;
}

void Wifi::connect (char* ssid, char* password)
{
    if (WiFi.status() == WL_NO_SHIELD)
    {
        Serial.println("WiFi shield not present");
        // don't continue
        while (true) ;
    }

    // attempt to connect to WiFi network
    while (status != WL_CONNECTED)
    {
        Serial.print("Attempting to connect to WPA SSID: ");
        Serial.println(ssid);
        // Connect to WPA/WPA2 network
        status = WiFi.begin(ssid, password);
    }

    Serial.println("You're connected to the network");
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