/** @noSelf **/
interface ImmobileLib {
  /**
   * table
   * @returns Caster, EndTime, CanMove, Danger
   */
  GetChannelBeingCast(unit: AIHeroClient): LuaTable;
  GetImmobileTimeLeft(unit: AIHeroClient): number;
}
