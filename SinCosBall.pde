
class SinCosBall extends Effect {

  float t;
  float angle = 0;
  int lines = 380;
  float v1 = 0.4f;
  float v2;
  boolean increment = false;
  float factor = 0.00001f;
  float eRadius;
  color colSinCosBall = color(0, 113, 175);
  float strokeWeight = WallHeight * 0.013;
  float lineWeight = WallHeight * 0.005f;

  void playEffect() {
    angle += 0.01;
    translate(WindowWidth / 2, WallHeight / 2);
    rotate(sin(angle));
    // Push new audio samples to the FFT
    beat.detect(input.mix);
    // Trigger der BeatDetection
    if (beat.isOnset()) {
      v1 = random(0.4f) + 0.2f;
      eRadius = 1.5f;
    }
    if (eRadius < 0.1) eRadius = 0.1f;

    for (int i = 1; i < lines; i++) {
      strokeWeight(strokeWeight); 
      stroke(7, 61, 91);
      point(x(t + i), y(t + i));
      stroke(0, 99, 153);
      point(x2(t + i), y2(t + i));
      strokeWeight(lineWeight);
      stroke(32, 142, 201, 90);
      line(x(t + i) * eRadius, y(t + i) * eRadius, x2(t + i) * eRadius, y2(t + i) * eRadius);
    }

    t += 0.08 * (input.right.level() + input.left.level()) / 2;
    if (increment) v1 += factor;

    eRadius *= 0.95;
    
    sm.setColor(colSinCosBall);

  }

  float x(float t) {
    return sin(t / 10) * 100 + cos(t / v1) * WallHeight*0.2;
  }

  float y(float t) {
    return cos(t / 10) * 100 + sin(t / v1) * WallHeight*0.2;
  }

  float x2(float t) {
    return sin(t / 10) * 10 + cos(t / v1) * WallHeight*0.2;
  }

  float y2(float t) {
    return cos(t / 10) * 10 + sin(t / v1) * WallHeight*0.2;
  }
}
