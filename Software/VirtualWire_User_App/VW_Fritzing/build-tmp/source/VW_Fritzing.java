import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.*; 
import java.io.*; 
import interfascia.*; 
import processing.serial.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class VW_Fritzing extends PApplet {





final int SERIAL_PORT_INDEX = 1;

Serial myPort;                // The serial port
String inString;              // Input string from serial port
String receivedMessage = "";  // message from hardware
String fileName;
String filePath;
String folderPath;

int serialCmdIndex = 0; 

JSONArray allCommands;

Console console;

GUIController c;
IFButton brdSignalInject_regular;
IFButton brdSignalInject_voltera;

Timer timer;
TimerTask task;

int lastChangeTime;
int thisChangeTime;
boolean firstSave = true;

public void setup(){
  
  background(200);
  
  console = new Console(0, 450, width, height-450, 9, width/50);
  
  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[SERIAL_PORT_INDEX], 115200); 
  
  c = new GUIController(this);
  
  brdSignalInject_regular = new IFButton ("brdSignalInject_regular", 30, 150, 150, 30);
  brdSignalInject_voltera = new IFButton ("brdSignalInject_voltera", 30, 190, 150, 30);
  
  brdSignalInject_regular.addActionListener(this);
  brdSignalInject_voltera.addActionListener(this);
  
  c.add(brdSignalInject_regular);
  c.add(brdSignalInject_voltera);
  
  lastChangeTime = millis();
  
  //surface.setVisible(false);
  prepareExitHandler();
  selectInput("Select a file to process:", "fileSelected");
}

public void mouseWheel(MouseEvent event) {
  int e = (int)event.getCount();
  console.scrollConsole(e);
}

public void draw(){
  
  fill(43, 48, 69);
  rect(0, 450, width, height-450);
  console.display();
  
}

public void actionPerformed (GUIEvent e){
  if(e.getSource() == brdSignalInject_regular){
    clearBrdSignals_regular();
    injectSignals_regular();
  }else if(e.getSource() == brdSignalInject_voltera){
    clearBrdSignals_voltera();
    injectSignals_voltera();
  }
}

public void fileSelected(File selection) {
  if (selection == null) {
    console.println("Window was closed or the user hit cancel.");
    return;
  }else{
    fileName = selection.getName();
    filePath = selection.getPath();
    folderPath = selection.getParent() + "\\";
    console.println("file name is: " + fileName);
    console.println("file path is: " + filePath);
    console.println("folder path is: " + folderPath);
    console.println(" ");
  }
  
  task = new FileWatcher( selection ) {
    protected void onChange( File file ) {
      
      thisChangeTime = millis();
      
      if(thisChangeTime - lastChangeTime > 5000){
        console.println("LAST CHANGE: " + lastChangeTime);
        console.println("THIS CHANGE: " + thisChangeTime);
        lastChangeTime = thisChangeTime;
        
        console.println("File "+ file.getName() +" has changed!!!");
        console.println(" ");
        
        delay(2000);
        updateConnections_FZ(filePath);
        
        delay(2000);
        updateCommands_Multi();
        
        runAllCommands();
      }
    }
  };

  timer = new Timer();
  // repeat the check every second
  timer.schedule( task, new Date(), 1000 );
}
public void injectSignals_regular(){
  ArrayList<String> allNets = pairsToNet();
  
  String[] contacts;
  String from;
  String to;
  int cnum = 1;
  
  XML brd_xml = loadXML("data/PCB/VW_PCB.brd");
  XML[] drawing = brd_xml.getChildren("drawing");
  XML[] board = drawing[0].getChildren("board");
  XML[] signals = board[0].getChildren("signals");
  
  for(int i = 0; i < allNets.size(); i++){
    contacts = split(allNets.get(i), "_");
    
    XML signal = signals[0].addChild("signal");
    signal.setString("name", "S$"+cnum);
    cnum++;
    
    String first = contacts[0];
    if(first.equals("3V3")) first = "A3V";
    if(first.equals("5V")) first = "A5V";
    
    XML contactrefFirst = signal.addChild("contactref");
    contactrefFirst.setString("element", "E$1");
    contactrefFirst.setString("pad", first);
    
    from = contacts[0];
    //if(from.equals("GND")) from = "GND1";
    if(from.equals("3V3")) from = "A3V";
    if(from.equals("5V")) from = "A5V";
      
    for(int j = 1; j < contacts.length; j++){
      
      to = contacts[j];
      //if(to.equals("GND")) to = "GND1";
      if(to.equals("3V3")) to = "A3V";
      if(to.equals("5V")) to = "A5V";
    
      XML contactrefTo = signal.addChild("contactref");
      contactrefTo.setString("element", "E$1");
      contactrefTo.setString("pad", to);
      XML wire = signal.addChild("wire");
      wire.setString("width", "0");
      wire.setString("layer", "19");
      wire.setString("extent", "1-16");
      
      wire.setString("x1", ""+getBoardCoordinate_regular(from).x);
      wire.setString("y1", ""+getBoardCoordinate_regular(from).y);
      wire.setString("x2", ""+getBoardCoordinate_regular(to).x);
      wire.setString("y2", ""+getBoardCoordinate_regular(to).y);
      
      from = to;
    }
  }
  
  saveXML(brd_xml, "data/PCB/VW_PCB.brd");
  console.println("VW_PCB.brd Signals Injected");
}

//inject via netlist made by CurrentConnections.json (VOLTERA)
public void injectSignals_voltera(){
  ArrayList<String> allNets = pairsToNet();
  
  String[] contacts;
  String from;
  String to;
  int cnum = 1;
  
  XML brd_xml = loadXML("data/PCB/VW_PCB_Voltera.brd");
  XML[] drawing = brd_xml.getChildren("drawing");
  XML[] board = drawing[0].getChildren("board");
  XML[] signals = board[0].getChildren("signals");
  
  for(int i = 0; i < allNets.size(); i++){
    contacts = split(allNets.get(i), "_");
    
    XML signal = signals[0].addChild("signal");
    signal.setString("name", "S$"+cnum);
    cnum++;
    
    String first = contacts[0];
    if(first.equals("3V3")) first = "A3V";
    if(first.equals("5V")) first = "A5V";
    
    XML contactrefFirst = signal.addChild("contactref");
    contactrefFirst.setString("element", "E$1");
    contactrefFirst.setString("pad", first);
    
    from = contacts[0];
    //if(from.equals("GND")) from = "GND1";
    if(from.equals("3V3")) from = "A3V";
    if(from.equals("5V")) from = "A5V";
    
    for(int j = 1; j < contacts.length; j++){
      
      to = contacts[j];
      //if(to.equals("GND")) to = "GND1";
      if(to.equals("3V3")) to = "A3V";
      if(to.equals("5V")) to = "A5V";
    
      XML contactrefTo = signal.addChild("contactref");
      contactrefTo.setString("element", "E$1");
      contactrefTo.setString("pad", to);
      XML wire = signal.addChild("wire");
      wire.setString("width", "0");
      wire.setString("layer", "19");
      wire.setString("extent", "1-16");
      
      wire.setString("x1", ""+getBoardCoordinate_voltera(from).x);
      wire.setString("y1", ""+getBoardCoordinate_voltera(from).y);
      wire.setString("x2", ""+getBoardCoordinate_voltera(to).x);
      wire.setString("y2", ""+getBoardCoordinate_voltera(to).y);
      
      from = to;
    }
  }
  
  saveXML(brd_xml, "data/PCB/VW_PCB_Voltera.brd");
  console.println("VW_PCB_Voltera.brd Signals Injected");
}



public void clearBrdSignals_regular(){
  XML brd_xml = loadXML("data/PCB/VW_PCB.brd");
  XML[] drawing = brd_xml.getChildren("drawing");
  XML[] board = drawing[0].getChildren("board");
  XML[] signals = board[0].getChildren("signals");
  XML[] allSignals = signals[0].getChildren("signal");
  
  for (int i = 0; i < allSignals.length; i++) {
    XML temp = signals[0].getChild("signal");
    signals[0].removeChild(temp);
  }
  
  saveXML(brd_xml, "data/PCB/VW_PCB.brd");
  console.println("VW_PCB.brd Signals Cleared");
}

public void clearBrdSignals_voltera(){
  XML brd_xml = loadXML("data/PCB/VW_PCB_Voltera.brd");
  XML[] drawing = brd_xml.getChildren("drawing");
  XML[] board = drawing[0].getChildren("board");
  XML[] signals = board[0].getChildren("signals");
  XML[] allSignals = signals[0].getChildren("signal");
  
  for (int i = 0; i < allSignals.length; i++) {
    XML temp = signals[0].getChild("signal");
    signals[0].removeChild(temp);
  }
  
  saveXML(brd_xml, "data/PCB/VW_PCB_Voltera.brd");
  console.println("VW_PCB_Voltera.brd Signals Cleared");
}

public PVector getBoardCoordinate_regular(String pad){
  float x;
  float y;
  
  switch (pad) { 
    case "SCL":
      x = 18.796f; y = 50.8f; break;
    case "SDA":
      x = 21.336f; y = 50.8f; break;
    case "AREF":
      x = 23.876f; y = 50.8f; break;
    case "GND3":
      x = 26.416f; y = 50.8f; break;
    case "D13":
      x = 28.956f; y = 50.8f; break;
    case "D12":
      x = 31.496f; y = 50.8f; break;
    case "D11":
      x = 34.036f; y = 50.8f; break;
    case "D10":
      x = 36.576f; y = 50.8f; break;
    case "D9":
      x = 39.116f; y = 50.8f; break;
    case "D8":
      x = 41.656f; y = 50.8f; break;
    case "D7":
      x = 45.72f; y = 50.8f; break;
    case "D6":
      x = 48.26f; y = 50.8f; break;
    case "D5":
      x = 50.8f; y = 50.8f; break;
    case "D4":
      x = 53.34f; y = 50.8f; break;
    case "D3":
      x = 55.88f; y = 50.8f; break;
    case "D2":
      x = 58.42f; y = 50.8f; break;
    case "D1":
      x = 60.96f; y = 50.8f; break;
    case "D0":
      x = 63.5f; y = 50.8f; break;
    case "ROW1":
      x = 17.78f; y = 35.306f; break;
    case "ROW2":
      x = 17.78f; y = 32.766f; break;
    case "ROW3":
      x = 17.78f; y = 30.226f; break;
    case "ROW4":
      x = 17.78f; y = 27.686f; break;
    case "ROW5":
      x = 17.78f; y = 25.146f; break;
    case "ROW6":
      x = 17.78f; y = 22.606f; break;
    case "ROW7":
      x = 17.78f; y = 20.066f; break;
    case "ROW8":
      x = 17.78f; y = 17.526f; break;
    case "ROW9":
      x = 54.61f; y = 35.306f; break;
    case "ROW10":
      x = 54.61f; y = 32.766f; break;
    case "ROW11":
      x = 54.61f; y = 30.226f; break;
    case "ROW12":
      x = 54.61f; y = 27.686f; break;
    case "ROW13":
      x = 54.61f; y = 25.146f; break;
    case "ROW14":
      x = 54.61f; y = 22.606f; break;
    case "ROW15":
      x = 54.61f; y = 20.066f; break;
    case "ROW16":
      x = 54.61f; y = 17.526f; break;
    case "NC":
      x = 27.94f; y = 2.54f; break;
    case "IOREF":
      x = 30.48f; y = 2.54f; break;
    case "RESET":
      x = 33.02f; y = 2.54f; break;
    case "3V3":
      x = 35.56f; y = 2.54f; break;
    case "5V":
      x = 38.1f; y = 2.54f; break;
    case "A3V":
      x = 35.56f; y = 2.54f; break;
    case "A5V":
      x = 38.1f; y = 2.54f; break;
    case "GND1":
      x = 40.64f; y = 2.54f; break;
    case "GND2":
      x = 43.18f; y = 2.54f; break;
    case "VIN":
      x = 45.72f; y = 2.54f; break;
    case "A0":
      x = 50.8f; y = 2.54f; break;
    case "A1":
      x = 53.34f; y = 2.54f; break;
    case "A2":
      x = 55.88f; y = 2.54f; break;
    case "A3":
      x = 58.42f; y = 2.54f; break;
    case "A4":
      x = 60.96f; y = 2.54f; break;
    case "A5":
      x = 63.5f; y = 2.54f; break;
    default: 
      x = 0.0f; y = 0.0f;
      break; 
  }
  
  return new PVector(x, y);
}


public PVector getBoardCoordinate_voltera(String pad){
  float x;
  float y;
  
  switch (pad) { 
    case "SCL":
      x = 18.796f; y = 45.593f; break;
    case "SDA":
      x = 21.336f; y = 45.593f; break;
    case "AREF":
      x = 23.876f; y = 45.593f; break;
    case "GND3":
      x = 26.416f; y = 45.593f; break;
    case "D13":
      x = 28.956f; y = 45.593f; break;
    case "D12":
      x = 31.496f; y = 45.593f; break;
    case "D11":
      x = 34.036f; y = 45.593f; break;
    case "D10":
      x = 36.576f; y = 45.593f; break;
    case "D9":
      x = 39.116f; y = 45.593f; break;
    case "D8":
      x = 41.656f; y = 45.593f; break;
    case "D7":
      x = 45.72f; y = 45.593f; break;
    case "D6":
      x = 48.26f; y = 45.593f; break;
    case "D5":
      x = 50.8f; y = 45.593f; break;
    case "D4":
      x = 53.34f; y = 45.593f; break;
    case "D3":
      x = 55.88f; y = 45.593f; break;
    case "D2":
      x = 58.42f; y = 45.593f; break;
    case "D1":
      x = 60.96f; y = 45.593f; break;
    case "D0":
      x = 63.5f; y = 45.593f; break;
    case "ROW1":
      x = 17.78f; y = 32.385f; break;
    case "ROW2":
      x = 17.78f; y = 29.845f; break;
    case "ROW3":
      x = 17.78f; y = 27.305f; break;
    case "ROW4":
      x = 17.78f; y = 24.765f; break;
    case "ROW5":
      x = 17.78f; y = 22.225f; break;
    case "ROW6":
      x = 17.78f; y = 19.685f; break;
    case "ROW7":
      x = 17.78f; y = 17.145f; break;
    case "ROW8":
      x = 17.78f; y = 14.605f; break;
    case "ROW9":
      x = 54.61f; y = 32.385f; break;
    case "ROW10":
      x = 54.61f; y = 29.845f; break;
    case "ROW11":
      x = 54.61f; y = 27.305f; break;
    case "ROW12":
      x = 54.61f; y = 24.765f; break;
    case "ROW13":
      x = 54.61f; y = 22.225f; break;
    case "ROW14":
      x = 54.61f; y = 19.685f; break;
    case "ROW15":
      x = 54.61f; y = 17.145f; break;
    case "ROW16":
      x = 54.61f; y = 14.605f; break;
    case "NC":
      x = 27.94f; y = 1.905f; break;
    case "IOREF":
      x = 30.48f; y = 1.905f; break;
    case "RESET":
      x = 33.02f; y = 1.905f; break;
    case "3V3":
      x = 35.56f; y = 1.905f; break;
    case "5V":
      x = 38.1f; y = 1.905f; break;
    case "A3V":
      x = 35.56f; y = 1.905f; break;
    case "A5V":
      x = 38.1f; y = 1.905f; break;
    case "GND1":
      x = 40.64f; y = 1.905f; break;
    case "GND2":
      x = 43.18f; y = 1.905f; break;
    case "VIN":
      x = 45.72f; y = 1.905f; break;
    case "A0":
      x = 50.8f; y = 1.905f; break;
    case "A1":
      x = 53.34f; y = 1.905f; break;
    case "A2":
      x = 55.88f; y = 1.905f; break;
    case "A3":
      x = 58.42f; y = 1.905f; break;
    case "A4":
      x = 60.96f; y = 1.905f; break;
    case "A5":
      x = 63.5f; y = 1.905f; break;
    default: 
      x = 0.0f; y = 0.0f;
      break; 
  }
  
  return new PVector(x, y);
}


public ArrayList<String> pairsToNet(){
  ArrayList<String> result = new ArrayList<String>();
  ArrayList<ArrayList<String>> nets = new ArrayList<ArrayList<String>>();
  ArrayList<String> pairs = new ArrayList<String>();
  
  JSONArray ccjson = loadJSONArray("data/CurrentConnections.json");
  
  for (int i = 0; i < ccjson.size(); i++) {
    
    JSONObject connection = ccjson.getJSONObject(i); 
    
    int cnum = connection.getInt("Connection Number");
    cnum++;
    String from = connection.getString("from");
    if(from.equals("A3V")) from = "3V3";
    if(from.equals("A5V")) from = "5V";
    String to = connection.getString("to");
    if(to.equals("A3V")) to = "3V3";
    if(to.equals("A5V")) to = "5V";
    
    //println(cnum + ") from: " + from + ", to: " + to);
    
    pairs.add(from + "_" + to);
  }
  
  for(int i = 0; i < pairs.size(); i++){
    String[] pair = pairs.get(i).split("_");
    String from = pair[0];
    String to = pair[1];
    boolean newNet = true;
    
    for(int j = 0; j < nets.size(); j++){
      ArrayList<String> nodes = nets.get(j);
      
      for(int k = 0; k < nodes.size(); k++){
        if(nodes.get(k).equals(from)){
          nets.get(j).add(to);
          newNet = false;
          break;
        }else if(nodes.get(k).equals(to)){
          nets.get(j).add(from);
          newNet = false;
          break;
        }
      }
      
      if(!newNet) break;
    }
    
    if(newNet){
      nets.add(new ArrayList<String>());
      nets.get(nets.size()-1).add(from);
      nets.get(nets.size()-1).add(to);
    }
  }
  
  for(int i = 0; i < nets.size(); i++){
    String str = "";
    ArrayList<String> nodes = nets.get(i);
    
    for(int j = 0; j < nodes.size(); j++){
      str = str + nodes.get(j) + "_";
    }
    
    str = str.substring(0, str.length()-1);
    
    result.add(str);
  }
  
  //for(String str: result) println(str);
  
  return result;
}
class Console{
  ArrayList<String> log;
  int xPos, yPos;
  int boxWidth, boxHeight;
  int bottomLine;
  int maxLineNum;
  int thumbThickness;
  
  Console(int xPos, int yPos, int boxWidth, int boxHeight, int maxLineNum, int thumbThickness){
    log = new ArrayList<String>();
    for(int i = 0; i < maxLineNum; i++) log.add("");
    
    this.xPos = xPos;
    this.yPos = yPos;
    this.boxWidth = boxWidth;
    this.boxHeight = boxHeight;
    this.maxLineNum = maxLineNum;
    this.thumbThickness = thumbThickness;
    
    bottomLine = log.size() - 1;
  }
  
  public int getLogSize(){ return log.size(); }
  
  public int getBottomLine(){ return bottomLine; }
  
  public void println(String line){
    if(line.length() >= 65){
      String part1 = line.substring(0, 65);
      String part2 = line.substring(65, line.length());
      log.add(part1);
      log.add(part2);
      bottomLine = log.size() - 1;
    }else{
      log.add(line);
      bottomLine = log.size() - 1;
    }
    
  }
  
  public void scrollConsole(int change){
    bottomLine = bottomLine + change;
    if(bottomLine > log.size() - 1) bottomLine = log.size() - 1;
    if(bottomLine < maxLineNum-1) bottomLine = maxLineNum-1;
  }
  
  public void display(){
    int linePos = 0;
    int lineSpacing = boxHeight/maxLineNum;
    for(int i = bottomLine - maxLineNum+1; i <= bottomLine; i++){
      fill(255);
      textSize(18);
      text(log.get(i), xPos + boxWidth/25, yPos + (linePos + 1)*lineSpacing - lineSpacing/3.5f);
      linePos++;
    }
    
    int contentHeight = log.size()*lineSpacing;
    int bottomLineHeight = (bottomLine+1)*lineSpacing;
    int thumbHeight = (int)boxHeight*boxHeight/contentHeight;
    int thumbPos = (int)bottomLineHeight*boxHeight/contentHeight;
    
    fill(200);
    //rect(xPos + 14*boxWidth/15, yPos + (int)map(thumbPos-thumbHeight, -thumbHeight/2, boxHeight-thumbHeight, 0, boxHeight-thumbHeight), boxWidth/15, thumbHeight);
    rect(xPos + boxWidth-5*thumbThickness/4, yPos + thumbPos-thumbHeight, thumbThickness, thumbHeight, thumbThickness);
  }
  
}
abstract class FileWatcher extends TimerTask {
  private long timeStamp;
  private File file;

  public FileWatcher( File file ) {
    this.file = file;
    this.timeStamp = file.lastModified();
  }

  public final  void run() {
    long timeStamp = file.lastModified();
    
    if ( this.timeStamp != timeStamp ) {
      this.timeStamp = timeStamp;
      onChange(file);
    }
  }
  
  protected abstract void onChange( File file );
}

class Wire{
  
  int id;
  String title;
  int lConn, rConn;
  int lComp, rComp;
  
  Wire(int id, String title, int lConn, int rConn, int lComp, int rComp){
    this.id = id;
    this.title = title;
    this.lConn = lConn;
    this.rConn = rConn;
    this.lComp = lComp;
    this.rComp = rComp;
  }
  
  public String getTitle(){ return title; }
  public int getLConn(){ return lConn; }
  public int getLComp(){ return lComp; }
  public int getRConn(){ return rConn; }
  public int getRComp(){ return rComp; }
  
  public String toString(){ return "id: " + id + ", title: " + title + ", lConn: " + lConn + ", rConn: " + rConn + ", lComp: " + lComp + ", rComp: " + rComp; }
}

class Map{
  int id;
  String title;
  
  Map(int id, String title){
    this.id = id;
    this.title = title;
  }
  
  public int getId(){ return id; }
  public String getTitle(){ return title; }
  
  public String toString(){ return "id: " + id + ", title: " + title; }
}

class Connection{
  
  String wireNum;
  String from, to;
  
  Connection(String wireNum, String from, String to){
    this.wireNum = wireNum;
    this.from = from;
    this.to = to;
  }
  
  public String getWireNum(){ return wireNum; }
  public String getFrom(){ return from; }
  public String getTo(){ return to; }
  
  public void changeWireNum(String wireNum){ this.wireNum = wireNum; }
  public void changeFrom(String from){ this.from = from; }
  public void changeTo(String to){ this.to = to; }
  
  public String toString(){ return wireNum + ", from: " + from + ", to: " + to; }
}

class Command{
  
  String type;
  int numberData;
  String[] data = new String[2];
  
  Command(String type, String from, String to){
    this.type = type;
    this.numberData = -1;
    this.data[0] = from;
    this.data[1] = to;
  }
  
  Command(String type, int data){
    this.type = type;
    this.numberData = data;
    this.data[0] = "";
    this.data[1] = "";
  }
  
  Command(String type){
    this.type = type;
    this.numberData = -1;
    this.data[0] = "";
    this.data[1] = "";
  }
  
  public String toString(){
    if(type.equals("reset")){ return "{\"cmd\":\"reset\"}"; }
    if(type.equals("adc")){ return "{\"cmd\":\"adc\"}" ; }
    if(type.equals("dac")){ return "{\"cmd\":\"dac\", \"data\":" + numberData + "}"; }
    if(type.equals("connect")){ return "{\"cmd\":\"connect\", \"data\": [\"" + data[0] + "\", \"" + data[1] + "\"]}"; }
    if(type.equals("disconnect")){ return "{\"cmd\":\"disconnect\", \"data\": [\"" + data[0] + "\", \"" + data[1] + "\"]}"; }
    if(type.equals("status")){ return "{\"cmd\":\"status\", \"data\": [\"" + data[0] + "\", \"" + data[1] + "\"]}"; }
    return "invalid command";
  }
}
public void serialEvent(Serial p) {
  inString = p.readStringUntil(10);
  if(inString != null){
    console.println(inString);
    serialCmdIndex++;
    
    if(serialCmdIndex < allCommands.size()){
      JSONObject command = allCommands.getJSONObject(serialCmdIndex);
      
      String runThis = command.getString("Command") + "\n";
      console.println(command.getString("Command"));
      myPort.write(runThis);
    }else{
      serialCmdIndex = 0;
      console.println("VW CONNECTIONS UPDATED!!!");
    }
  }
  
}

public void runScript(String input, String output){
  try{
    Runtime.getRuntime().exec("C:\\Users\\aerol\\AppData\\Local\\Programs\\Python\\Python37\\python.exe "+dataPath("Eagle\\eagle.py")+" "+dataPath("Eagle\\"+input)+" "+dataPath("Eagle\\"+output));
    console.println("Solver Executed");
  }catch(Exception e){
    console.println("Couldn't run the script: "+e.getMessage());
  }
}

public void newSerial(){
  myPort = new Serial(this, Serial.list()[SERIAL_PORT_INDEX], 115200);
}

private void prepareExitHandler() {
  Runtime.getRuntime().addShutdownHook(new Thread(new Runnable() {
    public void run(){
      System.out.println("EXIT: NO LONGER WATCHING FILE");
      myPort.stop();
    }
  }));
}
ArrayList<Map> mapping = new ArrayList<Map>();

public void updateConnections_FZ(String filePath){
  mapping = new ArrayList<Map>();
  ArrayList<Wire> wires = new ArrayList<Wire>();
  //netParts = new ArrayList<String>();
  ArrayList<Connection> connectionList = new ArrayList<Connection>();
  ArrayList<Connection> formattedConnectionList = new ArrayList<Connection>();
  ArrayList<Connection> formattedConnectionListNoDup = new ArrayList<Connection>();
  ArrayList<Connection> formattedConnectionListNoDupNoInvalid  = new ArrayList<Connection>();
  
  int id;
  String title;
  int lConn, rConn;
  int lComp, rComp;
  
  XML fz_xml = loadXML(filePath);
  
  XML instances = fz_xml.getChild("instances");
  XML[] instList = instances.getChildren("instance");
  
  for (int i = 0; i < instList.length; i++) {
    id = instList[i].getInt("modelIndex");
    
    XML titleTag = instList[i].getChild("title");
    
    if(titleTag != null){
      title = titleTag.getContent();
      String[] m = match(title, "Wire");
      
      mapping.add(new Map(id, title));
      
      if(m != null){
        XML connectors = instList[i].getChild("views").getChild("breadboardView").getChild("connectors");
        if(connectors == null) continue;
        
        XML[] connectorList = connectors.getChildren("connector");
        
        if(connectorList.length < 2) continue;
        
        XML leftEnd = connectorList[0].getChild("connects").getChild("connect");
        XML rightEnd = connectorList[1].getChild("connects").getChild("connect");
        
        lConn = Integer.parseInt(leftEnd.getString("connectorId").substring(9));
        rConn = Integer.parseInt(rightEnd.getString("connectorId").substring(9));
        lComp = Integer.parseInt(leftEnd.getString("modelIndex"));
        rComp = Integer.parseInt(rightEnd.getString("modelIndex"));
        
        wires.add(new Wire(id, title, lConn, rConn, lComp, rComp));
      }
    }
  }
  
  for(Wire w: wires){ connectionList.add(new Connection(w.getTitle(), node(w.getLConn(), w.getLComp()), node(w.getRConn(), w.getRComp()))); }
  
  
  formattedConnectionList = formatConnections2(connectionList);
  while(!formattDone(formattedConnectionList)){
    formattedConnectionList = formatConnections2(formattedConnectionList);
  }
  //formattedConnectionList = formatConnections(connectionList);
  formattedConnectionListNoDup = removeDuplicateConnections(formattedConnectionList);
  formattedConnectionListNoDupNoInvalid = removeInvalidConnections(formattedConnectionListNoDup);
  
  for(Connection c: connectionList) console.println(c.toString());
  console.println(" ");
  
  int ctnNum = 0;
  JSONArray connections = new JSONArray();
  for(Connection c: formattedConnectionListNoDupNoInvalid){
    if(c.getFrom().equals(c.getTo())) continue;
    if(c.getFrom().substring(0, 2).equals("Wi")) continue;
    if(c.getTo().substring(0, 2).equals("Wi")) continue;
    
    JSONObject cmdJSONObj = new JSONObject();
    
    cmdJSONObj.setInt("Connection Number", ctnNum);
    cmdJSONObj.setString("from", c.getFrom());
    cmdJSONObj.setString("to", c.getTo());
    
    connections.setJSONObject(ctnNum, cmdJSONObj);
    ctnNum++;
  }
  
  saveJSONArray(connections, "data/CurrentConnections.json");
  console.println("<CurrentConnections.json> Updated From Fritzing");
  console.println("");
}

public ArrayList<Connection> removeDuplicateConnections(ArrayList<Connection> connectionList){
  ArrayList<Connection> result = new ArrayList<Connection>();
  
  boolean add = true;
  for(Connection c: connectionList){
    
    add = true;
    for(Connection res: result){
      /*
      if(c.getWireNum().equals(res.getWireNum()) && 
         c.getFrom().equals(res.getFrom()) && 
         c.getTo().equals(res.getTo())){
        add = false;
      }
      */
      if(c.getFrom().equals(res.getFrom()) && c.getTo().equals(res.getTo()) ||
         c.getFrom().equals(res.getTo()) && c.getTo().equals(res.getFrom())){
        add = false;
      }
    }
    
    if(add) result.add(c);
  }
  
  return result;
}

public ArrayList<Connection> formatConnections(ArrayList<Connection> connectionList){
  for(int i = 0; i < connectionList.size(); i++){
    if(connectionList.get(i).getFrom().substring(0, 2).equals("Wi")){
      String find = connectionList.get(i).getFrom();
      
      for(int j = 0; j < connectionList.size(); j++)
        if(connectionList.get(j).getWireNum().equals(find))
          if(connectionList.get(j).getFrom().substring(0, 2).equals("RO"))
            connectionList.get(i).changeFrom(connectionList.get(j).getFrom());
          else if(connectionList.get(j).getTo().substring(0, 2).equals("RO"))
            connectionList.get(i).changeFrom(connectionList.get(j).getTo());
    }
  }
  
  for(int i = 0; i < connectionList.size(); i++){
    if(connectionList.get(i).getTo().substring(0, 2).equals("Wi")){
      String find = connectionList.get(i).getTo();
      
      for(int j = 0; j < connectionList.size(); j++)
        if(connectionList.get(j).getWireNum().equals(find))
          if(connectionList.get(j).getFrom().substring(0, 2).equals("RO"))
            connectionList.get(i).changeTo(connectionList.get(j).getFrom());
          else if(connectionList.get(j).getTo().substring(0, 2).equals("RO"))
            connectionList.get(i).changeTo(connectionList.get(j).getTo());
    }
  }
  
  return connectionList;
}

public ArrayList<Connection> formatConnections2(ArrayList<Connection> connectionList){
  boolean flag = false;
  
  for(int i = 0; i < connectionList.size(); i++){
    if(connectionList.get(i).getTo().substring(0, 2).equals("Wi")){
      for(int j = 0; j < connectionList.size(); j++){
        if(connectionList.get(j).getWireNum().equals(connectionList.get(i).getTo())){
          connectionList.get(i).changeWireNum(connectionList.get(j).getWireNum());
          connectionList.get(i).changeTo(connectionList.get(j).getTo());
          connectionList.remove(j);
          
          flag = true;
          break;
        }
      }
    }
    
    if(flag) break;
  }
  
  return connectionList;
}

public boolean formattDone(ArrayList<Connection> connectionList){
  
  for(int i = 0; i < connectionList.size(); i++){
    if(connectionList.get(i).getTo().substring(0, 2).equals("Wi")) return false;
  }
  
  return true;
}

public ArrayList<Connection> removeInvalidConnections(ArrayList<Connection> connectionList){
  ArrayList<Connection> result = new ArrayList<Connection>();
  
  for(int i = 0; i < connectionList.size(); i++){
    if(!connectionList.get(i).getFrom().substring(0, 2).equals("Er") &&
      !connectionList.get(i).getTo().substring(0, 2).equals("Er")){
      
      result.add(connectionList.get(i));
      
    }
  }
  
  return result;
}


// id: 5766, title: PCB1
// id: 49080, title: MicroBreadboard_left1
// id: 49423, title: ArduinoUno1
// id: 49420, title: MicroBreadboard_right1
public String node(int conn, int comp){
  String t = idToTitle(comp);
  String[] m = match(t, "Wire");
  
  if(m != null){ return t; }//its a wire
  
  if(t.equals("ArduinoUno1")){
    if(conn == 60) return "SCL";
    if(conn == 59) return "SDA";
    if(conn == 58) return "AREF";
    if(conn == 57) return "GND1";
    if(conn == 56) return "D13";
    if(conn == 55) return "D12";
    if(conn == 54) return "D11";
    if(conn == 53) return "D10";
    if(conn == 52) return "D9";
    if(conn == 51) return "D8";
    if(conn == 68) return "D7";
    if(conn == 67) return "D6";
    if(conn == 66) return "D5";
    if(conn == 65) return "D4";
    if(conn == 64) return "D3";
    if(conn == 63) return "D2"; 
    if(conn == 62) return "D1";
    if(conn == 61) return "D0";
    if(conn == 91) return "N/C";
    if(conn == 84) return "IOREF";
    if(conn == 85) return "RESET";
    if(conn == 86) return "A3V";
    if(conn == 87) return "A5V";
    if(conn == 88) return "GND2";
    if(conn == 89) return "GND3";
    if(conn == 90) return "VIN";
    if(conn == 0) return "A0";
    if(conn == 1) return "A1";
    if(conn == 2) return "A2";
    if(conn == 3) return "A3";
    if(conn == 4) return "A4";
    if(conn == 5) return "A5";
    return "Error: Nonexistent Connector and Component Pair";
  }
  
  if(t.equals("MicroBreadboard_left1")){ return "ROW" + ((conn/5)+1); }
  if(t.equals("MicroBreadboard_right1")){ return "ROW" + ((conn/5)+9); }
  
  return "Error: Nonexistent Connector and Component Pair";
}

public String idToTitle(int id){
  for(Map m: mapping)
    if (id == m.getId())
      return m.getTitle();
  
  return "Id Not Found";
}
public void updateCommands_Multi(){
  JSONArray CurrentConnections = loadJSONArray("data/CurrentConnections.json");
  ArrayList<String> pairs = new ArrayList<String>();
  JSONArray Commands = new JSONArray();
  
  JSONObject initialReset = new JSONObject();
  initialReset.setInt("a_Command Number", 0);
  initialReset.setString("Command", new Command("reset").toString());
  Commands.setJSONObject(0, initialReset);
  
  for(int i = 0; i < CurrentConnections.size(); i++){
    JSONObject wireConnection = CurrentConnections.getJSONObject(i);
    
    String from = wireConnection.getString("from");
    String to = wireConnection.getString("to");
    
    if(!from.substring(0, 2).equals("Er") && !to.substring(0, 2).equals("Er")){
      pairs.add(from);
      pairs.add(to);
    }
  }
  
  String cmd1 = "{\"cmd\":\"connect\", \"data\": [\"";
  
  if(pairs.size() == 0){
    console.println("No Connections in CurrentConnections.JSON");
    saveJSONArray(Commands, "data/Commands.json");
    console.println("<Commands.json> Updated");
    return ;
  }
  
  for(int i = 0; i < pairs.size()-1; i++){
    cmd1 = cmd1 + pairs.get(i) + "\", \"";
  }
  cmd1 = cmd1 + pairs.get(pairs.size()-1) + "\"]}";
  
  JSONObject connectionCommand = new JSONObject();
  connectionCommand.setInt("a_Command Number", 1);
  connectionCommand.setString("Command", cmd1);
  Commands.setJSONObject(1, connectionCommand);
  // "{\"cmd\":\"connect\", \"data\": [\"" + data[0] + "\", \"" + data[1] + "\"]}"
  
  saveJSONArray(Commands, "data/Commands.json");
  console.println("<Commands.json> Updated");
  console.println(" ");
}

public void printAllCommands(){
  allCommands = loadJSONArray("data/Commands.json");
  
  for(int i = 0; i < allCommands.size(); i++){
    JSONObject command = allCommands.getJSONObject(i);
    console.println(command.getString("Command"));
  }
}

public void runAllCommands(){
  allCommands = loadJSONArray("data/Commands.json");
  
  //myPort = new Serial(this, Serial.list()[2], 115200);
  
  JSONObject command = allCommands.getJSONObject(serialCmdIndex);
  
  String runThis = command.getString("Command") + "\n";
  console.println(command.getString("Command"));
  myPort.write(runThis);
  
}
  public void settings() {  size(640, 720); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "VW_Fritzing" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
