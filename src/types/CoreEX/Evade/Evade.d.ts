interface Evade {
  /**
   * @returns true if Evade is Enabled
   */
  IsEnabled(): boolean;
  /**
   * @returns true if Evade is currently dodging a spell
   */
  IsEvading(): boolean;
  /**
   * @returns true if Evade is in "DodgeOnlyDangerous" mode
   */
  IsDodgeOnlyDangerous(): boolean;
  /**
   * @returns true if any spells will hit [hero] in [time_in_secs] seconds
   */
  IsAboutToHit(timeInSec: number, hero: AIHeroClient): boolean;
  IsSpellShielded(hero: AIHeroClient): boolean;
  GetBestWalkPosition(
    position: Vector,
    speed: number,
    delay_in_secs: number
  ): Vector | null;
  GetBestDashPosition(
    position: Vector,
    speed: number,
    delay_in_secs: number,
    range: number,
    fixed_range: boolean
  ): Vector | null;
  GetBestBlinkPosition(
    position: Vector,
    delay_in_secs: number,
    range: number,
    fixed_range: boolean
  ): Vector | null;
  IsPointSafe(position: Vector): boolean;
  IsPathSafe(position: Vector, speed: number, delay_in_secs: number): boolean;
  IsBlinkSafe(position: Vector, delay_in_secs: number): boolean;
  /**
   * @returns All detected Skills
   */
  GetDetectedSkillshots(): DetectedSpell[];
  /**
   * @returns All Detected skills enabled in Evade
   */
  GetEnabledSkillshots(): DetectedSpell[];
  /**
   * @returns Skills Player is inside
   */
  GetDangerousSkillshots(): DetectedSpell[];
}
