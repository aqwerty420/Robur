interface Path {
  GetPoints(): Vector[];
  GetPaths(): Path[];
  Direction(): Vector;
  Len(): number;
  Contains(geometry: Vector | Path): boolean;
  Intersects(geometry: Circle | Path | Rectangle | Cone | Polygon): boolean;
  Distance(
    geometry: Vector | Circle | Path | Rectangle | Cone | Polygon
  ): number;
  Draw(color?: number): void;
}
