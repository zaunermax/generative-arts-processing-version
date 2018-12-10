class Player {
  
  // --- All the information about a player ---
  PharusClient pc; // do not modify this, PharusClient updates it
  int id; // do not modify this, PharusClient updates it
  long tuioId; // do not modify this, PharusClient updates it
  int age; // do not modify this, PharusClient updates it
  float x; // do not modify this, PharusClient updates it
  float y; // do not modify this, PharusClient updates it
  ArrayList<Foot> feet = new ArrayList<Foot>(); // do not modify this, PharusClient updates it
  
  PlayerEffect playerEffect;

  public Player(PharusClient pc, int id, long tuioId, float x, float y) {
    this.pc = pc;
    this.id = id;
    this.tuioId = tuioId;
    this.x = x;
    this.y = y;
    
    playerEffect = new NoisePlexus();
  }
  
  public void playPlayerEffect() {
    playerEffect.playEffect(x, y);
  }

  // TODO extend this with additional fields

  // --- Some functions that have information about the player ---
  boolean isJumping() {
    // we assume that we jump if we have no feet and update
    return feet.size() == 0 && age > 1;
  }

  // handling of path information
  int getNumPathPoints() {
    TuioCursor tc = pc.tuioProcessing.getTuioCursor(tuioId);
    if (tc != null) {
      return tc.getPath().size();
    }
    return -1;
  }

  float getPathPointX(int pointID) {
    TuioCursor tc = pc.tuioProcessing.getTuioCursor(tuioId);
    if (tc != null) {
      ArrayList pointList = tc.getPath();
      if (pointList == null || pointList.size() <=  pointID) {
        return 0;
      }
      TuioPoint tp = (TuioPoint)pointList.get(pointID);
      return tp.getScreenX(width);
    }
    return 0;
  }

  float getPathPointY(int pointID) {
    TuioCursor tc = pc.tuioProcessing.getTuioCursor(tuioId);
    if (tc != null) {
      ArrayList pointList = tc.getPath();
      if (pointList == null || pointList.size() <=  pointID) {
        return 0;
      }
      TuioPoint tp = (TuioPoint)pointList.get(pointID);
      return tc.getScreenY(height - pc.wallHeight) + pc.wallHeight;
    }
    return 0;
  }
}

public class Foot {
  public Foot(float x, float y) {
    this.x = x;
    this.y = y;
  }

  float x;
  float y;
}
