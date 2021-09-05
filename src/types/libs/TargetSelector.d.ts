/* eslint-disable @typescript-eslint/ban-types */
interface TargetSelector {
  /**
   * @param val_fn Evaluates the current target. i.e. function(target) return target.Health end
   */
  AddMode(this: void, name: string, order: Order, val_fn: Function);
  /**
   * @param val_fn Evaluates the current target. i.e. function(target) return target.Health end
   */
  OverrideMode(this: void, name: string, order: Order, val_fn: Function);
  ForceTarget(Target?: AIHeroClient);
  GetForcedTarget(): AIHeroClient | null;
  GetValidTargets(
    maxRange: number,
    enemies?: AIHeroClient[] | null,
    checkMissileBlocks?: boolean | null
  );
  SelectTargetForMode(enemies: AIHeroClient[], mode: string): AIHeroClient;
  GetTargetFromList(
    possibleTargets: AIHeroClient[],
    checkMissileBlocks?: boolean
  ): AIHeroClient;
  GetTarget(
    maxRange?: number | null,
    checkMissileBlocks?: boolean
  ): AIHeroClient;
  SortTargetsForMode(enemies: AIHeroClient[], mode: string): AIHeroClient[];
  GetTargetsFromList(
    possibleTargets: AIHeroClient[],
    checkMissileBlocks?: boolean
  ): AIHeroClient[];
  GetTargets(
    maxRange?: number | null,
    checkMissileBlocks?: boolean
  ): AIHeroClient[];
  GetTrueAutoAttackRange(Source: AIBaseClient, Target: AttackableUnit);
  /**
   * @param maxRange Can be -1
   */
  IsValidTarget(o: GameObject, maxRange?: number | null, from?: Vector);
  IsValidAutoRange(Target: GameObject, Source?: AIBaseClient);
  HasUndyingBuff(Target: AIBaseClient, extraTime?: number);
}
