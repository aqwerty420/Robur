/** @noSelf **/
interface Nav {
  WorldToCell(worldPos: Vector): Vector;
  CellToWorld(x: number, z: number): Vector;
  GetTerrainHeight(worldPos: Vector): number;
  IsWall(worldPos: Vector): boolean;
  IsGrass(worldPos: Vector): boolean;
  IsWithinTheMap(worldPos: Vector): boolean;
  GetCellSize(): number;
  GetCellCount(): Vector;
  /**
   * @returns Team="Order"|"Chaos"|"Neutral", Area="Base"|"TopLane"|"MidLane"|"BotLane"|"TopJungle"|"BotJungle"|"TopRiver"|"BotRiver"|"DragonPit"|"BaronPit"
   */
  GetMapArea(pos: Vector): LuaTable<TeamOrArea, Enum_Teams | Area>;
}
