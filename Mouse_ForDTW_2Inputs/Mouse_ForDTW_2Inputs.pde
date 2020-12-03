/*
*  Amayrani Luna
*  Description: sends x,y values of the wrist to Wekinator     
*
*/

import controlP5.*;
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress dest;
ControlP5 cp5;

final String POSENET_ADDRESS = "/pose"; //the OSC message sent from the standalone

//The port we are listening to
final int LISTENING_PORT = 9876;

PFont f, f2;
boolean isRecording = true; //mode
boolean isRecordingNow = true;

//values recieved from posenet
String bodyPart;
float xPos = 0;
float yPos;

//values of the box output
int areaTopX = 140;
int areaTopY = 70;
int areaWidth = 450;
int areaHeight = 390;

int currentClass = 1;

void setup(){
 // colorMode(HSB);
  size(640, 480, P2D);
  noStroke();

  /* start oscP5, listening for incoming messages at port 9876 */
  oscP5 = new OscP5(this,LISTENING_PORT);
  dest = new NetAddress("127.0.0.1",6448);
  
  //Create the font
  f = createFont("Courier", 14);
  textFont(f);
  f2 = createFont("Courier", 40);
  textAlign(LEFT, TOP);
  
  createControls();
  sendNames();
}


 
void sendNames() {
  OscMessage msg = new OscMessage("/wekinator/control/setInputNames");
  msg.add("mouseX"); 
  msg.add("mouseY");
  oscP5.send(msg, dest);
}



void createControls() {
  cp5 = new ControlP5(this);
  cp5.addToggle("isRecording")
     .setPosition(10,20)
     .setSize(75,20)
     .setValue(true)
     .setCaptionLabel("record/run")
     .setMode(ControlP5.SWITCH)
     ;
}



void drawText() {
  fill(255);
  textFont(f);
  if (isRecording) {
    text("Run Wekinator with 2 inputs (mouse x,y), 1 DTW output", 100, 20);
    text("Click and drag to record gesture #" + currentClass + " (press number to change)", 100, 35);
  } else {
    text("Click and drag to test", 100, 20);    
  }
  text ("This program does NOT act as an output; run with your own output!", 100, 50);  
}


void draw() {
  background(0);
   smooth();
   drawText();
  
  if(inTheBox()){
    noStroke();
    fill(255, 0, 0);
    ellipse(xPos, yPos, 10, 10);
  }
  drawClassifierArea();
  if(inTheBox() && frameCount % 2 == 0) {
    sendOsc();
  }
}


//DETERMINES IF X,Y VALUES ARE WITHIN THE OUTPUT BOX
boolean inTheBox(){
  if(xPos < (areaTopX + areaWidth) && xPos > areaTopX){
    if(yPos < (areaTopY + areaHeight) && yPos > areaTopY){
      return true; // if X and Y pos of right wrist are within the classifier area return true
    } 
  }  
  return false; //else right wrist is out of bounds 
}  


void drawClassifierArea() {
  stroke(255);
  noFill();
  rect(areaTopX, areaTopY, areaWidth, areaHeight, 7);
}



//FOR TRAINING
void mousePressed() {
  if (! inTheBox()) {
    return;
  }
  if (isRecording) {
     isRecordingNow = true;
     OscMessage msg = new OscMessage("/wekinator/control/startDtwRecording");
     msg.add(currentClass);
     oscP5.send(msg, dest);
  } else {
    OscMessage msg = new OscMessage("/wekinator/control/startRunning");
    oscP5.send(msg, dest);
  }
}


void mouseReleased() {//when you release the mouse, it'll stop recording the gesture
  if (isRecordingNow) {
     isRecordingNow = false;
     OscMessage msg = new OscMessage("/wekinator/control/stopDtwRecording");
      oscP5.send(msg, dest);
  }
}



void keyPressed() {
  int keyIndex = -1;
  if (key >= '1' && key <= '9') {
    currentClass = key - '1' + 1;
  }
}



//SENDING OSC TO WEKINATOR 
void sendOsc() {
  OscMessage msg = new OscMessage("/wek/inputs");
  msg.add((float)xPos); 
  msg.add((float)yPos);
  oscP5.send(msg, dest);
}



//RECIEVING OSC MESSAGE FROM POSENET
void oscEvent(OscMessage msg){
  String addr = msg.addrPattern(); //get the address
  
  if(addr.contains(POSENET_ADDRESS)){ 
    
    for(int i=0; i<msg.arguments().length; i+=3)
    {
      if(msg.get(i).stringValue().equals("leftWrist"))//actually right wrist, camera is flipped
       {
         xPos = msg.get(i+1).floatValue(); //setting x position of wrist
         yPos = msg.get(i+2).floatValue(); //setting y position of wrist
         
         sendOsc();
         
       }
    }  
  }
}
