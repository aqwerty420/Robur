interface GameObject {
  readonly IsValid: boolean;
  readonly Ptr: Pointer;
  readonly Handle: Handle_t;
  readonly IsMe: boolean;
  readonly IsNeutral: boolean;
  readonly IsAlly: boolean;
  readonly IsEnemy: boolean;
  readonly IsMonster: boolean;
  readonly TeamId: number;
  readonly Name: string;
  readonly IsOnScreen: boolean;
  readonly IsDead: boolean;
  readonly IsZombie: boolean;
  readonly TypeFlags: number;
  readonly IsParticle: boolean;
  readonly IsMissile: boolean;
  readonly IsAttackableUnit: boolean;
  readonly IsAI: boolean;
  readonly IsMinion: boolean;
  readonly IsHero: boolean;
  readonly IsTurret: boolean;
  readonly IsNexus: boolean;
  readonly IsInhibitor: boolean;
  readonly IsBarracks: boolean;
  readonly IsStructure: boolean;
  readonly IsShop: boolean;
  readonly IsWard: boolean;
  readonly AsAI: AIBaseClient;
  readonly AsHero: AIHeroClient;
  readonly AsTurret: AITurretClient;
  readonly AsMinion: AIMinionClient;
  readonly AsMissile: MissileClient;
  readonly AsAttackableUnit: AttackableUnit;
  readonly IsVisible: boolean;
  readonly BoundingRadius: number;
  Distance(to: Vector): number;
  EdgeDistance(to: Vector): number;
  readonly BBoxMin: Vector;
  readonly BBoxMax: Vector;
  readonly Position: Vector;
  readonly Orientation: Vector;
  readonly IsInGrass: boolean;
  readonly IsInBaronPit: boolean;
  readonly IsInDragonPit: boolean;
  readonly IsInTopLane: boolean;
  readonly IsInMidLane: boolean;
  readonly IsInBotLane: boolean;
  readonly IsInRiver: boolean;
  readonly IsInJungle: boolean;
  readonly IsInAllyJungle: boolean;
  readonly IsInEnemyJungle: boolean;
  readonly IsInBase: boolean;
  readonly IsInEnemyBase: boolean;
  /**
   * table
   * @returns { Team="Order" | "Chaos" | "Neutral", Area="Base" | "TopLane" | "MidLane" | "BotLane" | "TopJungle" | "BotJungle" | "TopRiver" | "BotRiver" | "DragonPit" | "BaronPit" }
   */
  readonly MapArea: LuaTable<TeamOrArea, keyof Enum_Teams | Area>;
  /**
   * @"Order"|"Chaos"|"Neutral"
   */
  readonly TeamName: string;
}
