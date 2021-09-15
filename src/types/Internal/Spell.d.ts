interface SpellBase {
  GetSpellData(): SpellData | null;
  SetTargetSelector(newTS: TargetSelector): void;
  SetRangeCheckObj(obj: AIBaseClient): void;
  IsReady(extraTime?: number): boolean;
  IsLearned(): boolean;
  GetLevel(): number;
  GetName(): string;
  /**
   * @returns Enum_SpellStates
   */
  GetState(): keyof Enum_SpellStates;
  GetToggleState(): number;
  GetManaCost(): number;
  GetCurrentAmmo(): number;
  GetMaxAmmo(): number;
  GetTarget(): AIHeroClient | null;
  GetTargets(): AIHeroClient[];
  GetDamage(target: AIBaseClient, stage?: string): number;
  GetHealthPred(target: AIBaseClient): number;
  CanCast(target: AIBaseClient): boolean;
  IsInRange(pos_or_target: AIBaseClient | Vector): boolean;
  IsLeavingRange(target: AIBaseClient): boolean;
}

interface Skillshot extends SpellBase {
  GetPrediction(target: AIBaseClient): PredictionResult;
  GetCollision(
    startPos: Vector,
    endPos: Vector,
    team_lbl?: string | null,
    ignoreList?: LuaTable
  ): CollisionResult;
  GetFirstCollision(
    startPos: Vector,
    endPos: Vector,
    team_lbl?: string | null,
    ignoreList?: LuaTable
  ): CollisionResult;
  Cast(pos_target: AIBaseClient | Vector): boolean;
  /**
   * @param minHitChance Enums_HitChance
   */
  CastOnHitChance(
    target: AIBaseClient,
    minHitChance: keyof Enums_HitChance
  ): boolean;
  GetBestLinearCastPos(
    targets: Vector[] | AIBaseClient[]
  ): LuaMultiReturn<[Vector, number]>;
  GetBestCircularCastPos(
    targets: Vector[] | AIBaseClient[]
  ): LuaMultiReturn<[Vector, number]>;
  CastIfWillHit(minTargets: number, type: ObjectType): boolean;
  /**
   * @param stage "Default", "Empowered", "SecondCast", "ThirdCast", "SecondForm", "ThirdForm"..
   */
  GetDamage(target: AIBaseClient, stage?: string): number;
  GetHealthPred(target: AIBaseClient): number;
  /**
   * @returns Current health + shield + yasuo passive etc
   */
  GetKillstealHealth(target: AIHeroClient): number;
}

interface Targeted extends SpellBase {
  Cast(pos_target: AIBaseClient | Vector): boolean;
}

interface Active extends SpellBase {
  Cast(pos_target?: AIBaseClient | Vector): boolean;
}

interface Chargeable extends Skillshot {
  readonly IsCharging: boolean;
  GetRange(): number;
  IsFullyCharged(): boolean;
  /**
   * Start charging the spell
   */
  StartCharging(): boolean;
  /**
   * Release a spell during charge
   */
  Release(pos_target: AIBaseClient | Vector): boolean;
  /**
   * Release a spell during charge
   * @param minHitChance Enums_HitChance
   */
  ReleaseOnHitChance(
    target: AIBaseClient,
    minHitChance: keyof Enums_HitChance
  ): boolean;
  /**
   * Instant cast the spell at min range towards position or target prediction
   */
  Cast(pos_target: AIBaseClient | Vector): boolean;
}

/** @noSelf **/
interface SpellLib {
  Skillshot(input: PredictionInput): Skillshot;
  Targeted(input: PredictionInput): Targeted;
  Active(input: PredictionInput): Active;
  Chargeable(input: PredictionInput): Chargeable;
}
