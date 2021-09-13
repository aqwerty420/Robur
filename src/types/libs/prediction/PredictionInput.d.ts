interface PredictionInput {
  From?: Vector;
  Slot: number;
  Range?: number;
  /**
   * Width / 2 for Linear Spells
   */
  Radius?: number;
  Speed?: number;
  Delay?: number;
  Type?: SpellType;
  ConeAngleRad?: number;
  /**
   * Enums_HitChance
   */
  MinHitChance?: number;
  MinHitChanceEnum?: keyof Enums_HitChance;
  /**
   * table { Heroes=true, Minions=true, WindWall=true, Wall=true }
   */
  Collisions?: CollisionsPossible;
  MaxCollisions?: number;
  IsTrap?: boolean;
  UseHitbox?: boolean;
  /**
   * When Spell Does Extra Damage / Effect Within X Radius: (Eg.: Xerath: W)
   */
  EffectRadius?: number;
}
