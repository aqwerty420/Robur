interface CollisionLib {
  SearchWall(
    startPos: Vector,
    endPos: Vector,
    width: number,
    speed: number,
    delay_ms: number
  ): CollisionResult;
  SearchHeroes(
    startPos: Vector,
    endPos: Vector,
    width: number,
    speed: number,
    delay_ms: number,
    maxResults: number,
    allyOrEnemy: AllyOrEnemy,
    handlesToIgnore: number[]
  ): CollisionResult;
  SearchMinions(
    startPos: Vector,
    endPos: Vector,
    width: number,
    speed: number,
    delay_ms: number,
    maxResults: number,
    allyOrEnemy: AllyOrEnemy,
    handlesToIgnore: number[]
  ): CollisionResult;
  SearchYasuoWall(
    startPos: Vector,
    endPos: Vector,
    width: number,
    speed: number,
    delay_ms: number,
    maxResults: number,
    allyOrEnemy: AllyOrEnemy
  ): CollisionResult;
}
