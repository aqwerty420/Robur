interface Circle {
  GetPoints(quality?: number): Vector[];
  GetPaths(quality?: number): Path[];
  Contains(
    geometry: Vector | Circle | Path | Rectangle | Cone | Polygon
  ): boolean;
  Intersects(geometry: Circle | Path | Rectangle | Cone | Polygon): boolean;
  Distance(
    geometry: Vector | Circle | Path | Rectangle | Cone | Polygon
  ): number;
  IsOnScreen(): boolean;
  Draw(color?: number | null, quality?: number | null): void;
  Offseted(distance: number): boolean;
}
