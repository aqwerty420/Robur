// OWN

declare const enum AllyOrEnemy {
  ally = 'ally',
  enemy = 'enemy',
}

declare const enum OtherTeam {
  all = 'all',
  neutral = 'neutral',
  no_team = 'no_team',
}

type Team = AllyOrEnemy | OtherTeam;
