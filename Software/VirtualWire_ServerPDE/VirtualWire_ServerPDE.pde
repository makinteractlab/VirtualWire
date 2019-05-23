import java.util.*;
import java.io.*;

XML xml;
JSONArray commands;

String id, part, name, label;

ArrayList<Map> mapping = new ArrayList<Map>();
ArrayList<Wire> wires = new ArrayList<Wire>();
ArrayList<Command> commandList = new ArrayList<Command>();
ArrayList<String> netParts = new ArrayList<String>();

Timer timer;
TimerTask task;

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


void setup()
{
    selectInput("Select a file to process:", "fileSelected");
}



void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
    return;
  }
  
  task = new FileWatcher( selection ) {
    protected void onChange( File file ) {
      // here we code the action on a change
      println( "File "+ file.getName() +" have change !" );
      
      delay(1000);
      
      String fileName = dataPath("commands.json");
      File f = new File(fileName);
      if (f.exists()) {
        f.delete();
      }
      
      int id;
      String title;
      int lConn, rConn;
      int lComp, rComp;
      JSONObject cmdJSONObj;
      int cmdNum = 0;
      
      commands = new JSONArray();
      mapping = new ArrayList<Map>();
      wires = new ArrayList<Wire>();
      commandList = new ArrayList<Command>();
      netParts = new ArrayList<String>();
      
      xml = loadXML(file.getName());//try catch, diff event w/flag, delay save 1 sec, manual save load
      
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
      
      for(Wire w: wires){ commandList.add(new Command(w.getTitle(), node(w.getLConn(), w.getLComp()), node(w.getRConn(), w.getRComp()))); }
      
      commandList = formatCommands(commandList);
      
      for(Command c: commandList){
        if(c.getFrom().equals(c.getTo())) continue;
        if(c.getFrom().substring(0, 4).equals("Wire")) continue;
        if(c.getTo().substring(0, 4).equals("Wire")) continue;
        
        cmdJSONObj = new JSONObject();
        
        cmdJSONObj.setInt("Command Number", cmdNum);
        cmdJSONObj.setString("from", c.getFrom());
        cmdJSONObj.setString("to", c.getTo());
        
        commands.setJSONObject(cmdNum, cmdJSONObj);
        cmdNum++;
      }
      
      //println(commands);
      saveJSONArray(commands, "data/commands.json");
      println("commands.json file saved");
    }
  };

  timer = new Timer();
  // repeat the check every second
  timer.schedule( task, new Date(), 1000 );
}

void draw(){}

//CLASSES AND METHODS
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

class Command{
  
  String wireNum;
  String from, to;
  
  Command(String wireNum, String from, String to){
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
    if(conn == 60) return "SCL  ";
    if(conn == 59) return "SDA  ";
    if(conn == 58) return "AREF ";
    if(conn == 57) return "GND  ";
    if(conn == 56) return "P13  ";
    if(conn == 55) return "P12  ";
    if(conn == 54) return "P11  ";
    if(conn == 53) return "P10  ";
    if(conn == 52) return "P9   ";
    if(conn == 51) return "P8   ";
    if(conn == 68) return "P7   ";
    if(conn == 67) return "P6   ";
    if(conn == 66) return "P5   ";
    if(conn == 65) return "P4   ";
    if(conn == 64) return "P3   ";
    if(conn == 63) return "P2   ";
    if(conn == 62) return "P1/TX";
    if(conn == 61) return "P0/RX";
    if(conn == 91) return "N/C  ";
    if(conn == 84) return "IOREF";
    if(conn == 85) return "RESET";
    if(conn == 86) return "3V3  ";
    if(conn == 87) return "5V   ";
    if(conn == 88) return "GND  ";
    if(conn == 89) return "GND  ";
    if(conn == 90) return "VIN  ";
    if(conn == 0) return "A0   ";
    if(conn == 1) return "A1   ";
    if(conn == 2) return "A2   ";
    if(conn == 3) return "A3   ";
    if(conn == 4) return "A4   ";
    if(conn == 5) return "A5   ";
    return "Error: Nonexistent Connector and Component Pair";
  }
  
  if(t.equals("MicroBreadboard_left1")){ return "line" + conn/5; }
  if(t.equals("MicroBreadboard_right1")){ return "line" + ((conn/5)+8); }
  
  return "Error: Nonexistent Connector and Component Pair";
}

void removeJSONDuplicates(String filename){
  
}

ArrayList<Command> formatCommands(ArrayList<Command> commandList){
  for(int i = 0; i < commandList.size(); i++){
    if(commandList.get(i).getFrom().substring(0, 4).equals("Wire")){
      String find = commandList.get(i).getFrom();
      
      for(int j = 0; j < commandList.size(); j++)
        if(commandList.get(j).getWireNum().equals(find))
          if(commandList.get(j).getFrom().substring(0, 4).equals("line"))
            commandList.get(i).changeFrom(commandList.get(j).getFrom());
          else if(commandList.get(j).getTo().substring(0, 4).equals("line"))
            commandList.get(i).changeFrom(commandList.get(j).getTo());
    }
  }
  
  for(int i = 0; i < commandList.size(); i++){
    if(commandList.get(i).getTo().substring(0, 4).equals("Wire")){
      String find = commandList.get(i).getTo();
      
      for(int j = 0; j < commandList.size(); j++)
        if(commandList.get(j).getWireNum().equals(find))
          if(commandList.get(j).getFrom().substring(0, 4).equals("line"))
            commandList.get(i).changeTo(commandList.get(j).getFrom());
          else if(commandList.get(j).getTo().substring(0, 4).equals("line"))
            commandList.get(i).changeTo(commandList.get(j).getTo());
    }
  }
  
  return commandList;
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
