import java.util.*;
import java.io.*;
import interfascia.*;
import processing.serial.*;
final int SERIAL_PORT_INDEX = 4;

Serial myPort;                // The serial port
String inString;              // Input string from serial port
String receivedMessage = "";  // message from hardware
String fileName;
String filePath;
String folderPath;

String pinlistOutputfileName = "data/Eagle/pinlist_output.json";

int serialCmdIndex = 0;

JSONArray allCommands;

Console console;

GUIController c;
IFButton visualizer;
IFButton visualizer_wire;
IFButton brdSignalInject_regular;
IFButton brdSignalInject_voltera;

Timer timer;
TimerTask task;

int lastChangeTime;
int thisChangeTime;
boolean firstSave = true;

boolean schVis = false;
boolean schVis_wire = false;

void setup(){
  size(640, 720);
  
  console = new Console(0, 450, width, height-450, 9, width/50);
  
  printArray(Serial.list());
  ////////////////////////////////////////////myPort = new Serial(this, Serial.list()[SERIAL_PORT_INDEX], 115200); 
  
  c = new GUIController(this);
  
  visualizer = new IFButton ("visualizer_component", 30, 110, 150, 30);
  visualizer_wire = new IFButton ("visualizer_wire", 30, 70, 150, 30);
  brdSignalInject_regular = new IFButton ("brdSignalInject_regular", 30, 150, 150, 30);
  brdSignalInject_voltera = new IFButton ("brdSignalInject_voltera", 30, 190, 150, 30);
  
  visualizer.addActionListener(this);
  visualizer_wire.addActionListener(this);
  brdSignalInject_regular.addActionListener(this);
  brdSignalInject_voltera.addActionListener(this);
  
  c.add(visualizer);
  c.add(visualizer_wire);
  c.add(brdSignalInject_regular);
  c.add(brdSignalInject_voltera);
  
  lastChangeTime = millis();
  
  //surface.setVisible(false);
  prepareExitHandler();
  selectInput("Select a file to process:", "fileSelected");
}

void mouseWheel(MouseEvent event) {
  int e = (int)event.getCount();
  console.scrollConsole(e);
}

void mousePressed(){
  compCount++;
}

void draw(){
  background(200);
  
  if(schVis){
    sch_vis_draw();
  }
  
  if(schVis_wire){
    sch_vis_wire();
  }
  
  fill(43, 48, 69);
  rect(0, 450, width, height-450);
  
  console.display();
  
}

void actionPerformed (GUIEvent e){
  if(e.getSource() == brdSignalInject_regular){
    schVis = false;
    schVis_wire = false;
    clearBrdSignals_regular();
    injectSignals_regular();
  }else if(e.getSource() == brdSignalInject_voltera){
    schVis = false;
    schVis_wire = false;
    clearBrdSignals_voltera();
    injectSignals_voltera();
  }else if(e.getSource() == visualizer){
    sch_vis_setup();
    schVis = true;
    schVis_wire = false;
  }else if(e.getSource() == visualizer_wire){
    sch_vis_setup();
    schVis = false;
    schVis_wire = true;
  }
}


void fileSelected(File selection) {
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
  }
  
  task = new FileWatcher( selection ) {
    protected void onChange( File file ) {
      
      thisChangeTime = millis();
      
      if(thisChangeTime - lastChangeTime > 5000){
        console.println("LAST CHANGE: " + lastChangeTime);
        console.println("THIS CHANGE: " + thisChangeTime);
        lastChangeTime = thisChangeTime;
        
        console.println("File "+ file.getName() +" has changed!!!");
        
        delay(2000);
        runScript(filePath, "pinlist_output");
        delay(1000);
        updateConnections_Eagle();
        
        delay(2000);
        updateCommands_Multi();
        
        ////////////////////////////////////////////////runAllCommands();
      }
    }
  };

  timer = new Timer();
  // repeat the check every second
  timer.schedule( task, new Date(), 1000 );
}
