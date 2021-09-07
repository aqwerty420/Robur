/*
TO_DO :

Q AOE not ball on self
QR not ball on self
Harass mana slider
Enemy Spell Cancel
KS
Initiator (Cast E on dashing ally to R)
Spell Lane Clear
Spell Last Hit + Tear farm
Flee (E + W)
Finish Draw

*/

interface EventToRegister {
  id: string;
  // eslint-disable-next-line @typescript-eslint/ban-types
  callback: Function;
}

if (Player.CharName != 'Orianna') {
  // eslint-disable-next-line @typescript-eslint/ban-ts-comment
  // @ts-ignore
  return false;
}

const Core = _G.CoreEx;
const ObjectManager = Core.ObjectManager;
const Game = Core.Game;
//const Input = Core.Input;
const Geometry = Core.Geometry;
const Enums = Core.Enums;
const SpellSlots = Enums.SpellSlots;
const Events = Enums.Events;

const Libs = _G.Libs;
const Orbwalker = Libs.Orbwalker;
const Menu = Libs.NewMenu;
const SpellLib = Libs.Spell;
const TargetSelector = Libs.TargetSelector();

const ballSelfBuffName = 'orianaghostself';
const ballAllyBuffName = 'orianaghost';
const ballObjName = 'TheDoomBall';
const ballMissileNames: string[] = ['OrianaIzuna', 'OrianaRedact'];

//const ballMaxRange = 1250;
const collisions: CollisionsPossible = { WindWall: true, Wall: true };
const qRange = 825;
const qSpeed = 1400;
const ballRadius = 80;
const wRadius = 225;
const eSpeed = 1850;
const rRadius = 415;
const rDelay = 0.5;
const baseDelay = 0.25;

const mathHuge = _G.math.huge;

//const ballDrawAngle = 360;

let ballPosition: Vector = Geometry.Vector();
let ballMoving = false;
let ballOnSelf = false;

const qInput: PredictionInput = {
  Slot: SpellSlots.Q,
  Range: qRange,
  Speed: qSpeed,
  Delay: baseDelay,
  Radius: ballRadius,
  Type: SpellType.Linear,
  UseHitbox: true,
  Collisions: collisions,
};

const Q = SpellLib.Skillshot(qInput);

const W = SpellLib.Active({
  Slot: SpellSlots.W,
  Range: 0,
  Speed: mathHuge,
  Delay: baseDelay,
  Radius: wRadius,
  Type: SpellType.Circular,
  UseHitbox: false,
});

const E = SpellLib.Targeted({
  Slot: SpellSlots.E,
  Range: 1120,
  Speed: eSpeed,
  Delay: baseDelay,
  Radius: ballRadius,
  Type: SpellType.Linear,
  UseHitbox: true,
  Collisions: collisions, // WIP not 100% sure
});

const R = SpellLib.Active({
  Slot: SpellSlots.R,
  Range: 0,
  Speed: mathHuge,
  Delay: rDelay,
  Radius: rRadius,
  Type: SpellType.Circular,
  UseHitbox: false,
  Collisions: collisions,
});

const QR = SpellLib.Skillshot({
  Slot: SpellSlots.Q,
  Range: qRange,
  Speed: qSpeed,
  Delay: baseDelay, // WIP could maybe add /or use rDelay
  Radius: rRadius,
  Type: SpellType.Circular,
  UseHitbox: false,
  Collisions: collisions,
});

const events: EventToRegister[] = [
  {
    id: Events.OnTick,
    callback: OnTick,
  },
  {
    id: Events.OnDraw,
    callback: OnDraw,
  },
  {
    id: Events.OnCreateObject,
    callback: OnCreateObject,
  },
  {
    id: Events.OnCastSpell,
    callback: OnCastSpell,
  },
  {
    id: Events.OnProcessSpell,
    callback: OnProcessSpell,
  },
];

function InitLog(): void {
  // eslint-disable-next-line @typescript-eslint/ban-ts-comment
  // @ts-ignore
  module('PoncheOrianna', package.seeall, log.setup);
  // eslint-disable-next-line @typescript-eslint/ban-ts-comment
  // @ts-ignore
  clean.module('PoncheOrianna', clean.seeall, log.setup);
}

function InitMenu(): void {
  const enemies = ObjectManager.Get(AllyOrEnemy.Enemy, ObjectType.Heroes);
  const enemiesName: string[] = [];
  const allies = ObjectManager.Get(AllyOrEnemy.Ally, ObjectType.Heroes);
  const alliesName: string[] = [];
  let enemiesCount = 0;
  for (const [key, obj] of pairs(enemies)) {
    const enemyName = obj.AsHero.CharName;
    if (!enemiesName.includes(enemyName)) enemiesName.push(obj.AsHero.CharName);
    enemiesCount++;
  }
  for (const [key, obj] of pairs(allies)) {
    if (obj.IsMe) continue;
    const allyName = obj.AsHero.CharName;
    if (!alliesName.includes(allyName)) alliesName.push(obj.AsHero.CharName);
  }
  if (enemiesCount === 0) enemiesCount = 1;
  Menu.RegisterMenu('PoncheOrianna', 'PoncheOrianna', function () {
    Menu.NewTree('q', 'Q Options', function () {
      Menu.Checkbox('qCombo', 'Combo', true);
      Menu.Checkbox('qHarass', 'Harass', true);
      //Menu.Checkbox('eToQ', 'E to Q', true);
      Menu.Checkbox('qKs', 'Kill Steal', true);
      //Menu.Checkbox('qDraw', 'Draw Range', true);
    });
    Menu.NewTree('w', 'W Options', function () {
      Menu.Checkbox('wCombo', 'Combo', true);
      Menu.Checkbox('wHarass', 'Harass', true);
      //Menu.Checkbox('wFlee', 'Flee', true);
      Menu.Checkbox('wKs', 'Kill Steal', true);
      Menu.Checkbox('wAuto', 'Auto', true);
      Menu.Checkbox('wDraw', 'Draw Range', true);
    });
    Menu.NewTree('e', 'E Options', function () {
      Menu.Checkbox('eCombo', 'Combo', true);
      Menu.Checkbox('eHarass', 'Harass', false);
      //Menu.Checkbox('eFlee', 'Flee', true);
      Menu.Checkbox('eKs', 'Kill Steal', true);
      Menu.Checkbox('eShieldSelf', 'Protect self', true);
      Menu.NewTree('eProtectList', 'Protect ally :', function () {
        for (const [key, obj] of pairs(allies)) {
          const ally = obj.AsHero;
          if (!obj.IsMe)
            Menu.Checkbox('eShield' + ally.CharName, ally.CharName, true);
        }
      });
      Menu.Checkbox('eShieldAllies', 'Protect allies', true);
      Menu.Checkbox('eDraw', 'Draw Range', false);
    });
    Menu.NewTree('r', 'R Options', function () {
      Menu.Checkbox('rCombo', 'Combo', true);
      Menu.Checkbox('rKill', 'Kill Steal', true);
      Menu.Checkbox('rAuto', 'Auto', true);
      Menu.Checkbox('eToR', 'E to R', true);
      Menu.Checkbox('qToR', 'Q to R', true);
      Menu.NewTree('eWaight', 'Enemy value :', function () {
        for (const enemyName of enemiesName) {
          Menu.Slider('rWeight' + enemyName, enemyName, 1, 1, 3, 1);
        }
      });
      Menu.Slider('rValue', 'Value to R', 1, 1, enemiesCount * 3, 1);
      //Menu.Checkbox('rCancel', 'Use to cancel spell', true);
      Menu.Checkbox('rBlock', 'Cancel if no hit', true);
      Menu.Checkbox('rDraw', 'Draw Range', true);
    });
    Menu.Checkbox('ballDraw', 'Ball Draw', true);
  });
}

function InitEvents(): void {
  const eventManager = _G.CoreEx.EventManager;
  for (let i = 0; i < events.length; i++) {
    eventManager.RegisterCallback(events[i].id, events[i].callback);
  }
}

function RetrieveBallPosition(): void {
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  for (const [key, obj] of pairs(
    ObjectManager.Get(AllyOrEnemy.Ally, ObjectType.Minions)
  )) {
    if (IsBall(obj)) {
      ballPosition = obj.Position;
      return;
    }
  }
}

function IsBall(obj: GameObject) {
  return obj.IsAlly && obj.Name == ballObjName;
}

function GetValidNearbyHeroes(team: AllyOrEnemy): AIHeroClient[] {
  const heroes: AIHeroClient[] = [];
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  for (const [key, obj] of pairs(
    ObjectManager.GetNearby(team, ObjectType.Heroes)
  )) {
    if (TargetSelector.IsValidTarget(obj)) heroes.push(obj.AsHero);
  }
  return heroes;
}

function SetBallPosition(allies: AIHeroClient[]): void {
  if (Player.GetBuff(ballSelfBuffName)) {
    ballMoving = false;
    ballPosition = Player.Position;
    ballOnSelf = true;
    return;
  }
  for (let i = 0; i < allies.length; i++) {
    if (allies[i].GetBuff(ballAllyBuffName)) {
      ballMoving = false;
      ballPosition = allies[i].Position;
      ballOnSelf = false;
      return;
    }
  }
}

function OnCreateObject(obj: GameObject): void {
  if (obj.Name === ballMissileNames[0] || obj.Name === ballMissileNames[1]) {
    ballOnSelf = false;
    ballMoving = true;
    return;
  }
  if (IsBall(obj)) {
    ballMoving = false;
    ballPosition = obj.Position;
    return;
  }
}

function OnCastSpell(args: OnCastSpellArgs): void {
  if (Menu.Get('rBlock') && args.Slot === SpellSlots.R) {
    const enemies = GetValidNearbyHeroes(AllyOrEnemy.Enemy);
    for (let i = 0; i < enemies.length; i++) {
      if (IsInRange(enemies[i], rRadius, ballPosition, rDelay)) {
        return;
      }
    }
    args.Process = false;
  }
}

function OnProcessSpell(source: AIHeroClient, spell: SpellCast) {
  if (
    !ballMoving &&
    source.IsEnemy &&
    source.IsHero &&
    spell.Target &&
    !spell.IsBasicAttack &&
    spell.Target.IsHero &&
    spell.Target.IsAlly
  ) {
    if (spell.Target.IsMe) {
      if (Menu.Get('eShieldSelf') && E.CanCast(Player)) {
        E.Cast(Player);
      }
      return;
    }
    const target = spell.Target.AsHero;
    if (Menu.Get('eShield' + target.CharName) && E.CanCast(target)) {
      E.Cast(target);
      return;
    }
  }
}

function OnDraw(): void {
  const drawBallPos = Geometry.Vector(ballPosition);
  const t = Core.Game.GetTime() % 0.8;
  drawBallPos.y += 100;
  drawBallPos.y += t < 0.4 ? -50.0 * t : -(20.0 - (t - 0.4) * 50.0);

  if (Menu.Get('ballDraw') && !ballMoving) {
    Core.Renderer.DrawCircle3D(drawBallPos, 100, 10);
  }
}

function IsInRange(
  enemy: AIHeroClient,
  range: number,
  position: Vector,
  delay = 0
): boolean {
  if (enemy.Position.Distance(position) > range) return false;
  if (delay === 0) return true;
  const enemyPos = enemy.FastPrediction(delay);
  return enemyPos.Distance(position) <= range;
}

function getValuePos(enemies: AIHeroClient[], delay: number) {
  let count = 0;
  for (let i = 0; i < enemies.length; i++) {
    const enemy = enemies[i].AsHero;
    if (IsInRange(enemy, rRadius, ballPosition, delay)) {
      count += Menu.Get('rWeight' + enemy.CharName);
    }
  }
  return count;
}

function tryQ(enemies: AIHeroClient[]): boolean {
  if (!Q.IsReady() || Q.GetManaCost() > Player.Mana) return false;
  if (enemies.length > 1 && ballOnSelf) {
    const castPos = Q.GetBestLinearCastPos(enemies);
    if (castPos[1] >= 2) {
      return Q.Cast(castPos[0]);
    }
  }
  const target = Q.GetTarget();
  if (!target) return;
  const result = Libs.Prediction.GetPredictedPosition(
    target,
    qInput,
    ballPosition
  );
  if (result && result.HitChance >= Enums.HitChance.Collision)
    return Q.Cast(result.CastPosition);
  return false;
}

function tryW(enemies: AIHeroClient[]): boolean {
  if (!W.IsReady() || W.GetManaCost() > Player.Mana) return false;
  for (let i = 0; i < enemies.length; i++) {
    if (IsInRange(enemies[i], wRadius, ballPosition, baseDelay)) {
      return W.Cast();
    }
  }
  return false;
}

function tryE(enemies: AIHeroClient[]) {
  if (!E.IsReady || E.GetManaCost() > Player.Mana) return false;
  for (let i = 0; i < enemies.length; i++) {
    const reachDelay = ballPosition.Distance(enemies[i]) / eSpeed + baseDelay;
    const enemyPos = enemies[i].FastPrediction(reachDelay);
    const distance = enemyPos.LineDistance(
      ballPosition,
      Player.Position,
      false
    );
    if (distance <= ballRadius) {
      return E.Cast(Player);
    }
  }
  return false;
}

function getBestER(
  allies: AIHeroClient[],
  enemies: AIHeroClient[]
): LuaMultiReturn<[AIBaseClient | null, number]> {
  if (
    !Menu.Get('eToR') ||
    !E.IsReady() ||
    E.GetManaCost() + R.GetManaCost() > Player.Mana
  )
    return $multi(null, 0);
  let ally: AIHeroClient = null;
  let bestCount = 0;
  for (let i = 0; i < allies.length; i++) {
    let count = 0;
    const reachDelay = ballPosition.Distance(allies[i]) / eSpeed + baseDelay;
    for (let j = 0; j < enemies.length; j++) {
      const enemy = enemies[j].AsHero;
      if (IsInRange(enemy, rRadius, allies[i].Position, reachDelay)) {
        count += Menu.Get('rWeight' + enemy.CharName);
      }
    }
    if (count > bestCount) {
      bestCount = count;
      ally = allies[i];
    }
  }
  return $multi(ally, bestCount);
}

function getQR(
  enemies: AIHeroClient[]
): LuaMultiReturn<[Vector | null, number]> {
  if (
    !Menu.Get('qToR') ||
    !Q.IsReady() ||
    Q.GetManaCost() + R.GetManaCost() > Player.Mana
  )
    return $multi(null, 0);
  let count = 0;
  if (ballOnSelf) {
    const castPos = QR.GetBestCircularCastPos(enemies);
    for (let j = 0; j < enemies.length; j++) {
      const enemy = enemies[j].AsHero;
      if (
        IsInRange(
          enemy,
          rRadius,
          castPos[0],
          baseDelay + ballPosition.Distance(castPos[0]) / qSpeed
        )
      ) {
        count += Menu.Get('rWeight' + enemy.CharName);
      }
    }
    return $multi(castPos[0], count);
  }
  return $multi(null, 0);
}

function tryR(allies: AIHeroClient[], enemies: AIHeroClient[]) {
  if (!R.IsReady() || R.GetManaCost() > Player.Mana) return false;
  const rResult = getValuePos(enemies, rDelay);
  const qrResult = getQR(enemies);
  const erResult = getBestER(allies, enemies);

  print(erResult[1].toString());
  if (
    rResult >= Menu.Get('rValue') &&
    rResult >= qrResult[1] &&
    rResult >= erResult[1]
  ) {
    return R.Cast();
  }
  if (erResult[1] >= Menu.Get('rValue') && erResult[1] >= qrResult[1]) {
    return E.Cast(erResult[0]);
  }
  if (qrResult[1] >= Menu.Get('rValue')) {
    return Q.Cast(qrResult[0]);
  }
  return false;
}

function Auto(allies: AIHeroClient[], enemies: AIHeroClient[]): void {
  if (Menu.Get('rAuto')) {
    if (tryR(allies, enemies)) return;
  }
  if (Menu.Get('wAuto')) {
    if (tryW(enemies)) return;
  }
}

function Combo(allies: AIHeroClient[], enemies: AIHeroClient[]): void {
  if (Menu.Get('rCombo')) {
    if (tryR(allies, enemies)) return;
  }
  if (Menu.Get('qCombo')) {
    if (tryQ(enemies)) return;
  }
  if (Menu.Get('wCombo')) {
    if (tryW(enemies)) return;
  }
  if (Menu.Get('eCombo')) {
    if (tryE(enemies)) return;
  }
}

function Harass(allies: AIHeroClient[], enemies: AIHeroClient[]): void {
  if (Menu.Get('qHarass')) {
    if (tryQ(enemies)) return;
  }
  if (Menu.Get('wHarass')) {
    if (tryW(enemies)) return;
  }
  if (Menu.Get('eHarass')) {
    if (tryW(enemies)) return;
  }
}

function OnTick(): void {
  const allies = GetValidNearbyHeroes(AllyOrEnemy.Ally);
  SetBallPosition(allies);

  if (
    ballMoving ||
    Player.IsDead ||
    Player.IsRecalling ||
    !Player.CanCast ||
    Game.IsMinimized() ||
    Game.IsChatOpen()
  )
    return;

  const enemies = GetValidNearbyHeroes(AllyOrEnemy.Enemy);

  if (enemies.length === 0) return;

  const orbwalkerMode = Orbwalker.GetMode();

  switch (orbwalkerMode) {
    case OrbwalkerMode.Combo: {
      Combo(allies, enemies);
      break;
    }
    case OrbwalkerMode.Harass: {
      Harass(allies, enemies);
      break;
    }
    case OrbwalkerMode.Lasthit: {
      //statements;
      break;
    }
    case OrbwalkerMode.Waveclear: {
      //statements;
      break;
    }
    case OrbwalkerMode.Flee: {
      //statements;
      break;
    }
    case OrbwalkerMode.Nil: {
      Auto(allies, enemies);
      break;
    }
  }
}

OnLoad = () => {
  InitLog();
  InitMenu();
  InitEvents();
  RetrieveBallPosition();
  return true;
};
