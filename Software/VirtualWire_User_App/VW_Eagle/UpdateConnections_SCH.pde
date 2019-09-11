void updateConnections_Eagle(){
  ArrayList<Connection> connectionList = new ArrayList<Connection>();
  
  JSONObject json = loadJSONObject(pinlistOutputfileName);
  String lable;
  ArrayList<Integer> positions = new ArrayList<Integer>();
  
  JSONArray component = json.getJSONArray("component");
  
  for (int i = 0; i < component.size(); i++) {
    positions = new ArrayList<Integer>();
    JSONObject comp = component.getJSONObject(i); 
    
    lable = comp.getString("label");
    
    if(!isComponent(lable)){
      JSONArray connector = comp.getJSONArray("connector");
      
      for(int j = 0; j < connector.size(); j++){
        JSONObject pin = connector.getJSONObject(j);
        JSONArray position = pin.getJSONArray("position");
        
        positions.add(position.getInt(0));
      }
      
      if(positions.get(0) == -1){
        connectionList.add(new Connection("Wire"+i, lable, "ROW"+positions.get(1)));
      }else{
        connectionList.add(new Connection("Wire"+i, "ROW"+positions.get(0), "ROW"+positions.get(1)));
      }
      
    }
    
  }
  
  for(Connection c: connectionList) console.println(c.toString());
  
  int ctnNum = 0;
  JSONArray connections = new JSONArray();
  for(Connection c: connectionList){
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
  console.println("<CurrentConnections.json> Updated From Eagle (.sch file)");
  
}

//returns whether label is a component or wire connection
boolean isComponent(String lable){
  
  if(lable.equals("SCL")) return false;
  if(lable.equals("SDA")) return false;
  if(lable.equals("AREF")) return false;
  if(lable.equals("GND1")) return false;
  if(lable.equals("D13")) return false;
  if(lable.equals("D12")) return false;
  if(lable.equals("D11")) return false;
  if(lable.equals("D10")) return false;
  if(lable.equals("D9")) return false;
  if(lable.equals("D8")) return false;
  if(lable.equals("D7")) return false;
  if(lable.equals("D6")) return false;
  if(lable.equals("D5")) return false;
  if(lable.equals("D4")) return false;
  if(lable.equals("D3")) return false;
  if(lable.equals("D2")) return false;
  if(lable.equals("D1")) return false;
  if(lable.equals("D0")) return false;
  if(lable.equals("N/C")) return false;
  if(lable.equals("IOREF")) return false;
  if(lable.equals("RESET")) return false;
  if(lable.equals("A3V")) return false;
  if(lable.equals("A5V")) return false;
  if(lable.equals("GND2")) return false;
  if(lable.equals("GND3")) return false;
  if(lable.equals("VIN")) return false;
  if(lable.equals("A0")) return false;
  if(lable.equals("A1")) return false;
  if(lable.equals("A2")) return false;
  if(lable.equals("A3")) return false;
  if(lable.equals("A4")) return false;
  if(lable.equals("A5")) return false;
  if(lable.substring(0,1).equals("w")) return false;
  return true;
  
}
