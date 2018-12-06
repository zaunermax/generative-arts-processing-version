import processing.core.*; //<>//
import java.util.HashMap;
import ddf.minim.*;
import ddf.minim.analysis.*;
import controlP5.*;

// Version 3.1
// Example implemenation which shows the usage of the new PharusClient

private int shrink = 4;
private int WindowWidth = 3030 / shrink; // for real Deep Space this should be 3030
private int WindowHeight = 3712 / shrink; // for real Deep Space this should be 3712
private int WallHeight = 1914 / shrink; // for real Deep Space this should be 1914 (Floor is 1798)

private boolean ShowTrack = true;

StateManager sm;

public void settings() {
  size(WindowWidth, WindowHeight);
  smooth(2);
  //fullScreen(P2D, SPAN);
}

Minim minim;
AudioPlayer input;
ControlP5 cp5;
BeatDetect beat;

boolean bool = false;

public void setup() {
  
  sm = new StateManager();
  
  sm.addEffect(new PlexusBall());
  sm.addEffect(new SinCosBall());
  sm.addEffect(new PlexusBall());
  sm.addEffect(new SinCosBall());

  frameRate(60);

  noStroke();
  fill(0);

  PFont font = createFont("Arial", 18);
  textFont(font, 18);
  textAlign(CENTER, CENTER);

  initPlayerTracking();

  minim = new Minim(this);
  cp5 = new ControlP5(this);
  beat = new BeatDetect();
  input = minim.loadFile("skrillex.mp3");

  //fftLog = new FFT( input.bufferSize(), input.sampleRate());
  //fftLog.logAverages( 22, 3);;

  noFill();
  //ellipseMode(RADIUS);

  input.play();
}

public void draw() {
  // clear background with white
  background(255);

  // set upper half of window (=wall projection) bluish
  noStroke();
  fill(32);
  rect(0, 0, WindowWidth, WallHeight);
  fill(150);
  text((int) frameRate + " FPS", width / 2, 10);

  stroke(0, 0, 0);
  strokeWeight(2);
  line(WindowWidth / 2, WallHeight, WindowWidth / 2, WindowHeight);

  stroke(0, 0, 0);
  strokeWeight(2);
  line(0, WallHeight + (WindowHeight - WallHeight) / 2, WindowWidth, WallHeight + (WindowHeight - WallHeight) / 2);

  sm.drawFloor();
  sm.drawCurrentEffect();
}

public void keyPressed() {
}

PharusClient pc;

private void initPlayerTracking() {
  pc = new PharusClient(this, WallHeight);  
  // age is measured in update cycles, with 25 fps this is 2 seconds
  pc.setMaxAge(50);
  // max distance allowed when jumping between last known position and potential landing position, unit is in pixels relative to window width
  pc.setjumpDistanceMaxTolerance(0.05f);
}

public void pharusPlayerAdded(Player player) {
  println("Player " + player.id + " added");
  // TODO do something here if needed
}

public void pharusPlayerRemoved(Player player) {
  println("Player " + player.id + " removed");
  // TODO do something here if needed
}
