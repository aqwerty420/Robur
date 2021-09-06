interface AttackableUnit extends GameObject {
  readonly Health: number;
  readonly MaxHealth: number;
  readonly HealthPercent: number;
  readonly Mana: number;
  readonly MaxMana: number;
  readonly ManaPercent: number;
  readonly ShieldAll: number;
  readonly ShieldAD: number;
  readonly ShieldAP: number;
  readonly FirstResource: number;
  readonly FirstResourceMax: number;
  readonly SecondResource: number;
  readonly SecondResourceMax: number;
  readonly IsTargetable: boolean;
  readonly IsInvulnerable: boolean;
  readonly IsAlive: boolean;
  readonly Owner: AIHeroClient;
}
