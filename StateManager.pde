public class StateManager {
  
  Effect[] effects;
  int currentEffectID;
  
  int addEffect(Effect effect) {
    if (effects == null) {
      effects = new Effect[1];
      effects[0] = effect;
    } else {
      effects = (Effect[])append(effects, effect);
    }
    
    effect.setStateId(effects.length - 1);
    
    return effect.getEffectId();
  }
  
  int setEffect(int newEffect) {
    if (newEffect < 0 || newEffect >= effects.length) {
      return -1;
    }
  
    if (newEffect != currentEffectID) {
      currentEffectID = newEffect;
    }
    
    return currentEffectID;
  }
}
