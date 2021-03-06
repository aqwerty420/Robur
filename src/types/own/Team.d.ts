// OWN

declare const enum AllyOrEnemy {
  Ally = 'ally',
  Enemy = 'enemy',
}

declare const enum OtherTeam {
  All = 'all',
  Neutral = 'neutral',
  NoTeam = 'no_team',
}

type Team = AllyOrEnemy | OtherTeam;
