void updateCommands_Multi(){
  commandList.clear();
  commandList.add("{\"cmd\":\"reset\"}");
  
  String cmd1 = "{\"cmd\":\"connect\", \"data\": [\"";
  
  for(int i = 0; i < wirelist.size()-1; i++){
    cmd1 = cmd1 + wirelist.get(i).getFrom() + "\", \"" + wirelist.get(i).getTo() + "\", \"";
  }
  cmd1 = cmd1 + wirelist.get(wirelist.size()-1).getFrom() + "\", \"" + wirelist.get(wirelist.size()-1).getTo() + "\"]}";
  
  commandList.add(cmd1);
  println("COMMANDS UPDATED");
}

void printAllCommands(){
  for(int i = 0; i < commandList.size(); i++){
    print("COMMAND #" + (i + 1) + ": ");
    println(commandList.get(i));
  }
  println();
}

void runAllCommands(){
  println("SENDING COMMANDS");
  
  String runThis = commandList.get(serialCmdIndex) + "\n";
  println(commandList.get(serialCmdIndex) + " - sent to VW Board");
  myPort.write(runThis);
}
