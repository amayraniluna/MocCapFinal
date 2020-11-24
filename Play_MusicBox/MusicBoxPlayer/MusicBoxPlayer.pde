import netP5.*;
import oscP5.*;
import themidibus.*;
import processing.core.*;
import java.util.*;

OscP5 oscP5; //the object that will send OSC
//NetAddress dest;

//the OSC addresses we are receiving
//MUST match what we are sending
final String WEK_OSC = "/wek/outputs"; //the OSC message 

boolean circularMotion;

//SETUP
void setup()
{
  size(640, 480); 
  background(255);  
 
 circularMotion = false;
  //initialize OSC
  oscP5 = new OscP5(this,12000); //listen for OSC messages on port 12000 (Wekinator default)
}


void draw(){
  
  background(255,255,81);//yellow
  
  if(circularMotion == true){
    background(4,0,255);//blue
  }

  
  
}
//RECIEVE OSC MESSAGE
void oscEvent(OscMessage msg){
  String addr = msg.addrPattern(); //get the address
  println("addr: " + addr);
  //if(addr.contains(WEK_OSC))
  //{ 
    if(msg.checkAddrPattern("/output_1")==true)//circular motion
    { 
       println("circular motion detected");
       circularMotion = true;
    }
      else if(msg.checkAddrPattern("/output_2")==true)
      {
          println("no motion");
          circularMotion = false;
      } 
        else println("unrecognized motion");
      
  //} 
  
}  
