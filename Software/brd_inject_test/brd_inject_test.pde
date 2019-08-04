XML brdxml;
JSONArray ccjson;

XML netlistxml;
String id;
String part;
String name;
String label;
String net = "";

ArrayList<String> netParts = new ArrayList<String>();
ArrayList<String> allNets = new ArrayList<String>();

void setup() {
  clearBrdSignals();
  injectSignals();
}


// inject signals via VirtualWire_tempalte_netlist.xml
void injectSignals(){
  getAllNets();
  
  String[] contacts;
  String from;
  String to;
  int cnum = 1;
  
  brdxml = loadXML("data/VW_PCB.brd");
  XML[] drawing = brdxml.getChildren("drawing");
  XML[] board = drawing[0].getChildren("board");
  XML[] signals = board[0].getChildren("signals");
  
  for(int i = 0; i < allNets.size(); i++){
    contacts = split(allNets.get(i), "_");
    
    XML signal = signals[0].addChild("signal");
    signal.setString("name", "S$"+cnum);
    cnum++;
    
    XML contactrefFirst = signal.addChild("contactref");
    contactrefFirst.setString("element", "E$1");
    contactrefFirst.setString("pad", contacts[0]);
    
    from = contacts[0];
    if(from.equals("GND")) from = "GND1";
    
      
    for(int j = 1; j < contacts.length; j++){
      
      to = contacts[j];
      if(to.equals("GND")) to = "GND1";
    
      XML contactrefTo = signal.addChild("contactref");
      contactrefTo.setString("element", "E$1");
      contactrefTo.setString("pad", to);
      XML wire = signal.addChild("wire");
      wire.setString("width", "0");
      wire.setString("layer", "19");
      wire.setString("extent", "1-16");
      
      wire.setString("x1", ""+getBoardCoordinate(from).x);
      wire.setString("y1", ""+getBoardCoordinate(from).y);
      wire.setString("x2", ""+getBoardCoordinate(to).x);
      wire.setString("y2", ""+getBoardCoordinate(to).y);
      
      from = to;
    }
  }
  
  saveXML(brdxml, "data/VW_PCB.brd");
}


/*
// inject signals via CurrentConnections.json
void injectSignals(){
  ccjson = loadJSONArray("CurrentConnections.json");
  
  brdxml = loadXML("data/VW_PCB.brd");
  XML[] drawing = brdxml.getChildren("drawing");
  XML[] board = drawing[0].getChildren("board");
  XML[] signals = board[0].getChildren("signals");
  
  
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
    
    println(cnum + ") from: " + from + ", to: " + to);
    
    XML signal = signals[0].addChild("signal");
    signal.setString("name", "S$"+cnum);
    XML contactrefFrom = signal.addChild("contactref");
    contactrefFrom.setString("element", "E$1");
    contactrefFrom.setString("pad", from);
    XML contactrefTo = signal.addChild("contactref");
    contactrefTo.setString("element", "E$1");
    contactrefTo.setString("pad", to);
    XML wire = signal.addChild("wire");
    wire.setString("width", "0");
    wire.setString("layer", "19");
    wire.setString("extent", "1-16");
    
    wire.setString("x1", ""+getBoardCoordinate(from).x);
    wire.setString("y1", ""+getBoardCoordinate(from).y);
    wire.setString("x2", ""+getBoardCoordinate(to).x);
    wire.setString("y2", ""+getBoardCoordinate(to).y);
  }
  
  saveXML(brdxml, "data/VW_PCB.brd");
}
*/

void clearBrdSignals(){
  brdxml = loadXML("data/VW_PCB.brd");
  XML[] drawing = brdxml.getChildren("drawing");
  XML[] board = drawing[0].getChildren("board");
  XML[] signals = board[0].getChildren("signals");
  XML[] allSignals = signals[0].getChildren("signal");
  
  for (int i = 0; i < allSignals.length; i++) {
    String name = allSignals[i].getString("name");
    println("signal: " + name);
  }
  
  println(signals[0]);
  
  for (int i = 0; i < allSignals.length; i++) {
    XML temp = signals[0].getChild("signal");
    signals[0].removeChild(temp);
  }
  
  saveXML(brdxml, "data/VW_PCB.brd");
}

PVector getBoardCoordinate(String pad){
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

void getAllNets(){
  netlistxml = loadXML("VirtualWire_tempalte_netlist.xml");
  XML[] nets = netlistxml.getChildren("net");

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
      
      //println(id + " " + part + " " + label);
      
      if(!netParts.contains(label)) netParts.add(label);
    }
    
    //add to allNets
    if(netParts.size() > 1){
      for(int k = 0; k < netParts.size(); k++){
        net = net + netParts.get(k) + "_";
      }
      net = net.substring(0, net.length()-1);
      
      allNets.add(net);
      
      net = "";
    }
  }
  
  println(allNets);
}

String connectorToLabel(String id, String part){
  String result = "ROW";
  int resNum;
  
  int connectorNum = Integer.parseInt(id.substring(9));
  
  if(part.equals("MicroBreadboard_left1") == true) resNum = connectorNum/5 + 1;
  else resNum = (connectorNum/5) + 9;
  
  result = result + resNum;
  
  return result;
}
