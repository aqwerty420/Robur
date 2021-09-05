/** @noSelf **/
interface Geometry {
  Vector(
    x?: number | Vector | null,
    y?: number | null,
    z?: number | null
  ): Vector;
  Path(pos1: Vector | Path, pos2: Vector): Path;
  Circle(pos1: Vector | Circle, radius: number): Circle;
  Rectangle(
    startpos: Vector | Rectangle,
    endPos: Vector,
    width: number
  ): Rectangle;
  Ring(center: Vector[] | Ring, r_min: number, r_max: number): Ring;
  Polygon(points: Vector[] | Polygon): Polygon;
  /**
   * @returns [BestPos, HitCount]
   */
  BestCoveringCircle(
    points: Vector[],
    radius: number
  ): LuaMultiReturn<[Vector, number]>;
  /**
   * @returns [BestPos, HitCount]
   */
  BestCoveringRectangle(
    points: Vector[],
    startPos: Vector,
    width: number
  ): LuaMultiReturn<[Vector, number]>;
  /**
   * @returns [BestPos, HitCount]
   */
  BestCoveringCone(
    points: Vector[],
    startPos: Vector,
    radians: number
  ): LuaMultiReturn<[Vector, number]>;
  /**
   * @returns the 2 Points Where Circles Intersect
   */
  CircleCircleIntersection(
    center1: Vector,
    radius1: number,
    center2: Vector,
    radius2: number
  ): Vector[];
  /**
   * @returns the Points Where Line and Circle Intersect
   */
  LineCircleIntersection(
    lineP1: Vector,
    lineP2: Vector,
    center: Vector,
    radius: number,
    isInfiniteLine?: boolean
  ): Vector[];
}
