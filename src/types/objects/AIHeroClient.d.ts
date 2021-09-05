/** @noSelf **/
interface AIHeroClient extends AIBaseClient {
  readonly RespawnTime: number;
  readonly Experience: number;
  readonly Level: number;
  readonly Gold: number;
  readonly TotalGold: number;
  readonly VisionScore: number;
  readonly IsRecalling: boolean;
  readonly IsTeleporting: boolean;
  readonly IsInFountain: boolean;
  /**
   * table
   * @returns [perkId] = perkName
   */
  readonly Perks: LuaTable<number, string>;
  /**
   * @returns [itemSlot] = item
   */
  readonly Items: Item[];
  readonly RecallInfo: string;
  HasPerk(id_or_name: number | string): boolean;
  /**
   * @param slot Enum_SpellSlots
   */
  IsSpellEvolved(slot: number): boolean;
  /**
   * @param slot Enum_SpellSlots
   */
  CanLevelSpell(slot: number): boolean;
  /**
   * @param slot Enum_SpellSlots
   */
  CanEvolveSpell(slot: number): boolean;
}
