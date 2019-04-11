#ifndef __CONSTANTS__HPP__
#define __CONSTANTS__HPP__

// PINS
#define PCLK 14
#define SCLK 15
#define SIN 16
#define STATUS_LED 10
// Teensy LC
// #define DAC_PIN A12
// Teensy 3.2
#define DAC_PIN A14
#define ADC_PIN A5

// WIFI
#define BAUD_RATE 115200 
#define WIFI_RESET 6
#define IP_ADDRESS 192, 168, 0, 1
#define PORT 8080
#define BUFFER_SIZE 160

// EEPROM
#define EEPROM_SIZE 128
#define EEPROM_MEM_BASE 0
#define EEPROM_MAX_WRITE 20

// Flags
#define DEBUG 1

// Others
#define DAC_RESOLUTION 12
#define DAC_TICK_MS 1
#define DAC_MAX 4096
#define VOLT_MAX 3300
#define VOLT_MAX_HALF 1650

#define MIN_FREQ 1
#define MAX_FREQ 100

#define ADC_RESOLUTION 16
#define ADC_MAX 65536




#endif