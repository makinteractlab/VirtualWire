import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.*; 
import java.io.*; 
import processing.serial.*; 
import interfascia.*; 
import controlP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class VirtualWireStandalone extends PApplet {





 // DEPENDECY
 //DEPENDENCY

// TO CHANGE ACCORDING TO YOUR SYSTEM
final int SERIAL_PORT_INDEX = 3;


// BEGIN CODE
Serial myPort;                // The serial port
String inString;              // Input string from serial port
String receivedMessage = "";  // message from hardware
int serialCmdIndex = 0;

PImage UNO;
int lineAnchorX = 0;
int lineAnchorY = 0;

boolean mouseFlag = false;

ArrayList<Wire> wirelist = new ArrayList<Wire>();
ArrayList<Node> nodelist = new ArrayList<Node>();
ArrayList<String> commandList = new ArrayList<String>();

GUIController c;
IFButton b1, b2, b3;
IFLabel l;

ControlP5 controlP5;
ListBox lb;

public void setup(){
  
  
  println(Serial.list());
  println();
  myPort = new Serial(this, Serial.list()[SERIAL_PORT_INDEX], 115200);
  
  UNO = loadImage("data/ArduinoUno.png");
  
  c = new GUIController(this);
  
  b1 = new IFButton("Send", 15, 15, 60, 30);
  b1.addActionListener(this);
  c.add(b1);
  
  b2 = new IFButton("Clear", 15, 50, 60, 30);
  b2.addActionListener(this);
  c.add(b2);
  
  //b3 = new IFButton("Reset VW Board", 15, 85, 120, 30);
  //b3.addActionListener(this);
  //c.add(b3);
  
  controlP5 = new ControlP5(this);
  lb = controlP5.addListBox("history", 940, 0, 180, 720);
  // l.actAsPulldownMenu(true);
  lb.setItemHeight(25);
  
  //initialize wire list console
  for(int i = 0; i < wirelist.size(); i++){
    lb.addItem(wirelist.get(i).getButtonLabel(), i);
  }
  
  create_nodes();
}

public void draw(){
  background(200);
  draw_board();
  
  //cood_tester();
  
  if(mouseFlag) for(int i = 0; i < nodelist.size(); i++) nodelist.get(i).draw();
  for(int i = 0; i < wirelist.size(); i++) wirelist.get(i).draw();
  
  if(mouseFlag){
    stroke(150, 150, 255);
    strokeWeight(5);
    line(lineAnchorX, lineAnchorY, mouseX, mouseY);
  }
  
}

public void draw_board(){
  background(200);
  noStroke();
  
  image(UNO, 50, 50, 875, 650);
  
  pushMatrix();
  translate(120, 82.5f);
  scale(1.25f);
  fill(255);
  rect(132.5f, 90, 220, 300, 10);
  rect(362.5f, 90, 220, 300, 10);
  fill(0);
  for(int i = 0; i < 5; i++)
    for(int j = 0; j < 8; j++) ellipse(170 + i*35, 118 + j*35, 15, 15);
  for(int i = 0; i < 5; i++)
    for(int j = 0; j < 8; j++) ellipse(400 + i*35, 118 + j*35, 15, 15);
  //for(int i = 0; i < 8; i++) rect(395, 115 + i*35, 150, 5);
  //for(int i = 0; i < 8; i++) rect(165, 115 + i*35, 150, 5);
  popMatrix();
}

public void cood_tester(){
  fill(255, 0, 0);
  ellipse(nodeToPixel("SCL").x, nodeToPixel("SCL").y, 10, 10);
  ellipse(nodeToPixel("SDA").x, nodeToPixel("SDA").y, 10, 10);
  ellipse(nodeToPixel("AREF").x, nodeToPixel("AREF").y, 10, 10);
  ellipse(nodeToPixel("GND1").x, nodeToPixel("GND1").y, 10, 10);
  ellipse(nodeToPixel("D13").x, nodeToPixel("D13").y, 10, 10);
  ellipse(nodeToPixel("D12").x, nodeToPixel("D12").y, 10, 10);
  ellipse(nodeToPixel("D11").x, nodeToPixel("D11").y, 10, 10);
  ellipse(nodeToPixel("D10").x, nodeToPixel("D10").y, 10, 10);
  ellipse(nodeToPixel("D9").x, nodeToPixel("D9").y, 10, 10);
  ellipse(nodeToPixel("D8").x, nodeToPixel("D8").y, 10, 10);
  ellipse(nodeToPixel("D7").x, nodeToPixel("D7").y, 10, 10);
  ellipse(nodeToPixel("D6").x, nodeToPixel("D6").y, 10, 10);
  ellipse(nodeToPixel("D5").x, nodeToPixel("D5").y, 10, 10);
  ellipse(nodeToPixel("D4").x, nodeToPixel("D4").y, 10, 10);
  ellipse(nodeToPixel("D3").x, nodeToPixel("D3").y, 10, 10);
  ellipse(nodeToPixel("D2").x, nodeToPixel("D2").y, 10, 10);
  ellipse(nodeToPixel("D1").x, nodeToPixel("D1").y, 10, 10);
  ellipse(nodeToPixel("D0").x, nodeToPixel("D0").y, 10, 10);
  
  ellipse(nodeToPixel("N/C").x, nodeToPixel("N/C").y, 10, 10);
  ellipse(nodeToPixel("IOREF").x, nodeToPixel("IOREF").y, 10, 10);
  ellipse(nodeToPixel("RESET").x, nodeToPixel("RESET").y, 10, 10);
  ellipse(nodeToPixel("A3V").x, nodeToPixel("A3V").y, 10, 10);
  ellipse(nodeToPixel("A5V").x, nodeToPixel("A5V").y, 10, 10);
  ellipse(nodeToPixel("GND2").x, nodeToPixel("GND2").y, 10, 10);
  ellipse(nodeToPixel("GND3").x, nodeToPixel("GND3").y, 10, 10);
  ellipse(nodeToPixel("VIN").x, nodeToPixel("VIN").y, 10, 10);
  ellipse(nodeToPixel("A0").x, nodeToPixel("A0").y, 10, 10);
  ellipse(nodeToPixel("A1").x, nodeToPixel("A1").y, 10, 10);
  ellipse(nodeToPixel("A2").x, nodeToPixel("A2").y, 10, 10);
  ellipse(nodeToPixel("A3").x, nodeToPixel("A3").y, 10, 10);
  ellipse(nodeToPixel("A4").x, nodeToPixel("A4").y, 10, 10);
  ellipse(nodeToPixel("A5").x, nodeToPixel("A5").y, 10, 10);
  
  ellipse(nodeToPixel("ROW1-1").x, nodeToPixel("ROW1-1").y, 10, 10);
  ellipse(nodeToPixel("ROW2-1").x, nodeToPixel("ROW2-1").y, 10, 10);
  ellipse(nodeToPixel("ROW3-1").x, nodeToPixel("ROW3-1").y, 10, 10);
  ellipse(nodeToPixel("ROW4-1").x, nodeToPixel("ROW4-1").y, 10, 10);
  ellipse(nodeToPixel("ROW5-1").x, nodeToPixel("ROW5-1").y, 10, 10);
  ellipse(nodeToPixel("ROW6-1").x, nodeToPixel("ROW6-1").y, 10, 10);
  ellipse(nodeToPixel("ROW7-1").x, nodeToPixel("ROW7-1").y, 10, 10);
  ellipse(nodeToPixel("ROW8-1").x, nodeToPixel("ROW8-1").y, 10, 10);
  
  ellipse(nodeToPixel("ROW1-2").x, nodeToPixel("ROW1-2").y, 10, 10);
  ellipse(nodeToPixel("ROW2-2").x, nodeToPixel("ROW2-2").y, 10, 10);
  ellipse(nodeToPixel("ROW3-2").x, nodeToPixel("ROW3-2").y, 10, 10);
  ellipse(nodeToPixel("ROW4-2").x, nodeToPixel("ROW4-2").y, 10, 10);
  ellipse(nodeToPixel("ROW5-2").x, nodeToPixel("ROW5-2").y, 10, 10);
  ellipse(nodeToPixel("ROW6-2").x, nodeToPixel("ROW6-2").y, 10, 10);
  ellipse(nodeToPixel("ROW7-2").x, nodeToPixel("ROW7-2").y, 10, 10);
  ellipse(nodeToPixel("ROW8-2").x, nodeToPixel("ROW8-2").y, 10, 10);
  
  ellipse(nodeToPixel("ROW1-3").x, nodeToPixel("ROW1-3").y, 10, 10);
  ellipse(nodeToPixel("ROW2-3").x, nodeToPixel("ROW2-3").y, 10, 10);
  ellipse(nodeToPixel("ROW3-3").x, nodeToPixel("ROW3-3").y, 10, 10);
  ellipse(nodeToPixel("ROW4-3").x, nodeToPixel("ROW4-3").y, 10, 10);
  ellipse(nodeToPixel("ROW5-3").x, nodeToPixel("ROW5-3").y, 10, 10);
  ellipse(nodeToPixel("ROW6-3").x, nodeToPixel("ROW6-3").y, 10, 10);
  ellipse(nodeToPixel("ROW7-3").x, nodeToPixel("ROW7-3").y, 10, 10);
  ellipse(nodeToPixel("ROW8-3").x, nodeToPixel("ROW8-3").y, 10, 10);
  
  ellipse(nodeToPixel("ROW1-4").x, nodeToPixel("ROW1-4").y, 10, 10);
  ellipse(nodeToPixel("ROW2-4").x, nodeToPixel("ROW2-4").y, 10, 10);
  ellipse(nodeToPixel("ROW3-4").x, nodeToPixel("ROW3-4").y, 10, 10);
  ellipse(nodeToPixel("ROW4-4").x, nodeToPixel("ROW4-4").y, 10, 10);
  ellipse(nodeToPixel("ROW5-4").x, nodeToPixel("ROW5-4").y, 10, 10);
  ellipse(nodeToPixel("ROW6-4").x, nodeToPixel("ROW6-4").y, 10, 10);
  ellipse(nodeToPixel("ROW7-4").x, nodeToPixel("ROW7-4").y, 10, 10);
  ellipse(nodeToPixel("ROW8-4").x, nodeToPixel("ROW8-4").y, 10, 10);
  
  ellipse(nodeToPixel("ROW1-5").x, nodeToPixel("ROW1-5").y, 10, 10);
  ellipse(nodeToPixel("ROW2-5").x, nodeToPixel("ROW2-5").y, 10, 10);
  ellipse(nodeToPixel("ROW3-5").x, nodeToPixel("ROW3-5").y, 10, 10);
  ellipse(nodeToPixel("ROW4-5").x, nodeToPixel("ROW4-5").y, 10, 10);
  ellipse(nodeToPixel("ROW5-5").x, nodeToPixel("ROW5-5").y, 10, 10);
  ellipse(nodeToPixel("ROW6-5").x, nodeToPixel("ROW6-5").y, 10, 10);
  ellipse(nodeToPixel("ROW7-5").x, nodeToPixel("ROW7-5").y, 10, 10);
  ellipse(nodeToPixel("ROW8-5").x, nodeToPixel("ROW8-5").y, 10, 10);
  
  ellipse(nodeToPixel("ROW9-1").x, nodeToPixel("ROW9-1").y, 10, 10);
  ellipse(nodeToPixel("ROW10-1").x, nodeToPixel("ROW10-1").y, 10, 10);
  ellipse(nodeToPixel("ROW11-1").x, nodeToPixel("ROW11-1").y, 10, 10);
  ellipse(nodeToPixel("ROW12-1").x, nodeToPixel("ROW12-1").y, 10, 10);
  ellipse(nodeToPixel("ROW13-1").x, nodeToPixel("ROW13-1").y, 10, 10);
  ellipse(nodeToPixel("ROW14-1").x, nodeToPixel("ROW14-1").y, 10, 10);
  ellipse(nodeToPixel("ROW15-1").x, nodeToPixel("ROW15-1").y, 10, 10);
  ellipse(nodeToPixel("ROW16-1").x, nodeToPixel("ROW16-1").y, 10, 10);
  
  ellipse(nodeToPixel("ROW9-2").x, nodeToPixel("ROW9-2").y, 10, 10);
  ellipse(nodeToPixel("ROW10-2").x, nodeToPixel("ROW10-2").y, 10, 10);
  ellipse(nodeToPixel("ROW11-2").x, nodeToPixel("ROW11-2").y, 10, 10);
  ellipse(nodeToPixel("ROW12-2").x, nodeToPixel("ROW12-2").y, 10, 10);
  ellipse(nodeToPixel("ROW13-2").x, nodeToPixel("ROW13-2").y, 10, 10);
  ellipse(nodeToPixel("ROW14-2").x, nodeToPixel("ROW14-2").y, 10, 10);
  ellipse(nodeToPixel("ROW15-2").x, nodeToPixel("ROW15-2").y, 10, 10);
  ellipse(nodeToPixel("ROW16-2").x, nodeToPixel("ROW16-2").y, 10, 10);
  
  ellipse(nodeToPixel("ROW9-3").x, nodeToPixel("ROW9-3").y, 10, 10);
  ellipse(nodeToPixel("ROW10-3").x, nodeToPixel("ROW10-3").y, 10, 10);
  ellipse(nodeToPixel("ROW11-3").x, nodeToPixel("ROW11-3").y, 10, 10);
  ellipse(nodeToPixel("ROW12-3").x, nodeToPixel("ROW12-3").y, 10, 10);
  ellipse(nodeToPixel("ROW13-3").x, nodeToPixel("ROW13-3").y, 10, 10);
  ellipse(nodeToPixel("ROW14-3").x, nodeToPixel("ROW14-3").y, 10, 10);
  ellipse(nodeToPixel("ROW15-3").x, nodeToPixel("ROW15-3").y, 10, 10);
  ellipse(nodeToPixel("ROW16-3").x, nodeToPixel("ROW16-3").y, 10, 10);
  
  ellipse(nodeToPixel("ROW9-4").x, nodeToPixel("ROW9-4").y, 10, 10);
  ellipse(nodeToPixel("ROW10-4").x, nodeToPixel("ROW10-4").y, 10, 10);
  ellipse(nodeToPixel("ROW11-4").x, nodeToPixel("ROW11-4").y, 10, 10);
  ellipse(nodeToPixel("ROW12-4").x, nodeToPixel("ROW12-4").y, 10, 10);
  ellipse(nodeToPixel("ROW13-4").x, nodeToPixel("ROW13-4").y, 10, 10);
  ellipse(nodeToPixel("ROW14-4").x, nodeToPixel("ROW14-4").y, 10, 10);
  ellipse(nodeToPixel("ROW15-4").x, nodeToPixel("ROW15-4").y, 10, 10);
  ellipse(nodeToPixel("ROW16-4").x, nodeToPixel("ROW16-4").y, 10, 10);
  
  ellipse(nodeToPixel("ROW9-5").x, nodeToPixel("ROW9-5").y, 10, 10);
  ellipse(nodeToPixel("ROW10-5").x, nodeToPixel("ROW10-5").y, 10, 10);
  ellipse(nodeToPixel("ROW11-5").x, nodeToPixel("ROW11-5").y, 10, 10);
  ellipse(nodeToPixel("ROW12-5").x, nodeToPixel("ROW12-5").y, 10, 10);
  ellipse(nodeToPixel("ROW13-5").x, nodeToPixel("ROW13-5").y, 10, 10);
  ellipse(nodeToPixel("ROW14-5").x, nodeToPixel("ROW14-5").y, 10, 10);
  ellipse(nodeToPixel("ROW15-5").x, nodeToPixel("ROW15-5").y, 10, 10);
  ellipse(nodeToPixel("ROW16-5").x, nodeToPixel("ROW16-5").y, 10, 10);
}

public PVector nodeToPixel(String node){
  int h1 = 108;
  int w1 = 355;
  int w2 = 647;
  float s1 = 27;
  
  if(node.equals("SCL")) return new PVector(w1, h1);
  if(node.equals("SDA")) return new PVector(w1 + s1, h1);
  if(node.equals("AREF")) return new PVector(w1 + 2*s1, h1);
  if(node.equals("GND1")) return new PVector(w1 + 3*s1, h1);
  if(node.equals("D13")) return new PVector(w1 + 4*s1, h1);
  if(node.equals("D12")) return new PVector(w1 + 5*s1, h1);
  if(node.equals("D11")) return new PVector(w1 + 6*s1, h1);
  if(node.equals("D10")) return new PVector(w1 + 7*s1 + 1, h1);
  if(node.equals("D9")) return new PVector(w1 + 8*s1 + 2, h1);
  if(node.equals("D8")) return new PVector(w1 + 9*s1 + 3, h1);
  
  if(node.equals("D7")) return new PVector(w2, h1);
  if(node.equals("D6")) return new PVector(w2 + s1, h1);
  if(node.equals("D5")) return new PVector(w2 + 2*s1, h1);
  if(node.equals("D4")) return new PVector(w2 + 3*s1, h1);
  if(node.equals("D3")) return new PVector(w2 + 4*s1, h1);
  if(node.equals("D2")) return new PVector(w2 + 5*s1 + 1, h1);
  if(node.equals("D1")) return new PVector(w2 + 6*s1 + 2, h1);
  if(node.equals("D0")) return new PVector(w2 + 7*s1 + 2, h1);
  
  int h2 = 640;
  int w3 = 453;
  int w4 = 702;
  
  if(node.equals("N/C")) return new PVector(w3, h2);
  if(node.equals("IOREF")) return new PVector(w3 + s1, h2);
  if(node.equals("RESET")) return new PVector(w3 + 2*s1, h2);
  if(node.equals("A3V")) return new PVector(w3 + 3*s1, h2);
  if(node.equals("A5V")) return new PVector(w3 + 4*s1 + 2, h2);
  if(node.equals("GND2")) return new PVector(w3 + 5*s1 + 2, h2);
  if(node.equals("GND3")) return new PVector(w3 + 6*s1 + 3, h2);
  if(node.equals("VIN")) return new PVector(w3 + 7*s1 + 3, h2);
  
  if(node.equals("A0")) return new PVector(w4, h2);
  if(node.equals("A1")) return new PVector(w4 + s1, h2);
  if(node.equals("A2")) return new PVector(w4 + 2*s1, h2);
  if(node.equals("A3")) return new PVector(w4 + 3*s1, h2);
  if(node.equals("A4")) return new PVector(w4 + 4*s1 + 2, h2);
  if(node.equals("A5")) return new PVector(w4 + 5*s1 + 2, h2);
  
  int h3 = 230;
  int w5_1 = 332;
  int w5_2 = 332 + 44;
  int w5_3 = 332 + 44*2;
  int w5_4 = 332 + 44*3;
  int w5_5 = 332 + 44*4;
  int w6_1 = 620;
  int w6_2 = 620 + 44;
  int w6_3 = 620 + 44*2;
  int w6_4 = 620 + 44*3;
  int w6_5 = 620 + 44*4;
  int s2 = 44;
  
  if(node.equals("ROW1-1")) return new PVector(w5_1, h3);
  if(node.equals("ROW2-1")) return new PVector(w5_1, h3 + s2);
  if(node.equals("ROW3-1")) return new PVector(w5_1, h3 + 2*s2);
  if(node.equals("ROW4-1")) return new PVector(w5_1, h3 + 3*s2);
  if(node.equals("ROW5-1")) return new PVector(w5_1, h3 + 4*s2 - 1);
  if(node.equals("ROW6-1")) return new PVector(w5_1, h3 + 5*s2 - 1);
  if(node.equals("ROW7-1")) return new PVector(w5_1, h3 + 6*s2 - 2);
  if(node.equals("ROW8-1")) return new PVector(w5_1, h3 + 7*s2 - 2);
  
  if(node.equals("ROW1-2")) return new PVector(w5_2, h3);
  if(node.equals("ROW2-2")) return new PVector(w5_2, h3 + s2);
  if(node.equals("ROW3-2")) return new PVector(w5_2, h3 + 2*s2);
  if(node.equals("ROW4-2")) return new PVector(w5_2, h3 + 3*s2);
  if(node.equals("ROW5-2")) return new PVector(w5_2, h3 + 4*s2 - 1);
  if(node.equals("ROW6-2")) return new PVector(w5_2, h3 + 5*s2 - 1);
  if(node.equals("ROW7-2")) return new PVector(w5_2, h3 + 6*s2 - 2);
  if(node.equals("ROW8-2")) return new PVector(w5_2, h3 + 7*s2 - 2);
  
  if(node.equals("ROW1-3")) return new PVector(w5_3, h3);
  if(node.equals("ROW2-3")) return new PVector(w5_3, h3 + s2);
  if(node.equals("ROW3-3")) return new PVector(w5_3, h3 + 2*s2);
  if(node.equals("ROW4-3")) return new PVector(w5_3, h3 + 3*s2);
  if(node.equals("ROW5-3")) return new PVector(w5_3, h3 + 4*s2 - 1);
  if(node.equals("ROW6-3")) return new PVector(w5_3, h3 + 5*s2 - 1);
  if(node.equals("ROW7-3")) return new PVector(w5_3, h3 + 6*s2 - 2);
  if(node.equals("ROW8-3")) return new PVector(w5_3, h3 + 7*s2 - 2);
  
  if(node.equals("ROW1-4")) return new PVector(w5_4, h3);
  if(node.equals("ROW2-4")) return new PVector(w5_4, h3 + s2);
  if(node.equals("ROW3-4")) return new PVector(w5_4, h3 + 2*s2);
  if(node.equals("ROW4-4")) return new PVector(w5_4, h3 + 3*s2);
  if(node.equals("ROW5-4")) return new PVector(w5_4, h3 + 4*s2 - 1);
  if(node.equals("ROW6-4")) return new PVector(w5_4, h3 + 5*s2 - 1);
  if(node.equals("ROW7-4")) return new PVector(w5_4, h3 + 6*s2 - 2);
  if(node.equals("ROW8-4")) return new PVector(w5_4, h3 + 7*s2 - 2);
  
  if(node.equals("ROW1-5")) return new PVector(w5_5, h3);
  if(node.equals("ROW2-5")) return new PVector(w5_5, h3 + s2);
  if(node.equals("ROW3-5")) return new PVector(w5_5, h3 + 2*s2);
  if(node.equals("ROW4-5")) return new PVector(w5_5, h3 + 3*s2);
  if(node.equals("ROW5-5")) return new PVector(w5_5, h3 + 4*s2 - 1);
  if(node.equals("ROW6-5")) return new PVector(w5_5, h3 + 5*s2 - 1);
  if(node.equals("ROW7-5")) return new PVector(w5_5, h3 + 6*s2 - 2);
  if(node.equals("ROW8-5")) return new PVector(w5_5, h3 + 7*s2 - 2);
  
  if(node.equals("ROW9-1")) return new PVector(w6_1, h3);
  if(node.equals("ROW10-1")) return new PVector(w6_1, h3 + s2);
  if(node.equals("ROW11-1")) return new PVector(w6_1, h3 + 2*s2);
  if(node.equals("ROW12-1")) return new PVector(w6_1, h3 + 3*s2);
  if(node.equals("ROW13-1")) return new PVector(w6_1, h3 + 4*s2 - 1);
  if(node.equals("ROW14-1")) return new PVector(w6_1, h3 + 5*s2 - 1);
  if(node.equals("ROW15-1")) return new PVector(w6_1, h3 + 6*s2 - 2);
  if(node.equals("ROW16-1")) return new PVector(w6_1, h3 + 7*s2 - 2);
  
  if(node.equals("ROW9-2")) return new PVector(w6_2, h3);
  if(node.equals("ROW10-2")) return new PVector(w6_2, h3 + s2);
  if(node.equals("ROW11-2")) return new PVector(w6_2, h3 + 2*s2);
  if(node.equals("ROW12-2")) return new PVector(w6_2, h3 + 3*s2);
  if(node.equals("ROW13-2")) return new PVector(w6_2, h3 + 4*s2 - 1);
  if(node.equals("ROW14-2")) return new PVector(w6_2, h3 + 5*s2 - 1);
  if(node.equals("ROW15-2")) return new PVector(w6_2, h3 + 6*s2 - 2);
  if(node.equals("ROW16-2")) return new PVector(w6_2, h3 + 7*s2 - 2);
  
  if(node.equals("ROW9-3")) return new PVector(w6_3, h3);
  if(node.equals("ROW10-3")) return new PVector(w6_3, h3 + s2);
  if(node.equals("ROW11-3")) return new PVector(w6_3, h3 + 2*s2);
  if(node.equals("ROW12-3")) return new PVector(w6_3, h3 + 3*s2);
  if(node.equals("ROW13-3")) return new PVector(w6_3, h3 + 4*s2 - 1);
  if(node.equals("ROW14-3")) return new PVector(w6_3, h3 + 5*s2 - 1);
  if(node.equals("ROW15-3")) return new PVector(w6_3, h3 + 6*s2 - 2);
  if(node.equals("ROW16-3")) return new PVector(w6_3, h3 + 7*s2 - 2);
  
  if(node.equals("ROW9-4")) return new PVector(w6_4, h3);
  if(node.equals("ROW10-4")) return new PVector(w6_4, h3 + s2);
  if(node.equals("ROW11-4")) return new PVector(w6_4, h3 + 2*s2);
  if(node.equals("ROW12-4")) return new PVector(w6_4, h3 + 3*s2);
  if(node.equals("ROW13-4")) return new PVector(w6_4, h3 + 4*s2 - 1);
  if(node.equals("ROW14-4")) return new PVector(w6_4, h3 + 5*s2 - 1);
  if(node.equals("ROW15-4")) return new PVector(w6_4, h3 + 6*s2 - 2);
  if(node.equals("ROW16-4")) return new PVector(w6_4, h3 + 7*s2 - 2);
  
  if(node.equals("ROW9-5")) return new PVector(w6_5, h3);
  if(node.equals("ROW10-5")) return new PVector(w6_5, h3 + s2);
  if(node.equals("ROW11-5")) return new PVector(w6_5, h3 + 2*s2);
  if(node.equals("ROW12-5")) return new PVector(w6_5, h3 + 3*s2);
  if(node.equals("ROW13-5")) return new PVector(w6_5, h3 + 4*s2 - 1);
  if(node.equals("ROW14-5")) return new PVector(w6_5, h3 + 5*s2 - 1);
  if(node.equals("ROW15-5")) return new PVector(w6_5, h3 + 6*s2 - 2);
  if(node.equals("ROW16-5")) return new PVector(w6_5, h3 + 7*s2 - 2);
  
  return new PVector(-7, -7);
}
public void mousePressed(){
  if(mouseFlag == false && mouseX < 940){
    //println("mouse down");
    mouseFlag = true;
    lineAnchorX = mouseX;
    lineAnchorY = mouseY;
  }
}

public void mouseReleased(){
  //println("mouse up");
  mouseFlag = false;
  
  int currX = mouseX;
  int currY = mouseY;
  
  if(!checkWithinNode(lineAnchorX, lineAnchorY).equals("null") && !checkWithinNode(currX, currY).equals("null")){
    String from = checkWithinNode(lineAnchorX, lineAnchorY);
    String to = checkWithinNode(currX, currY);
    
    if(!from.equals(to)) wirelist.add(new Wire(from, to, lineAnchorX, lineAnchorY, currX, currY));
    
    lb.clear();
    
    for(int i = 0; i < wirelist.size(); i++) {
      lb.addItem(wirelist.get(i).getButtonLabel(), i);
    }
  }
}

public void history(int x) {
  println("deleting " + wirelist.get(x).getButtonLabel());
  lb.clear();
  
  wirelist.remove(x);
  
  for(int i = 0; i < wirelist.size(); i++) {
    lb.addItem(wirelist.get(i).getButtonLabel(), i);
  }
}

public void actionPerformed (GUIEvent e) {
  if (e.getSource() == b1) {
    for(int i = 0; i < wirelist.size(); i++){
      println("Wire #" + (i + 1));
      println(wirelist.get(i));
    }
    updateCommands_Multi();
    printAllCommands();
    runAllCommands();
  }
  
  if (e.getSource() == b2) {
    println();
    println("WIRES CLEARED");
    
    wirelist.clear();
    lb.clear();
    
    println("SENDING RESET COMMAND");
  
    String runThis = "{\"cmd\":\"reset\"}" + "\n";
    println("{\"cmd\":\"reset\"}" + " - sent to VW Board");
    myPort.write(runThis);
  }
  
  //if(e.getSource() == b3) {
  //  println("SENDING RESET COMMAND");
  //
  //  String runThis = "{\"cmd\":\"reset\"}" + "\n";
  //  println("{\"cmd\":\"reset\"}" + " - sent to VW Board");
  //  myPort.write(runThis);
  //}
}


public void serialEvent(Serial p) {
  inString = p.readStringUntil(10);
  if(inString != null){
    println(inString + " - received from VW Board");
    serialCmdIndex++;
    
    if(serialCmdIndex < commandList.size()){
      String runThis = commandList.get(serialCmdIndex) + "\n";
      println(commandList.get(serialCmdIndex));
      myPort.write(runThis);
    }else{
      serialCmdIndex = 0;
      println("BOARD CONNECTIONS UPDATED");
    }
  }
  
}
public String checkWithinNode(int x, int y){
  String result = "null";
  String temp;
  
  for(int i = 0; i < nodelist.size(); i++){
    temp = nodelist.get(i).within(x, y);
    if(!temp.equals("null")) return temp;
  }
  
  return result;
}
class Node{
  String name;
  int posX;
  int posY;
  
  Node(String name, int posX, int posY){
    this.name = name;
    this.posX = posX;
    this.posY = posY;
  }
  
  public int getX(){ return this.posX; }
  public int getY(){ return this.posY; }
  
  public void draw(){
    fill(0, 255, 125);
    noStroke();
    ellipse(posX, posY, 15, 15);
  }
  
  public String within(int x, int y){
    if(dist(x, y, posX, posY) < 10) return this.name;
    return "null";
  }
  
  public String toString(){ return "Node: " + name; }
}

public void create_nodes(){
  nodelist.add(new Node("SCL", (int)nodeToPixel("SCL").x, (int)nodeToPixel("SCL").y));
  nodelist.add(new Node("SDA", (int)nodeToPixel("SDA").x, (int)nodeToPixel("SDA").y));
  nodelist.add(new Node("AREF", (int)nodeToPixel("AREF").x, (int)nodeToPixel("AREF").y));
  nodelist.add(new Node("GND1", (int)nodeToPixel("GND1").x, (int)nodeToPixel("GND1").y));
  nodelist.add(new Node("D13", (int)nodeToPixel("D13").x, (int)nodeToPixel("D13").y));
  nodelist.add(new Node("D12", (int)nodeToPixel("D12").x, (int)nodeToPixel("D12").y));
  nodelist.add(new Node("D11", (int)nodeToPixel("D11").x, (int)nodeToPixel("D11").y));
  nodelist.add(new Node("D10", (int)nodeToPixel("D10").x, (int)nodeToPixel("D10").y));
  nodelist.add(new Node("D9", (int)nodeToPixel("D9").x, (int)nodeToPixel("D9").y));
  nodelist.add(new Node("D8", (int)nodeToPixel("D8").x, (int)nodeToPixel("D8").y));
  
  nodelist.add(new Node("D7", (int)nodeToPixel("D7").x, (int)nodeToPixel("D7").y));
  nodelist.add(new Node("D6", (int)nodeToPixel("D6").x, (int)nodeToPixel("D6").y));
  nodelist.add(new Node("D5", (int)nodeToPixel("D5").x, (int)nodeToPixel("D5").y));
  nodelist.add(new Node("D4", (int)nodeToPixel("D4").x, (int)nodeToPixel("D4").y));
  nodelist.add(new Node("D3", (int)nodeToPixel("D3").x, (int)nodeToPixel("D3").y));
  nodelist.add(new Node("D2", (int)nodeToPixel("D2").x, (int)nodeToPixel("D2").y));
  nodelist.add(new Node("D1", (int)nodeToPixel("D1").x, (int)nodeToPixel("D1").y));
  nodelist.add(new Node("D0", (int)nodeToPixel("D0").x, (int)nodeToPixel("D0").y));
  
  nodelist.add(new Node("N/C", (int)nodeToPixel("N/C").x, (int)nodeToPixel("N/C").y));
  nodelist.add(new Node("IOREF", (int)nodeToPixel("IOREF").x, (int)nodeToPixel("IOREF").y));
  nodelist.add(new Node("RESET", (int)nodeToPixel("RESET").x, (int)nodeToPixel("RESET").y));
  nodelist.add(new Node("A3V", (int)nodeToPixel("A3V").x, (int)nodeToPixel("A3V").y));
  nodelist.add(new Node("A5V", (int)nodeToPixel("A5V").x, (int)nodeToPixel("A5V").y));
  nodelist.add(new Node("GND2", (int)nodeToPixel("GND2").x, (int)nodeToPixel("GND2").y));
  nodelist.add(new Node("GND3", (int)nodeToPixel("GND3").x, (int)nodeToPixel("GND3").y));
  nodelist.add(new Node("VIN", (int)nodeToPixel("VIN").x, (int)nodeToPixel("VIN").y));
  
  nodelist.add(new Node("A0", (int)nodeToPixel("A0").x, (int)nodeToPixel("A0").y));
  nodelist.add(new Node("A1", (int)nodeToPixel("A1").x, (int)nodeToPixel("A1").y));
  nodelist.add(new Node("A2", (int)nodeToPixel("A2").x, (int)nodeToPixel("A2").y));
  nodelist.add(new Node("A3", (int)nodeToPixel("A3").x, (int)nodeToPixel("A3").y));
  nodelist.add(new Node("A4", (int)nodeToPixel("A4").x, (int)nodeToPixel("A4").y));
  nodelist.add(new Node("A5", (int)nodeToPixel("A5").x, (int)nodeToPixel("A5").y));
  
  nodelist.add(new Node("ROW1", (int)nodeToPixel("ROW1-1").x, (int)nodeToPixel("ROW1-1").y));
  nodelist.add(new Node("ROW2", (int)nodeToPixel("ROW2-1").x, (int)nodeToPixel("ROW2-1").y));
  nodelist.add(new Node("ROW3", (int)nodeToPixel("ROW3-1").x, (int)nodeToPixel("ROW3-1").y));
  nodelist.add(new Node("ROW4", (int)nodeToPixel("ROW4-1").x, (int)nodeToPixel("ROW4-1").y));
  nodelist.add(new Node("ROW5", (int)nodeToPixel("ROW5-1").x, (int)nodeToPixel("ROW5-1").y));
  nodelist.add(new Node("ROW6", (int)nodeToPixel("ROW6-1").x, (int)nodeToPixel("ROW6-1").y));
  nodelist.add(new Node("ROW7", (int)nodeToPixel("ROW7-1").x, (int)nodeToPixel("ROW7-1").y));
  nodelist.add(new Node("ROW8", (int)nodeToPixel("ROW8-1").x, (int)nodeToPixel("ROW8-1").y));
  
  nodelist.add(new Node("ROW1", (int)nodeToPixel("ROW1-2").x, (int)nodeToPixel("ROW1-2").y));
  nodelist.add(new Node("ROW2", (int)nodeToPixel("ROW2-2").x, (int)nodeToPixel("ROW2-2").y));
  nodelist.add(new Node("ROW3", (int)nodeToPixel("ROW3-2").x, (int)nodeToPixel("ROW3-2").y));
  nodelist.add(new Node("ROW4", (int)nodeToPixel("ROW4-2").x, (int)nodeToPixel("ROW4-2").y));
  nodelist.add(new Node("ROW5", (int)nodeToPixel("ROW5-2").x, (int)nodeToPixel("ROW5-2").y));
  nodelist.add(new Node("ROW6", (int)nodeToPixel("ROW6-2").x, (int)nodeToPixel("ROW6-2").y));
  nodelist.add(new Node("ROW7", (int)nodeToPixel("ROW7-2").x, (int)nodeToPixel("ROW7-2").y));
  nodelist.add(new Node("ROW8", (int)nodeToPixel("ROW8-2").x, (int)nodeToPixel("ROW8-2").y));
  
  nodelist.add(new Node("ROW1", (int)nodeToPixel("ROW1-3").x, (int)nodeToPixel("ROW1-3").y));
  nodelist.add(new Node("ROW2", (int)nodeToPixel("ROW2-3").x, (int)nodeToPixel("ROW2-3").y));
  nodelist.add(new Node("ROW3", (int)nodeToPixel("ROW3-3").x, (int)nodeToPixel("ROW3-3").y));
  nodelist.add(new Node("ROW4", (int)nodeToPixel("ROW4-3").x, (int)nodeToPixel("ROW4-3").y));
  nodelist.add(new Node("ROW5", (int)nodeToPixel("ROW5-3").x, (int)nodeToPixel("ROW5-3").y));
  nodelist.add(new Node("ROW6", (int)nodeToPixel("ROW6-3").x, (int)nodeToPixel("ROW6-3").y));
  nodelist.add(new Node("ROW7", (int)nodeToPixel("ROW7-3").x, (int)nodeToPixel("ROW7-3").y));
  nodelist.add(new Node("ROW8", (int)nodeToPixel("ROW8-3").x, (int)nodeToPixel("ROW8-3").y));
  
  nodelist.add(new Node("ROW1", (int)nodeToPixel("ROW1-4").x, (int)nodeToPixel("ROW1-4").y));
  nodelist.add(new Node("ROW2", (int)nodeToPixel("ROW2-4").x, (int)nodeToPixel("ROW2-4").y));
  nodelist.add(new Node("ROW3", (int)nodeToPixel("ROW3-4").x, (int)nodeToPixel("ROW3-4").y));
  nodelist.add(new Node("ROW4", (int)nodeToPixel("ROW4-4").x, (int)nodeToPixel("ROW4-4").y));
  nodelist.add(new Node("ROW5", (int)nodeToPixel("ROW5-4").x, (int)nodeToPixel("ROW5-4").y));
  nodelist.add(new Node("ROW6", (int)nodeToPixel("ROW6-4").x, (int)nodeToPixel("ROW6-4").y));
  nodelist.add(new Node("ROW7", (int)nodeToPixel("ROW7-4").x, (int)nodeToPixel("ROW7-4").y));
  nodelist.add(new Node("ROW8", (int)nodeToPixel("ROW8-4").x, (int)nodeToPixel("ROW8-4").y));
  
  nodelist.add(new Node("ROW1", (int)nodeToPixel("ROW1-5").x, (int)nodeToPixel("ROW1-5").y));
  nodelist.add(new Node("ROW2", (int)nodeToPixel("ROW2-5").x, (int)nodeToPixel("ROW2-5").y));
  nodelist.add(new Node("ROW3", (int)nodeToPixel("ROW3-5").x, (int)nodeToPixel("ROW3-5").y));
  nodelist.add(new Node("ROW4", (int)nodeToPixel("ROW4-5").x, (int)nodeToPixel("ROW4-5").y));
  nodelist.add(new Node("ROW5", (int)nodeToPixel("ROW5-5").x, (int)nodeToPixel("ROW5-5").y));
  nodelist.add(new Node("ROW6", (int)nodeToPixel("ROW6-5").x, (int)nodeToPixel("ROW6-5").y));
  nodelist.add(new Node("ROW7", (int)nodeToPixel("ROW7-5").x, (int)nodeToPixel("ROW7-5").y));
  nodelist.add(new Node("ROW8", (int)nodeToPixel("ROW8-5").x, (int)nodeToPixel("ROW8-5").y));
  
  nodelist.add(new Node("ROW9", (int)nodeToPixel("ROW9-1").x, (int)nodeToPixel("ROW9-1").y));
  nodelist.add(new Node("ROW10", (int)nodeToPixel("ROW10-1").x, (int)nodeToPixel("ROW10-1").y));
  nodelist.add(new Node("ROW11", (int)nodeToPixel("ROW11-1").x, (int)nodeToPixel("ROW11-1").y));
  nodelist.add(new Node("ROW12", (int)nodeToPixel("ROW12-1").x, (int)nodeToPixel("ROW12-1").y));
  nodelist.add(new Node("ROW13", (int)nodeToPixel("ROW13-1").x, (int)nodeToPixel("ROW13-1").y));
  nodelist.add(new Node("ROW14", (int)nodeToPixel("ROW14-1").x, (int)nodeToPixel("ROW14-1").y));
  nodelist.add(new Node("ROW15", (int)nodeToPixel("ROW15-1").x, (int)nodeToPixel("ROW15-1").y));
  nodelist.add(new Node("ROW16", (int)nodeToPixel("ROW16-1").x, (int)nodeToPixel("ROW16-1").y));
  
  nodelist.add(new Node("ROW9", (int)nodeToPixel("ROW9-2").x, (int)nodeToPixel("ROW9-2").y));
  nodelist.add(new Node("ROW10", (int)nodeToPixel("ROW10-2").x, (int)nodeToPixel("ROW10-2").y));
  nodelist.add(new Node("ROW11", (int)nodeToPixel("ROW11-2").x, (int)nodeToPixel("ROW11-2").y));
  nodelist.add(new Node("ROW12", (int)nodeToPixel("ROW12-2").x, (int)nodeToPixel("ROW12-2").y));
  nodelist.add(new Node("ROW13", (int)nodeToPixel("ROW13-2").x, (int)nodeToPixel("ROW13-2").y));
  nodelist.add(new Node("ROW14", (int)nodeToPixel("ROW14-2").x, (int)nodeToPixel("ROW14-2").y));
  nodelist.add(new Node("ROW15", (int)nodeToPixel("ROW15-2").x, (int)nodeToPixel("ROW15-2").y));
  nodelist.add(new Node("ROW16", (int)nodeToPixel("ROW16-2").x, (int)nodeToPixel("ROW16-2").y));
  
  nodelist.add(new Node("ROW9", (int)nodeToPixel("ROW9-3").x, (int)nodeToPixel("ROW9-3").y));
  nodelist.add(new Node("ROW10", (int)nodeToPixel("ROW10-3").x, (int)nodeToPixel("ROW10-3").y));
  nodelist.add(new Node("ROW11", (int)nodeToPixel("ROW11-3").x, (int)nodeToPixel("ROW11-3").y));
  nodelist.add(new Node("ROW12", (int)nodeToPixel("ROW12-3").x, (int)nodeToPixel("ROW12-3").y));
  nodelist.add(new Node("ROW13", (int)nodeToPixel("ROW13-3").x, (int)nodeToPixel("ROW13-3").y));
  nodelist.add(new Node("ROW14", (int)nodeToPixel("ROW14-3").x, (int)nodeToPixel("ROW14-3").y));
  nodelist.add(new Node("ROW15", (int)nodeToPixel("ROW15-3").x, (int)nodeToPixel("ROW15-3").y));
  nodelist.add(new Node("ROW16", (int)nodeToPixel("ROW16-3").x, (int)nodeToPixel("ROW16-3").y));
  
  nodelist.add(new Node("ROW9", (int)nodeToPixel("ROW9-4").x, (int)nodeToPixel("ROW9-4").y));
  nodelist.add(new Node("ROW10", (int)nodeToPixel("ROW10-4").x, (int)nodeToPixel("ROW10-4").y));
  nodelist.add(new Node("ROW11", (int)nodeToPixel("ROW11-4").x, (int)nodeToPixel("ROW11-4").y));
  nodelist.add(new Node("ROW12", (int)nodeToPixel("ROW12-4").x, (int)nodeToPixel("ROW12-4").y));
  nodelist.add(new Node("ROW13", (int)nodeToPixel("ROW13-4").x, (int)nodeToPixel("ROW13-4").y));
  nodelist.add(new Node("ROW14", (int)nodeToPixel("ROW14-4").x, (int)nodeToPixel("ROW14-4").y));
  nodelist.add(new Node("ROW15", (int)nodeToPixel("ROW15-4").x, (int)nodeToPixel("ROW15-4").y));
  nodelist.add(new Node("ROW16", (int)nodeToPixel("ROW16-4").x, (int)nodeToPixel("ROW16-4").y));
  
  nodelist.add(new Node("ROW9", (int)nodeToPixel("ROW9-5").x, (int)nodeToPixel("ROW9-5").y));
  nodelist.add(new Node("ROW10", (int)nodeToPixel("ROW10-5").x, (int)nodeToPixel("ROW10-5").y));
  nodelist.add(new Node("ROW11", (int)nodeToPixel("ROW11-5").x, (int)nodeToPixel("ROW11-5").y));
  nodelist.add(new Node("ROW12", (int)nodeToPixel("ROW12-5").x, (int)nodeToPixel("ROW12-5").y));
  nodelist.add(new Node("ROW13", (int)nodeToPixel("ROW13-5").x, (int)nodeToPixel("ROW13-5").y));
  nodelist.add(new Node("ROW14", (int)nodeToPixel("ROW14-5").x, (int)nodeToPixel("ROW14-5").y));
  nodelist.add(new Node("ROW15", (int)nodeToPixel("ROW15-5").x, (int)nodeToPixel("ROW15-5").y));
  nodelist.add(new Node("ROW16", (int)nodeToPixel("ROW16-5").x, (int)nodeToPixel("ROW16-5").y));
}
public void updateCommands_Multi(){
  commandList.clear();
  commandList.add("{\"cmd\":\"reset\"}");
  
  String cmd1 = "{\"cmd\":\"connect\", \"data\": [\"";
  
  for(int i = 0; i < wirelist.size()-1; i++){
    cmd1 = cmd1 + wirelist.get(i).getFrom() + "\", \"" + wirelist.get(i).getTo() + "\", \"";
  }
  cmd1 = cmd1 + wirelist.get(wirelist.size()-1).getFrom() + "\", \"" + wirelist.get(wirelist.size()-1).getTo() + "\"]}";
  
  commandList.add(cmd1);
  println("COMMANDS UPDATED");
}

public void printAllCommands(){
  for(int i = 0; i < commandList.size(); i++){
    print("COMMAND #" + (i + 1) + ": ");
    println(commandList.get(i));
  }
  println();
}

public void runAllCommands(){
  println("SENDING COMMANDS");
  
  String runThis = commandList.get(serialCmdIndex) + "\n";
  println(commandList.get(serialCmdIndex) + " - sent to VW Board");
  myPort.write(runThis);
}
class Wire{
  String from;
  String to;
  
  int x1;
  int y1;
  int x2;
  int y2;
  
  int r;
  int g;
  int b;
  
  Wire(String from, String to, int x1, int y1, int x2, int y2){
    //r = (int)random(0, 255);
    //g = (int)random(0, 255);
    //b = (int)random(0, 255);
    
    this.from = from;
    this.to = to;
    
    this.x1 = x1;
    this.y1 = y1;
    this.x2 = x2;
    this.y2 = y2;
  }
  
  public void draw(){
    //stroke(r, g, b);
    stroke(230, 230, 25);
    strokeWeight(5);
    
    line(x1, y1, x2, y2);
    noStroke();
  }
  
  public String getFrom(){
    return from;
  }
  
  public String getTo(){
    return to;
  }
  
  public String getButtonLabel(){
    return from + "-" + to;
  }
  
  //public String toString(){ return "x1: " + x1 + "\ny1: " + y1 + "\nx2: " + x2 + "\ny2" + y2 + "\n\n"; }
  public String toString(){ return "from: " + from + "\nto: " + to + "\n"; }
}
  public void settings() {  size(1120, 720); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "VirtualWireStandalone" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
