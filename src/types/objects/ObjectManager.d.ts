/** @noSelf **/
interface ObjectManager {
  readonly Player: AIHeroClient;
  /**
   * table
   * @param team all, ally, enemy, neutral, no_team
   * @param type heroes, minions, turrets, inhibitors, hqs, wards, particles, missiles, others
   */
  Get(team: Team, type: ObjectType): LuaTable<Handle_t, GameObject>;

  /**
   * @param team all, ally, enemy, neutral, no_team
   * @param type heroes, minions, turrets, inhibitors, hqs, wards, particles, missiles, others
   * @returns GameObject within 1500 range
   */
  GetNearby(team: Team, type: ObjectType): LuaTable<Handle_t, GameObject>;
  GetObjectByHandle(handle: Handle_t): GameObject;
}
