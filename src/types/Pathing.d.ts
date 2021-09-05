interface Pathing {
  readonly Velocity: Vector;
  readonly StartPos: Vector;
  readonly EndPos: Vector;
  readonly IsMoving: boolean;
  readonly IsDashing: boolean;
  readonly DashGravity: number;
  readonly DashSpeed: number;
  readonly CurrentWaypoint: number;
  readonly Waypoints: Vector[];
}
