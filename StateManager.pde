public class StateManager {

  List<Effect> effects = new ArrayList<Effect>(4);
  int currentEffectID;
  int sectorActive;

  float meanX;
  float meanY;

  List<Player> playerList;

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

  void drawFloor() {
    calculatePositions();

    drawActiveSector();
    drawMeanPosition();

    drawPlayers(playerList);
  }

  // private methods

  private void calculatePositions() {
    float allX = 0;
    float allY = 0;

    playerList = new ArrayList<Player>();

    for (HashMap.Entry<Long, Player> playersEntry : pc.players.entrySet()) {
      Player p = playersEntry.getValue();

      allX += p.x;
      allY += p.y;

      playerList.add(p);
    }

    meanX = allX / pc.players.size();
    meanY = allY / pc.players.size();
  }

  private void drawMeanPosition() {
    noStroke();
    fill(255);
    ellipse(meanX, meanY, WallHeight*0.03, WallHeight*0.03);
  }

  private void drawActiveSector() {

    float bottomHeight = WindowHeight - WallHeight;
    float bottomSphereDims = bottomHeight * 0.8;
    float bottomMiddleSphereDims = bottomHeight * 0.15;

    noStroke();

    fill(0, 153, 153, 40);
    ellipse(WindowWidth / 2, WallHeight + bottomHeight / 2, bottomSphereDims, bottomSphereDims);

    fill(0, 153, 153, 80);
    ellipse(WindowWidth / 2, WallHeight + bottomHeight / 2, bottomMiddleSphereDims, bottomMiddleSphereDims);

    noFill();

    if (meanY < WallHeight + (WindowHeight - WallHeight) / 2) {
      if (meanX < WindowWidth / 2) {
        fill(0, 153, 153, 70);
        arc(WindowWidth / 2, WallHeight + bottomHeight / 2, bottomSphereDims, bottomSphereDims, PI, PI + HALF_PI); //LINKS oben
        sm.setEffect(0);
      } else {
        fill(0, 153, 153, 70);
        arc(WindowWidth / 2, WallHeight + bottomHeight / 2, bottomSphereDims, bottomSphereDims, PI + HALF_PI, PI * 2); //RECHTS oben
        sm.setEffect(1);
      }
    } else {
      if (meanX < WindowWidth / 2) {
        fill(0, 153, 153, 70);
        arc(WindowWidth / 2, WallHeight + bottomHeight / 2, bottomSphereDims, bottomSphereDims, HALF_PI, PI); //LINKS unten
        sm.setEffect(2);
      } else {
        fill(0, 153, 153, 70);
        arc(WindowWidth / 2, WallHeight + bottomHeight / 2, bottomSphereDims, bottomSphereDims, 0, HALF_PI); //rechts unten
        sm.setEffect(3);
      }
    }
  }

  private void drawPlayers(List<Player> players) {
    for (Player p : players) {
      p.playPlayerEffect();
    }
  }
}
