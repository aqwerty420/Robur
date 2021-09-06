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
  readonly Nav: Nav;
  /**
   * 1. Put a ".version" file with the same name and path of your script at the git:
   *  https://robur.site/Thorn/Public/src/branch/master/UnrulyEzreal.lua
   *  https://robur.site/Thorn/Public/src/branch/master/UnrulyEzreal.version
   * 2. Call CoreEx.AutoUpdate() on the script, passing the link and local version:
   *  CoreEx.AutoUpdate("https://robur.site/Thorn/Public/raw/branch/master/UnrulyEzreal.lua", "1.0.0")
   */
  AutoUpdate(url: string, version: string): void;
}
