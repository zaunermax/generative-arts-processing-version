float t;
float angle = 0;
int NUM_LINES = 380;
float v1 = 0.4f;
float v2;
boolean increment = false;
float factor = 0.00001f;
float eRadius;

void drawSinCosBall() {

  //pushMatrix();

  angle += 0.01;
  stroke(255, 200);

  translate(WindowWidth / 2, WallHeight / 2);
  rotate(sin(angle));

  // Push new audio samples to the FFT
  beat.detect(input.mix);

  // Trigger der BeatDetection
  if (beat.isOnset()) {
    v1 = random(0.4f) + 0.2f;
    eRadius = 1.5f;
    //print(1);
  }
  if (eRadius < 0.1) eRadius = 0.1f;

  for (int i = 1; i < NUM_LINES; i++) {
    strokeWeight(4);
    point(x(t + i), y(t + i));
    point(x2(t + i), y2(t + i));
    strokeWeight(1.2f);
    //stroke(204,0,0);
    line(x(t + i) * eRadius, y(t + i) * eRadius, x2(t + i) * eRadius, y2(t + i) * eRadius);
  }
  // pushStyle();
  t += 0.08 * (input.right.level() + input.left.level()) / 2;
  // popStyle();
  if (increment) v1 += factor;
  //  popMatrix();

  eRadius *= 0.95;
}

float x(float t) {
  return sin(t / 10) * 100 + cos(t / v1) * 100;
}

float y(float t) {
  return cos(t / 10) * 100 + sin(t / v1) * 100;
}

float x2(float t) {
  return sin(t / 10) * 10 + cos(t / v1) * 100;
}

float y2(float t) {
  return cos(t / 10) * 10 + sin(t / v1) * 100;
}
