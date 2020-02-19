import java.util.*;
import java.io.*;
import interfascia.*;
import processing.serial.*;


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


void setup(){
  size(1000, 720);
  
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
  
  b3 = new IFButton("Reset VW Board", 15, 85, 120, 30);
  b3.addActionListener(this);
  c.add(b3);
  
  create_nodes();
}

void draw(){
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

void draw_board(){
  background(200);
  noStroke();
  
  image(UNO, 50, 50, 875, 650);
  
  pushMatrix();
  translate(120, 82.5);
  scale(1.25);
  fill(255);
  rect(132.5, 90, 220, 300, 10);
  rect(362.5, 90, 220, 300, 10);
  fill(0);
  for(int i = 0; i < 5; i++)
    for(int j = 0; j < 8; j++) ellipse(170 + i*35, 118 + j*35, 15, 15);
  for(int i = 0; i < 5; i++)
    for(int j = 0; j < 8; j++) ellipse(400 + i*35, 118 + j*35, 15, 15);
  //for(int i = 0; i < 8; i++) rect(395, 115 + i*35, 150, 5);
  //for(int i = 0; i < 8; i++) rect(165, 115 + i*35, 150, 5);
  popMatrix();
}
