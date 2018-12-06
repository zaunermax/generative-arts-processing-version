class Effect {
  StateManager stateMgr;
  int effectId;
  
  Effect(StateManager _stateMgr) {
    stateMgr = _stateMgr;
  }
  
  void playEffect() {}
  
  void setStateId(int _stateID) {
    effectId = _stateID;
  }

  int getEffectId() {
    return effectId;
  }
  
  void setStateMgr(StateManager _stateMgr) {
    stateMgr = _stateMgr;
  }
}
