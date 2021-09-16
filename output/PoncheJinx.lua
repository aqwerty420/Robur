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
local Core, ObjectManager, Game, SpellSlots, Orbwalker, Menu, SpellLib, HealthPred, TargetSelector, fishbonesStack, fishbonesRange, isFishBones, powPowRange, rSpeed1, rSpeed2, Q, wInput, W, eInput, E, rInput, R, GetValidNearbyHeroes, OnGapclose, OnHeroImmobilized, OnDraw, GetHitChance, GetAoeCount, ShouldSwap, HasMana, GetWDelay, tryQ, tryW, tryE, tryR, Combo, WaveClear, IsAnyoneInRange, Harass, HasStatik, LastHit, Auto, UpdateStats, OnTick
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
    if Menu.Get("wDraw") then
        Core.Renderer.DrawCircle3D(Player.Position, wInput.Range, 10)
    end
    if Menu.Get("eDraw") then
        Core.Renderer.DrawCircle3D(Player.Position, eInput.Range, 10)
    end
    if Menu.Get("qDraw") then
        if isFishBones then
            Core.Renderer.DrawCircle3D(Player.Position, powPowRange + 100, 10)
        else
            Core.Renderer.DrawCircle3D(Player.Position, fishbonesRange + 100, 10)
        end
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
function HasMana(minPercent)
    print(
        tostring(Player.ManaPercent * 100)
    )
    print(
        tostring(minPercent)
    )
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
        local ____switch54 = Menu.Get("wMode")
        local ____cond54 = ____switch54 == 0
        if ____cond54 then
            do
                if target.Position:Distance(Player.Position) > powPowRange then
                    return WCast:CastOnHitChance(target, hitchance)
                end
                break
            end
        end
        ____cond54 = ____cond54 or (____switch54 == 1)
        if ____cond54 then
            do
                if target.Position:Distance(Player.Position) > Menu.Get("wMinRange") then
                    return WCast:CastOnHitChance(target, hitchance)
                end
                break
            end
        end
        ____cond54 = ____cond54 or (____switch54 == 2)
        if ____cond54 then
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
            local health = {
                HealthPred.GetHealthPrediction(enemy, timeToHit, true)
            }
            if (health[1] > 0) and (R:GetDamage(enemy) > health[1]) then
                repeat
                    local ____switch68 = Menu.Get("rMode")
                    local ____cond68 = ____switch68 == 0
                    if ____cond68 then
                        do
                            if enemy:Distance(Player.Position) > powPowRange then
                                return RC:CastOnHitChance(
                                    enemy,
                                    GetHitChance("rHit")
                                )
                            end
                            break
                        end
                    end
                    ____cond68 = ____cond68 or (____switch68 == 1)
                    if ____cond68 then
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
                    ____cond68 = ____cond68 or (____switch68 == 2)
                    if ____cond68 then
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
function Combo(enemies)
    if Menu.Get("eCombo") then
        if tryE(
            enemies,
            GetHitChance("eComboHit")
        ) then
            return
        end
    end
    if Menu.Get("qCombo") then
        if tryQ(enemies) then
            return
        end
    end
    if Menu.Get("wCombo") then
        if tryW(
            GetHitChance("wComboHit")
        ) then
            return
        end
    end
end
function WaveClear()
    if (not Menu.Get("qWaveClear")) or (not Q:IsReady()) then
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
function IsAnyoneInRange(enemies)
    do
        local i = 0
        while i < #enemies do
            if enemies[i + 1]:EdgeDistance(Player.Position) <= (powPowRange + 50) then
                return true
            end
            i = i + 1
        end
    end
    return false
end
function Harass(enemies)
    if Menu.Get("eHarass") and HasMana(
        Menu.Get("eHarassMana")
    ) then
        if tryE(
            enemies,
            GetHitChance("eHarassHit")
        ) then
            return
        end
    end
    if Menu.Get("qHarass") then
        if (not IsAnyoneInRange(enemies)) or (not HasMana(
            Menu.Get("qHarassMana")
        )) then
            if ((not isFishBones) and Q:IsReady()) and Q:Cast() then
                return
            end
        elseif HasMana(
            Menu.Get("qHarassMana")
        ) and (#enemies > 0) then
            if tryQ(enemies) then
                return
            end
        end
    end
    if Menu.Get("wHarass") and HasMana(
        Menu.Get("wHarassMana")
    ) then
        if tryW(
            GetHitChance("wHarassHit")
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
function Auto()
    if Menu.Get("rAuto") then
        return tryR()
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
    if Auto() then
        return
    end
    local orbwalkerMode = Orbwalker.GetMode()
    repeat
        local ____switch118 = orbwalkerMode
        local ____cond118 = ____switch118 == "Combo"
        if ____cond118 then
            do
                if #enemies == 0 then
                    return
                end
                Combo(enemies)
                break
            end
        end
        ____cond118 = ____cond118 or (____switch118 == "Harass")
        if ____cond118 then
            do
                Harass(enemies)
                break
            end
        end
        ____cond118 = ____cond118 or (____switch118 == "Lasthit")
        if ____cond118 then
            do
                LastHit()
                break
            end
        end
        ____cond118 = ____cond118 or (____switch118 == "Waveclear")
        if ____cond118 then
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
wInput = {Slot = SpellSlots.W, Range = 1500, Speed = 3300, Delay = 0, Radius = 120, Type = "Linear", UseHitbox = true, Collisions = {WindWall = true, Minions = true}}
W = SpellLib.Skillshot(wInput)
eInput = {Slot = SpellSlots.E, Range = 900, Speed = 1850, Delay = 0.9, Radius = 115, Type = "Circular", UseHitbox = false, Collisions = {WindWall = true}}
E = SpellLib.Skillshot(eInput)
rInput = {Slot = SpellSlots.R, Range = math.huge, Speed = rSpeed1, Delay = 0.6, Radius = 280, Type = "Circular", UseHitbox = false, Collisions = {WindWall = true}}
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
            Menu.Text("v1.0", true)
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
                    Menu.Slider("qHarassMana", "Min. Mana % ", 40, 0, 100, 5)
                    Menu.Checkbox("wHarass", "Use [W]", true)
                    Menu.Dropdown("wHarassHit", "Hitchance", 4, hitchances)
                    Menu.Slider("wHarassMana", "Min. Mana % ", 40, 0, 100, 5)
                    Menu.Checkbox("eHarass", "Use [E]", true)
                    Menu.Dropdown("eHarassHit", "Hitchance", 5, hitchances)
                    Menu.Slider("eHarassMana", "Min. Mana % ", 0, 0, 100, 5)
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
                    Menu.Checkbox("powPowFullStack", "Switch full stack", false)
                    Menu.Checkbox("powPowAoe", "Switch for AOE", true)
                    Menu.Slider("aoeCount", "Min. Hitcount ", 2, 1, 3, 1)
                    Menu.Slider("aoeRadius", "AOE Radius ", 300, 100, 300, 50)
                    Menu.Slider("overSwap", "Anti Overswap", 60, 0, 150, 10)
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
                    Menu.Checkbox("wDraw", "Draw [w]", true)
                    Menu.Checkbox("eDraw", "Draw [E]", true)
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
