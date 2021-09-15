-- Lua Library inline imports
function __TS__ArrayIncludes(self, searchElement, fromIndex)
    if fromIndex == nil then
        fromIndex = 0
    end
    local len = #self
    local k = fromIndex
    if fromIndex < 0 then
        k = len + fromIndex
    end
    if k < 0 then
        k = 0
    end
    for i = k, len do
        if self[i + 1] == searchElement then
            return true
        end
    end
    return false
end

function __TS__ArrayPush(arr, ...)
    local items = {...}
    for ____, item in ipairs(items) do
        arr[#arr + 1] = item
    end
    return #arr
end

local ____exports = {}
local ObjectManager, Game, SpellSlots, Orbwalker, Menu, SpellLib, TargetSelector, fishbonesStack, fishbonesRange, isFishBones, powPowRange, Q, wInput, W, eInput, E, GetValidNearbyHeroes, OnGapclose, OnHeroImmobilized, OnDraw, GetAoeCount, ShouldSwap, GetWDelay, tryQ, tryW, tryE, Combo, Harass, HasStatik, LastHit, UpdateStats, OnTick
function GetValidNearbyHeroes(team)
    local heroes = {}
    for key, obj in pairs(
        ObjectManager.GetNearby(team, "heroes")
    ) do
        if TargetSelector:IsValidTarget(obj) then
            __TS__ArrayPush(heroes, obj.AsHero)
        end
    end
    return heroes
end
function OnGapclose(source, dash)
    if (((((Menu.Get("eOnGapclose") and source.IsHero) and source.IsEnemy) and source.IsValid) and Menu.Get("eOnGap" .. source.CharName)) and E:IsReady()) and (E:GetManaCost() <= Player.Mana) then
        local paths = dash:GetPaths()
        local endPos = paths[#paths].EndPos
        if endPos:Distance(Player.Position) <= eInput.Range then
            E:Cast(endPos)
            return
        end
    end
end
function OnHeroImmobilized(source, endTime, isStasis)
    if (((((Menu.Get("eOnCC") and source.IsEnemy) and source.IsValid) and E:IsReady()) and (E:GetManaCost() <= Player.Mana)) and (Menu.Get("eCCDuration") <= endTime)) and E:CanCast(source) then
        E:Cast(source)
        return
    end
end
function OnDraw()
end
function GetAoeCount(target, enemies)
    local count = 0
    local radius = Menu.Get("aoeRadius")
    do
        local i = 0
        while i < #enemies do
            if (target.Name ~= enemies[i + 1].Name) and (target.Position:Distance(enemies[i + 1].Position) < radius) then
                count = count + 1
            end
            i = i + 1
        end
    end
    return count
end
function ShouldSwap(target, enemies)
    local distanceTarget = Player.Position:Distance(target.Position)
    local isInFishBonesRange = distanceTarget < (fishbonesRange + target.BoundingRadius)
    local notInOverswaprange = distanceTarget < ((525 + target.BoundingRadius) - Menu.Get("overSwap"))
    local isFullStack = fishbonesStack == 3
    local canAoe = GetAoeCount(target, enemies) > (Menu.Get("aoeCount") - 1)
    if isFishBones then
        return ((not isInFishBonesRange) or (Menu.Get("powPowFullStack") and isFullStack)) or (Menu.Get("powPowAoe") and canAoe)
    end
    return ((not canAoe) and (not isFullStack)) and notInOverswaprange
end
function GetWDelay()
    return 0.6 - (((Player.AttackSpeedMod - 1) / 25) * 2)
end
function tryQ(enemies)
    local target = TargetSelector:GetTarget(powPowRange, true)
    if (not Q:IsReady()) or (not ShouldSwap(
        ((target and (function() return target end)) or (function() return enemies[1] end))(),
        enemies
    )) then
        return false
    end
    return Q:Cast()
end
function tryW(hitchance)
    local target = TargetSelector:GetTarget(wInput.Range, true)
    if ((not target) or (not W:IsReady())) or (W:GetManaCost() > Player.Mana) then
        return false
    end
    wInput.Delay = GetWDelay()
    local WCast = SpellLib.Skillshot(wInput)
    repeat
        local ____switch41 = Menu.Get("wMode")
        local ____cond41 = ____switch41 == 1
        if ____cond41 then
            do
                if target.Position:Distance(Player.Position) > powPowRange then
                    return WCast:CastOnHitChance(target, hitchance)
                end
                break
            end
        end
        ____cond41 = ____cond41 or (____switch41 == 2)
        if ____cond41 then
            do
                if target.Position:Distance(Player.Position) > Menu.Get("wMinRange") then
                    return WCast:Cast(target)
                end
                break
            end
        end
        ____cond41 = ____cond41 or (____switch41 == 3)
        if ____cond41 then
            return WCast:Cast(target)
        end
        do
            break
        end
    until true
    return false
end
function tryE(enemies, hitchance)
    if (not E.IsReady) or (E:GetManaCost() > Player.Mana) then
        return false
    end
    do
        local i = 0
        while i < #enemies do
            if E:CastOnHitChance(enemies[i + 1], hitchance) then
                return true
            end
            i = i + 1
        end
    end
    return false
end
function Combo(enemies)
    if Menu.Get("eCombo") then
        if tryE(
            enemies,
            Menu.Get("eComboHit")
        ) then
            return
        end
    end
    if Menu.Get("qCombo") then
        if tryQ(enemies) then
            return
        end
    end
    if Menu.Get("wCombo") and (not Menu.Get("wAuto")) then
        if tryW(
            Menu.Get("wComboHit")
        ) then
            return
        end
    end
end
function Harass(enemies)
    if Menu.Get("eHarass") then
        if tryE(
            enemies,
            Menu.Get("eHarassHit")
        ) then
            return
        end
    end
    if Menu.Get("qHarass") then
        if tryQ(enemies) then
            return
        end
    end
    if Menu.Get("wHarass") then
        if tryW(
            Menu.Get("wHarassHit")
        ) then
            return
        end
    end
end
function HasStatik()
    for key, item in pairs(Player.Items) do
        if item and (item.ItemId == 3094) then
            return true
        end
    end
    return false
end
function LastHit()
    if (Menu.Get("qLastHit") and Q:IsReady()) and (not isFishBones) then
        Q:Cast()
    end
end
function UpdateStats()
    local qLevel = Player:GetSpell(SpellSlots.Q).Level
    fishbonesRange = 525
    powPowRange = (qLevel * 25) + 600
    local fishBonesBuff = Player:GetBuff("jinxqramp")
    if fishBonesBuff then
        fishbonesStack = fishBonesBuff.Count
    end
    local statikBuff = Player:GetBuff("itemstatikshankcharge")
    if (HasStatik() and statikBuff) and (statikBuff.Count == 100) then
        fishbonesRange = fishbonesRange + 150
        powPowRange = powPowRange + 150
    end
    isFishBones = not Player:GetBuff("JinxQ")
end
function OnTick()
    if ((((Player.IsDead or Player.IsRecalling) or (not Player.CanCast)) or Player.IsCasting) or Game.IsMinimized()) or Game.IsChatOpen() then
        return
    end
    UpdateStats()
    local enemies = GetValidNearbyHeroes("enemy")
    local orbwalkerMode = Orbwalker.GetMode()
    if #enemies == 0 then
        return
    end
    repeat
        local ____switch77 = orbwalkerMode
        local ____cond77 = ____switch77 == "Combo"
        if ____cond77 then
            do
                Combo(enemies)
                break
            end
        end
        ____cond77 = ____cond77 or (____switch77 == "Harass")
        if ____cond77 then
            do
                Harass(enemies)
                break
            end
        end
        ____cond77 = ____cond77 or (____switch77 == "Lasthit")
        if ____cond77 then
            do
                LastHit()
                break
            end
        end
        ____cond77 = ____cond77 or (____switch77 == "Waveclear")
        if ____cond77 then
            do
                break
            end
        end
        do
            break
        end
    until true
end
if Player.CharName ~= "Jinx" then
    return false
end
local Core = _G.CoreEx
ObjectManager = Core.ObjectManager
Game = Core.Game
local Enums = Core.Enums
SpellSlots = Enums.SpellSlots
local Events = Enums.Events
local Libs = _G.Libs
Orbwalker = Libs.Orbwalker
Menu = Libs.NewMenu
SpellLib = Libs.Spell
TargetSelector = Libs.TargetSelector()
fishbonesStack = 0
fishbonesRange = 525
isFishBones = true
powPowRange = 600
local qInput = {Slot = SpellSlots.Q}
Q = SpellLib.Active(qInput)
wInput = {Slot = SpellSlots.W, Range = 1500, Speed = 3300, Delay = 0, Radius = 120, Type = "Linear", UseHitbox = true, Collisions = {WindWall = true, Minions = true}}
W = SpellLib.Skillshot(wInput)
eInput = {Slot = SpellSlots.E, Range = 1120, Speed = 1850, Delay = 0.9, Radius = 115, Type = "Circular", UseHitbox = false, Collisions = {WindWall = true}}
E = SpellLib.Skillshot(eInput)
local rInput = {Slot = SpellSlots.R, Range = math.huge, Speed = 1700, Delay = 0.6, Radius = 280, Type = "Circular", UseHitbox = false, Collisions = {WindWall = true}}
local R = SpellLib.Skillshot(rInput)
local events = {{id = Events.OnTick, callback = OnTick}, {id = Events.OnDraw, callback = OnDraw}, {id = Events.OnGapclose, callback = OnGapclose}, {id = Events.OnHeroImmobilized, callback = OnHeroImmobilized}}
local wModes = {}
wModes[1] = "Out of AA range"
wModes[2] = "Min. distance"
wModes[3] = "Always"
local hitchances = {}
hitchances[1] = "Collision"
hitchances[2] = "Out Of Range"
hitchances[3] = "Very Low"
hitchances[4] = "Low"
hitchances[5] = "Medium"
hitchances[6] = "High"
hitchances[7] = "Very High"
hitchances[8] = "Dashing"
hitchances[9] = "Immobile"
local function InitLog()
    module("PoncheJinx", package.seeall, log.setup)
    clean.module("PoncheJinx", clean.seeall, log.setup)
end
local function InitMenu()
    local enemies = ObjectManager.Get("enemy", "heroes")
    local enemiesName = {}
    local allies = ObjectManager.Get("ally", "heroes")
    local alliesName = {}
    local enemiesCount = 0
    for key, obj in pairs(enemies) do
        local enemyName = obj.AsHero.CharName
        if not __TS__ArrayIncludes(enemiesName, enemyName) then
            __TS__ArrayPush(enemiesName, enemyName)
        end
        enemiesCount = enemiesCount + 1
    end
    for key, obj in pairs(allies) do
        do
            if obj.IsMe then
                goto __continue7
            end
            local allyName = obj.AsHero.CharName
            if not __TS__ArrayIncludes(alliesName, allyName) then
                __TS__ArrayPush(alliesName, allyName)
            end
        end
        ::__continue7::
    end
    if enemiesCount == 0 then
        enemiesCount = 1
    end
    Menu.RegisterMenu(
        "PoncheJinx",
        "PoncheJinx",
        function()
            Menu.Text("v1.0", true)
            Menu.NewTree(
                "combo",
                "Combo",
                function()
                    Menu.Checkbox("qCombo", "Use [Q]", true)
                    Menu.Checkbox("wCombo", "Use [W]", true)
                    Menu.Dropdown("wComboHit", "[W] Hitchance: ", 5, hitchances)
                    Menu.Checkbox("eCombo", "Use [E]", true)
                    Menu.Dropdown("eComboHit", "[E] Hitchance: ", 6, hitchances)
                end
            )
            Menu.NewTree(
                "harass",
                "Harass",
                function()
                    Menu.Checkbox("qHarass", "Use [Q]", true)
                    Menu.Checkbox("wHarass", "Use [W]", true)
                    Menu.Dropdown("wHarassHit", "[W] Hitchance: ", 6, hitchances)
                    Menu.Checkbox("eHarass", "Use [E]", true)
                    Menu.Dropdown("eHarassHit", "[W] Hitchance: ", 7, hitchances)
                end
            )
            Menu.NewTree(
                "lastHit",
                "Last Hit",
                function()
                    Menu.Checkbox("qLastHit", "Use [Q]", true)
                    Menu.Text("Just switch back to Fishbones")
                end
            )
            Menu.NewTree(
                "qConfig",
                "[Q] Config",
                function()
                    Menu.Checkbox("powPowFullStack", "Switch full stack", false)
                    Menu.Checkbox("powPowAoe", "Switch for AOE", true)
                    Menu.Slider("aoeCount", "Min. AOE hitcount ", 2, 1, 3, 1)
                    Menu.Slider("aoeRadius", "AOE hit radius ", 300, 100, 300, 50)
                    Menu.Slider("overSwap", "Anti overswap", 60, 0, 150, 10)
                end
            )
            Menu.NewTree(
                "wConfig",
                "[W] Config",
                function()
                    Menu.Dropdown("wMode", "Cast mode: ", 1, wModes)
                    Menu.Slider("wMinRange", "Min. distance", 900, 0, wInput.Range, 50)
                end
            )
            Menu.NewTree(
                "eConfig",
                "[E] Config",
                function()
                    Menu.Checkbox("eOnGapclose", "Auto on gapclose", true)
                    Menu.NewTree(
                        "eOnEnemyGap",
                        "On enemy gapclose:",
                        function()
                            for ____, enemyName in ipairs(enemiesName) do
                                Menu.Checkbox("eOnGap" .. enemyName, enemyName, true)
                            end
                        end
                    )
                    Menu.Checkbox("eOnCC", "Auto on CC", true)
                    Menu.Slider("eCCDuration", "Min. CC duration", 0.4, 0, 2, 0.1)
                end
            )
        end
    )
end
local function InitEvents()
    local eventManager = _G.CoreEx.EventManager
    do
        local i = 0
        while i < #events do
            eventManager.RegisterCallback(events[i + 1].id, events[i + 1].callback)
            i = i + 1
        end
    end
end
local function tryR(enemies)
    if (not R:IsReady()) or (R:GetManaCost() > Player.Mana) then
        return false
    end
    return false
end
OnLoad = function()
    InitLog()
    InitMenu()
    InitEvents()
    return true
end
return ____exports
