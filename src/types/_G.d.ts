type Pointer = number;
type Handle_t = number;

/** @noSelf **/
interface CoreEx {
  readonly Enums: Enums;
  readonly Geometry: Geometry;
  readonly ObjectManager: ObjectManager;
  readonly EventManager: EventManager;
  readonly Input: Input;
  readonly Renderer: Renderer;
  readonly EvadeAPI: Evade;
  readonly Game: Game;
  /**
   * 1. Put a ".version" file with the same name and path of your script at the git:
   *  https://robur.site/Thorn/Public/src/branch/master/UnrulyEzreal.lua
   *  https://robur.site/Thorn/Public/src/branch/master/UnrulyEzreal.version
   * 2. Call CoreEx.AutoUpdate() on the script, passing the link and local version:
   *  CoreEx.AutoUpdate("https://robur.site/Thorn/Public/raw/branch/master/UnrulyEzreal.lua", "1.0.0")
   */
  AutoUpdate(url: string, version: string): void;
}

interface maths {
  readonly huge: number;
  rad(number: number): number;
  sin(number: number): number;
  cos(number: number): number;
}

interface _Gi {
  readonly Libs: Libs;
  readonly CoreEx: CoreEx;
  readonly Player: AIHeroClient;
  readonly math: maths;
}

declare const _G: _Gi;

type OnLoadEvent = () => boolean;

// eslint-disable-next-line @typescript-eslint/no-explicit-any
declare function print(this: void, ...args: any[]): void;

declare let OnLoad: OnLoadEvent;

declare const Player: AIHeroClient;
