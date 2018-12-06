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
private boolean ShowPath = false;
private boolean ShowFeet = false;

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

int EFFECT1;
int EFFECT2;
int EFFECT3;
int EFFECT4;

boolean bool = false;

public void setup() {
  
  sm = new StateManager();
  
  EFFECT1 = sm.addEffect(new PlexusBall(sm));
  EFFECT2 = sm.addEffect(new SinCosBall(sm));
  EFFECT2 = sm.addEffect(new PlexusBall(sm));
  EFFECT2 = sm.addEffect(new SinCosBall(sm));

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

  drawPlayerTracking();

  if (bool) {
    drawSinCosBall();
  } else {
    drawPlexusBall();
  }
}

public void keyPressed() {
  switch (key) {
  case 'p':
    ShowPath = !ShowPath;
    break;
  case 't':
    ShowTrack = !ShowTrack;
    break;
  case 'f':
    ShowFeet = !ShowFeet;
    break;
  }
}

PharusClient pc;

private void initPlayerTracking() {
  pc = new PharusClient(this, WallHeight);  
  // age is measured in update cycles, with 25 fps this is 2 seconds
  pc.setMaxAge(50);
  // max distance allowed when jumping between last known position and potential landing position, unit is in pixels relative to window width
  pc.setjumpDistanceMaxTolerance(0.05f);
}

private void drawPlayerTracking() {
  // reference for hashmap: file:///C:/Program%20Files/processing-3.0/modes/java/reference/HashMap.html

  float allX = 0;
  float allY = 0;

  for (HashMap.Entry<Long, Player> playersEntry : pc.players.entrySet()) {
    Player p = playersEntry.getValue();

    allX += p.x;
    allY += p.y;

    // render tracks = player
    float cursor_size = 25;
    if (ShowTrack) {
      // show each track with the corresponding  id number
      noStroke();
      if (p.isJumping()) {
        fill(192, 0, 0);
      } else {
        fill(192, 192, 192);
      }
      ellipse(p.x, p.y, cursor_size, cursor_size);
      //ellipse(p.x, p.y - WallHeight, cursor_size, cursor_size);
      fill(0);
      //text(p.id /*+ "/" + p.tuioId*/, p.x, p.y);
    }
  }

  float meanX = allX / pc.players.size();
  float meanY = allY / pc.players.size();

  fill(255, 0, 0);
  ellipse(meanX, meanY, 10, 10);

  noFill();

  if (meanY < WallHeight + (WindowHeight - WallHeight) / 2) {
    if (meanX < WindowWidth / 2) {
      //System.out.println("Links oben");
      stroke(0, 0, 255);
      rect(0, WallHeight, WindowWidth / 2, (WindowHeight - WallHeight) / 2);
      bool = false;
    } else {
      //System.out.println("Rechts oben");
      stroke(0, 0, 255);
      rect(WindowWidth / 2, WallHeight, WindowWidth, (WindowHeight - WallHeight) / 2);
      bool = true;
    }
  } else {
    if (meanX < WindowWidth / 2) {
      //System.out.println("Links unten");
      stroke(0, 0, 255);
      rect(0, WallHeight + (WindowHeight - WallHeight) / 2, WindowWidth / 2, WindowHeight);
      bool = true;
    } else {
      //System.out.println("Rechts unten");
      stroke(0, 0, 255);
      rect(WindowWidth / 2, WallHeight + (WindowHeight - WallHeight) / 2, WindowWidth, WindowHeight);
      bool = false;
    }
  }
}

public void pharusPlayerAdded(Player player) {
  println("Player " + player.id + " added");
  // TODO do something here if needed
}

public void pharusPlayerRemoved(Player player) {
  println("Player " + player.id + " removed");
  // TODO do something here if needed
}
