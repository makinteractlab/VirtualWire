#include "Helpers.h"
#include <EEPROMex.h>

InternalMemory::InternalMemory(byte memBase, byte memSize, byte maxWrite) : writeSize(maxWrite)
{
    EEPROM.setMemPool(memBase, memSize);
    EEPROM.setMaxAllowedWrites(writeSize);
    ssidAddr = EEPROM.getAddress(sizeof(char) * writeSize);
    passAddr = EEPROM.getAddress(sizeof(char) * writeSize);
}

void InternalMemory::saveSSID(char ssid[])
{
    EEPROM.writeBlock<char>(ssidAddr, ssid, writeSize);
}

void InternalMemory::savePW(char pass[])
{
    EEPROM.writeBlock<char>(passAddr, pass, writeSize);
}

String InternalMemory::getSSID()
{
    char output[writeSize];
    EEPROM.readBlock<char>(ssidAddr, output, writeSize);
    return String(output);
}

String InternalMemory::getPW()
{
    char output[writeSize];
    EEPROM.readBlock<char>(passAddr, output, writeSize);
    return String(output);
}

// // Save ssid and pass to EEPROM
// // assume max array size of EEPROM_MAX_WRITE
// void saveSSID_PASS (char ssid[], char pass[])
// {
//     EEPROM.setMemPool(EEPROM_MEM_BASE, EEPROM_SIZE);
//     EEPROM.setMaxAllowedWrites(EEPROM_MAX_WRITE);

//     int ssid_addr = EEPROM.getAddress(sizeof(char) * EEPROM_MAX_WRITE);
//     int pass_addr = EEPROM.getAddress(sizeof(char) * EEPROM_MAX_WRITE);
//     Serial.println(ssid_addr);
//     Serial.println(pass_addr);

//     EEPROM.writeBlock<char>(ssid_addr, ssid, EEPROM_MAX_WRITE);
//     EEPROM.writeBlock<char>(pass_addr, pass, EEPROM_MAX_WRITE);
// }

// // Save ssid and pass to EEPROM
// // assume max array size of EEPROM_MAX_WRITE
// void loadSSID_PASS (char ssid[], char pass[])
// {
//     int ssid_addr = EEPROM.getAddress(sizeof(char) * EEPROM_MAX_WRITE);
//     int pass_addr = EEPROM.getAddress(sizeof(char) * EEPROM_MAX_WRITE);
//     Serial.println(ssid_addr);
//     Serial.println(pass_addr);

//     char output [EEPROM_MAX_WRITE];
//     EEPROM.readBlock<char>(ssid_addr, output, EEPROM_MAX_WRITE);
//     Serial.println(output);
//     EEPROM.readBlock<char>(pass_addr, output, EEPROM_MAX_WRITE);
//     Serial.println(output);
// }