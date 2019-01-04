class SphericalWave extends Effect{

int fps = 30;
color bg = #ECF0F1;
color fg = #34495E;
int count = 19;
float r = 150;
float d = 8.25;
int max = 330;

 SphericalWave(){
   setupSphericalWave();
 }

void setupSphericalWave() {
  smooth();
  noStroke();
}

void playEffect() {
  fill(bg, 70);
  rect(0, 0, width, height);
  fill(fg, 200);
  
  pushMatrix();
  translate(width/2, height/2);
  for (int n = 1; n < count; n++) {
    for (float a = 0; a <= 360; a += 1) {
      float progress = constrain(map(frameCount%max, 0+n*d, max+(n-count)*d, 0, 1), 0, 1);
      float ease = -0.5*(cos(progress * PI) - 1);
      float phase = 0 + 2*PI*ease + PI + radians(map(frameCount%max, 0, max, 0, 360));
      float x = map(a, 0, 360, -r, r);
      float y = r * sqrt(1 - pow(x/r, 2)) * sin(radians(a) + phase);
      ellipse(x, y, 1, 1);
    }
  }
  popMatrix();
}
}
