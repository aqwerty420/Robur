interface Input {
  /**
   * @param slot Enum_SpellSlots
   */
  Cast(slot: number): boolean;
  /**
   * @param slot Enum_SpellSlots
   */
  Cast(slot: number, target: AttackableUnit): boolean;
  /**
   * @param slot Enum_SpellSlots
   */
  Cast(slot: number, targetPos: Vector): boolean;
  /**
   * @param slot Enum_SpellSlots
   */
  Cast(slot: number, targetPos: Vector, startPos: Vector): boolean;
  Attack(target: AttackableUnit): boolean;
  MoveTo(pos: Vector): boolean;
  /**
   * @param slot Enum_SpellSlots
   */
  Release(slot: number, pos?: Vector): boolean;
  /**
   * @param slot Enum_SpellSlots
   */
  LevelSpell(slot: Enum_SpellSlots): boolean;
}
