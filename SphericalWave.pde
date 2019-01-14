class SphericalWave extends Effect {

  int fps = 30;
  color bg = #ECF0F1;
  color fg = #34495E;
  int count = 19;
  float r = WallHeight * 0.4;
  float d = 8.25;
  int max = 330;

  float freq = 0.000005; 
  float v1 = 0.4f;

  float size = WallHeight * 0.004;
  color colSphericalWave= color(206, 107, 163);


  SphericalWave() {
    setupSphericalWave();
  }

  void setupSphericalWave() {
    smooth();
    noStroke();
  }

  void playEffect() {

    float tmpSize = size;
    beat.detect(input.mix);

    if (beat.isOnset()) {
      v1 = random(0.4f) + 0.8f;
      tmpSize -= WallHeight * 0.005;
    }

    translate(WindowWidth /2, WallHeight/2 );
    fill(206, 107, 163, 90);

    pushMatrix();

    for (int n = 1; n < count; n++) {
      for (float a = 0; a <= 360; a += 1) {
        float progress = constrain(map(frameCount%max, 0+n*d, max+(n-count)*d, 0, 1)*v1, 0, 1);
        float ease = -0.5*(cos(progress*v1*tmpSize * PI) - 1*v1);
        float phase = 0 + 2*PI*ease + PI + radians(map(frameCount%max, 0, max, 0, 360));
        float x = map(a, 0, 360, -r, r);
        float y = r * sqrt(1 - pow(x/r, 2)) * (sin(radians(a) + phase)*v1);
        ellipse(x*v1, y, 1*size, 1*size);
      }
    }

    sm.setColor(colSphericalWave);

    popMatrix();
  }
}
