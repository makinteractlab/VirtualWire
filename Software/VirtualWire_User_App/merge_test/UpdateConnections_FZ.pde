ArrayList<Map> mapping = new ArrayList<Map>();

void updateConnections_FZ(){
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
  
  XML fz_xml = loadXML("data/Fritzing/VW.fz");
  
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
  
  formattedConnectionList = formatConnections(connectionList);
  formattedConnectionListNoDup = removeDuplicateConnections(formattedConnectionList);
  formattedConnectionListNoDupNoInvalid = removeInvalidConnections(formattedConnectionListNoDup);
  
  for(Connection c: formattedConnectionListNoDupNoInvalid) console.println(c.toString());
  
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
}

ArrayList<Connection> removeDuplicateConnections(ArrayList<Connection> connectionList){
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


ArrayList<Connection> removeInvalidConnections(ArrayList<Connection> connectionList){
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
  
  if(t.equals("MicroBreadboard_left1")){ return "ROW" + ((conn/5)+1); }
  if(t.equals("MicroBreadboard_right1")){ return "ROW" + ((conn/5)+9); }
  
  return "Error: Nonexistent Connector and Component Pair";
}

String idToTitle(int id){
  for(Map m: mapping)
    if (id == m.getId())
      return m.getTitle();
  
  return "Id Not Found";
}
