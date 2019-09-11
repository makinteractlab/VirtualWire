void serialEvent(Serial p) {
  inString = p.readStringUntil(10);
  if(inString != null){
    console.println(inString);
    serialCmdIndex++;
    
    if(serialCmdIndex < allCommands.size()){
      JSONObject command = allCommands.getJSONObject(serialCmdIndex);
      
      String runThis = command.getString("Command") + "\n";
      console.println(command.getString("Command"));
      myPort.write(runThis);
    }else{
      serialCmdIndex = 0;
      console.println("VW CONNECTIONS UPDATED!!!");
    }
  }
  
}

void runScript(String input, String output){
  try{
    Runtime.getRuntime().exec("C:\\Users\\aerol\\AppData\\Local\\Programs\\Python\\Python37\\python.exe "+dataPath("Eagle\\eagle.py")+" "+dataPath("Eagle\\"+input)+" "+dataPath("Eagle\\"+output));
    console.println("Solver Executed");
  }catch(Exception e){
    console.println("Couldn't run the script: "+e.getMessage());
  }
}

void newSerial(){
  myPort = new Serial(this, Serial.list()[SERIAL_PORT_INDEX], 115200);
}

private void prepareExitHandler() {
  Runtime.getRuntime().addShutdownHook(new Thread(new Runnable() {
    public void run(){
      System.out.println("EXIT: NO LONGER WATCHING FILE");
      myPort.stop();
    }
  }));
}
