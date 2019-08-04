JSONObject json;
ArrayList<Component> components;
int compCount = 0;

PImage C;
PImage CP;
PImage DE;
PImage LED;
PImage R;
PImage RP;
PImage SV;
PImage UC;
PImage PB;


void sch_vis_setup(){
  //size(720, 480);
  
  C = loadImage("data/img/C.png");
  CP = loadImage("data/img/CP.png");
  DE = loadImage("data/img/DE.png");
  LED = loadImage("data/img/LED.png");
  R = loadImage("data/img/R.png");
  RP = loadImage("data/img/RP.png");
  SV = loadImage("data/img/SV.png");
  UC = loadImage("data/img/UC.png");
  PB = loadImage("data/img/PB.png");
  
  components = parseComponents();
  
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
  
  //pushMatrix();
  //translate(5, 75);
  fill(255); rectMode(CENTER);
  rect(240, 240, 220, 300, 10);
  rect(470, 240, 220, 300, 10);
  fill(0); ellipseMode(CENTER);
  for(int i = 0; i < 5; i++)
    for(int j = 0; j < 8; j++) ellipse(170 + i*35, 118 + j*35, 15, 15);
  for(int i = 0; i < 5; i++)
    for(int j = 0; j < 8; j++) ellipse(400 + i*35, 118 + j*35, 15, 15);
  for(int i = 0; i < 8; i++) rect(470, 118 + i*35, 150, 5);
  for(int i = 0; i < 8; i++) rect(240, 118 + i*35, 150, 5);
  //popMatrix();
  
  /*
  ArrayList<String> c1PinTypes = new ArrayList<String>();
  c1PinTypes.add("connector0"); c1PinTypes.add("connector1"); c1PinTypes.add("connector2"); c1PinTypes.add("connector3");
  c1PinTypes.add("connector4"); c1PinTypes.add("connector5"); c1PinTypes.add("connector6"); c1PinTypes.add("connector7");
  ArrayList<Integer> c1PinRows = new ArrayList<Integer>();
  c1PinRows.add(1); c1PinRows.add(2); c1PinRows.add(3); c1PinRows.add(4);
  c1PinRows.add(12); c1PinRows.add(11); c1PinRows.add(10); c1PinRows.add(9);
  
  Component c1 = new Component("RP1", c1PinTypes, c1PinRows);
  c1.draw();
  */
  
  components.get(compCount%components.size()).draw();
  
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
  }
  
  return "not a comp";
}

PVector pinToPixel(int row){
  if(row < 9){ return new PVector(175, 193 + (row-1)*35); }
  return new PVector(545, 193 + (row-9)*35);
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
      image(C, width/2, height/8, 100, 100);
  
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
      image(CP, width/2, height/8, 100, 100);
  
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
      image(DE, width/2, height/8, 100, 100);
  
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
      image(LED, width/2, height/8, 100, 100);
  
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
      image(R, width/2, height/8, 100, 100);
  
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
      image(RP, width/2, height/8, 100, 100);
  
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
      image(SV, width/2, height/7, 2*45, 3*45);
  
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
      image(UC, width/2, height/8, 100, 100);
  
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
      image(PB, width/2, height/8, 100, 100);
  
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
    }
  }
  
  String returnCompType(){ return compType; }
  
  public String toString(){ return "label: " + label + "\nconnector#: " + connectorNum + "\npinRows: " + pinRows; }
  
}
