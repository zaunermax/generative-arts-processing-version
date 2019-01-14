class PlexusBall extends Effect {

  PlexusBall() {
    setupPlexusBall();
  }

  //creates an array for the points
  Particle[] p = new Particle[100];
  //radius of the grey circle in the middle
  float rad;
  float radReset;

  int ampLineLength;  // Length of the line that builds the outer circle
  int ampLineRadius;  // Radius of the outer circle
  int ampPoints;  // Amplitude of the points on the outer circle
  float plexusRadius; //outer radius of the plexuseffect
  int plexusJitter; //max possible distance from plexusRadius

  float plexusRangeReset = 1; //size of plexus effect is depending to it
  float plexusRange = plexusRangeReset; //size of plexus effect is depending to it

  float amplitudeThreshold = 0.45f; //threshold for the beat effect

  float plexusSize; // size of the circles and lines of the plexuseffect
  float c= random(0, 255);
  color colPlexusBall = color(134, 87, 175);

  void setupPlexusBall() {
    // if portrait or landscape mode
    int size;
    size = WallHeight;

    // depending on the screen size
    radReset = size * 0.07f;
    rad = radReset;

    ampLineLength = int(size * 0.1);
    ampLineRadius = int(size * 0.35);
    ampPoints = ampLineLength;
    
    plexusRadius = ampLineRadius;
    plexusJitter = int(size * 0.04);
    plexusSize = size * 0.006f;

    //construct particles
    for (int i = 0; i < p.length; i++) {
      p[i] = new Particle(0, 0, plexusSize);
    }
  }

  void playEffect() {
    //gets amplitude value 1-0
    float amplitude = input.mix.level();

    //circle in middle moves to audio
    if (amplitude > amplitudeThreshold) rad = rad * 0.9f; //circle shriks at beat
    else rad = radReset;
    //creates circle
    noStroke();
    fill(134, 87, 175, 60);
    ellipse(WindowWidth / 2, WallHeight / 2, 2 * rad, 2 * rad);

    int bsize = input.bufferSize();

    //creates lines on the outer circle - react with audio
    strokeWeight(5); //thickness
    for (int i = 0; i < bsize - 1; i += 5) {
      float x = (ampLineRadius) * cos(i * 2 * PI / bsize);
      float y = (ampLineRadius) * sin(i * 2 * PI / bsize);
      float x2 = (ampLineRadius + input.left.get(i) * ampLineLength) * cos(i * 2 * PI / bsize);
      float y2 = (ampLineRadius + input.left.get(i) * ampLineLength) * sin(i * 2 * PI / bsize);
      stroke(92, 59, 122, 90);
      line(x + WindowWidth / 2, y + WallHeight / 2, x2 + WindowWidth / 2, y2 + WallHeight / 2);
    }

    //creates points on the lines on the outer circle
    beginShape();
    noFill();
    stroke(-1, 50);
    for (int i = 0; i < bsize; i += 30) {
      float x2 = (ampLineRadius + input.left.get(i) * ampPoints) * cos(i * 2 * PI / bsize);
      float y2 = (ampLineRadius + input.left.get(i) * ampPoints) * sin(i * 2 * PI / bsize);
      vertex(x2, y2);
      pushStyle();
      stroke(-1);
      strokeWeight(4);  // Point thickness
      stroke(134, 87, 175);
      point(x2 + WindowWidth / 2, y2 + WallHeight / 2);
      popStyle();
    }
  
    //creates plexus - iterates through all particles
    for (int i = 0; i < p.length; i++) {
      if (amplitude > amplitudeThreshold) //plexus effect gets more range in the circle
      {
        plexusRange = plexusRange * 0.9f;
      } else {
        if (plexusRange < plexusRangeReset) {
          plexusRange += 0.0007;  // Reset speed, smaller -> slower
        }
      }
      //move all particles
      p[i].x = WindowWidth / 2 + cos(i * 2 * PI / p.length) * plexusRadius * random(plexusRange, 1) + random(-plexusJitter, plexusJitter);
      p[i].y = WallHeight / 2 + sin(i * 2 * PI / p.length) * plexusRadius * random(plexusRange, 1) + random(-plexusJitter, plexusJitter);

      //creates the stroks between the points
      for (int j = i + 1; j < p.length; j++) {
        springTo(p[i], p[j]);
      }
      p[i].display();
    }
    
    sm.setColor(colPlexusBall);
  }

  //stroks from the plexus effect
  void springTo(Particle p1, Particle p2) {
    float dx = p2.x - p1.x;
    float dy = p2.y - p1.y;
    float dist = sqrt(dx * dx + dy * dy);

    strokeWeight(plexusSize * 0.5f);
    stroke(134, 87, 175, 60);

    if (dist < 100) {
      line(p1.x, p1.y, p2.x, p2.y);
    }
  }

  class Particle {
    float x;
    float y;
    float r;

    Particle(float _x, float _y, float _r) {
      x = _x;
      y = _y;
      r = _r;
    }

    void display() {
      fill(200);
      noStroke();
      ellipse(x, y, r, r);
    }
  }
}
