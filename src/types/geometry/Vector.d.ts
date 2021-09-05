interface Vector {
  x: number;
  y: number;
  z: number;
  AsArray(): Pointer;
  SetHeight(height?: number): void;
  ToScreen(): Vector;
  ToMM(): Vector;
  Unpack(): LuaMultiReturn<[number, number, number]>;
  LenSqr(): number;
  Len(): number;
  DistanceSqr(to: Vector | GameObject): number;
  Distance(to: Vector | GameObject): number;
  LineDistance(
    sefStart: Vector,
    sefEnd: Vector,
    onlyIfOnSegment: boolean
  ): number;
  Normalize(): Vector;
  Normalized(): Vector;
  Extended(to: Vector | GameObject, distance: number): Vector;
  Center(v: Vector | GameObject): Vector;
  CrossProduct(v: Vector | GameObject): Vector;
  DotProduct(v: Vector | GameObject): number;
  /**
   * @returns [isOnSegment, pointSegment, pointLine]
   */
  ProjectOn(
    segStart: Vector | GameObject,
    segEnd: Vector | GameObject
  ): LuaMultiReturn<[boolean, Vector, Vector]>;
  Polar(): number;
  AngleBetween(v1: Vector | GameObject, v2: Vector | GameObject): number;
  RotateX(phi: number): Vector;
  RotateY(phi: number): Vector;
  RotateZ(phi: number): Vector;
  Rotate(phiX: number, phiY: number, phiZ: number): Vector;
  Rotated(phiX: number, phiY: number, phiZ: number): Vector;
  RotatedAroundPoint(
    point: Vector | GameObject,
    phiX: number,
    phiY: number,
    phiZ: number
  ): Vector;
  IsValid(): boolean;
  Perpendicular(): Vector;
  Perpendicular2(): Vector;
  Absolute(): Vector;
  Draw(color: number);
  IsOnScreen(): boolean;
  IsWall(): boolean;
  IsGrass(): boolean;
  IsWithinTheMap(): boolean;
  GetTerrainHeight(): number;
}
