interface DashPath {
  readonly StartPos: Vector;
  readonly EndPos: Vector;
  readonly Delay: number;
  readonly EndDelay: number;
  readonly Speed: number;
  readonly StartTime: number;
  readonly DashTime: number;
  /**
   * StartTime + Delay + DashTime + EndDelay
   */
  readonly EndTime: number;
}
