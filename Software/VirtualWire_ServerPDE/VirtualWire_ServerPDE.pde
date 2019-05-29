import java.util.*;
import java.io.*;

XML xml;
JSONArray commands;

int cmdNum;
String id, part, name, label;

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
      
      cmdNum = 0;
      commands = new JSONArray();
      xml = loadXML("VirtualWire_tempalte_netlist.xml");
      XML[] nets = xml.getChildren("net");
    
      for (int i = 0; i < nets.length; i++) {
        XML[] connectors = nets[i].getChildren("connector");
        netParts = new ArrayList<String>();
        
        for(int j = 0; j < connectors.length; j++){
          id = connectors[j].getString("id");
          name = connectors[j].getString("name");
          XML firstChild = connectors[j].getChild("part");
          part = firstChild.getString("label");
          
          if(part.equals("ArduinoUno1") == true) label = name;
          else label = connectorToLabel(id, part);
          
          if(!netParts.contains(label)) netParts.add(label);
        }
        
        //add to allNets
        if(netParts.size() > 1){
          for(int k = 0; k < netParts.size() - 1; k++){
            JSONObject cmd = new JSONObject();
            
            cmd.setString("cmd", "connect");
            cmd.setString("from", netParts.get(k));
            cmd.setString("to", netParts.get(k+1));
            
            commands.setJSONObject(cmdNum, cmd);
            cmdNum++;
          }
        }
      }
      
      saveJSONArray(commands, "data/CommandList.json");
    }
  };

  timer = new Timer();
  // repeat the check every second
  timer.schedule( task, new Date(), 1000 );
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

void draw(){}
