/** @noSelf **/
interface HealthPred {
  /**
   * @param SimulateDmg extrapolates attacks that havent started yet
   * @returns [dmgPred, maxIncomingDmg, incomingDmgCount]
   */
  GetDamagePrediction(
    Target: AttackableUnit,
    Time: number,
    SimulateDmg: boolean
  ): LuaMultiReturn<[number, number, number]>;
  /**
   * @param SimulateDmg extrapolates attacks that havent started yet
   * @returns [hpPred, maxIncomingDmg, incomingDmgCount]
   */
  GetHealthPrediction(
    Target: AttackableUnit,
    Time: number,
    SimulateDmg: boolean
  ): LuaMultiReturn<[number, number, number]>;
  /**
   * @param DmgType Enum_DamageTypes
   */
  GetKillstealHealth(
    Target: AIHeroClient,
    Time: number,
    DmgType: keyof Enum_DamageTypes
  ): number;
}
