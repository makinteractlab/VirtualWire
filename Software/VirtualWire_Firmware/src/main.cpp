#include <Arduino.h>
#include <AD75019.h>
#define LED 10

AD75019 bd_matrix (14, 15, 16); // breadboard to arduino digital pins
AD75019 bb_matrix (14, 15, 16); // breadboard matrix


enum BREADBOARD_PINS {P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, P14, P15, P16};


void setup()
{
  Serial.begin(115200);
  pinMode(LED, OUTPUT);
  digitalWrite (LED, HIGH);

  
  delay(2000);
  
  bd_matrix.connect(0, 5);
  bb_matrix.twoWaysConnect (P1,P14);
  
  bd_matrix.writeSwitches();
  bb_matrix.writeSwitches();
  bd_matrix.updateSwitches();
  // breadboard_matrix.dbg();
  digitalWrite (LED, LOW);
}

void loop()
{
  // Serial.println("fds"); delay(1000);
  // Serial.println("hello");
  // while (Serial.available()) Serial3.write(Serial.read());
  // while (Serial3.available()) Serial.write(Serial3.read());
}
