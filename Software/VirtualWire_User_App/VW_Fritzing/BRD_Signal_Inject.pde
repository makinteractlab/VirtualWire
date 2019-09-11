void injectSignals_regular(){
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
void injectSignals_voltera(){
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



void clearBrdSignals_regular(){
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

void clearBrdSignals_voltera(){
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

PVector getBoardCoordinate_regular(String pad){
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


PVector getBoardCoordinate_voltera(String pad){
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


ArrayList<String> pairsToNet(){
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
