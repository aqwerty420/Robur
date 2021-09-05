/** @noSelf **/
interface DashLib {
  /**
   * @returns null if target isnt dashing / blinking
   */
  GetDash(Obj: AIHeroClient): DashInstance | null;
  IsDash(charName: string, spellName: string): boolean;
}
