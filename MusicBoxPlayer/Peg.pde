
class Peg{
  int xLoc;
  int y;
  
  Peg(int inX){
    xLoc = inX;
    y = height/2;
  }
  
  void drawPeg(){
    y -= 20;
    translate(0, y);
    fill(0);
    ellipse(xLoc, height/2, 45, 45);
  } 
  
}
