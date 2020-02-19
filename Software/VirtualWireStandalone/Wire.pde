class Wire{
  String from;
  String to;
  
  int x1;
  int y1;
  int x2;
  int y2;
  
  int r;
  int g;
  int b;
  
  Wire(String from, String to, int x1, int y1, int x2, int y2){
    //r = (int)random(0, 255);
    //g = (int)random(0, 255);
    //b = (int)random(0, 255);
    
    this.from = from;
    this.to = to;
    
    this.x1 = x1;
    this.y1 = y1;
    this.x2 = x2;
    this.y2 = y2;
  }
  
  void draw(){
    //stroke(r, g, b);
    stroke(230, 230, 25);
    strokeWeight(5);
    
    line(x1, y1, x2, y2);
    noStroke();
  }
  
  String getFrom(){
    return from;
  }
  
  String getTo(){
    return to;
  }
  
  String getButtonLabel(){
    return from + "-" + to;
  }
  
  //public String toString(){ return "x1: " + x1 + "\ny1: " + y1 + "\nx2: " + x2 + "\ny2" + y2 + "\n\n"; }
  public String toString(){ return "from: " + from + "\nto: " + to + "\n"; }
}
