//TO_DO

interface DashInstance {
  readonly Slot: number;
  readonly Range: number;
  readonly Delay: number;
  readonly EndDelay: number;
  readonly StartTime: number;
  readonly Target: AIBaseClient;
  readonly StartPos: Vector;
  /**
   * Whether Dash Is Always Cast At Max Range
   */
  readonly FixedRange: boolean;
  readonly IsBlink: boolean;
  /**
   * Wheter Its an intentional Dash or unintentional(Knockback etc)
   */
  readonly IsGapClose: boolean;
  readonly IsTargeted: boolean;
  /**
   * Wheter Target Is Invulnerable Until EndDelay
   */
  readonly Invulnerable: boolean;
  GetPaths(): DashPath[];
  GetSpeed(): number;
  GetPosition(delay?: number): Vector;
  //(fromPos: Vector, speed: number, delay: number, radius: number, useHitBox: boolean, isTrap: boolean): Pred
}
