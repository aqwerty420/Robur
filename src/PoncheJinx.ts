/*

TO_DO:

R
Wave Clear

*/

if (Player.CharName != 'Jinx') {
  // eslint-disable-next-line @typescript-eslint/ban-ts-comment
  // @ts-ignore
  return false;
}

const Core = _G.CoreEx;
const ObjectManager = Core.ObjectManager;
const Game = Core.Game;
const Enums = Core.Enums;
const SpellSlots = Enums.SpellSlots;
const Events = Enums.Events;

const Libs = _G.Libs;
const Orbwalker = Libs.Orbwalker;
const Menu = Libs.NewMenu;
const SpellLib = Libs.Spell;
const HealthPred = Libs.HealthPred;
const TargetSelector = Libs.TargetSelector();

let fishbonesStack = 0;
let fishbonesRange = 525;
let isFishBones = true;
let powPowRange = 600;

const qInput: PredictionInput = {
  Slot: SpellSlots.Q,
};

const Q = SpellLib.Active(qInput);

const wInput = {
  Slot: SpellSlots.W,
  Range: 1500,
  Speed: 3300,
  Delay: 0,
  Radius: 120,
  Type: SpellType.Linear,
  UseHitbox: true,
  Collisions: { WindWall: true, Minions: true },
};

const W = SpellLib.Skillshot(wInput);

const eInput = {
  Slot: SpellSlots.E,
  Range: 1120,
  Speed: 1850,
  Delay: 0.9, // 0.4 + 0.5
  Radius: 115,
  Type: SpellType.Circular,
  UseHitbox: false,
  Collisions: { WindWall: true },
};

const E = SpellLib.Skillshot(eInput);

const rInput = {
  Slot: SpellSlots.R,
  Range: math.huge,
  Speed: 1700, // 2200
  Delay: 0.6,
  Radius: 280,
  Type: SpellType.Circular,
  UseHitbox: false,
  Collisions: { WindWall: true },
};

const R = SpellLib.Skillshot(rInput);

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
    id: Events.OnGapclose,
    callback: OnGapclose,
  },
  {
    id: Events.OnHeroImmobilized,
    callback: OnHeroImmobilized,
  },
];

const rModes = new LuaTable();
rModes.set(1, 'Out of AA range');
rModes.set(2, 'Min/Max distance');
rModes.set(3, 'Always');

const wModes = new LuaTable();
wModes.set(1, 'Out of AA range');
wModes.set(2, 'Min. distance');
wModes.set(3, 'Always');

const hitchances = new LuaTable();
hitchances.set(1, 'Collision');
hitchances.set(2, 'Out Of Range');
hitchances.set(3, 'Very Low');
hitchances.set(4, 'Low');
hitchances.set(5, 'Medium');
hitchances.set(6, 'High');
hitchances.set(7, 'Very High');
hitchances.set(8, 'Dashing');
hitchances.set(9, 'Immobile');

function InitLog(): void {
  // eslint-disable-next-line @typescript-eslint/ban-ts-comment
  // @ts-ignore
  module('PoncheJinx', package.seeall, log.setup);
  // eslint-disable-next-line @typescript-eslint/ban-ts-comment
  // @ts-ignore
  clean.module('PoncheJinx', clean.seeall, log.setup);
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
  Menu.RegisterMenu('PoncheJinx', 'PoncheJinx', function () {
    Menu.Text('v1.0', true);
    Menu.NewTree('combo', 'Combo', function () {
      Menu.Checkbox('qCombo', 'Use [Q]', true);
      Menu.Checkbox('wCombo', 'Use [W]', true);
      Menu.Dropdown('wComboHit', 'Hitchance', 4, hitchances);
      Menu.Checkbox('eCombo', 'Use [E]', true);
      Menu.Dropdown('eComboHit', 'Hitchance', 6, hitchances);
      //Menu.Checkbox('rCombo', 'Use [R]', true);
    });
    Menu.NewTree('harass', 'Harass', function () {
      Menu.Checkbox('qHarass', 'Use [Q]', true);
      Menu.Slider('qHarassMana', 'Min. Mana % ', 40, 0, 100, 5);
      Menu.Checkbox('wHarass', 'Use [W]', true);
      Menu.Dropdown('wHarassHit', 'Hitchance', 5, hitchances);
      Menu.Slider('wHarassMana', 'Min. Mana % ', 40, 0, 100, 5);
      Menu.Checkbox('eHarass', 'Use [E]', true);
      Menu.Dropdown('eHarassHit', 'Hitchance', 7, hitchances);
      Menu.Slider('eHarassMana', 'Min. Mana % ', 0, 0, 100, 5);
    });
    Menu.NewTree('lastHit', 'Last Hit', function () {
      Menu.Checkbox('qLastHit', 'Use [Q]', true);
      Menu.Text('Just switch back to Fishbones');
    });
    Menu.NewTree('qConfig', '[Q] Config', function () {
      Menu.Checkbox('powPowFullStack', 'Switch full stack', false);
      Menu.Checkbox('powPowAoe', 'Switch for AOE', true);
      Menu.Slider('aoeCount', 'Min. Hitcount ', 2, 1, 3, 1);
      Menu.Slider('aoeRadius', 'AOE Radius ', 300, 100, 300, 50);
      Menu.Slider('overSwap', 'Anti Overswap', 60, 0, 150, 10);
    });
    Menu.NewTree('wConfig', '[W] Config', function () {
      Menu.Dropdown('wMode', 'Cast mode: ', 1, wModes);
      Menu.Slider('wMinRange', 'Min. distance', 900, 0, wInput.Range, 50);
    });
    Menu.NewTree('eConfig', '[E] Config', function () {
      Menu.Checkbox('eOnGapclose', 'Auto on gapclose', true);
      Menu.NewTree('eOnEnemyGap', 'On enemy gapclose:', function () {
        for (const enemyName of enemiesName) {
          Menu.Checkbox('eOnGap' + enemyName, enemyName, true);
        }
      });
      Menu.Checkbox('eOnCC', 'Auto on CC', true);
      Menu.Slider('eCCDuration', 'Min. CC duration', 0.4, 0, 2, 0.1);
    });
    Menu.NewTree('rConfig', '[R] Config', function () {
      Menu.Checkbox('rAuto', 'Auto [R]', true);
      Menu.Dropdown('rHit', 'Hitchance', 5, hitchances);
      Menu.Dropdown('rMode', 'Cast mode: ', 1, rModes);
      Menu.Slider('rMinRange', 'Min. distance', 1400, 0, 3000, 100);
      Menu.Slider('rMaxRange', 'Max. distance', 4000, 3000, 6000, 100);
    });
  });
}

function InitEvents(): void {
  const eventManager = _G.CoreEx.EventManager;
  for (let i = 0; i < events.length; i++) {
    eventManager.RegisterCallback(events[i].id, events[i].callback);
  }
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

function OnGapclose(source: AIHeroClient, dash: DashInstance): void {
  if (
    Menu.Get('eOnGapclose') &&
    source.IsHero &&
    source.IsEnemy &&
    source.IsValid &&
    Menu.Get('eOnGap' + source.CharName) &&
    E.IsReady() &&
    E.GetManaCost() <= Player.Mana
  ) {
    const paths = dash.GetPaths();
    const endPos = paths[paths.length - 1].EndPos;
    if (endPos.Distance(Player.Position) <= eInput.Range) {
      E.Cast(endPos);
      return;
    }
  }
}

function OnHeroImmobilized(
  source: AIHeroClient,
  endTime: number,
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  isStasis: boolean
): void {
  if (
    Menu.Get('eOnCC') &&
    source.IsEnemy &&
    source.IsValid &&
    E.IsReady() &&
    E.GetManaCost() <= Player.Mana &&
    Menu.Get('eCCDuration') <= endTime &&
    E.CanCast(source)
  ) {
    E.Cast(source);
    return;
  }
}

function OnDraw(): void {
  Core.Renderer.DrawCircle3D(Player.Position, powPowRange, 10, 10);
}

function GetAoeCount(target: AIHeroClient, enemies: AIHeroClient[]): number {
  let count = 0;
  const radius = Menu.Get('aoeRadius');
  for (let i = 0; i < enemies.length; i++) {
    if (
      target.Name != enemies[i].Name &&
      target.Position.Distance(enemies[i].Position) < radius
    ) {
      count++;
    }
  }
  return count;
}

function ShouldSwap(target: AIHeroClient, enemies: AIHeroClient[]): boolean {
  const distanceTarget = Player.Position.Distance(target.Position);
  //const isInPowPowRange = distanceTarget < powPowRange + target.BoundingRadius;
  const isInFishBonesRange =
    distanceTarget < fishbonesRange + target.BoundingRadius;
  const notInOverswaprange =
    distanceTarget < 525 + target.BoundingRadius - Menu.Get('overSwap');
  const isFullStack = fishbonesStack === 3;
  const canAoe = GetAoeCount(target, enemies) > Menu.Get('aoeCount') - 1;
  if (isFishBones) {
    return (
      !isInFishBonesRange /*&& isInPowPowRange*/ ||
      (Menu.Get('powPowFullStack') && isFullStack) ||
      (Menu.Get('powPowAoe') && canAoe)
    );
  }
  return !canAoe && !isFullStack && notInOverswaprange;
}

function GetWDelay(): number {
  return 0.6 - ((Player.AttackSpeedMod - 1) / 25) * 2;
}

function tryQ(enemies: AIHeroClient[]): boolean {
  if (!Q.IsReady()) return false;
  const target = TargetSelector.GetTarget(powPowRange, true);
  if (ShouldSwap(target ? target : enemies[0], enemies)) return Q.Cast();
  return false;
}

function tryW(hitchance: keyof Enums_HitChance): boolean {
  if (!W.IsReady() || W.GetManaCost() > Player.Mana) return false;
  const target = TargetSelector.GetTarget(wInput.Range, true);
  if (!target) return false;
  wInput.Delay = GetWDelay();
  const WCast = SpellLib.Skillshot(wInput);
  switch (Menu.Get('wMode')) {
    case 0: {
      if (target.Position.Distance(Player.Position) > powPowRange) {
        return WCast.CastOnHitChance(target, hitchance);
      }
      break;
    }
    case 1: {
      if (target.Position.Distance(Player.Position) > Menu.Get('wMinRange')) {
        return WCast.CastOnHitChance(target, hitchance);
      }
      break;
    }
    case 2:
      return WCast.CastOnHitChance(target, hitchance);
    default:
      break;
  }
  return false;
}

function tryE(
  enemies: AIHeroClient[],
  hitchance: keyof Enums_HitChance
): boolean {
  if (!E.IsReady || E.GetManaCost() > Player.Mana) return false;
  for (let i = 0; i < enemies.length; i++) {
    if (E.CastOnHitChance(enemies[i], hitchance)) return true;
  }
  return false;
}

function tryR(): boolean {
  if (!R.IsReady() || R.GetManaCost() > Player.Mana) return false;
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  for (const [key, obj] of pairs(
    ObjectManager.Get(AllyOrEnemy.Enemy, ObjectType.Heroes)
  )) {
    const enemy = obj as AIHeroClient;
    if (TargetSelector.IsValidTarget(enemy)) {
      const timeToHit =
        rInput.Delay + Player.Distance(enemy.Position) / rInput.Speed;
      const health = HealthPred.GetHealthPrediction(enemy, timeToHit, false);
      if (R.GetDamage(enemy) < health[0]) continue;
      switch (Menu.Get('rMode')) {
        case 0: {
          if (enemy.Distance(Player.Position) > powPowRange) {
            return R.CastOnHitChance(enemy, Menu.Get('rHit'));
          }
          break;
        }
        case 1: {
          const distance = enemy.Distance(Player.Position);
          if (
            distance > Menu.Get('rMinRange') &&
            distance < Menu.Get('rMaxRange')
          ) {
            return R.CastOnHitChance(enemy, Menu.Get('rHit'));
          }
          break;
        }
        case 2: {
          return R.CastOnHitChance(enemy, Menu.Get('rHit'));
        }
        default:
          break;
      }
    }
  }
  return false;
}

function Combo(enemies: AIHeroClient[]): void {
  if (Menu.Get('eCombo')) {
    if (tryE(enemies, Menu.Get('eComboHit'))) return;
  }
  if (Menu.Get('qCombo')) {
    if (tryQ(enemies)) return;
  }
  if (Menu.Get('wCombo')) {
    if (tryW(Menu.Get('wComboHit'))) return;
  }
}

function HasMana(minPercent: number): boolean {
  return Player.ManaPercent > minPercent;
}

function Harass(enemies: AIHeroClient[]): void {
  if (Menu.Get('eHarass') && HasMana(Menu.Get('eHarassMana'))) {
    if (tryE(enemies, Menu.Get('eHarassHit'))) return;
  }
  if (Menu.Get('qHarass')) {
    if (
      !isFishBones &&
      (enemies.length === 0 || !HasMana(Menu.Get('qHarassMana'))) &&
      Q.IsReady()
    ) {
      if (Q.Cast()) return;
    } else if (HasMana(Menu.Get('qHarassMana')) && enemies.length > 0) {
      if (tryQ(enemies)) return;
    }
  }
  if (Menu.Get('wHarass') && HasMana(Menu.Get('wHarassMana'))) {
    if (tryW(Menu.Get('wHarassHit'))) return;
  }
}

function HasStatik(): boolean {
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  for (const [key, item] of pairs(Player.Items)) {
    if (item && item.ItemId === 3094) {
      return true;
    }
  }
  return false;
}

function LastHit(): void {
  if (Menu.Get('qLastHit') && Q.IsReady() && !isFishBones) Q.Cast();
}

function Auto(): boolean {
  if (Menu.Get('rAuto')) {
    return tryR();
  }
}

function UpdateStats(): void {
  const qLevel = Player.GetSpell(SpellSlots.Q).Level;
  fishbonesRange = 525;
  powPowRange = qLevel * 25 + 600;
  const fishBonesBuff = Player.GetBuff('jinxqramp');
  if (fishBonesBuff) {
    fishbonesStack = fishBonesBuff.Count;
  }
  const statikBuff = Player.GetBuff('itemstatikshankcharge');
  if (HasStatik() && statikBuff && statikBuff.Count === 100) {
    fishbonesRange += 150;
    powPowRange += 150;
  }
  isFishBones = !Player.GetBuff('JinxQ');
}

function OnTick(): void {
  if (
    Player.IsDead ||
    Player.IsRecalling ||
    !Player.CanCast ||
    Player.IsCasting ||
    Game.IsMinimized() ||
    Game.IsChatOpen()
  )
    return;

  UpdateStats();

  const enemies = GetValidNearbyHeroes(AllyOrEnemy.Enemy);

  if (Auto()) return;

  const orbwalkerMode = Orbwalker.GetMode();

  switch (orbwalkerMode) {
    case OrbwalkerMode.Combo: {
      if (enemies.length === 0) return;
      Combo(enemies);
      break;
    }
    case OrbwalkerMode.Harass: {
      Harass(enemies);
      break;
    }
    case OrbwalkerMode.Lasthit: {
      LastHit();
      break;
    }
    case OrbwalkerMode.Waveclear: {
      //statements;
      break;
    }
    default:
      break;
  }
}

OnLoad = () => {
  InitLog();
  InitMenu();
  InitEvents();
  return true;
};

// eslint-disable-next-line prettier/prettier
export { };
