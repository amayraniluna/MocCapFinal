/*
 *  Amayrani Luna
 *  Class: MelodyBoxPlayer
 *  Description: recieves OSC from Wekinator. When circular motion flag is recieved from Wekinator, it plays the midi file and displays the notes on the screen.  
 */
 
//OSC imports
import netP5.*;
import oscP5.*;
import themidibus.*;
import processing.core.*;
import java.util.*;

//imports for sound 
import jm.music.data.*;
import jm.JMC;
import jm.util.*;
import jm.midi.*;


OscP5 oscP5; //the object that will send OSC
final String WEK_OSC = "/wek/outputs"; //the OSC address we are receiving

boolean circularMotion;
MelodyPlayer player; //plays a midi sequence
MidiFileToNotes midiNotes; //reads a midi file


ArrayList<Peg> myPegs; //holds Peg objects

//generates colors for the Pegs
Random rand;
int randR;
int randG;
int randB;

String filePath;
int currentNote;
float y;
int pastNote = 0;




//SETUP
void setup()
{
  size(800, 700); 
  background(0);  
  
  //initializing class variables
  filePath = "/Users/amayraniluna/Downloads/MoCapFinalProject/MusicBoxPlayer/midiFiles/Upmaintheme.mid"; //change this file path to play your midi file
  circularMotion = false;
  currentNote = 0;
  y = height/2;
  myPegs = new ArrayList<Peg>();
  rand = new Random();
  
  midiNotes = new MidiFileToNotes(filePath);
  midiNotes.setWhichLine(0);

  player = new MelodyPlayer(this, 100.0f);

  player.setup();
  player.setMelody(midiNotes.getPitchArray());
  player.setRhythm(midiNotes.getRhythmArray());
  
  //initialize OSC
  oscP5 = new OscP5(this,12000); //listen for OSC messages on port 12000 (Wekinator default)
}



//RECIEVES NUMERICAL PITCH VALUE AND RETURNS CORRESPONDING LETTER VALUE 
String getNote(int pitchNum)
{
   if(pitchNum == 36 || pitchNum == 48 || pitchNum == 60 || pitchNum == 72 || pitchNum == 84 || pitchNum == 96)
     return "C";
     
   else if(pitchNum == 37 || pitchNum == 49 || pitchNum == 61|| pitchNum == 73 || pitchNum == 85 )
     return "C#";
     
   else if(pitchNum == 38 ||pitchNum == 50 || pitchNum == 62 || pitchNum == 74 || pitchNum == 86)
     return "D";
     
   else if(pitchNum == 39 || pitchNum == 51 || pitchNum == 63 || pitchNum == 75 || pitchNum == 87)
     return "D#";
     
   else if(pitchNum == 40 || pitchNum == 52 || pitchNum == 64 || pitchNum == 76 || pitchNum == 88) 
     return "E";
     
   else if(pitchNum == 41 ||pitchNum == 53 || pitchNum == 65 || pitchNum == 77 || pitchNum == 89)  
     return "F";
     
   else if(pitchNum == 42 || pitchNum == 54 || pitchNum == 66 || pitchNum == 78 || pitchNum == 90)
     return "F#";
     
   else if(pitchNum == 43 ||pitchNum == 55 || pitchNum == 67 || pitchNum == 79 || pitchNum == 91)
     return "G";
     
   else if(pitchNum == 44 || pitchNum == 56 || pitchNum == 68 || pitchNum == 80 || pitchNum == 92)  
     return "G#";
     
   else if(pitchNum == 45 || pitchNum == 57 || pitchNum == 69 || pitchNum == 81 || pitchNum == 93)  
     return "A";
     
   else if(pitchNum == 46 || pitchNum == 58 || pitchNum == 70 || pitchNum == 82 || pitchNum == 94)
      return "A#";
      
   else if(pitchNum == 47 || pitchNum == 59 || pitchNum == 71 || pitchNum == 83 || pitchNum == 95)  
     return "B";
     
   else return "no note";
}




//RECIEVES NOTE AND RETURNS X VALUE OF WHERE TO DISPLAY PEG ON THE SCREEN 
float getX(int midiNotePitch)
{
  String note = getNote(midiNotePitch);
  if(note == "C" ) return 100.0;
  
  else if(note == "C#") return 150.0;
  
  else if(note == "D") return 200.0;
  
  else if(note == "D#") return 250.0;
  
  else if(note == "E") return 300.0;
  
  else if(note == "F") return 350.0;
  
  else if(note == "F#") return 400.0;
  
  else if(note == "G") return 450.0;
  
  else if(note == "G#") return 500.0;
  
  else if(note == "A") return 550.0;
  
  else if(note == "A#") return 600.0;
  
  else if(note == "B") return 650.0;
  
  else return 700.0;
}  




void draw()
{
  background(0);
  
  //when circular motion is detected, play music box
  if(circularMotion == true) 
  {
    unPause(); //move pegs again 
    player.play(); //plays the notes on the console
    currentNote = player.getCurrentNote();
    if(currentNote != pastNote)
    {
      randR = rand.nextInt(10);
      randG = rand.nextInt(255);
      randB = rand.nextInt(255);
      myPegs.add(new Peg((int)(getX(currentNote)), randR, randG, randB));
    }
    for(Peg p: myPegs){
      p.display();
    }
    pastNote = currentNote;
  }
  
  //else stop pegs from moving
  else pause(); 
      
  //display the objects in the Pegs array (whether paused or unpaused)
  for(Peg p: myPegs){
     p.display();
  }
}



//STOPS PEGS FROM MOVING
void pause(){
  for(int i = 0 ; i < myPegs.size() ; i++){
    myPegs.get(i).stopPeg();
  }
}



//MOVES THE PEGS AGAIN
void unPause(){
  for(int i = 0 ; i < myPegs.size() ; i++){
    myPegs.get(i).unStopPeg();
  }
}



//RECIEVE OSC MESSAGE
void oscEvent(OscMessage msg){
    if(msg.checkAddrPattern("/output_1")==true)//detects circular motion
    { 
       //println("circular motion detected");
       circularMotion = true;
    }
      else if(msg.checkAddrPattern("/output_2")==true)//detects hand staying still 
      {
          //println("no motion");
          circularMotion = false;
      } 
        else ; //unrecognized motion detected
}  



//PLAYS THE MIDI FILE
void playMidiFile(String filename){
    Score theScore = new Score("Temporary score");
    Read.midi(theScore, filename);
    Play.midi(theScore);
  }
  
  
 
//RESTARTS THE MELODY
  public void keyPressed(){
    if (key == ' ') {
      player.reset();
      println("Melody started!");
    }
  }
