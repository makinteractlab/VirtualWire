import java.util.*;
import java.io.*;
import processing.serial.*;

int lastChangeTime;
int thisChangeTime;
boolean firstSave = true;

Serial myPort;                // The serial port
String inString;              // Input string from serial port
String receivedMessage = "";  // message from hardware

int serialCmdIndex = 0;

XML xml;
JSONArray connections;
JSONArray CurrentConnections;
JSONArray Commands;
JSONArray allCommands;

int ctnNum;
String id, part, name, label;

ArrayList<Map> mapping = new ArrayList<Map>();
ArrayList<Wire> wires = new ArrayList<Wire>();
ArrayList<Connection> connectionList = new ArrayList<Connection>();
ArrayList<Connection> formattedConnectionList = new ArrayList<Connection>();
ArrayList<Connection> formattedConnectionListNoDup = new ArrayList<Connection>();
ArrayList<String> netParts = new ArrayList<String>();

Timer timer;
TimerTask task;

void setup(){
  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[2], 115200); 
  
  lastChangeTime = millis();
  
  //surface.setVisible(false);
  prepareExitHandler();
  selectInput("Select a file to process:", "fileSelected");
}

void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
    return;
  }
  
  task = new FileWatcher( selection ) {
    protected void onChange( File file ) {
      
      thisChangeTime = millis();
      println("LAST CHANGE: " + lastChangeTime);
      println("THIS CHANGE: " + thisChangeTime); 
      if(thisChangeTime - lastChangeTime > 5000){
        lastChangeTime = thisChangeTime;
        
        
        
        // here we code the action on a change
        println( "File "+ file.getName() +" has changed!!!" );
        
        //File f = new File(dataPath("connections.json"));
        //if (f.exists()) f.delete();
        
        delay(2000);
        updateConnections(file);
        
        delay(2000);
        updateCommands();
        
        if(firstSave){
          firstSave = false;
          newSerial();
        }
        
        runAllCommands();
        
        
      }
      
    }
  };

  timer = new Timer();
  // repeat the check every second
  timer.schedule( task, new Date(), 1000 );
}

//
//
//  HELPER FUNCTIONS
//
//

void newSerial(){
  myPort = new Serial(this, Serial.list()[2], 115200);
}

void runAllCommands(){
  allCommands = loadJSONArray("Commands.json");
  
  //myPort = new Serial(this, Serial.list()[2], 115200);
  
  JSONObject command = allCommands.getJSONObject(serialCmdIndex);
  
  
  String runThis = command.getString("Command") + "\n";
  println(command.getString("Command"));
  myPort.write(runThis);
  
}

void printAllCommands(){
  allCommands = loadJSONArray("Commands.json");
  
  for(int i = 0; i < allCommands.size(); i++){
    JSONObject command = allCommands.getJSONObject(i);
    println(command.getString("Command"));
  }
}

void updateCommands(){
  CurrentConnections = loadJSONArray("CurrentConnections.json");
  Commands = new JSONArray();
  
  JSONObject initialReset = new JSONObject();
  initialReset.setInt("a_Command Number", 0);
  initialReset.setString("Command", new Command("reset").toString());
  Commands.setJSONObject(0, initialReset);
  
  int i = 0;
  while(i < CurrentConnections.size()){
    JSONObject wireConnection = CurrentConnections.getJSONObject(i);
    
    String from = wireConnection.getString("from");
    String to = wireConnection.getString("to");
    
    JSONObject connectionCommand = new JSONObject();
    
    connectionCommand.setInt("a_Command Number", i+1);
    connectionCommand.setString("Command", new Command("connect", from, to).toString());
    Commands.setJSONObject(i+1, connectionCommand);
    
    i++;
    //println(connectionNumber + ": " + from + ", " + to);
  }
  
  int plus = i + 1;
  int j = 0;
  while(j < CurrentConnections.size()){
    JSONObject wireConnection = CurrentConnections.getJSONObject(j);
    
    String from = wireConnection.getString("from");
    String to = wireConnection.getString("to");
    
    JSONObject connectionCommand = new JSONObject();
    
    connectionCommand.setInt("a_Command Number", j+plus);
    connectionCommand.setString("Command", new Command("status", from, to).toString());
    Commands.setJSONObject(j+plus, connectionCommand);
    
    j++;
  }
  
  saveJSONArray(Commands, "data/Commands.json");
}

void updateConnections(File file){
  mapping = new ArrayList<Map>();
  wires = new ArrayList<Wire>();
  netParts = new ArrayList<String>();
  connectionList = new ArrayList<Connection>();
  formattedConnectionList = new ArrayList<Connection>();
  formattedConnectionListNoDup = new ArrayList<Connection>();
  File f = new File(dataPath("data/CurrentConnections.json"));
  if (f.exists()) f.delete();
  
  int id;
  String title;
  int lConn, rConn;
  int lComp, rComp;
  
  xml = loadXML(file.getName());
  
  XML instances = xml.getChild("instances");
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
  
  formattedConnectionList = formatConnections(connectionList);
  formattedConnectionListNoDup = removeDuplicateConnections(formattedConnectionList);
  
  for(Connection c: formattedConnectionListNoDup) println(c.toString());
  
  ctnNum = 0;
  connections = new JSONArray();
  for(Connection c: formattedConnectionListNoDup){
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
  println("CurrentConnections.json file saved");
}

int titleToId(String title){
  for(Map m: mapping)
    if (title.equals(m.getTitle()))
      return m.getId();
  
  return -1;
} 

String idToTitle(int id){
  for(Map m: mapping)
    if (id == m.getId())
      return m.getTitle();
  
  return "Id Not Found";
}

// id: 5766, title: PCB1
// id: 49080, title: MicroBreadboard_left1
// id: 49423, title: ArduinoUno1
// id: 49420, title: MicroBreadboard_right1
String node(int conn, int comp){
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
  
  if(t.equals("MicroBreadboard_left1")){ return "ROW" + conn/5; }
  if(t.equals("MicroBreadboard_right1")){ return "ROW" + ((conn/5)+8); }
  
  return "Error: Nonexistent Connector and Component Pair";
}

ArrayList<Connection> removeDuplicateConnections(ArrayList<Connection> connectionList){
  ArrayList<Connection> result = new ArrayList<Connection>();
  
  boolean add = true;
  for(Connection c: connectionList){
    
    add = true;
    for(Connection res: result){
      if(c.getWireNum().equals(res.getWireNum()) && 
         c.getFrom().equals(res.getFrom()) && 
         c.getTo().equals(res.getTo())){
        add = false;
      }
    }
    
    if(add) result.add(c);
  }
  
  return result;
}

ArrayList<Connection> formatConnections(ArrayList<Connection> connectionList){
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

String connectorToLabel(String id, String part){
  String result = "";
  int resNum;
  
  int connectorNum = Integer.parseInt(id.substring(9));
  
  if(part.equals("MicroBreadboard_left1") == true) resNum = connectorNum/5;
  else resNum = (connectorNum/5)+8;
  
  result = result + resNum;
  
  return result;
}

//
//
//  CLASSES
//
//

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
  
  String getTitle(){ return title; }
  int getLConn(){ return lConn; }
  int getLComp(){ return lComp; }
  int getRConn(){ return rConn; }
  int getRComp(){ return rComp; }
  
  public String toString(){ return "id: " + id + ", title: " + title + ", lConn: " + lConn + ", rConn: " + rConn + ", lComp: " + lComp + ", rComp: " + rComp; }
}

class Map{
  int id;
  String title;
  
  Map(int id, String title){
    this.id = id;
    this.title = title;
  }
  
  int getId(){ return id; }
  String getTitle(){ return title; }
  
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
  
  String getWireNum(){ return wireNum; }
  String getFrom(){ return from; }
  String getTo(){ return to; }
  
  void changeFrom(String from){ this.from = from; }
  void changeTo(String to){ this.to = to; }
  
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

//
//
//  EVENT HANDLERS
//
//

private void prepareExitHandler() {
  Runtime.getRuntime().addShutdownHook(new Thread(new Runnable() {
    public void run(){
      System.out.println("EXIT: NO LONGER WATCHING FILE");
      myPort.stop();
    }
  }));
}

void serialEvent(Serial p) {
  
  inString = p.readStringUntil(10);
  //myPort.clear();
  if(inString != null){
    println(inString);
    //myPort.clear();
    serialCmdIndex++;
    
    if(serialCmdIndex < allCommands.size()){
      JSONObject command = allCommands.getJSONObject(serialCmdIndex);
      
      String runThis = command.getString("Command") + "\n";
      println(command.getString("Command"));
      myPort.write(runThis);
    }else{
      serialCmdIndex = 0;
      println("CONNECTIONS UPDATED!!!");
      //myPort.stop();
    }
  }
  
}
