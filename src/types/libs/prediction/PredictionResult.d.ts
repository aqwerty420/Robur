interface PredictionResult {
  CollisionTime: number;
  CastPosition: Vector;
  TargetPosition: Vector;
  HitChance: number;
  /**
   * Enums_HitChance
   */
  HitChanceEnum: number;
  CollisionCount: number;
  CollisionObjects: GameObject[];
  CollisionPoints: Vector[];
}
