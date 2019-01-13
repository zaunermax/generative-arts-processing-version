class ParticleFlow extends Effect {

  float freq = 0.000005;
  int cont = 0;
  float size = WallHeight * 0.35;
  float v1 = 0.4f;
  
  float maxStrokeLength=1000;
  float strokeThickness=2;
  
  float circle;
  float rot;
  float col; 
  float r;
  float greenmix;
  float bluemix;
  float eRadius;
  
  float circle2;
  float rot2;
  float col2; 
  float r2;
  float greenmix2;
  float bluemix2;
  float eRadius2;

  color colParticleFlow = color(0, 153, 153);


  ParticleFlow() {
  } 

  void playEffect() {

    translate(WindowWidth / 2, WallHeight / 2);
    //rotate(radians(rot));
    
    float tmpSize = size;
    float tmpSize2 = size *0.4;
    
    beat.detect(input.mix);
    // Trigger der BeatDetection
    if (beat.isOnset()) {
      v1 = random(0.1f) + WallHeight*0.0009;
      tmpSize += WallHeight * 0.01;
      tmpSize2 -= WallHeight * 0.01;
    }

    for (int i=0; i<500; i ++) {
      circle= tmpSize + 50*sin(millis()*freq*i)*(v1*2);
      col=map(circle, 150, 250, 160, 150);
      r=map(circle, 150, 250, 10, 5);
      greenmix= map(circle, 150, 250, 220, 200);
      bluemix= map(circle, 150, 250, 255, 230);
      fill(51, 220, bluemix);
      noStroke();
      // stroke(153, 204, 255);
      ellipse(circle*cos(i), circle*sin(i), (r*2)*v1, (r*2)*v1); 
      //SpringTo(circle*cos(i)*(v1), circle*sin(i)*(v1), ((WallHeight/2)-(WallHeight/5))*random(0.7f),( WallHeight/2- WallHeight+(WallHeight/5))*random(0.7f)); //first x,y start then x,y end try to get variation and make it bound somewhere in the middle
      rot=rot+0.00005;
    }
    
     for (int j=0; j<200; j ++) {
      circle2= tmpSize2 + 50*sin(millis()*freq*j)*(v1*2);
      col2=map(circle2, 150, 250, 160, 150);
      r2=map(circle2, 50, 150, 10, 5);
      greenmix2= map(circle2, 150, 250, 220, 200);
      fill(51, 220, bluemix);
      noStroke();
      ellipse(circle2*cos(j), circle2*sin(j), (r2-WallHeight*0.0009), (r2-WallHeight*0.0009)); 
      rot=rot+0.00005;
    }
    sm.setColor(colParticleFlow);
    
  }

  void SpringTo(float x, float xOrigin, float y, float yOrigin) {
    float dx = x - xOrigin;
    float dy = y - yOrigin;
    float dist = sqrt(dx * dx + dy * dy);
    circle= 200 + 50*sin(millis()*freq)*(v1*2);
    greenmix= map(circle, 150, 250, 170, 120);

    if (dist < maxStrokeLength) {
    //stroke(70, greenmix, 150, 30);
    //strokeWeight(strokeThickness*(v1*5));
    //line(x, y, xOrigin, yOrigin);
    }
  }
}
