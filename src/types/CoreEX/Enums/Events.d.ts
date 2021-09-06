interface Enum_Events {
  /**
   * [[30FPS]] void OnTick()
   */
  readonly OnTick: string;
  /**
   * [[60FPS]] void OnUpdate()
   */
  readonly OnUpdate: string;
  /**
   * [[Screen Refresh Rate]] void OnDraw()
   */
  readonly OnDraw: string;
  /**
   * [[Screen Refresh Rate]] void OnDrawMenu()
   */
  readonly OnDrawMenu: string;
  /**
   * [[Screen Refresh Rate]]void OnDrawHUD()
   */
  readonly OnDrawHUD: string;
  /**
   * [[Screen Refresh Rate]]void OnDrawDamage(target, dmgList)
   */
  readonly OnDrawDamage: string;
  /**
   * [[KeyPress]]void OnKey(e, message, wparam, lparam)
   */
  readonly OnKey: string;
  /**
   * [[KeyPress]]void OnMouseEvent(e, message, wparam, lparam)
   */
  readonly OnMouseEvent: string;
  /**
   * [[KeyPress]]void OnKeyDown(keycode, char, lparam)
   */
  readonly OnKeyDown: string;
  /**
   * [[KeyPress]]void OnKeyUp(keycode, char, lparam)
   */
  readonly OnKeyUp: string;
  /**
   * [[After Creation]]void OnCreateObject(obj)
   */
  readonly OnCreateObject: string;
  /**
   * [[Before Deletion]]void OnDeleteObject(obj)
   */
  readonly OnDeleteObject: string;
  /**
   * [[Change / Block Player Casts]]void OnCastSpell(Args)--Args = { Process, Slot, TargetPosition, TargetEndPosition, Target }
   */
  readonly OnCastSpell: string;
  /**
   * [[Animation Start]]void OnProcessSpell(obj, spellcast)
   */
  readonly OnProcessSpell: string;
  /**
   * [[Change Pos / Block Charged Spell]]void OnUpdateChargedSpell(Args)--Args = { Spell, TargetPosition, Release }(Can't Change SpellData)
   */
  readonly OnUpdateChargedSpell: string;
  /**
   * [[Animation End]]void OnSpellCast(obj, spellcast)
   */
  readonly OnSpellCast: string;
  /**
   * [[Animation Interrupted]]void OnCastStop(sender, spellcast, bStopAnimation, bExecuteCastFrame, bDestroyMissile)
   */
  readonly OnCastStop: string;
  /**
   * [[Animation Start]]void OnBasicAttack(obj, spellcast)
   */
  readonly OnBasicAttack: string;
  /**
   * [[Animation Start]]void OnNewPath(obj, pathing)
   */
  readonly OnNewPath: string;
  /**
   * [[Change / Block Player Orders]]void OnIssueOrder(Args)--Args = { Process, Order, Position, Target }
   */
  readonly OnIssueOrder: string;
  /**
   * [[After Update]]void OnBuffUpdate(obj, buffInst)
   */
  readonly OnBuffUpdate: string;
  /**
   * [[After Creation]]void OnBuffGain(obj, buffInst)
   */
  readonly OnBuffGain: string;
  /**
   * [[Before Deletion]]void OnBuffLost(obj, buffInst)
   */
  readonly OnBuffLost: string;
  /**
   * [[Before Animation Start]]void PlayAnimation(obj, animationName)
   */
  readonly OnPlayAnimation: string;
  /**
   * [[Hero Leaves FOG]]void OnVisionGain(obj)
   */
  readonly OnVisionGain: string;
  /**
   * [[Hero Enters FOG]]void OnVisionLost(obj)
   */
  readonly OnVisionLost: string;
  /**
   * [[Works in FOG]]void OnTeleport(obj, name, duration_secs, status)--status: "Started", "Finished" or "Interrupted"
   */
  readonly OnTeleport: string;
  /**
   * [[Called When Nexus Is Destroyed]]void OnGameEnd(obj)--obj: Destroyed Nexus
   */
  readonly OnGameEnd: string;
  /**
   * [[Orbwalker Wants To Attack]]void OnPreAttack(args)--args: { Process, Target }
   */
  readonly OnPreAttack: string;
  /**
   * [[Orbwalker Finished Attacking]]void OnPostAttack(target)
   */
  readonly OnPostAttack: string;
  /**
   * [[Orbwalker Wants To Move]]void OnPreMove(args)--args: { Process, Position }
   */
  readonly OnPreMove: string;
  /**
   * [[Orbwalker Started Moving]]void OnPostMove(endPosition)
   */
  readonly OnPostMove: string;
  /**
   * [[Orbwalker Cant Kill a Minion]]void OnUnkillableMinion(minion)
   */
  readonly OnUnkillableMinion: string;
  /**
   * [[Source Is Dashing / Blinking]]void OnGapClose(Source, DashInstance)
   */
  readonly OnGapclose: string;
  /**
   *  [[Source Is Channelling]]void OnInterruptibleSpell(Source, SpellCast, Danger, EndTime, CanMoveDuringChannel)
   */
  readonly OnInterruptibleSpell: string;
  /**
   * [[Source Is Casting / CCed]]void OnHeroImmobilized(Source, EndTime, IsStasis)
   */
  readonly OnHeroImmobilized: string;
  /**
   * [[Improved OnTick]]void OnExtremePriority()--Evade, Autosmite, etc
   */
  readonly OnExtremePriority: string;
  /**
   * [[Improved OnTick]]void OnHighPriority()--important spells etc
   */
  readonly OnHighPriority: string;
  /**
   *  [[Improved OnTick]]void OnNormalPriority()--Orbwalker, Normal Spells
   */
  readonly OnNormalPriority: string;
  /**
   * [[Improved OnTick]]void OnLowPriority() - Pseudo - Useless Spells
   */
  readonly OnLowPriority: string;
  readonly OnAttackReset: string;
  readonly OnOrbwalkerPreTick: string;
  readonly OnOrbwalkerNewTarget: string;
}
