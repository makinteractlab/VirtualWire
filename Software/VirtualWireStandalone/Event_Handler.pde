void mousePressed(){
  if(mouseFlag == false){
    //println("mouse down");
    mouseFlag = true;
    lineAnchorX = mouseX;
    lineAnchorY = mouseY;
  }
}

void mouseReleased(){
  //println("mouse up");
  mouseFlag = false;
  
  int currX = mouseX;
  int currY = mouseY;
  
  if(!checkWithinNode(lineAnchorX, lineAnchorY).equals("null") && !checkWithinNode(currX, currY).equals("null")){
    String from = checkWithinNode(lineAnchorX, lineAnchorY);
    String to = checkWithinNode(currX, currY);
    
    if(!from.equals(to)) wirelist.add(new Wire(from, to, lineAnchorX, lineAnchorY, currX, currY));
  }
}

void actionPerformed (GUIEvent e) {
  if (e.getSource() == b1) {
    for(int i = 0; i < wirelist.size(); i++){
      println("Wire #" + (i + 1));
      println(wirelist.get(i));
    }
    updateCommands_Multi();
    printAllCommands();
    runAllCommands();
  }
  
  if (e.getSource() == b2) {
    println();
    println("WIRES CLEARED");
    println();
    wirelist.clear();
  }
  
  if(e.getSource() == b3) {
    println("SENDING RESET COMMAND");
  
    String runThis = "{\"cmd\":\"reset\"}" + "\n";
    println("{\"cmd\":\"reset\"}" + " - sent to VW Board");
    myPort.write(runThis);
  }
}


void serialEvent(Serial p) {
  inString = p.readStringUntil(10);
  if(inString != null){
    println(inString + " - received from VW Board");
    serialCmdIndex++;
    
    if(serialCmdIndex < commandList.size()){
      String runThis = commandList.get(serialCmdIndex) + "\n";
      println(commandList.get(serialCmdIndex));
      myPort.write(runThis);
    }else{
      serialCmdIndex = 0;
      println("BOARD CONNECTIONS UPDATED");
    }
  }
  
}
