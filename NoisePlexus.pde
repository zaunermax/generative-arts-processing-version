class NoisePlexus extends PlayerEffect {
  private class Particle {
    float mX;
    float mY;
    float mR;
    float mXoff;
    float mYoff;
    float mNoiseScale;
    float mRange;
    boolean mEvenOdd;

    Particle(float r, float range) {
      mRange = range;
      mR = r;
      mXoff = random(0, 100);
      mYoff = random(0, 100);
      mNoiseScale = random(0.005, 0.01);
      mEvenOdd = random(0, 1) > 0.5;
    }

    void Move(float x, float y) {
      mXoff += mNoiseScale;
      mYoff += mNoiseScale;
      float noiseY = noise(mYoff);
      float noiseX = noise(mXoff);   
      //Position from user in Heigth and width
      if (mEvenOdd) {
        mY = cos(noiseX*2*PI) * mRange * noiseY + y;
        mX = sin(noiseX*2*PI) * mRange * noiseY + x;
      } else {
        mX = cos(noiseX*2*PI) * mRange * noiseY + x;
        mY = sin(noiseX*2*PI) * mRange * noiseY + y;
      }
    }

    void Draw() {
      fill(-1);
      noStroke();
      ellipse(mX, mY, mR, mR);
    }
  }

  float noiseScale = 0.01;
  float radius = WallHeight * 0.065;
  float particleSize = WallHeight * 0.01;
  int numOfParticles = 8;
  float strokeThickness = WallHeight * 0.003;
  float maxStrokeLength = radius * 2;

  Particle particles[] = new Particle[numOfParticles];

  NoisePlexus() {
    println("radius", radius);
    println("particleSize", particleSize);
    println("strokeThickness", strokeThickness);
    println("maxStrokeLength", maxStrokeLength);
    for (int i = 0; i < numOfParticles; i++) {
      particles[i] = new Particle(particleSize, radius);
    }
  }

  void playEffect(float x, float y) {
    for (int i = 0; i < numOfParticles; i++) {
      particles[i].Move(x, y);
      particles[i].Draw();
      for (int j = i + 1; j < numOfParticles; j++) {
        SpringTo(particles[i], particles[j]);
      }
    }
  }

  //stroks from the plexus effect
  void SpringTo(Particle p1, Particle p2) {
    float dx = p2.mX - p1.mX;
    float dy = p2.mY - p1.mY;
    float dist = sqrt(dx * dx + dy * dy);

    if (dist < maxStrokeLength) {
      stroke(-1, 50);
      strokeWeight(strokeThickness);
      line(p1.mX, p1.mY, p2.mX, p2.mY);
    }
  }
}
