class Console{
  ArrayList<String> log;
  int xPos, yPos;
  int boxWidth, boxHeight;
  int bottomLine;
  int maxLineNum;
  int thumbThickness;
  
  Console(int xPos, int yPos, int boxWidth, int boxHeight, int maxLineNum, int thumbThickness){
    log = new ArrayList<String>();
    for(int i = 0; i < maxLineNum; i++) log.add("");
    
    this.xPos = xPos;
    this.yPos = yPos;
    this.boxWidth = boxWidth;
    this.boxHeight = boxHeight;
    this.maxLineNum = maxLineNum;
    this.thumbThickness = thumbThickness;
    
    bottomLine = log.size() - 1;
  }
  
  int getLogSize(){ return log.size(); }
  
  int getBottomLine(){ return bottomLine; }
  
  void println(String line){
    log.add(line);
    bottomLine = log.size() - 1;
  }
  
  void scrollConsole(int change){
    bottomLine = bottomLine + change;
    if(bottomLine > log.size() - 1) bottomLine = log.size() - 1;
    if(bottomLine < maxLineNum-1) bottomLine = maxLineNum-1;
  }
  
  void display(){
    int linePos = 0;
    int lineSpacing = boxHeight/maxLineNum;
    for(int i = bottomLine - maxLineNum+1; i <= bottomLine; i++){
      fill(255);
      textSize(18);
      text(log.get(i), xPos + boxWidth/25, yPos + (linePos + 1)*lineSpacing - lineSpacing/3.5);
      linePos++;
    }
    
    int contentHeight = log.size()*lineSpacing;
    int bottomLineHeight = (bottomLine+1)*lineSpacing;
    int thumbHeight = (int)boxHeight*boxHeight/contentHeight;
    int thumbPos = (int)bottomLineHeight*boxHeight/contentHeight;
    
    fill(200);
    //rect(xPos + 14*boxWidth/15, yPos + (int)map(thumbPos-thumbHeight, -thumbHeight/2, boxHeight-thumbHeight, 0, boxHeight-thumbHeight), boxWidth/15, thumbHeight);
    rect(xPos + boxWidth-5*thumbThickness/4, yPos + thumbPos-thumbHeight, thumbThickness, thumbHeight, thumbThickness);
  }
  
}
