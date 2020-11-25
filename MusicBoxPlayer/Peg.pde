
class Peg{
  int xLoc;
  int y;
  int r;
  int g;
  int b;
  boolean stop = false;
  
  Peg(int inX, int inR, int inG, int inB){
    xLoc = inX;
    y = height;
    r = inR;
    g = inG;
    b = inB;
  }
  
  void stopPeg(){
    stop = true;
  }
  
  void unStopPeg(){
    stop = false;
  }
  
  void display(){
    y -= 0.8;
   pushMatrix();
    translate(0, y);
    noStroke();
    fill(r,g,b);
    ellipse(xLoc, -30, 40, 40); 
    popMatrix();
  } 
  
  
}
