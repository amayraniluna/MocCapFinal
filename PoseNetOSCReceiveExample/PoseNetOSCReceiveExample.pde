//Programmer: Courtney Brown
//Desc: Receives OSC from the posenet standalone
//Date: Nov. 2020

//Go to the top menu Sketch->Import Library
//then search for oscP5 and import that
import netP5.*;
import oscP5.*;
import themidibus.*;
import processing.core.*;
import java.util.*;

import jm.music.data.*;
import jm.JMC;
import jm.util.*;
import jm.midi.*;

OscP5 oscP5; //the object that will send OSC
NetAddress remoteLocation; //where we are receiving OSC from

//the OSC addresses we are receiving
final String POSENET_ADDRESS = "/pose"; 
//The port we are listening to... MUST match DESTPORT in the C++ example 
final int LISTENING_PORT = 9876;

MelodyPlayer player; //plays a midi sequence
MidiFileToNotes midiNotes; //reads a midi file

Boolean circularMotion;
float y = height;
float dim = 80.0;
Integer[] localPitches;
int localPitchesSize;
int currentNote = 0;
boolean playing;

//SETUP
void setup()
{
  size(640, 480); 
  //background(255);  
  
  String filePath = "/Users/amayraniluna/Downloads/MoCapFinalProject/PoseNetOSCReceiveExample/midiFiles/UpThemeSong.mid";
  
  /**MOVE THIS TO DRAW FUNCTION AND ONLY PLAY WHEN OUTPUT_1 IS RECIEVED FROM WEKINATOR**/
  playMidiFile(filePath);
  midiNotes = new MidiFileToNotes(filePath);
  
  midiNotes.setWhichLine(0);

  player = new MelodyPlayer(this, 100.0f);

  player.setup();
  player.setMelody(midiNotes.getPitchArray());
  player.setRhythm(midiNotes.getRhythmArray());

//**CHANGE LISTENING_PORT TO 12000**/
  //initialize OSC 
  oscP5 = new OscP5(this, LISTENING_PORT); //listening for incoming!! 
  
  //localPitches = midiNotes.getPitches();
  //localPitchesSize = midiNotes.getPitchesSize();
}





//RECIEVES OSC MESSAGE 
void oscEvent(OscMessage msg)
{
  println("in osc reciever");
  String addr = msg.addrPattern(); //get the address
  //println(msg.toString()); 
  
  /* 
    /pose/0 -- 1st skeleton found
    /pose/1 -- 2nd skeleton found
    /pose/2 -- 3rd skeleton found
    etc.
  */
  
  if(addr.contains(POSENET_ADDRESS)){ 
    print("address: ");
    print(addr); 
    
    for(int i=0; i<msg.arguments().length; i+=3)
    {
       print(" "+msg.get(i).stringValue() + " ");  
       print(" "+msg.get(i+1).floatValue() + " ");  
       print(" "+msg.get(i+2).floatValue() + " ");  
    }
    println(); 
  }
  
   //^^pass these values to wekinator to get bool circularMotion
}





String getNote(int pitchNum){
   if(pitchNum == 48 || pitchNum == 60 || pitchNum == 72 || pitchNum == 84 || pitchNum == 96)
     return "C";
     
   else if(pitchNum == 49 || pitchNum == 61|| pitchNum == 73 || pitchNum == 85 )
     return "C#";
     
   else if(pitchNum == 50 || pitchNum == 62 || pitchNum == 74 || pitchNum == 86)
     return "D";
     
   else if(pitchNum == 51 || pitchNum == 63 || pitchNum == 75 || pitchNum == 87)
     return "D#";
     
   else if(pitchNum == 52 || pitchNum == 64 || pitchNum == 76 || pitchNum == 88) 
     return "E";
     
   else if(pitchNum == 53 || pitchNum == 65 || pitchNum == 77 || pitchNum == 89)  
     return "F";
     
   else if(pitchNum == 54 || pitchNum == 66 || pitchNum == 78 || pitchNum == 90)
     return "F#";
     
   else if(pitchNum == 55 || pitchNum == 67 || pitchNum == 79 || pitchNum == 91)
     return "G";
     
   else if(pitchNum == 56 || pitchNum == 68 || pitchNum == 80 || pitchNum == 92)  
     return "G#";
     
   else if(pitchNum == 57 || pitchNum == 69 || pitchNum == 81 || pitchNum == 93)  
     return "A";
     
   else if(pitchNum == 58 || pitchNum == 70 || pitchNum == 82 || pitchNum == 94)
      return "A#";
      
   else if(pitchNum == 59 || pitchNum == 71 || pitchNum == 83 || pitchNum == 95)  
     return "B";
     
   else return "no note";
}




//WHERE TO DISPLAY CIRCLE DEPENDING ON VALUE
float getX(int midiNotePitch){
  String note = getNote(midiNotePitch);
  //println("note: " + note);
  if(note == "C" ) return 48.0;
  
  else if(note == "C#") return 96.0;
  
  else if(note == "D") return 144.0;
  
  else if(note == "D#") return 192.0;
  
  else if(note == "E") return 240.0;
  
  else if(note == "F") return 288.0;
  
  else if(note == "F#") return 336.0;
  
  else if(note == "G") return 384.0;
  
  else if(note == "G#") return 432.0;
  
  else if(note == "A") return 480.0;
  
  else if(note == "A#") return 528.0;
  
  else if(note == "B") return 576.0;
  
  else return 624.0;
}  





void drawNote(){
   currentNote = player.getCurrentNote();
   y -= 0.8;
   translate(0, y);
   fill(200);
   ellipse(getX(currentNote), height, 45, 45);
}  



//DRAWS TO SCREEN
void draw()
{ 
  
 // background(0);
  player.play();
  
   drawNote();
  
}  



//CONSTANTLY UPDATING 
void update(){
  //player.play();
  //draw();
  //if circular motion is tracked
     //playMusicBox();
     playing = player.getNoteOn();
}  




void playMidiFile(String filename){
    Score theScore = new Score("Temporary score");
    Read.midi(theScore, filename);
    Play.midi(theScore);
  }


  //this starts & restarts the melody.
  public void keyPressed() {
    if (key == ' ') {
      player.reset();
      println("Melody started!");
    }
  }








/*background(0);
    dim = 80.0
    y = y - 0.8;
  
    if(y < (1.5 - dim))
      y = height;
     
    translate(width/2-dim/2, y);
    fill(255);
    ellipse(dim/2, -dim/2, 50, 50);
    ellipse(-dim *3, dim/2, 50, 50);
    ellipse(-dim, -3*dim/2, 50, 50);
    ellipse(width/3, dim*2, 50, 50);
*/
