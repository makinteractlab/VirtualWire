String checkWithinNode(int x, int y){
  String result = "null";
  String temp;
  
  for(int i = 0; i < nodelist.size(); i++){
    temp = nodelist.get(i).within(x, y);
    if(!temp.equals("null")) return temp;
  }
  
  return result;
}
