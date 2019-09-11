import interfascia.*;
import processing.serial.*;
final int SERIAL_PORT_INDEX = 2;

Serial myPort;                // The serial port
String inString;              // Input string from serial port
String receivedMessage = "";  // message from hardware

int serialCmdIndex = 0;

JSONArray allCommands;

Console console;

GUIController c;
IFButton updateConnectionsFile_fritzing;
IFButton updateConnectionsFile_eagle;

IFButton updateVWBoard;
IFButton brdSignalInject_regular;
IFButton brdSignalInject_voltera;

boolean schVis = false;

void setup(){
  size(640, 720);
  background(200);
  
  console = new Console(0, 450, width, height-450, 9, width/50);
  sch_vis_setup();
  
  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[SERIAL_PORT_INDEX], 115200); 
  
  c = new GUIController(this);
  
  updateConnectionsFile_fritzing  = new IFButton ("updateConnections_fritzing", 30, 30, 150, 30);
  updateConnectionsFile_eagle = new IFButton ("updateConnections_eagle", 30, 70, 150, 30);
  updateVWBoard = new IFButton ("updateVWBoard", 30, 110, 150, 30);
  brdSignalInject_regular = new IFButton ("brdSignalInject_regular", 30, 150, 150, 30);
  brdSignalInject_voltera = new IFButton ("brdSignalInject_voltera", 30, 190, 150, 30);
  
  updateConnectionsFile_fritzing.addActionListener(this);
  updateConnectionsFile_eagle.addActionListener(this);
  updateVWBoard.addActionListener(this);
  brdSignalInject_regular.addActionListener(this);
  brdSignalInject_voltera.addActionListener(this);
  
  c.add(updateConnectionsFile_fritzing);
  c.add(updateConnectionsFile_eagle);
  c.add(updateVWBoard);
  c.add(brdSignalInject_regular);
  c.add(brdSignalInject_voltera);
}

void mouseWheel(MouseEvent event) {
  int e = (int)event.getCount();
  console.scrollConsole(e);
}

void mousePressed(){
  compCount++;
}

void draw(){
  if(schVis){
    sch_vis_draw();
  }
  
  fill(43, 48, 69);
  rect(0, 450, width, height-450);
  console.display();
  
}

void actionPerformed (GUIEvent e){
  if(e.getSource() == updateConnectionsFile_fritzing){
    schVis = false;
    console.println("Updating <CurrentConnections.json> from Fritzing ...");
    updateConnections_FZ();
  }else if(e.getSource() == updateConnectionsFile_eagle){
    console.println("Updating <CurrentConnections.json> from Eagle ...");
    runScript("pinlist", "pinlist_output");
    updateConnections_Eagle();
    schVis = true;
  }else if(e.getSource() == updateVWBoard){
    schVis = false;
    console.println("Updating Virtual Wire Board ...");
    updateCommands_Multi();
    runAllCommands();
  }else if(e.getSource() == brdSignalInject_regular){
    schVis = false;
    clearBrdSignals_regular();
    injectSignals_regular();
  }else if(e.getSource() == brdSignalInject_voltera){
    schVis = false;
    clearBrdSignals_voltera();
    injectSignals_voltera();
  }
}
