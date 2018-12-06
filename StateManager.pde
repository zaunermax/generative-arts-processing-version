public class StateManager {

  List<Effect> effects = new ArrayList<Effect>(4);
  int currentEffectID;
  int sectorActive;

  int addEffect(Effect effect) {
    if (effects.size() > 3) return -1;
    effects.add(effect);
    effect.setStateId(effects.size() - 1);
    return effect.getEffectId();
  }

  int setEffect(int newEffect) {
    if (newEffect < 0 || newEffect >= effects.size()) {
      return -1;
    }

    if (newEffect != currentEffectID) {
      currentEffectID = newEffect;
    }

    return currentEffectID;
  }

  Effect getEffect(int effectId) {
    if (effectId < 0 || effectId >= effects.size())
      return effects.get(0);

    return effects.get(effectId);
  }

  void drawCurrentEffect() {
    getEffect(currentEffectID).playEffect();
  }
  
  void drawPlayers(List<Player> players) {
    for (Player p : players) {
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
  }

  void drawFloor() {
    float allX = 0;
    float allY = 0;

    ArrayList<Player> playerList = new ArrayList<Player>();

    for (HashMap.Entry<Long, Player> playersEntry : pc.players.entrySet()) {
      Player p = playersEntry.getValue();

      allX += p.x;
      allY += p.y;

      playerList.add(p);
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
        sm.setEffect(0);
      } else {
        //System.out.println("Rechts oben");
        stroke(0, 0, 255);
        rect(WindowWidth / 2, WallHeight, WindowWidth, (WindowHeight - WallHeight) / 2);
        bool = true;
        sm.setEffect(1);
      }
    } else {
      if (meanX < WindowWidth / 2) {
        //System.out.println("Links unten");
        stroke(0, 0, 255);
        rect(0, WallHeight + (WindowHeight - WallHeight) / 2, WindowWidth / 2, WindowHeight);
        bool = true;
        sm.setEffect(2);
      } else {
        //System.out.println("Rechts unten");
        stroke(0, 0, 255);
        rect(WindowWidth / 2, WallHeight + (WindowHeight - WallHeight) / 2, WindowWidth, WindowHeight);
        bool = false;
        sm.setEffect(3);
      }
    }
    
    drawPlayers(playerList);
  }
}
