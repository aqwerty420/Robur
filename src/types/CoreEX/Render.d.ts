/** @noSelf **/
interface Renderer {
  DrawCircle(
    center: Vector,
    radius: number,
    thickness?: number | null,
    color?: number | null,
    filled?: boolean
  ): void;
  DrawCircleMM(
    center: Vector,
    radius: number,
    thickness?: number | null,
    color?: number | null,
    filled?: boolean
  ): void;
  DrawCircle3D(
    center: Vector,
    radius: number,
    quality: number,
    thickness?: number | null,
    color?: number
  ): void;
  DrawLine(
    pos1: Vector,
    pos2: Vector,
    thickness?: number | null,
    color?: number
  ): void;
  DrawLine3D(
    pos1: Vector,
    pos2: Vector,
    thickness?: number | null,
    color?: number
  ): void;
  DrawText(pos: Vector, size: Vector, text: string, color: number): void;
  DrawTextOnTopLeft(text: string, color: number): void;
  DrawTextOnPlayer(text: string, color: number): void;
  DrawRectOutline(
    pos: Vector,
    size: Vector,
    rounding: number,
    thickness: number,
    color: number
  ): void;
  DrawRectOutline3D(
    start: Vector,
    end: Vector,
    width: number,
    thickness: number,
    color: number
  ): void;
  DrawFilledRect(
    pos: Vector,
    size: Vector,
    rounding: number,
    color: number
  ): void;
  DrawFilledRect3D(
    start: Vector,
    end: Vector,
    width: number,
    color: number
  ): void;
  IsOnScreen(pos: Vector): boolean;
  IsOnScreen2D(pos: Vector): boolean;
  WorldToScreen(pos: Vector): Vector;
  WorldToMinimap(pos: Vector): Vector;
  MinimapToWorld(pos: Vector): Vector;
  GetResolution(): Vector;
  GetMousePos(): Vector;
  CalcTextSize(text: string): Vector;
  /**
   * (relPath = "Rocket.png" will return file[\\lol\\Sprites\\Rocket.png]).Call Only Once Per Sprite!
   */
  CreateSprite(relPath: string, width: number, height: number): Sprite;
}
