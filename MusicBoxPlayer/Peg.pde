/*
 *  Amayrani Luna
 *  Class: Peg
 *  Description: Peg objects are used in the MusicBoxPlayer class to represent the pegs on a music box roll. Each Peg has a distinct color, unchanging x value of 
 *               where to be diplayed on the screen, and y value that translates upward on the screen 
*/
class Peg{
  int xLoc; //unchanging x value
  int y; //y value that decreases
  //RGB color values of Peg
  int r;
  int g;
  int b;
  boolean stop = false;
  int op; //opacity
  
  //CONSTRUCTOR
  Peg(int inX, int inR, int inG, int inB){
    xLoc = inX;
    y = height;
    r = inR;
    g = inG;
    b = inB;
    op = 700;
  }
  
  void stopPeg(){
    stop = true;
  }
  
  void unStopPeg(){
    stop = false;
  }
  
  //DISPLAYS THE PEG OBJECTS 
  void display(){
    if(stop == false){ //stops pegs from translating up and fading out 
      y -= 0.8;
      op -= 1;
    }
    
    //moves the pegs across the screen 
    pushMatrix();
    translate(0, y);
    noStroke();
    fill(0, g, b, op); 
    ellipse(xLoc, -30, 30, 30); 
    popMatrix();
  } 
  
  
}
