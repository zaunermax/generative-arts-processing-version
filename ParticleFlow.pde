class ParticleFlow extends Effect {

  float circle = 200;
  float rot;
  float col;
  float freq = 0.000005; 
  int cont = 0;
  float r;
  float greenmix;
  float bluemix;


  float v1 = 0.4f;
  float eRadius;


  float maxStrokeLength=1000;
  float strokeThickness=2;

  ParticleFlow() {
  } 

  void playEffect() {

    translate(WindowWidth / 2, WallHeight / 2);
    //rotate(radians(rot));

    beat.detect(input.mix);
    // Trigger der BeatDetection
    if (beat.isOnset()) {
      v1 = random(0.4f) + 0.2f;
    }

    for (int i=0; i<500; i ++) {
      circle= 200 + 50*sin(millis()*freq*i)*(v1*2);
      col=map(circle, 150, 250, 160, 150);
      r=map(circle, 150, 250, 10, 5);
      greenmix= map(circle, 150, 250, 220, 200);
      bluemix= map(circle, 150, 250, 255, 230);
      fill(153, 204, bluemix);
      noStroke();
      // stroke(153, 204, 255);
      ellipse(circle*cos(i), circle*sin(i), (r*2)*v1, (r*2)*v1); 
      SpringTo(circle*cos(i)*(v1), circle*sin(i)*(v1), ((WallHeight/2)-(WallHeight/5))*random(0.7f),( WallHeight/2- WallHeight+(WallHeight/5))*random(0.7f)); //first x,y start then x,y end try to get variation and make it bound somewhere in the middle
      rot=rot+0.00005;
    }
  }

  void SpringTo(float x, float xOrigin, float y, float yOrigin) {
    float dx = x - xOrigin;
    float dy = y - yOrigin;
    float dist = sqrt(dx * dx + dy * dy);
    circle= 200 + 50*sin(millis()*freq)*(v1*2);
    greenmix= map(circle, 150, 250, 170, 120);

    if (dist < maxStrokeLength) {
      stroke(70, greenmix, 150, 30);
      strokeWeight(strokeThickness*(v1*5));
      line(x, y, xOrigin, yOrigin);
    }
  }
}
