interface MissileClient extends GameObject {
  readonly StartPos: Vector;
  readonly EndPos: Vector;
  readonly CasterDirection: Vector;
  readonly StartTime: number;
  readonly CastEndTime: number;
  readonly EndTime: number;
  readonly IsBasicAttack: boolean;
  readonly IsSpecialAttack: boolean;
  readonly Caster: AIBaseClient;
  readonly Source: AIBaseClient;
  readonly Target: AttackableUnit;
  readonly Width: number;
  readonly Speed: number;
  readonly SpellCastInfo: SpellCast;
}
