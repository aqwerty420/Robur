/** @noSelf **/
interface Orbwalker {
  /**
   * Use When You'll Kill Minion With Spell and Dont Want Orb To Last Hit
   */
  IgnoreMinion(obj: AttackableUnit): void;
  IsIgnoringMinion(obj: AttackableUnit): boolean;
  StopIgnoringMinion(obj: AttackableUnit): void;
  /**
   * [handle1] = true, [handle2] = true, etc
   */
  GetIgnoredMinions(): LuaTable<Handle_t, boolean>;
  /**
   * @Returns if we already attacked a minion with intent to last hit (don't cast on that minion)
   */
  IsLasthitMinion(obj: GameObject): boolean;

  GetMode(): OrbwalkerMode;
  GetTarget(): GameObject | null;
  GetLastTarget(): AttackableUnit | null;
  BlockMove(value: boolean): void;
  IsMovingDisabled(): boolean;
  BlockAttack(value: boolean): void;
  IsAttackingDisabled(): boolean;
  IsAttackReady(): boolean;
  IsWindingUp(): boolean;
  CanMove(): boolean;
  CanAttack(): boolean;
  CanCast(): boolean;
  /**
   * Forces Orb To Move To This Position. Use Orbwalker.MoveTo(nil) to reset. WARNING! IMPROPER USAGE MIGHT MAKE ORB STUCK!
   */
  MoveTo(position: Vector): void;
  /**
   * Useful for Custom Modes etc
   */
  Move(position: Vector): void;
  /**
   * Useful for Custom Modes etc
   */
  Attack(target: AttackableUnit): void;
  /**
   * Useful for Custom Modes etc
   */
  ResetAttack(): void;
  /**
   * Kites [target] Moving Towards [position]. Useful for Custom Modes etc
   */
  Orbwalk(
    position: Vector,
    target?: AttackableUnit | null,
    orbMode?: string
  ): void;
  /**
   * Seconds Passed Since Last Attack Start
   */
  TimeSinceLastAttack(): number;
  /**
   * Seconds Passed Since Last Attack Request
   */
  TimeSinceLastAttackOrder(): number;
  /**
   * Seconds Passed Since Last Move Start
   */
  TimeSinceLastMove(): number;
  /**
   * Seconds Passed Since Last Move Request
   */
  TimeSinceLastMoveOrder(): number;
  GetTrueAutoAttackRange(source: AIBaseClient, target?: AttackableUnit): number;
  GetTrueAutoAttackMissileSpeed(): number;
  /**
   * Only For Minions, For Other Objects use DamageLib.GetAutoAttackDamage
   */
  GetAutoAttackDamage(minion: AttackableUnit): number;
  /**
   * Returns if Object is being attacked by a turret
   */
  HasTurretTargetting(obj: AttackableUnit): boolean;
}
