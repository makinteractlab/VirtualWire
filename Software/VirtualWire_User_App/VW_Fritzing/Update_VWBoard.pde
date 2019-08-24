void updateCommands_Multi(){
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

void printAllCommands(){
  allCommands = loadJSONArray("data/Commands.json");
  
  for(int i = 0; i < allCommands.size(); i++){
    JSONObject command = allCommands.getJSONObject(i);
    console.println(command.getString("Command"));
  }
}

void runAllCommands(){
  allCommands = loadJSONArray("data/Commands.json");
  
  //myPort = new Serial(this, Serial.list()[2], 115200);
  
  JSONObject command = allCommands.getJSONObject(serialCmdIndex);
  
  String runThis = command.getString("Command") + "\n";
  console.println(command.getString("Command"));
  myPort.write(runThis);
  
}
