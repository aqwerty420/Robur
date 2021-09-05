// OWN

declare const enum CollisionsTypes {
  Heroes = 'Heroes',
  Minions = 'Minions',
  WindWall = 'WindWall',
  Wall = 'Wall',
}

interface CollisionsPossible {
  Minions?: boolean;
  WindWall?: boolean;
  Wall?: boolean;
}
