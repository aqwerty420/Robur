interface DetectedSpell {
  GetName(): string;
  /**
   * @param Enum_SpellSlots
   */
  GetSlot(): number;
  GetCaster(): AIBaseClient | null;
  /**
   * @returns "Ring", "Circle", "Line", "MissileLine", "Cone", "MissileCone", "Arc"
   */
  GetType(): string;
  /**
   * @returns true if Skill is enabled on Evade menu
   */
  IsEnabled(): boolean;
  /**
   * @returns true if Skill is marked as Dangerous on Evade menu
   */
  IsDangerous(): boolean;
  /**
   * @returns Skill DangerLevel from Evade menu
   */
  GetDangerLevel(): number;
  IsSafePoint(position: Vector): boolean;
  IsAboutToHit(
    time_in_secs: number,
    hero_or_pos: Vector | AIHeroClient
  ): boolean;
}
