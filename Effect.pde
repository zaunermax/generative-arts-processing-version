class Effect {
  int effectId;
  
  void playEffect() {}
  
  void setStateId(int _stateID) {
    effectId = _stateID;
  }

  int getEffectId() {
    return effectId;
  }
}
