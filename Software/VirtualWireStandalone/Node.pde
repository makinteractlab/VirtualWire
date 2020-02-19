class Node{
  String name;
  int posX;
  int posY;
  
  Node(String name, int posX, int posY){
    this.name = name;
    this.posX = posX;
    this.posY = posY;
  }
  
  int getX(){ return this.posX; }
  int getY(){ return this.posY; }
  
  void draw(){
    fill(0, 255, 125);
    noStroke();
    ellipse(posX, posY, 15, 15);
  }
  
  String within(int x, int y){
    if(dist(x, y, posX, posY) < 10) return this.name;
    return "null";
  }
  
  public String toString(){ return "Node: " + name; }
}

void create_nodes(){
  nodelist.add(new Node("SCL", (int)nodeToPixel("SCL").x, (int)nodeToPixel("SCL").y));
  nodelist.add(new Node("SDA", (int)nodeToPixel("SDA").x, (int)nodeToPixel("SDA").y));
  nodelist.add(new Node("AREF", (int)nodeToPixel("AREF").x, (int)nodeToPixel("AREF").y));
  nodelist.add(new Node("GND1", (int)nodeToPixel("GND1").x, (int)nodeToPixel("GND1").y));
  nodelist.add(new Node("D13", (int)nodeToPixel("D13").x, (int)nodeToPixel("D13").y));
  nodelist.add(new Node("D12", (int)nodeToPixel("D12").x, (int)nodeToPixel("D12").y));
  nodelist.add(new Node("D11", (int)nodeToPixel("D11").x, (int)nodeToPixel("D11").y));
  nodelist.add(new Node("D10", (int)nodeToPixel("D10").x, (int)nodeToPixel("D10").y));
  nodelist.add(new Node("D9", (int)nodeToPixel("D9").x, (int)nodeToPixel("D9").y));
  nodelist.add(new Node("D8", (int)nodeToPixel("D8").x, (int)nodeToPixel("D8").y));
  
  nodelist.add(new Node("D7", (int)nodeToPixel("D7").x, (int)nodeToPixel("D7").y));
  nodelist.add(new Node("D6", (int)nodeToPixel("D6").x, (int)nodeToPixel("D6").y));
  nodelist.add(new Node("D5", (int)nodeToPixel("D5").x, (int)nodeToPixel("D5").y));
  nodelist.add(new Node("D4", (int)nodeToPixel("D4").x, (int)nodeToPixel("D4").y));
  nodelist.add(new Node("D3", (int)nodeToPixel("D3").x, (int)nodeToPixel("D3").y));
  nodelist.add(new Node("D2", (int)nodeToPixel("D2").x, (int)nodeToPixel("D2").y));
  nodelist.add(new Node("D1", (int)nodeToPixel("D1").x, (int)nodeToPixel("D1").y));
  nodelist.add(new Node("D0", (int)nodeToPixel("D0").x, (int)nodeToPixel("D0").y));
  
  nodelist.add(new Node("N/C", (int)nodeToPixel("N/C").x, (int)nodeToPixel("N/C").y));
  nodelist.add(new Node("IOREF", (int)nodeToPixel("IOREF").x, (int)nodeToPixel("IOREF").y));
  nodelist.add(new Node("RESET", (int)nodeToPixel("RESET").x, (int)nodeToPixel("RESET").y));
  nodelist.add(new Node("A3V", (int)nodeToPixel("A3V").x, (int)nodeToPixel("A3V").y));
  nodelist.add(new Node("A5V", (int)nodeToPixel("A5V").x, (int)nodeToPixel("A5V").y));
  nodelist.add(new Node("GND2", (int)nodeToPixel("GND2").x, (int)nodeToPixel("GND2").y));
  nodelist.add(new Node("GND3", (int)nodeToPixel("GND3").x, (int)nodeToPixel("GND3").y));
  nodelist.add(new Node("VIN", (int)nodeToPixel("VIN").x, (int)nodeToPixel("VIN").y));
  
  nodelist.add(new Node("A0", (int)nodeToPixel("A0").x, (int)nodeToPixel("A0").y));
  nodelist.add(new Node("A1", (int)nodeToPixel("A1").x, (int)nodeToPixel("A1").y));
  nodelist.add(new Node("A2", (int)nodeToPixel("A2").x, (int)nodeToPixel("A2").y));
  nodelist.add(new Node("A3", (int)nodeToPixel("A3").x, (int)nodeToPixel("A3").y));
  nodelist.add(new Node("A4", (int)nodeToPixel("A4").x, (int)nodeToPixel("A4").y));
  nodelist.add(new Node("A5", (int)nodeToPixel("A5").x, (int)nodeToPixel("A5").y));
  
  nodelist.add(new Node("ROW1", (int)nodeToPixel("ROW1-1").x, (int)nodeToPixel("ROW1-1").y));
  nodelist.add(new Node("ROW2", (int)nodeToPixel("ROW2-1").x, (int)nodeToPixel("ROW2-1").y));
  nodelist.add(new Node("ROW3", (int)nodeToPixel("ROW3-1").x, (int)nodeToPixel("ROW3-1").y));
  nodelist.add(new Node("ROW4", (int)nodeToPixel("ROW4-1").x, (int)nodeToPixel("ROW4-1").y));
  nodelist.add(new Node("ROW5", (int)nodeToPixel("ROW5-1").x, (int)nodeToPixel("ROW5-1").y));
  nodelist.add(new Node("ROW6", (int)nodeToPixel("ROW6-1").x, (int)nodeToPixel("ROW6-1").y));
  nodelist.add(new Node("ROW7", (int)nodeToPixel("ROW7-1").x, (int)nodeToPixel("ROW7-1").y));
  nodelist.add(new Node("ROW8", (int)nodeToPixel("ROW8-1").x, (int)nodeToPixel("ROW8-1").y));
  
  nodelist.add(new Node("ROW1", (int)nodeToPixel("ROW1-2").x, (int)nodeToPixel("ROW1-2").y));
  nodelist.add(new Node("ROW2", (int)nodeToPixel("ROW2-2").x, (int)nodeToPixel("ROW2-2").y));
  nodelist.add(new Node("ROW3", (int)nodeToPixel("ROW3-2").x, (int)nodeToPixel("ROW3-2").y));
  nodelist.add(new Node("ROW4", (int)nodeToPixel("ROW4-2").x, (int)nodeToPixel("ROW4-2").y));
  nodelist.add(new Node("ROW5", (int)nodeToPixel("ROW5-2").x, (int)nodeToPixel("ROW5-2").y));
  nodelist.add(new Node("ROW6", (int)nodeToPixel("ROW6-2").x, (int)nodeToPixel("ROW6-2").y));
  nodelist.add(new Node("ROW7", (int)nodeToPixel("ROW7-2").x, (int)nodeToPixel("ROW7-2").y));
  nodelist.add(new Node("ROW8", (int)nodeToPixel("ROW8-2").x, (int)nodeToPixel("ROW8-2").y));
  
  nodelist.add(new Node("ROW1", (int)nodeToPixel("ROW1-3").x, (int)nodeToPixel("ROW1-3").y));
  nodelist.add(new Node("ROW2", (int)nodeToPixel("ROW2-3").x, (int)nodeToPixel("ROW2-3").y));
  nodelist.add(new Node("ROW3", (int)nodeToPixel("ROW3-3").x, (int)nodeToPixel("ROW3-3").y));
  nodelist.add(new Node("ROW4", (int)nodeToPixel("ROW4-3").x, (int)nodeToPixel("ROW4-3").y));
  nodelist.add(new Node("ROW5", (int)nodeToPixel("ROW5-3").x, (int)nodeToPixel("ROW5-3").y));
  nodelist.add(new Node("ROW6", (int)nodeToPixel("ROW6-3").x, (int)nodeToPixel("ROW6-3").y));
  nodelist.add(new Node("ROW7", (int)nodeToPixel("ROW7-3").x, (int)nodeToPixel("ROW7-3").y));
  nodelist.add(new Node("ROW8", (int)nodeToPixel("ROW8-3").x, (int)nodeToPixel("ROW8-3").y));
  
  nodelist.add(new Node("ROW1", (int)nodeToPixel("ROW1-4").x, (int)nodeToPixel("ROW1-4").y));
  nodelist.add(new Node("ROW2", (int)nodeToPixel("ROW2-4").x, (int)nodeToPixel("ROW2-4").y));
  nodelist.add(new Node("ROW3", (int)nodeToPixel("ROW3-4").x, (int)nodeToPixel("ROW3-4").y));
  nodelist.add(new Node("ROW4", (int)nodeToPixel("ROW4-4").x, (int)nodeToPixel("ROW4-4").y));
  nodelist.add(new Node("ROW5", (int)nodeToPixel("ROW5-4").x, (int)nodeToPixel("ROW5-4").y));
  nodelist.add(new Node("ROW6", (int)nodeToPixel("ROW6-4").x, (int)nodeToPixel("ROW6-4").y));
  nodelist.add(new Node("ROW7", (int)nodeToPixel("ROW7-4").x, (int)nodeToPixel("ROW7-4").y));
  nodelist.add(new Node("ROW8", (int)nodeToPixel("ROW8-4").x, (int)nodeToPixel("ROW8-4").y));
  
  nodelist.add(new Node("ROW1", (int)nodeToPixel("ROW1-5").x, (int)nodeToPixel("ROW1-5").y));
  nodelist.add(new Node("ROW2", (int)nodeToPixel("ROW2-5").x, (int)nodeToPixel("ROW2-5").y));
  nodelist.add(new Node("ROW3", (int)nodeToPixel("ROW3-5").x, (int)nodeToPixel("ROW3-5").y));
  nodelist.add(new Node("ROW4", (int)nodeToPixel("ROW4-5").x, (int)nodeToPixel("ROW4-5").y));
  nodelist.add(new Node("ROW5", (int)nodeToPixel("ROW5-5").x, (int)nodeToPixel("ROW5-5").y));
  nodelist.add(new Node("ROW6", (int)nodeToPixel("ROW6-5").x, (int)nodeToPixel("ROW6-5").y));
  nodelist.add(new Node("ROW7", (int)nodeToPixel("ROW7-5").x, (int)nodeToPixel("ROW7-5").y));
  nodelist.add(new Node("ROW8", (int)nodeToPixel("ROW8-5").x, (int)nodeToPixel("ROW8-5").y));
  
  nodelist.add(new Node("ROW9", (int)nodeToPixel("ROW9-1").x, (int)nodeToPixel("ROW9-1").y));
  nodelist.add(new Node("ROW10", (int)nodeToPixel("ROW10-1").x, (int)nodeToPixel("ROW10-1").y));
  nodelist.add(new Node("ROW11", (int)nodeToPixel("ROW11-1").x, (int)nodeToPixel("ROW11-1").y));
  nodelist.add(new Node("ROW12", (int)nodeToPixel("ROW12-1").x, (int)nodeToPixel("ROW12-1").y));
  nodelist.add(new Node("ROW13", (int)nodeToPixel("ROW13-1").x, (int)nodeToPixel("ROW13-1").y));
  nodelist.add(new Node("ROW14", (int)nodeToPixel("ROW14-1").x, (int)nodeToPixel("ROW14-1").y));
  nodelist.add(new Node("ROW15", (int)nodeToPixel("ROW15-1").x, (int)nodeToPixel("ROW15-1").y));
  nodelist.add(new Node("ROW16", (int)nodeToPixel("ROW16-1").x, (int)nodeToPixel("ROW16-1").y));
  
  nodelist.add(new Node("ROW9", (int)nodeToPixel("ROW9-2").x, (int)nodeToPixel("ROW9-2").y));
  nodelist.add(new Node("ROW10", (int)nodeToPixel("ROW10-2").x, (int)nodeToPixel("ROW10-2").y));
  nodelist.add(new Node("ROW11", (int)nodeToPixel("ROW11-2").x, (int)nodeToPixel("ROW11-2").y));
  nodelist.add(new Node("ROW12", (int)nodeToPixel("ROW12-2").x, (int)nodeToPixel("ROW12-2").y));
  nodelist.add(new Node("ROW13", (int)nodeToPixel("ROW13-2").x, (int)nodeToPixel("ROW13-2").y));
  nodelist.add(new Node("ROW14", (int)nodeToPixel("ROW14-2").x, (int)nodeToPixel("ROW14-2").y));
  nodelist.add(new Node("ROW15", (int)nodeToPixel("ROW15-2").x, (int)nodeToPixel("ROW15-2").y));
  nodelist.add(new Node("ROW16", (int)nodeToPixel("ROW16-2").x, (int)nodeToPixel("ROW16-2").y));
  
  nodelist.add(new Node("ROW9", (int)nodeToPixel("ROW9-3").x, (int)nodeToPixel("ROW9-3").y));
  nodelist.add(new Node("ROW10", (int)nodeToPixel("ROW10-3").x, (int)nodeToPixel("ROW10-3").y));
  nodelist.add(new Node("ROW11", (int)nodeToPixel("ROW11-3").x, (int)nodeToPixel("ROW11-3").y));
  nodelist.add(new Node("ROW12", (int)nodeToPixel("ROW12-3").x, (int)nodeToPixel("ROW12-3").y));
  nodelist.add(new Node("ROW13", (int)nodeToPixel("ROW13-3").x, (int)nodeToPixel("ROW13-3").y));
  nodelist.add(new Node("ROW14", (int)nodeToPixel("ROW14-3").x, (int)nodeToPixel("ROW14-3").y));
  nodelist.add(new Node("ROW15", (int)nodeToPixel("ROW15-3").x, (int)nodeToPixel("ROW15-3").y));
  nodelist.add(new Node("ROW16", (int)nodeToPixel("ROW16-3").x, (int)nodeToPixel("ROW16-3").y));
  
  nodelist.add(new Node("ROW9", (int)nodeToPixel("ROW9-4").x, (int)nodeToPixel("ROW9-4").y));
  nodelist.add(new Node("ROW10", (int)nodeToPixel("ROW10-4").x, (int)nodeToPixel("ROW10-4").y));
  nodelist.add(new Node("ROW11", (int)nodeToPixel("ROW11-4").x, (int)nodeToPixel("ROW11-4").y));
  nodelist.add(new Node("ROW12", (int)nodeToPixel("ROW12-4").x, (int)nodeToPixel("ROW12-4").y));
  nodelist.add(new Node("ROW13", (int)nodeToPixel("ROW13-4").x, (int)nodeToPixel("ROW13-4").y));
  nodelist.add(new Node("ROW14", (int)nodeToPixel("ROW14-4").x, (int)nodeToPixel("ROW14-4").y));
  nodelist.add(new Node("ROW15", (int)nodeToPixel("ROW15-4").x, (int)nodeToPixel("ROW15-4").y));
  nodelist.add(new Node("ROW16", (int)nodeToPixel("ROW16-4").x, (int)nodeToPixel("ROW16-4").y));
  
  nodelist.add(new Node("ROW9", (int)nodeToPixel("ROW9-5").x, (int)nodeToPixel("ROW9-5").y));
  nodelist.add(new Node("ROW10", (int)nodeToPixel("ROW10-5").x, (int)nodeToPixel("ROW10-5").y));
  nodelist.add(new Node("ROW11", (int)nodeToPixel("ROW11-5").x, (int)nodeToPixel("ROW11-5").y));
  nodelist.add(new Node("ROW12", (int)nodeToPixel("ROW12-5").x, (int)nodeToPixel("ROW12-5").y));
  nodelist.add(new Node("ROW13", (int)nodeToPixel("ROW13-5").x, (int)nodeToPixel("ROW13-5").y));
  nodelist.add(new Node("ROW14", (int)nodeToPixel("ROW14-5").x, (int)nodeToPixel("ROW14-5").y));
  nodelist.add(new Node("ROW15", (int)nodeToPixel("ROW15-5").x, (int)nodeToPixel("ROW15-5").y));
  nodelist.add(new Node("ROW16", (int)nodeToPixel("ROW16-5").x, (int)nodeToPixel("ROW16-5").y));
}
