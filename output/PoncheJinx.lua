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
local Core, ObjectManager, Game, SpellSlots, Orbwalker, Menu, SpellLib, HealthPred, TargetSelector, fishbonesStack, fishbonesRange, isFishBones, powPowRange, rSpeed1, rSpeed2, Q, wInput, W, eInput, E, rInput, R, GetValidNearbyHeroes, OnGapclose, OnHeroImmobilized, OnDraw, GetHitChance, GetAoeCount, ShouldSwap, HasMana, GetWDelay, tryQ, tryW, tryE, tryR, HasStatik, IsAnyoneInRange, AutoQDisabler, HarassQ, WaveClear, LastHit, Harass, Combo, Auto, UpdateStats, OnTick
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
    if not Player.IsOnScreen then
        return
    end
    if Menu.Get("qDraw") then
        if isFishBones then
            Core.Renderer.DrawCircle3D(
                Player.Position,
                powPowRange + 100,
                10,
                1,
                Menu.Get("qColor")
            )
        else
            Core.Renderer.DrawCircle3D(
                Player.Position,
                fishbonesRange + 100,
                10,
                1,
                Menu.Get("qColor")
            )
        end
    end
    if Menu.Get("wDraw") then
        Core.Renderer.DrawCircle3D(
            Player.Position,
            wInput.Range,
            10,
            1,
            Menu.Get("wColor")
        )
    end
    if Menu.Get("eDraw") then
        Core.Renderer.DrawCircle3D(
            Player.Position,
            eInput.Range,
            10,
            1,
            Menu.Get("eColor")
        )
    end
end
function GetHitChance(id)
    return Menu.Get(id) + 2
end
function GetAoeCount(target, enemies)
    local count = 0
    local radius = Menu.Get("aoeRadius")
    do
        local i = 0
        while i < #enemies do
            if target.Position:Distance(enemies[i + 1].Position) < radius then
                count = count + 1
            end
            i = i + 1
        end
    end
    return count
end
function ShouldSwap(target, enemies)
    local distanceTarget = target:EdgeDistance(Player.Position)
    local isInFishBonesRange = distanceTarget < fishbonesRange
    local notInOverswaprange = distanceTarget < (fishbonesRange - Menu.Get("overSwap"))
    local isFullStack = fishbonesStack == 3
    local canAoe = GetAoeCount(target, enemies) >= Menu.Get("aoeCount")
    if isFishBones then
        return (not isInFishBonesRange) or ((Menu.Get("qAOEFullstack") and canAoe) and isFullStack)
    end
    return (isInFishBonesRange and notInOverswaprange) and (((not Menu.Get("qAOEFullstack")) or (not isFullStack)) or (not canAoe))
end
function HasMana(minPercent)
    return (Player.ManaPercent * 100) >= minPercent
end
function GetWDelay()
    return 0.6 - (((Player.AttackSpeedMod - 1) / 25) * 2)
end
function tryQ(enemies)
    if not Q:IsReady() then
        return false
    end
    local target = TargetSelector:GetTarget(powPowRange, true)
    if ShouldSwap(
        ((target and (function() return target end)) or (function() return enemies[1] end))(),
        enemies
    ) then
        return Q:Cast()
    end
    return false
end
function tryW(hitchance)
    if (not W:IsReady()) or (W:GetManaCost() > Player.Mana) then
        return false
    end
    local target = TargetSelector:GetTarget(wInput.Range, true)
    if not target then
        return false
    end
    wInput.Delay = GetWDelay()
    local WCast = SpellLib.Skillshot(wInput)
    repeat
        local ____switch53 = Menu.Get("wMode")
        local ____cond53 = ____switch53 == 0
        if ____cond53 then
            do
                if target:EdgeDistance(Player.Position) > powPowRange then
                    return WCast:CastOnHitChance(target, hitchance)
                end
                break
            end
        end
        ____cond53 = ____cond53 or (____switch53 == 1)
        if ____cond53 then
            do
                if target.Position:Distance(Player.Position) > Menu.Get("wMinRange") then
                    return WCast:CastOnHitChance(target, hitchance)
                end
                break
            end
        end
        ____cond53 = ____cond53 or (____switch53 == 2)
        if ____cond53 then
            return WCast:CastOnHitChance(target, hitchance)
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
function tryR()
    if (not R:IsReady()) or (R:GetManaCost() > Player.Mana) then
        return false
    end
    for key, obj in pairs(
        ObjectManager.Get("enemy", "heroes")
    ) do
        local enemy = obj
        if TargetSelector:IsValidTarget(enemy) then
            local distanceToHit = Player:Distance(enemy.Position)
            local timeToHit = rInput.Delay + (((distanceToHit <= 1350) and (function() return distanceToHit / rSpeed1 end)) or (function() return (1350 / rSpeed1) + ((distanceToHit - 1350) / rSpeed2) end))()
            rInput.Speed = distanceToHit / timeToHit
            local RC = SpellLib.Skillshot(rInput)
            local healthPredicted = {
                HealthPred.GetHealthPrediction(enemy, timeToHit, false)
            }
            if (healthPredicted[1] > 0) and (R:GetDamage(enemy) > healthPredicted[1]) then
                repeat
                    local ____switch67 = Menu.Get("rMode")
                    local ____cond67 = ____switch67 == 0
                    if ____cond67 then
                        do
                            if enemy:EdgeDistance(Player.Position) > powPowRange then
                                return RC:CastOnHitChance(
                                    enemy,
                                    GetHitChance("rHit")
                                )
                            end
                            break
                        end
                    end
                    ____cond67 = ____cond67 or (____switch67 == 1)
                    if ____cond67 then
                        do
                            local distance = enemy:Distance(Player.Position)
                            if (distance > Menu.Get("rMinRange")) and (distance < Menu.Get("rMaxRange")) then
                                return RC:CastOnHitChance(
                                    enemy,
                                    GetHitChance("rHit")
                                )
                            end
                            break
                        end
                    end
                    ____cond67 = ____cond67 or (____switch67 == 2)
                    if ____cond67 then
                        do
                            return RC:CastOnHitChance(
                                enemy,
                                GetHitChance("rHit")
                            )
                        end
                    end
                    do
                        break
                    end
                until true
            end
        end
    end
    return false
end
function HasStatik()
    for key, item in pairs(Player.Items) do
        if item and (item.ItemId == 3094) then
            return true
        end
    end
    return false
end
function IsAnyoneInRange(enemies)
    do
        local i = 0
        while i < #enemies do
            if enemies[i + 1]:EdgeDistance(Player.Position) <= powPowRange then
                return true
            end
            i = i + 1
        end
    end
    return false
end
function AutoQDisabler()
    return ((not isFishBones) and Q:IsReady()) and Q:Cast()
end
function HarassQ(enemies)
    if ((not Menu.Get("qHarass")) or (not IsAnyoneInRange(enemies))) or (not HasMana(
        Menu.Get("qHarassMana")
    )) then
        return AutoQDisabler()
    end
    return (#enemies > 0) and tryQ(enemies)
end
function WaveClear()
    if not Menu.Get("qWaveClear") then
        AutoQDisabler()
        return
    end
    if not Q:IsReady() then
        return
    end
    if not HasMana(
        Menu.Get("qWaveClearMana")
    ) then
        if not isFishBones then
            Q:Cast()
        end
        return
    end
    local minions = ObjectManager.GetNearby("enemy", "minions")
    local count = 0
    local canAoe = false
    for key, obj in pairs(minions) do
        if TargetSelector:IsValidTarget(obj) then
            count = count + 1
            if count > 1 then
                canAoe = true
                break
            end
        end
    end
    if canAoe then
        if isFishBones then
            Q:Cast()
        end
    else
        if not isFishBones then
            Q:Cast()
        end
    end
end
function LastHit()
    AutoQDisabler()
end
function Harass(enemies)
    if (Menu.Get("eHarass") and HasMana(
        Menu.Get("eHarassMana")
    )) and tryE(
        enemies,
        GetHitChance("eHarassHit")
    ) then
        return
    end
    if HarassQ(enemies) then
        return
    end
    if (Menu.Get("wHarass") and HasMana(
        Menu.Get("wHarassMana")
    )) and tryW(
        GetHitChance("wHarassHit")
    ) then
        return
    end
end
function Combo(enemies)
    if Menu.Get("eCombo") and tryE(
        enemies,
        GetHitChance("eComboHit")
    ) then
        return
    end
    if Menu.Get("qCombo") and tryQ(enemies) then
        return
    end
    if Menu.Get("wCombo") and tryW(
        GetHitChance("wComboHit")
    ) then
        return
    end
end
function Auto()
    return Menu.Get("rAuto") and tryR()
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
    if Auto() then
        return
    end
    local orbwalkerMode = Orbwalker.GetMode()
    repeat
        local ____switch110 = orbwalkerMode
        local ____cond110 = ____switch110 == "Combo"
        if ____cond110 then
            do
                if #enemies == 0 then
                    return
                end
                Combo(enemies)
                break
            end
        end
        ____cond110 = ____cond110 or (____switch110 == "Harass")
        if ____cond110 then
            do
                Harass(enemies)
                break
            end
        end
        ____cond110 = ____cond110 or (____switch110 == "Lasthit")
        if ____cond110 then
            do
                LastHit()
                break
            end
        end
        ____cond110 = ____cond110 or (____switch110 == "Waveclear")
        if ____cond110 then
            do
                WaveClear()
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
Core = _G.CoreEx
ObjectManager = Core.ObjectManager
Game = Core.Game
local Enums = Core.Enums
SpellSlots = Enums.SpellSlots
local Events = Enums.Events
local Libs = _G.Libs
Orbwalker = Libs.Orbwalker
Menu = Libs.NewMenu
SpellLib = Libs.Spell
HealthPred = Libs.HealthPred
TargetSelector = Libs.TargetSelector()
fishbonesStack = 0
fishbonesRange = 525
isFishBones = true
powPowRange = 600
rSpeed1 = 1700
rSpeed2 = 2200
local qInput = {Slot = SpellSlots.Q}
Q = SpellLib.Active(qInput)
wInput = {Slot = SpellSlots.W, Range = 1500, Speed = 3300, Delay = 0, Radius = 60, Type = "Linear", UseHitbox = true, Collisions = {Heroes = true, Minions = true, WindWall = true}}
W = SpellLib.Skillshot(wInput)
eInput = {Slot = SpellSlots.E, Range = 900, Speed = 1750, Delay = 0.9, Radius = 115, Type = "Circular", UseHitbox = false, Collisions = {WindWall = true}}
E = SpellLib.Skillshot(eInput)
rInput = {Slot = SpellSlots.R, Range = math.huge, Speed = rSpeed1, Delay = 0.6, Radius = 140, Type = "Linear", UseHitbox = true, Collisions = {Heroes = true, WindWall = true}}
R = SpellLib.Skillshot(rInput)
local events = {{id = Events.OnTick, callback = OnTick}, {id = Events.OnDraw, callback = OnDraw}, {id = Events.OnGapclose, callback = OnGapclose}, {id = Events.OnHeroImmobilized, callback = OnHeroImmobilized}}
local rModes = {}
rModes[1] = "Out of AA range"
rModes[2] = "Min/Max distance"
rModes[3] = "Always"
local wModes = {}
wModes[1] = "Out of AA range"
wModes[2] = "Min. distance"
wModes[3] = "Always"
local hitchances = {}
hitchances[1] = "Very Low"
hitchances[2] = "Low"
hitchances[3] = "Medium"
hitchances[4] = "High"
hitchances[5] = "Very High"
hitchances[6] = "Dashing"
hitchances[7] = "Immobile"
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
            Menu.Text("v2.0.0", true)
            Menu.NewTree(
                "combo",
                "Combo",
                function()
                    Menu.Checkbox("qCombo", "Use [Q]", true)
                    Menu.Checkbox("wCombo", "Use [W]", true)
                    Menu.Dropdown("wComboHit", "Hitchance", 3, hitchances)
                    Menu.Checkbox("eCombo", "Use [E]", true)
                    Menu.Dropdown("eComboHit", "Hitchance", 4, hitchances)
                end
            )
            Menu.NewTree(
                "harass",
                "Harass",
                function()
                    Menu.Checkbox("qHarass", "Use [Q]", true)
                    Menu.Slider("qHarassMana", "Min. Mana % ", 20, 0, 100, 5)
                    Menu.Checkbox("wHarass", "Use [W]", true)
                    Menu.Dropdown("wHarassHit", "Hitchance", 4, hitchances)
                    Menu.Slider("wHarassMana", "Min. Mana % ", 40, 0, 100, 5)
                    Menu.Checkbox("eHarass", "Use [E]", true)
                    Menu.Dropdown("eHarassHit", "Hitchance", 5, hitchances)
                    Menu.Slider("eHarassMana", "Min. Mana % ", 0, 0, 100, 5)
                end
            )
            Menu.NewTree(
                "waveClear",
                "Wave Clear",
                function()
                    Menu.Checkbox("qWaveClear", "Use [Q]", false)
                    Menu.Slider("qWaveClearMana", "Min. Mana % ", 40, 0, 100, 5)
                end
            )
            Menu.NewTree(
                "qConfig",
                "[Q] Config",
                function()
                    Menu.Slider("overSwap", "Anti Overswap", 0, 0, 150, 10)
                    Menu.Checkbox("qAOEFullstack", "Switch AOE fullstack", false)
                    Menu.Slider("aoeCount", "Min. Hitcount ", 2, 1, 3, 1)
                    Menu.Slider("aoeRadius", "AOE Radius ", 300, 100, 300, 50)
                end
            )
            Menu.NewTree(
                "wConfig",
                "[W] Config",
                function()
                    Menu.Dropdown("wMode", "Cast mode: ", 0, wModes)
                    Menu.Slider("wMinRange", "Min. distance", 900, 0, wInput.Range, 50)
                end
            )
            Menu.NewTree(
                "eConfig",
                "[E] Config",
                function()
                    Menu.Checkbox("eOnGapclose", "Auto on gapclose/dash", true)
                    Menu.NewTree(
                        "eOnEnemyGap",
                        "On enemy:",
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
            Menu.NewTree(
                "rConfig",
                "[R] Config",
                function()
                    Menu.Checkbox("rAuto", "Auto [R]", true)
                    Menu.Dropdown("rHit", "Hitchance", 4, hitchances)
                    Menu.Dropdown("rMode", "Cast mode: ", 1, rModes)
                    Menu.Slider("rMinRange", "Min. distance", 900, 0, 3000, 100)
                    Menu.Slider("rMaxRange", "Max. distance", 4000, 3000, 6000, 100)
                end
            )
            Menu.NewTree(
                "draw",
                "Draw Config",
                function()
                    Menu.Checkbox("qDraw", "Draw [Q]", true)
                    Menu.ColorPicker("qColor", "", 4261413119)
                    Menu.Checkbox("wDraw", "Draw [w]", true)
                    Menu.ColorPicker("wColor", "", 7405311)
                    Menu.Checkbox("eDraw", "Draw [E]", true)
                    Menu.ColorPicker("eColor", "", 4009689343)
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
OnLoad = function()
    InitLog()
    InitMenu()
    InitEvents()
    return true
end
return ____exports
