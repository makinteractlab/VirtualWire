abstract class FileWatcher extends TimerTask {
  private long timeStamp;
  private File file;

  public FileWatcher( File file ) {
    this.file = file;
    this.timeStamp = file.lastModified();
  }

  public final  void run() {
    long timeStamp = file.lastModified();
    
    if ( this.timeStamp != timeStamp ) {
      this.timeStamp = timeStamp;
      onChange(file);
    }
  }
  
  protected abstract void onChange( File file );
}

class Wire{
  
  int id;
  String title;
  int lConn, rConn;
  int lComp, rComp;
  
  Wire(int id, String title, int lConn, int rConn, int lComp, int rComp){
    this.id = id;
    this.title = title;
    this.lConn = lConn;
    this.rConn = rConn;
    this.lComp = lComp;
    this.rComp = rComp;
  }
  
  String getTitle(){ return title; }
  int getLConn(){ return lConn; }
  int getLComp(){ return lComp; }
  int getRConn(){ return rConn; }
  int getRComp(){ return rComp; }
  
  public String toString(){ return "id: " + id + ", title: " + title + ", lConn: " + lConn + ", rConn: " + rConn + ", lComp: " + lComp + ", rComp: " + rComp; }
}

class Map{
  int id;
  String title;
  
  Map(int id, String title){
    this.id = id;
    this.title = title;
  }
  
  int getId(){ return id; }
  String getTitle(){ return title; }
  
  public String toString(){ return "id: " + id + ", title: " + title; }
}

class Connection{
  
  String wireNum;
  String from, to;
  
  Connection(String wireNum, String from, String to){
    this.wireNum = wireNum;
    this.from = from;
    this.to = to;
  }
  
  String getWireNum(){ return wireNum; }
  String getFrom(){ return from; }
  String getTo(){ return to; }
  
  void changeFrom(String from){ this.from = from; }
  void changeTo(String to){ this.to = to; }
  
  public String toString(){ return wireNum + ", from: " + from + ", to: " + to; }
}

class Command{
  
  String type;
  int numberData;
  String[] data = new String[2];
  
  Command(String type, String from, String to){
    this.type = type;
    this.numberData = -1;
    this.data[0] = from;
    this.data[1] = to;
  }
  
  Command(String type, int data){
    this.type = type;
    this.numberData = data;
    this.data[0] = "";
    this.data[1] = "";
  }
  
  Command(String type){
    this.type = type;
    this.numberData = -1;
    this.data[0] = "";
    this.data[1] = "";
  }
  
  public String toString(){
    if(type.equals("reset")){ return "{\"cmd\":\"reset\"}"; }
    if(type.equals("adc")){ return "{\"cmd\":\"adc\"}" ; }
    if(type.equals("dac")){ return "{\"cmd\":\"dac\", \"data\":" + numberData + "}"; }
    if(type.equals("connect")){ return "{\"cmd\":\"connect\", \"data\": [\"" + data[0] + "\", \"" + data[1] + "\"]}"; }
    if(type.equals("disconnect")){ return "{\"cmd\":\"disconnect\", \"data\": [\"" + data[0] + "\", \"" + data[1] + "\"]}"; }
    if(type.equals("status")){ return "{\"cmd\":\"status\", \"data\": [\"" + data[0] + "\", \"" + data[1] + "\"]}"; }
    return "invalid command";
  }
}
