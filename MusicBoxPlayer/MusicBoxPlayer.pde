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
//NetAddress dest;

final String WEK_OSC = "/wek/outputs"; //the OSC address we are receiving

boolean circularMotion;
MelodyPlayer player; //plays a midi sequence
MidiFileToNotes midiNotes; //reads a midi file


ArrayList<Peg> myPegs;
boolean firstTimeOn;
String filePath;
int currentNote;
float y;
int pastNote = 0;
int randR;
int randG;
int randB;
Random rand;
boolean background = true;

//SETUP
void setup()
{
  size(640, 480); 
  background(0);  
 
  firstTimeOn = true;
  filePath = "/Users/amayraniluna/Downloads/MoCapFinalProject/MusicBoxPlayer/midiFiles/HarryPotter.mid";
  circularMotion = false;
  currentNote = 0;
  y = height/2;
  myPegs = new ArrayList<Peg>();
  rand = new Random();
  
  //println("height: " + height);
  midiNotes = new MidiFileToNotes(filePath);
  
  midiNotes.setWhichLine(0);

  player = new MelodyPlayer(this, 100.0f);

  player.setup();
  player.setMelody(midiNotes.getPitchArray());
  player.setRhythm(midiNotes.getRhythmArray());
  
  //initialize OSC
  oscP5 = new OscP5(this,12000); //listen for OSC messages on port 12000 (Wekinator default)
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
  
  else return 620.0;
}  




void draw(){
  
    background(0);
    
  if(circularMotion == true){
    
    player.play(); //plays the notes on the console
    currentNote = player.getCurrentNote();
    if(currentNote != pastNote){
      randR = rand.nextInt(20);
      randG = rand.nextInt(200);
      randB = rand.nextInt(220);
      myPegs.add(new Peg((int)(getX(currentNote)), randR, randG, randB));
    }
    for(Peg p: myPegs){
      p.display();
    }
    
    pastNote = currentNote;
  }
    else{
      //background(4,0,255);//blue
    }   
}

void drawNote(){
  
    
   //y -= 0.8;
   //currentNote = player.getCurrentNote();
       //translate(0, y);
   //Random rand = new Random(); 
   //fill(rand.nextInt(20), rand.nextInt(200), rand.nextInt(255));
   //ellipse(getX(currentNote), height/2, 45, 45);
}  


void pause(){
  for(int i = 0 ; i < myPegs.size() ; i++){
    myPegs.get(i).stopPeg();
  }
}

void unPause(){
  for(int i = 0 ; i < myPegs.size() ; i++){
    myPegs.get(i).unStopPeg();
  }
}


//RECIEVE OSC MESSAGE
void oscEvent(OscMessage msg){
  //String addr = msg.addrPattern(); //get the address
  //println("addr: " + addr);
  
    if(msg.checkAddrPattern("/output_1")==true)//circular motion
    { 
       println("circular motion detected");
       circularMotion = true;
    }
      else if(msg.checkAddrPattern("/output_2")==true)
      {
          //println("no motion");
          circularMotion = false;
      } 
        else ;//println("unrecognized motion");
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
