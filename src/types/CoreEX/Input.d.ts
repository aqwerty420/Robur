interface Input {
  /**
   * @param slot Enum_SpellSlots
   */
  Cast(slot: keyof Enum_SpellSlots): boolean;
  /**
   * @param slot Enum_SpellSlots
   */
  Cast(slot: keyof Enum_SpellSlots, target: AttackableUnit): boolean;
  /**
   * @param slot Enum_SpellSlots
   */
  Cast(slot: keyof Enum_SpellSlots, targetPos: Vector): boolean;
  /**
   * @param slot Enum_SpellSlots
   */
  Cast(
    slot: keyof Enum_SpellSlots,
    targetPos: Vector,
    startPos: Vector
  ): boolean;
  Attack(target: AttackableUnit): boolean;
  MoveTo(pos: Vector): boolean;
  /**
   * @param slot Enum_SpellSlots
   */
  Release(slot: keyof Enum_SpellSlots, pos?: Vector): boolean;
  /**
   * @param slot Enum_SpellSlots
   */
  LevelSpell(slot: keyof Enum_SpellSlots): boolean;
}
