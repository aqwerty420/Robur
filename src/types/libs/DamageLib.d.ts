/** @noSelf **/
interface DamageLib {
  CalculatePhysicalDamage(
    source: AIBaseClient,
    target: AttackableUnit,
    rawDmg: number
  ): number;
  CalculateMagicalDamage(
    source: AIBaseClient,
    target: AttackableUnit,
    rawDmg: number
  ): number;
  /**
   * Use this when you'll call GetAutoAttackDamage multiple times (memoization)
   */
  GetStaticAutoAttackDamage(
    source: AIBaseClient,
    isMinionTarget: boolean
  ): LuaTable;
  GetAutoAttackDamage(
    source: AIBaseClient,
    target: AttackableUnit,
    checkPassives: boolean,
    staticDamage?: LuaTable
  ): number;
}
