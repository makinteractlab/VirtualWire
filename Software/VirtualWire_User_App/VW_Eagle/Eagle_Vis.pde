JSONObject json;
ArrayList<Component> components;
ArrayList<EagleWire> eagleWires;
int compCount = 0;

PImage UNO;
PImage C;
PImage CP;
PImage DE;
PImage LED;
PImage R;
PImage RP;
PImage SV;
PImage UC;
PImage PB;
PImage BT;

void sch_vis_setup(){
  //size(720, 480);
  
  UNO = loadImage("data/img/ArduinoUno.png");
  C = loadImage("data/img/C.png");
  CP = loadImage("data/img/CP.png");
  DE = loadImage("data/img/DE.png");
  LED = loadImage("data/img/LED.png");
  R = loadImage("data/img/R.png");
  RP = loadImage("data/img/RP.png");
  SV = loadImage("data/img/SV.png");
  UC = loadImage("data/img/UC.png");
  PB = loadImage("data/img/PB.png");
  BT = loadImage("data/img/BT.png");
  
  components = parseComponents();
  eagleWires = parseWires();
  
  /*
  println("C1: " + getCompType("C1")); println("CP1: " + getCompType("CP1")); println("DE1: " + getCompType("DE1"));
  println("LED1: " + getCompType("LED1")); println("R1: " + getCompType("R1")); println("RP1: " + getCompType("RP1"));
  println("SV1: " + getCompType("SV1")); println("UC1: " + getCompType("UC1")); println("PB1: " + getCompType("PB1"));
  println();
  println("SCL: " + getCompType("SCL")); println("SDA: " + getCompType("SDA")); println("AREF: " + getCompType("AREF"));
  println("GND1: " + getCompType("GND1")); println("D13: " + getCompType("D13")); println("D12: " + getCompType("D12"));
  println("D11: " + getCompType("D11")); println("D10: " + getCompType("D10")); println("D9: " + getCompType("D9"));
  println("D8: " + getCompType("D8")); println("D7: " + getCompType("D7")); println("D6: " + getCompType("D6"));
  println("D5: " + getCompType("D5")); println("D4: " + getCompType("D4")); println("D3: " + getCompType("D3"));
  println("D2: " + getCompType("D2")); println("D1: " + getCompType("D1")); println("D0: " + getCompType("D0"));
  println("wire1: " + getCompType("")); println("NC: " + getCompType("")); println("IOREF: " + getCompType(""));
  println("RESET: " + getCompType("")); println("A3V: " + getCompType("")); println("A5V: " + getCompType(""));
  println("GND2: " + getCompType("")); println("GND3: " + getCompType("")); println("VIN: " + getCompType(""));
  println("A0: " + getCompType("")); println("A1: " + getCompType("")); println("A2: " + getCompType(""));
  println("A3: " + getCompType("")); println("A4: " + getCompType("")); println("A5: " + getCompType(""));
  */
}

void sch_vis_draw(){
  background(200);
  
  pushMatrix();
  translate(150, 100);
  scale(0.75);
  fill(255);
  rectMode(CENTER);
  rect(240, 240, 220, 300, 10);
  rect(470, 240, 220, 300, 10);
  fill(0);
  ellipseMode(CENTER);
  for(int i = 0; i < 5; i++)
    for(int j = 0; j < 8; j++) ellipse(170 + i*35, 118 + j*35, 15, 15);
  for(int i = 0; i < 5; i++)
    for(int j = 0; j < 8; j++) ellipse(400 + i*35, 118 + j*35, 15, 15);
  for(int i = 0; i < 8; i++) rect(470, 118 + i*35, 150, 5);
  for(int i = 0; i < 8; i++) rect(240, 118 + i*35, 150, 5);
  popMatrix();
  
  
  pushMatrix();
  translate(146, 44);
  scale(0.75);
  
  /*
  ArrayList<String> c1PinTypes = new ArrayList<String>();
  c1PinTypes.add("connector0");
  c1PinTypes.add("connector1");
  c1PinTypes.add("connector2");
  c1PinTypes.add("connector3");
  c1PinTypes.add("connector4");
  c1PinTypes.add("connector5");
  c1PinTypes.add("connector6");
  c1PinTypes.add("connector7");
  ArrayList<Integer> c1PinRows = new ArrayList<Integer>();
  c1PinRows.add(1);
  c1PinRows.add(2);
  c1PinRows.add(3);
  c1PinRows.add(4);
  c1PinRows.add(12);
  c1PinRows.add(11);
  c1PinRows.add(10);
  c1PinRows.add(9);
  
  Component c1 = new Component("BT1", c1PinTypes, c1PinRows);
  c1.draw();
  */
  
  components.get(compCount%components.size()).draw();
  popMatrix();
  
  rectMode(CORNER);
  ellipseMode(CORNER);
}

void sch_vis_wire(){
  
  imageMode(CORNER);
  image(UNO, 175, 100, 448, 329);
  
  pushMatrix();
  translate(235, 124);
  scale(0.60);
  fill(255);
  rectMode(CENTER);
  rect(240, 240, 220, 300, 10);
  rect(470, 240, 220, 300, 10);
  fill(0);
  ellipseMode(CENTER);
  for(int i = 0; i < 5; i++)
    for(int j = 0; j < 8; j++) ellipse(170 + i*35, 118 + j*35, 15, 15);
  for(int i = 0; i < 5; i++)
    for(int j = 0; j < 8; j++) ellipse(400 + i*35, 118 + j*35, 15, 15);
  for(int i = 0; i < 8; i++) rect(470, 118 + i*35, 150, 5);
  for(int i = 0; i < 8; i++) rect(240, 118 + i*35, 150, 5);
  popMatrix();
  resetMatrix();
  
  for(int i = 0; i < eagleWires.size(); i++)
    eagleWires.get(i).draw();
  
  //fill(255, 0, 0);
  //strokeWeight(0);
  //ellipse(nodeToPixel("ROW1").x, nodeToPixel("ROW1").y, 7, 7);
  //ellipse(nodeToPixel("ROW2").x, nodeToPixel("ROW2").y, 7, 7);
  //ellipse(nodeToPixel("ROW3").x, nodeToPixel("ROW3").y, 7, 7);
  //ellipse(nodeToPixel("ROW4").x, nodeToPixel("ROW4").y, 7, 7);
  //ellipse(nodeToPixel("ROW5").x, nodeToPixel("ROW5").y, 7, 7);
  //ellipse(nodeToPixel("ROW6").x, nodeToPixel("ROW6").y, 7, 7);
  //ellipse(nodeToPixel("ROW7").x, nodeToPixel("ROW7").y, 7, 7);
  //ellipse(nodeToPixel("ROW8").x, nodeToPixel("ROW8").y, 7, 7);
  //ellipse(nodeToPixel("ROW9").x, nodeToPixel("ROW9").y, 7, 7);
  //ellipse(nodeToPixel("ROW10").x, nodeToPixel("ROW10").y, 7, 7);
  //ellipse(nodeToPixel("ROW11").x, nodeToPixel("ROW11").y, 7, 7);
  //ellipse(nodeToPixel("ROW12").x, nodeToPixel("ROW12").y, 7, 7);
  //ellipse(nodeToPixel("ROW13").x, nodeToPixel("ROW13").y, 7, 7);
  //ellipse(nodeToPixel("ROW14").x, nodeToPixel("ROW14").y, 7, 7);
  //ellipse(nodeToPixel("ROW15").x, nodeToPixel("ROW15").y, 7, 7);
  //ellipse(nodeToPixel("ROW16").x, nodeToPixel("ROW16").y, 7, 7);
  
  //ellipse(nodeToPixel("SCL").x, nodeToPixel("SCL").y, 7, 7);
  //ellipse(nodeToPixel("SDA").x, nodeToPixel("SDA").y, 7, 7);
  //ellipse(nodeToPixel("AREF").x, nodeToPixel("AREF").y, 7, 7);
  //ellipse(nodeToPixel("GND1").x, nodeToPixel("GND1").y, 7, 7);
  //ellipse(nodeToPixel("D13").x, nodeToPixel("D13").y, 7, 7);
  //ellipse(nodeToPixel("D12").x, nodeToPixel("D12").y, 7, 7);
  //ellipse(nodeToPixel("D11").x, nodeToPixel("D11").y, 7, 7);
  //ellipse(nodeToPixel("D10").x, nodeToPixel("D10").y, 7, 7);
  //ellipse(nodeToPixel("D9").x, nodeToPixel("D9").y, 7, 7);
  //ellipse(nodeToPixel("D8").x, nodeToPixel("D8").y, 7, 7);
  //ellipse(nodeToPixel("D7").x, nodeToPixel("D7").y, 7, 7);
  //ellipse(nodeToPixel("D6").x, nodeToPixel("D6").y, 7, 7);
  //ellipse(nodeToPixel("D5").x, nodeToPixel("D5").y, 7, 7);
  //ellipse(nodeToPixel("D4").x, nodeToPixel("D4").y, 7, 7);
  //ellipse(nodeToPixel("D3").x, nodeToPixel("D3").y, 7, 7);
  //ellipse(nodeToPixel("D2").x, nodeToPixel("D2").y, 7, 7);
  //ellipse(nodeToPixel("D1").x, nodeToPixel("D1").y, 7, 7);
  //ellipse(nodeToPixel("D0").x, nodeToPixel("D0").y, 7, 7);
  
  //ellipse(nodeToPixel("N/C").x, nodeToPixel("N/C").y, 7, 7);
  //ellipse(nodeToPixel("IOREF").x, nodeToPixel("IOREF").y, 7, 7);
  //ellipse(nodeToPixel("RESET").x, nodeToPixel("RESET").y, 7, 7);
  //ellipse(nodeToPixel("A5V").x, nodeToPixel("A5V").y, 7, 7);
  //ellipse(nodeToPixel("A3V").x, nodeToPixel("A3V").y, 7, 7);
  //ellipse(nodeToPixel("GND2").x, nodeToPixel("GND2").y, 7, 7);
  //ellipse(nodeToPixel("GND3").x, nodeToPixel("GND3").y, 7, 7);
  //ellipse(nodeToPixel("VIN").x, nodeToPixel("VIN").y, 7, 7);
  //ellipse(nodeToPixel("A5").x, nodeToPixel("A5").y, 7, 7);
  //ellipse(nodeToPixel("A4").x, nodeToPixel("A4").y, 7, 7);
  //ellipse(nodeToPixel("A3").x, nodeToPixel("A3").y, 7, 7);
  //ellipse(nodeToPixel("A2").x, nodeToPixel("A2").y, 7, 7);
  //ellipse(nodeToPixel("A1").x, nodeToPixel("A1").y, 7, 7);
  //ellipse(nodeToPixel("A0").x, nodeToPixel("A0").y, 7, 7);
  
  rectMode(CORNER);
  ellipseMode(CORNER);
}

ArrayList<Component> parseComponents(){
  
  ArrayList<Component> components = new ArrayList<Component>();
  
  json = loadJSONObject(pinlistOutputfileName);
  
  JSONArray component = json.getJSONArray("component");
  
  for (int i = 0; i < component.size(); i++) {
    String label;
    ArrayList<String> connectorNum = new ArrayList<String>();
    ArrayList<Integer> pinRows = new ArrayList<Integer>();
    
    JSONObject comp = component.getJSONObject(i); 
    
    label = comp.getString("label");
    
    JSONArray connector = comp.getJSONArray("connector");
    
    for(int j = 0; j < connector.size(); j++){
      JSONObject pin = connector.getJSONObject(j);
      JSONArray position = pin.getJSONArray("position");
      String type = pin.getString("id");
      
      connectorNum.add(type);
      pinRows.add(position.getInt(0));
    }
    
    if(!getCompType(label).equals("not a comp")){
      components.add(new Component(label, connectorNum, pinRows));
    }
    
  }
  
  //for(Component c: components){ println(c); println(); }
  
  return components;
}

ArrayList<EagleWire> parseWires(){
  
  ArrayList<EagleWire> wires = new ArrayList<EagleWire>();
  
  
  json = loadJSONObject(pinlistOutputfileName);
  
  JSONArray component = json.getJSONArray("component");
  
  for (int i = 0; i < component.size(); i++) {
    String label;
    ArrayList<Integer> pinRows = new ArrayList<Integer>();
    ArrayList<String> nodes = new ArrayList<String>();
    
    JSONObject comp = component.getJSONObject(i); 
    
    label = comp.getString("label");
    
    JSONArray connector = comp.getJSONArray("connector");
    
    for(int j = 0; j < connector.size(); j++){
      JSONObject pin = connector.getJSONObject(j);
      JSONArray position = pin.getJSONArray("position");
      
      pinRows.add(position.getInt(0));
    }
    
    if(getCompType(label).equals("not a comp")){
      
      for(int j = 0; j < pinRows.size(); j++){
        if(pinRows.get(j) == -1) nodes.add(label);
        else nodes.add("ROW" + pinRows.get(j));
      }
      
      wires.add(new EagleWire(nodes));
    }
  }
  
  for(EagleWire w: wires){ println(w); println(); }
  
  return wires;
}

String getCompType(String label){
  if(label.length() < 2) return "not a comp";
  
  if(label.substring(0, 1).equals("C")){
    if(label.substring(1, 2).equals("P")) return "CP";
    else return "C";
  }else if(label.substring(0, 1).equals("R")){
    if(label.substring(1, 2).equals("E")) return "not a comp";
    else if(label.substring(1, 2).equals("P")) return "RP";
    else return "R";
  }else if(label.substring(0, 1).equals("D")){
    if(label.substring(1, 2).equals("E")) return "DE";
    else return "not a comp";
  }else if(label.substring(0, 1).equals("L")){
    return "LED";
  }else if(label.substring(0, 1).equals("S")){
    if(label.substring(1, 2).equals("V")) return "SV";
    else return "not a comp";
  }else if(label.substring(0, 1).equals("U")){
    return "UC";
  }else if(label.substring(0, 1).equals("P")){
    return "PB";
  }else if(label.substring(0, 1).equals("B")){
    return "BT";
  }
  
  return "not a comp";
}

PVector pinToPixel(int row){
  if(row < 9){ return new PVector(175, 193 + (row-1)*35); }
  return new PVector(545, 193 + (row-9)*35);
}

PVector nodeToPixel(String node){
  
  if(node.equals("SCL")) return new PVector(330, 130);
  if(node.equals("SDA")) return new PVector(344, 130);
  if(node.equals("AREF")) return new PVector(358, 130);
  if(node.equals("GND1")) return new PVector(372, 130);
  if(node.equals("D13")) return new PVector(386, 130);
  if(node.equals("D12")) return new PVector(400, 130);
  if(node.equals("D11")) return new PVector(414, 130);
  if(node.equals("D10")) return new PVector(428, 130);
  if(node.equals("D9")) return new PVector(442, 130);
  if(node.equals("D8")) return new PVector(456, 130);
  if(node.equals("D7")) return new PVector(480, 130);
  if(node.equals("D6")) return new PVector(494, 130);
  if(node.equals("D5")) return new PVector(508, 130);
  if(node.equals("D4")) return new PVector(522, 130);
  if(node.equals("D3")) return new PVector(536, 130);
  if(node.equals("D2")) return new PVector(550, 130);
  if(node.equals("D1")) return new PVector(564, 130);
  if(node.equals("D0")) return new PVector(578, 130);
  
  if(node.equals("N/C")) return new PVector(381, 400);
  if(node.equals("IOREF")) return new PVector(395, 400);
  if(node.equals("RESET")) return new PVector(409, 400);
  if(node.equals("A3V")) return new PVector(423, 400);
  if(node.equals("A5V")) return new PVector(437, 400);
  if(node.equals("GND2")) return new PVector(451, 400);
  if(node.equals("GND3")) return new PVector(465, 400);
  if(node.equals("VIN")) return new PVector(479, 400);
  if(node.equals("A0")) return new PVector(508, 400);
  if(node.equals("A1")) return new PVector(522, 400);
  if(node.equals("A2")) return new PVector(536, 400);
  if(node.equals("A3")) return new PVector(550, 400);
  if(node.equals("A4")) return new PVector(564, 400);
  if(node.equals("A5")) return new PVector(578, 400);
  
  if(node.equals("ROW1")) return new PVector(337, 195);
  if(node.equals("ROW2")) return new PVector(337, 216);
  if(node.equals("ROW3")) return new PVector(337, 237);
  if(node.equals("ROW4")) return new PVector(337, 258);
  if(node.equals("ROW5")) return new PVector(337, 279);
  if(node.equals("ROW6")) return new PVector(337, 300);
  if(node.equals("ROW7")) return new PVector(337, 321);
  if(node.equals("ROW8")) return new PVector(337, 342);
  if(node.equals("ROW9")) return new PVector(559, 195);
  if(node.equals("ROW10")) return new PVector(559, 216);
  if(node.equals("ROW11")) return new PVector(559, 237);
  if(node.equals("ROW12")) return new PVector(559, 258);
  if(node.equals("ROW13")) return new PVector(559, 279);
  if(node.equals("ROW14")) return new PVector(559, 300);
  if(node.equals("ROW15")) return new PVector(559, 321);
  if(node.equals("ROW16")) return new PVector(559, 342);
  
  return new PVector(-7, -7);
}

class EagleWire{
  String from;
  String to;
  
  int r;
  int g;
  int b;
  
  EagleWire(ArrayList<String> nodes){
    this.from = nodes.get(0);
    this.to = nodes.get(1);
    r = (int)random(0, 255);
    g = (int)random(0, 255);
    b = (int)random(0, 255);
  }
  
  void draw(){
    stroke(r, g, b);
    strokeWeight(5);
    
    line(nodeToPixel(from).x, nodeToPixel(from).y, nodeToPixel(to).x, nodeToPixel(to).y);
    noStroke();
  }
  
  public String toString(){ return "from: " + from + "\nto: " + to; }
}

class Component{
  String label;
  ArrayList<String> connectorNum;
  ArrayList<Integer> pinRows;
  String compType;
  
  Component(String label, ArrayList<String> connectorNum, ArrayList<Integer> pinRows){
    this.label = label;
    this.connectorNum = connectorNum;
    this.pinRows = pinRows;
    this.compType = getCompType(label);
  }
  
  void draw(){
    if(compType.equals("C")){//IF COMPONENT IS A CAPACITOR
      imageMode(CENTER);
      image(C, 360, 60, 100, 100);
  
      fill(133, 159, 255);
      strokeWeight(0);
      ellipse(pinToPixel(pinRows.get(0)).x, pinToPixel(pinRows.get(0)).y, 15, 15);
      ellipse(pinToPixel(pinRows.get(1)).x, pinToPixel(pinRows.get(1)).y, 15, 15);
      ellipse(340, 110, 15, 15);
      ellipse(380, 110, 15, 15);
      
      stroke(133, 159, 255);
      strokeWeight(5);
      line(340, 110, pinToPixel(pinRows.get(0)).x, pinToPixel(pinRows.get(0)).y);
      line(380, 110, pinToPixel(pinRows.get(1)).x, pinToPixel(pinRows.get(1)).y);
      stroke(0);
      strokeWeight(1);
    }else if(compType.equals("CP")){//IF COMPONENT IS A POLARIZED CAPACITOR
      imageMode(CENTER);
      image(CP, 360, 60, 100, 100);
  
      fill(133, 159, 255);
      strokeWeight(0);
      ellipse(pinToPixel(pinRows.get(0)).x, pinToPixel(pinRows.get(0)).y, 15, 15);
      ellipse(pinToPixel(pinRows.get(1)).x, pinToPixel(pinRows.get(1)).y, 15, 15);
      ellipse(350, 110, 15, 15);// (-) cathode
      ellipse(370, 110, 15, 15);// (+) anode
      
      stroke(133, 159, 255);
      strokeWeight(5);
      
      line(350, 110, pinToPixel(pinRows.get(connectorNum.indexOf("connector1"))).x, pinToPixel(pinRows.get(connectorNum.indexOf("connector1"))).y);
      line(370, 110, pinToPixel(pinRows.get(connectorNum.indexOf("connector0"))).x, pinToPixel(pinRows.get(connectorNum.indexOf("connector0"))).y);
      
      stroke(0);
      strokeWeight(1);
    }else if(compType.equals("DE")){//IF COMPONENT IS A DIODE
      imageMode(CENTER);
      image(DE, 360, 60, 100, 100);
  
      fill(133, 159, 255);
      strokeWeight(0);
      ellipse(pinToPixel(pinRows.get(0)).x, pinToPixel(pinRows.get(0)).y, 15, 15);
      ellipse(pinToPixel(pinRows.get(1)).x, pinToPixel(pinRows.get(1)).y, 15, 15);
      ellipse(310, 60, 15, 15);// (-) cathode
      ellipse(410, 60, 15, 15);// (+) anode
      
      stroke(133, 159, 255);
      strokeWeight(5);
      
      line(310, 60, pinToPixel(pinRows.get(connectorNum.indexOf("connector1"))).x, pinToPixel(pinRows.get(connectorNum.indexOf("connector1"))).y);
      line(410, 60, pinToPixel(pinRows.get(connectorNum.indexOf("connector0"))).x, pinToPixel(pinRows.get(connectorNum.indexOf("connector0"))).y);
      
      stroke(0);
      strokeWeight(1);
    }else if(compType.equals("LED")){//IF COMPONENT IS AN LED
      imageMode(CENTER);
      image(LED, 360, 60, 100, 100);
  
      fill(133, 159, 255);
      strokeWeight(0);
      ellipse(pinToPixel(pinRows.get(0)).x, pinToPixel(pinRows.get(0)).y, 15, 15);
      ellipse(pinToPixel(pinRows.get(1)).x, pinToPixel(pinRows.get(1)).y, 15, 15);
      ellipse(350, 110, 15, 15);// (-) cathode
      ellipse(370, 110, 15, 15);// (+) anode
      
      stroke(133, 159, 255);
      strokeWeight(5);
      
      line(350, 110, pinToPixel(pinRows.get(connectorNum.indexOf("connector1"))).x, pinToPixel(pinRows.get(connectorNum.indexOf("connector1"))).y);
      line(370, 110, pinToPixel(pinRows.get(connectorNum.indexOf("connector0"))).x, pinToPixel(pinRows.get(connectorNum.indexOf("connector0"))).y);
      
      stroke(0);
      strokeWeight(1);
    }else if(compType.equals("R")){//IF COMPONENT IS A RESISTOR
      imageMode(CENTER);
      image(R, 360, 60, 100, 100);
  
      fill(133, 159, 255);
      strokeWeight(0);
      ellipse(pinToPixel(pinRows.get(0)).x, pinToPixel(pinRows.get(0)).y, 15, 15);
      ellipse(pinToPixel(pinRows.get(1)).x, pinToPixel(pinRows.get(1)).y, 15, 15);
      ellipse(310, 60, 15, 15);
      ellipse(410, 60, 15, 15);
      
      stroke(133, 159, 255);
      strokeWeight(5);
      line(310, 60, pinToPixel(pinRows.get(0)).x, pinToPixel(pinRows.get(0)).y);
      line(410, 60, pinToPixel(pinRows.get(1)).x, pinToPixel(pinRows.get(1)).y);
      stroke(0);
      strokeWeight(1);
    }else if(compType.equals("RP")){//IF COMPONENT IS A POTENTIOMETER
      imageMode(CENTER);
      image(RP, 360, 60, 100, 100);
  
      fill(133, 159, 255);
      strokeWeight(0);
      ellipse(pinToPixel(pinRows.get(0)).x, pinToPixel(pinRows.get(0)).y, 15, 15);
      ellipse(pinToPixel(pinRows.get(1)).x, pinToPixel(pinRows.get(1)).y, 15, 15);
      ellipse(pinToPixel(pinRows.get(2)).x, pinToPixel(pinRows.get(2)).y, 15, 15);
      ellipse(340, 110, 15, 15);
      ellipse(360, 110, 15, 15);
      ellipse(380, 110, 15, 15);
      
      stroke(133, 159, 255);
      strokeWeight(5);
      
      line(340, 110, pinToPixel(pinRows.get(connectorNum.indexOf("connector0"))).x, pinToPixel(pinRows.get(connectorNum.indexOf("connector0"))).y);
      line(360, 110, pinToPixel(pinRows.get(connectorNum.indexOf("connector1"))).x, pinToPixel(pinRows.get(connectorNum.indexOf("connector1"))).y);
      line(380, 110, pinToPixel(pinRows.get(connectorNum.indexOf("connector2"))).x, pinToPixel(pinRows.get(connectorNum.indexOf("connector2"))).y);
      
      stroke(0);
      strokeWeight(1);
    }else if(compType.equals("SV")){//IF COMPONENT IS A SERVO MOTOR
      imageMode(CENTER);
      image(SV, 360, 60, 2*45, 3*45);
  
      fill(133, 159, 255);
      strokeWeight(0);
      ellipse(pinToPixel(pinRows.get(0)).x, pinToPixel(pinRows.get(0)).y, 15, 15);
      ellipse(pinToPixel(pinRows.get(1)).x, pinToPixel(pinRows.get(1)).y, 15, 15);
      ellipse(pinToPixel(pinRows.get(2)).x, pinToPixel(pinRows.get(2)).y, 15, 15);
      ellipse(338, 125, 15, 15);
      ellipse(358, 125, 15, 15);
      ellipse(378, 125, 15, 15);
      
      stroke(133, 159, 255);
      strokeWeight(5);
      line(338, 125, pinToPixel(pinRows.get(connectorNum.indexOf("connector0"))).x, pinToPixel(pinRows.get(connectorNum.indexOf("connector0"))).y);
      line(358, 125, pinToPixel(pinRows.get(connectorNum.indexOf("connector1"))).x, pinToPixel(pinRows.get(connectorNum.indexOf("connector1"))).y);
      line(378, 125, pinToPixel(pinRows.get(connectorNum.indexOf("connector2"))).x, pinToPixel(pinRows.get(connectorNum.indexOf("connector2"))).y);
      stroke(0);
      strokeWeight(1);
    }else if(compType.equals("UC")){//IF COMPONENT IS AN IC CHIP
      imageMode(CENTER);
      image(UC, 360, 60, 100, 100);
  
      fill(133, 159, 255);
      strokeWeight(0);
      ellipse(pinToPixel(pinRows.get(0)).x, pinToPixel(pinRows.get(0)).y, 15, 15);
      ellipse(pinToPixel(pinRows.get(1)).x, pinToPixel(pinRows.get(1)).y, 15, 15);
      ellipse(pinToPixel(pinRows.get(2)).x, pinToPixel(pinRows.get(2)).y, 15, 15);
      ellipse(pinToPixel(pinRows.get(3)).x, pinToPixel(pinRows.get(3)).y, 15, 15);
      ellipse(pinToPixel(pinRows.get(4)).x, pinToPixel(pinRows.get(4)).y, 15, 15);
      ellipse(pinToPixel(pinRows.get(5)).x, pinToPixel(pinRows.get(5)).y, 15, 15);
      ellipse(pinToPixel(pinRows.get(6)).x, pinToPixel(pinRows.get(6)).y, 15, 15);
      ellipse(pinToPixel(pinRows.get(7)).x, pinToPixel(pinRows.get(7)).y, 15, 15);
      ellipse(320, 23, 15, 15);
      ellipse(320, 48, 15, 15);
      ellipse(320, 73, 15, 15);
      ellipse(320, 98, 15, 15);
      ellipse(400, 23, 15, 15);
      ellipse(400, 48, 15, 15);
      ellipse(400, 73, 15, 15);
      ellipse(400, 98, 15, 15);
      
      stroke(133, 159, 255);
      strokeWeight(5);
      
      line(320, 23, pinToPixel(pinRows.get(connectorNum.indexOf("connector0"))).x, pinToPixel(pinRows.get(connectorNum.indexOf("connector0"))).y);
      line(320, 48, pinToPixel(pinRows.get(connectorNum.indexOf("connector1"))).x, pinToPixel(pinRows.get(connectorNum.indexOf("connector1"))).y);
      line(320, 73, pinToPixel(pinRows.get(connectorNum.indexOf("connector2"))).x, pinToPixel(pinRows.get(connectorNum.indexOf("connector2"))).y);
      line(320, 98, pinToPixel(pinRows.get(connectorNum.indexOf("connector3"))).x, pinToPixel(pinRows.get(connectorNum.indexOf("connector3"))).y);
      line(400, 23, pinToPixel(pinRows.get(connectorNum.indexOf("connector7"))).x, pinToPixel(pinRows.get(connectorNum.indexOf("connector7"))).y);
      line(400, 48, pinToPixel(pinRows.get(connectorNum.indexOf("connector6"))).x, pinToPixel(pinRows.get(connectorNum.indexOf("connector6"))).y);
      line(400, 73, pinToPixel(pinRows.get(connectorNum.indexOf("connector5"))).x, pinToPixel(pinRows.get(connectorNum.indexOf("connector5"))).y);
      line(400, 98, pinToPixel(pinRows.get(connectorNum.indexOf("connector4"))).x, pinToPixel(pinRows.get(connectorNum.indexOf("connector4"))).y);
      
      stroke(0);
      strokeWeight(1);
    }else if(compType.equals("PB")){//IF COMPONENT IS A PUSH BUTTON
      imageMode(CENTER);
      image(PB, 360, 60, 100, 100);
  
      fill(133, 159, 255);
      strokeWeight(0);
      ellipse(pinToPixel(pinRows.get(0)).x, pinToPixel(pinRows.get(0)).y, 15, 15);
      ellipse(pinToPixel(pinRows.get(1)).x, pinToPixel(pinRows.get(1)).y, 15, 15);
      ellipse(350, 110, 15, 15);
      ellipse(370, 110, 15, 15);
      
      stroke(133, 159, 255);
      strokeWeight(5);
      line(350, 110, pinToPixel(pinRows.get(0)).x, pinToPixel(pinRows.get(0)).y);
      line(370, 110, pinToPixel(pinRows.get(1)).x, pinToPixel(pinRows.get(1)).y);
      stroke(0);
      strokeWeight(1);
    }else if(compType.equals("BT")){//IF COMPONENT IS A BATTERY
      imageMode(CENTER);
      image(BT, 360, 60, 100, 100);
  
      fill(133, 159, 255);
      strokeWeight(0);
      ellipse(pinToPixel(pinRows.get(0)).x, pinToPixel(pinRows.get(0)).y, 15, 15);
      ellipse(pinToPixel(pinRows.get(1)).x, pinToPixel(pinRows.get(1)).y, 15, 15);
      ellipse(325, 85, 15, 15);
      ellipse(395, 85, 15, 15);
      
      stroke(133, 159, 255);
      strokeWeight(5);
      line(325, 85, pinToPixel(pinRows.get(0)).x, pinToPixel(pinRows.get(0)).y);
      line(395, 85, pinToPixel(pinRows.get(1)).x, pinToPixel(pinRows.get(1)).y);
      stroke(0);
      strokeWeight(1);
    }
  }
  
  String returnCompType(){ return compType; }
  
  public String toString(){ return "label: " + label + "\nconnector#: " + connectorNum + "\npinRows: " + pinRows; }
  
}
