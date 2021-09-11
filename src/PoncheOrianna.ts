/*

TO_DO NEXT:

R Combo Kill
Harass mana slider
Spell Lane Clear
Spell Last Hit + Tear farm
QR spell cancel

*/

if (Player.CharName != 'Orianna') {
  // eslint-disable-next-line @typescript-eslint/ban-ts-comment
  // @ts-ignore
  return false;
}

/*
_G.CoreEx.AutoUpdate(
  'https://raw.githubusercontent.com/aqwerty420/Robur/main/PoncheOrianna.lua',
  '1.1.0'
);
*/

const Core = _G.CoreEx;
const ObjectManager = Core.ObjectManager;
const Game = Core.Game;
const Geometry = Core.Geometry;
const Enums = Core.Enums;
const SpellSlots = Enums.SpellSlots;
const Events = Enums.Events;

const Libs = _G.Libs;
const Orbwalker = Libs.Orbwalker;
const Menu = Libs.NewMenu;
const SpellLib = Libs.Spell;
const TargetSelector = Libs.TargetSelector();

const ballBuffNames: string[] = [
  'orianaghostself',
  'orianaghost',
  'orianaredactshield',
];
//const ballSelfBuffName = 'orianaghostself';
//const ballBuffGainName = 'orianaredactshield';
//const ballAllyBuffName = 'orianaghost';
const ballObjName = 'TheDoomBall';
const ballMissileNames: string[] = ['OrianaIzuna', 'OrianaRedact'];

const qRange = 825;
const qSpeed = 1400;
const ballRadius = 80;
const rRadius = 400;
const baseDelay = 0.25;

const mathHuge = _G.math.huge;

let ballObj: AIBaseClient = Player;
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
  Collisions: { WindWall: true },
};

const Q = SpellLib.Skillshot(qInput);

const wInput = {
  Slot: SpellSlots.W,
  Range: 0,
  Speed: mathHuge,
  Delay: baseDelay,
  Radius: 225,
  Type: SpellType.Circular,
  UseHitbox: false,
};

const W = SpellLib.Active(wInput);

const eInput = {
  Slot: SpellSlots.E,
  Range: 1120,
  Speed: 1850,
  Delay: baseDelay,
  Radius: ballRadius,
  Type: SpellType.Linear,
  UseHitbox: true,
  Collisions: { WindWall: true },
};

const E = SpellLib.Targeted(eInput);

const rInput = {
  Slot: SpellSlots.R,
  Range: 0,
  Speed: mathHuge,
  Delay: 0.5,
  Radius: rRadius,
  Type: SpellType.Circular,
  UseHitbox: false,
};

const R = SpellLib.Active(rInput);

const qrInput = {
  Slot: SpellSlots.Q,
  Range: qRange,
  Speed: qSpeed,
  Delay: baseDelay, // WIP could maybe add /or use rDelay
  Radius: rRadius,
  Type: SpellType.Circular,
  UseHitbox: false,
  Collisions: { WindWall: true },
};

const QR = SpellLib.Skillshot(qrInput);

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
  {
    id: Events.OnInterruptibleSpell,
    callback: OnInterruptibleSpell,
  },
  {
    id: Events.OnGapclose,
    callback: OnGapclose,
  },
  {
    id: Events.OnBuffGain,
    callback: OnBuffGain,
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
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  for (const [key, obj] of pairs(enemies)) {
    const enemyName = obj.AsHero.CharName;
    if (!enemiesName.includes(enemyName)) enemiesName.push(enemyName);
    enemiesCount++;
  }
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  for (const [key, obj] of pairs(allies)) {
    if (obj.IsMe) continue;
    const allyName = obj.AsHero.CharName;
    if (!alliesName.includes(allyName)) alliesName.push(allyName);
  }
  if (enemiesCount === 0) enemiesCount = 1;
  Menu.RegisterMenu('PoncheOrianna', 'PoncheOrianna', function () {
    Menu.NewTree('q', 'Q Options', function () {
      Menu.Checkbox('qCombo', 'Combo', true);
      Menu.Checkbox('qHarass', 'Harass', true);
      Menu.Checkbox('eToQ', 'E to Q', true);
      Menu.Slider('eToQDistance', 'Min dist EQ', 350, 0, 600, 50);
      Menu.Checkbox('qDraw', 'Draw Range', true);
    });
    Menu.NewTree('w', 'W Options', function () {
      Menu.Checkbox('wCombo', 'Combo', true);
      Menu.Checkbox('wHarass', 'Harass', true);
      Menu.Checkbox('wFlee', 'Flee', true);
      Menu.Checkbox('wAuto', 'Auto', false);
    });
    Menu.NewTree('e', 'E Options', function () {
      Menu.Checkbox('eCombo', 'Combo', true);
      Menu.Checkbox('eHarass', 'Harass', false);
      Menu.Checkbox('eFlee', 'Flee', true);
      Menu.Checkbox('eShieldSelf', 'Protect self', true);
      Menu.NewTree('eProtectList', 'Protect ally :', function () {
        for (const allyName of alliesName) {
          Menu.Checkbox('eShield' + allyName, allyName, true);
        }
      });
      Menu.Checkbox('eShieldAllies', 'Protect allies', true);
      Menu.Checkbox('eDraw', 'Draw Range', false);
    });
    Menu.NewTree('r', 'R Options', function () {
      Menu.Checkbox('rCombo', 'Combo', true);
      Menu.Checkbox('rAuto', 'Auto', true);
      Menu.Slider('rRadius', 'Radius', 390, 300, 400, 5);
      Menu.Checkbox('eToR', 'E to R', true);
      Menu.Checkbox('qToR', 'Q to R', true);
      Menu.NewTree('eWaight', 'Enemy value :', function () {
        for (const enemyName of enemiesName) {
          Menu.Slider('rWeight' + enemyName, enemyName, 1, 1, 3, 1);
        }
      });
      Menu.Slider('rValue', 'Value to cast', 2, 1, enemiesCount * 3, 1);
      Menu.Checkbox('rCancel', 'Use to cancel spell', true);
      Menu.NewTree('SpellToCancel', 'Spell to cancel :', function () {
        Menu.Text('Even ticked a spell will be cancelled', false);
        Menu.Text('only if it is possible', false);
        for (const enemyName of enemiesName) {
          Menu.NewTree(enemyName + 'Cancel', enemyName + ' :', function () {
            Menu.Checkbox(enemyName + 'CancelQ', 'Q', true);
            Menu.Checkbox(enemyName + 'CancelW', 'W', true);
            Menu.Checkbox(enemyName + 'CancelE', 'E', true);
            Menu.Checkbox(enemyName + 'CancelR', 'R', true);
          });
        }
      });
      Menu.Checkbox('rBlock', 'Block manual cast if no hit', true);
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

function RetrieveballObj(): void {
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  for (const [key, obj] of pairs(
    ObjectManager.Get(AllyOrEnemy.Ally, ObjectType.Minions)
  )) {
    if (IsBall(obj)) {
      ballObj = obj as AIBaseClient;
      return;
    }
  }
}

function RetrieveBallBuff(): void {
  if (Player.GetBuff(ballBuffNames[0])) {
    ballObj = Player;
    ballOnSelf = true;
    return;
  }
  const allies = ObjectManager.Get(AllyOrEnemy.Ally, ObjectType.Heroes);
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  for (const [key, obj] of pairs(allies)) {
    const ally = obj.AsHero;
    if (!ally.IsMe && ally.GetBuff(ballBuffNames[1])) {
      ballObj = ally;
      ballOnSelf = false;
    }
  }
}

function IsBall(obj: GameObject): boolean {
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

function OnCreateObject(obj: GameObject): void {
  if (obj.Name === ballMissileNames[0] || obj.Name === ballMissileNames[1]) {
    ballOnSelf = false;
    ballMoving = true;
    ballObj = obj as AIBaseClient;
    return;
  }
  if (IsBall(obj)) {
    ballMoving = false;
    ballObj = obj.AsMinion;
  }
}

function OnBuffGain(obj: GameObject, buff: BuffInst) {
  if (obj.IsMe && buff.Name === ballBuffNames[0]) {
    ballOnSelf = true;
    ballMoving = false;
    ballObj = obj.AsHero;
    return;
  }
  if (obj.IsHero && obj.IsAlly && ballBuffNames[2] === buff.Name) {
    ballMoving = false;
    ballOnSelf = obj.IsMe;
    ballObj = obj.AsHero;
  }
}

function OnCastSpell(args: OnCastSpellArgs): void {
  if (Menu.Get('rBlock') && args.Slot === SpellSlots.R) {
    const enemies = GetValidNearbyHeroes(AllyOrEnemy.Enemy);
    for (let i = 0; i < enemies.length; i++) {
      if (
        IsInRange(
          enemies[i],
          Menu.Get('rRadius'),
          ballObj.Position,
          rInput.Delay
        )
      ) {
        return;
      }
    }
    args.Process = false;
  }
}

function OnProcessSpell(source: AIHeroClient, spell: SpellCast): void {
  if (
    !ballMoving &&
    source.IsHero &&
    source.IsEnemy &&
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
    }
  }
}

function IsToCancel(enemyName: string, slot: number): boolean {
  if (slot === SpellSlots.Q) {
    return Menu.Get(enemyName + 'CancelQ');
  }
  if (slot === SpellSlots.W) {
    return Menu.Get(enemyName + 'CancelW');
  }
  if (slot === SpellSlots.E) {
    return Menu.Get(enemyName + 'CancelE');
  }
  if (slot === SpellSlots.R) {
    return Menu.Get(enemyName + 'CancelR');
  }
}

function OnInterruptibleSpell(
  source: AIHeroClient,
  spell: SpellCast,
  danger: number,
  endTime: number,
  canMove: boolean
): void {
  if (
    Menu.Get('rCancel') &&
    !ballMoving &&
    source.IsEnemy &&
    source.IsHero &&
    IsToCancel(source.CharName, spell.Slot) &&
    ballObj.Distance(source.Position) <= Menu.Get('rRadius')
  ) {
    if (!canMove) {
      R.Cast();
    } else if (
      source.FastPrediction(rInput.Delay).Distance(ballObj) <=
      Menu.Get('rRadius')
    ) {
      R.Cast();
    }
  }
}

function OnGapclose(source: AIHeroClient, dash: DashInstance): void {
  if (
    Menu.Get('eToR') &&
    (Menu.Get('rAuto') ||
      (Menu.Get('rCombo') && Orbwalker.GetMode() === OrbwalkerMode.Combo)) &&
    source.IsAlly &&
    source.IsHero &&
    E.CanCast(source)
  ) {
    const enemies = GetValidNearbyHeroes(AllyOrEnemy.Enemy);
    const dashPath = dash.GetPaths();
    const lastPos = dashPath[dashPath.length - 1].EndPos;
    if (getValuePos(enemies, dash.EndDelay, lastPos) >= Menu.Get('rValue'))
      E.Cast(source);
  }
}

function OnDraw(): void {
  if (!ballMoving) {
    if (Menu.Get('ballDraw')) {
      const drawBallPos = Geometry.Vector(ballObj.Position);
      const t = Core.Game.GetTime() % 0.8;
      drawBallPos.y += 100;
      drawBallPos.y += t < 0.4 ? -50.0 * t : -(20.0 - (t - 0.4) * 50.0);
      Core.Renderer.DrawCircle3D(drawBallPos, 100, 10, 10);
    }
    if (Menu.Get('rDraw')) {
      Core.Renderer.DrawCircle3D(ballObj.Position, rInput.Radius, 10);
    }
  }
  if (Menu.Get('qDraw')) {
    Core.Renderer.DrawCircle3D(Player.Position, qInput.Range, 10);
  }
  if (Menu.Get('eDraw')) {
    Core.Renderer.DrawCircle3D(Player.Position, eInput.Range, 10);
  }
}

function IsInRange(
  enemy: AIHeroClient,
  range: number,
  position: Vector,
  delay?: number
): boolean {
  if (enemy.Position.Distance(position) > range) return false;
  if (!delay) return true;
  const enemyPos = enemy.FastPrediction(delay);
  return enemyPos.Distance(position) <= range;
}

function getValuePos(
  enemies: AIHeroClient[],
  delay: number,
  position: Vector
): number {
  let count = 0;
  for (let i = 0; i < enemies.length; i++) {
    const enemy = enemies[i].AsHero;
    if (IsInRange(enemy, Menu.Get('rRadius'), position, delay)) {
      count += Menu.Get('rWeight' + enemy.CharName);
    }
  }
  return count;
}

function tryQ(enemies: AIHeroClient[]): boolean {
  if (!Q.IsReady() || Q.GetManaCost() > Player.Mana) return false;
  if (
    Menu.Get('eToQ') &&
    E.IsReady() &&
    Q.GetManaCost() + E.GetManaCost() <= Player.Mana
  ) {
    let isBallFar = true;
    for (let i = 0; i < enemies.length; i++) {
      if (
        enemies[i].Position.Distance(ballObj.Position) <
        enemies[i].Position.Distance(Player.Position) + Menu.Get('eToQDistance')
      ) {
        isBallFar = false;
        break;
      }
    }
    if (isBallFar) {
      return E.Cast(Player);
    }
  }
  Q.SetRangeCheckObj(ballObj);
  if (enemies.length > 1) {
    const castPos = Q.GetBestLinearCastPos(enemies);
    if (castPos[1] > 1) {
      return Q.Cast(castPos[0]);
    }
  }
  const target = Q.GetTarget();
  if (!target) return false;
  return Q.Cast(target);
}

function tryW(enemies: AIHeroClient[]): boolean {
  if (!W.IsReady() || W.GetManaCost() > Player.Mana) return false;
  for (let i = 0; i < enemies.length; i++) {
    if (IsInRange(enemies[i], wInput.Radius, ballObj.Position, baseDelay)) {
      return W.Cast();
    }
  }
  return false;
}

function tryE(enemies: AIHeroClient[]): boolean {
  if (!E.IsReady || E.GetManaCost() > Player.Mana) return false;
  for (let i = 0; i < enemies.length; i++) {
    const reachDelay =
      ballObj.Position.Distance(enemies[i]) / eInput.Speed + baseDelay;
    const enemyPos = enemies[i].FastPrediction(reachDelay);
    const distance = enemyPos.LineDistance(
      ballObj.Position,
      Player.Position,
      false
    );
    if (distance <= eInput.Radius) {
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
    const reachDelay =
      ballObj.Position.Distance(allies[i]) / eInput.Speed + baseDelay;
    const allyPosition = allies[i].FastPrediction(reachDelay);
    for (let j = 0; j < enemies.length; j++) {
      const enemy = enemies[j].AsHero;
      if (IsInRange(enemy, Menu.Get('rRadius'), allyPosition, reachDelay)) {
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
  QR.SetRangeCheckObj(ballObj);
  const castPos = QR.GetBestCircularCastPos(enemies);
  for (let j = 0; j < enemies.length; j++) {
    const enemy = enemies[j].AsHero;
    if (
      IsInRange(
        enemy,
        Menu.Get('rRadius'),
        castPos[0],
        baseDelay + ballObj.Distance(castPos[0]) / qSpeed
      )
    ) {
      count += Menu.Get('rWeight' + enemy.CharName);
    }
  }
  return $multi(castPos[0], count);
}

function tryR(allies: AIHeroClient[], enemies: AIHeroClient[]): boolean {
  if (!R.IsReady() || R.GetManaCost() > Player.Mana) return false;
  const rResult = getValuePos(enemies, rInput.Delay, ballObj.Position);
  const qrResult = getQR(enemies);
  const erResult = getBestER(allies, enemies);

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
    if (tryE(enemies)) return;
  }
}

function Flee(): void {
  if (!ballOnSelf) {
    if (Menu.Get('eFlee') && E.IsReady() && E.GetManaCost() <= Player.Mana) {
      E.Cast(Player);
    }
  } else {
    if (Menu.Get('wFlee') && W.IsReady() && W.GetManaCost() <= Player.Mana) {
      W.Cast();
    }
  }
}

function OnTick(): void {
  if (
    ballMoving ||
    Player.IsDead ||
    Player.IsRecalling ||
    !Player.CanCast ||
    Game.IsMinimized() ||
    Game.IsChatOpen()
  )
    return;

  const allies = GetValidNearbyHeroes(AllyOrEnemy.Ally);
  const enemies = GetValidNearbyHeroes(AllyOrEnemy.Enemy);

  const orbwalkerMode = Orbwalker.GetMode();

  if (orbwalkerMode === OrbwalkerMode.Flee) {
    return Flee();
  }

  if (enemies.length === 0) return;

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
  RetrieveballObj();
  RetrieveBallBuff();
  return true;
};

// eslint-disable-next-line prettier/prettier
export { };
