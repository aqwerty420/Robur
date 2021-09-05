-- Lua Library inline imports
function __TS__ArrayPush(arr, ...)
    local items = {...}
    for ____, item in ipairs(items) do
        arr[#arr + 1] = item
    end
    return #arr
end

function IsBall(obj)
    return obj.IsAlly and (obj.Name == ballObjName)
end
function GetValidNearbyHeroes(team)
    local heroes = {}
    for key, obj in pairs(
        ObjectManager.GetNearby(team, "heroes")
    ) do
        if TargetSelector:IsValidTarget(obj) then
            __TS__ArrayPush(heroes, obj)
        end
    end
    return heroes
end
function SetBallPosition(allies)
    if Player:GetBuff(ballSelfBuffName) then
        ballMoving = false
        ballPosition = Player.Position
        ballOnSelf = true
        return
    end
    do
        local i = 0
        while i < #allies do
            if allies[i + 1]:GetBuff(ballAllyBuffName) then
                ballMoving = false
                ballPosition = allies[i + 1].Position
                ballOnSelf = false
                return
            end
            i = i + 1
        end
    end
end
function OnCreateObject(obj)
    if (obj.Name == ballMissileNames[1]) or (obj.Name == ballMissileNames[2]) then
        ballOnSelf = false
        ballMoving = true
        return
    end
    if not IsBall(obj) then
        return
    end
    ballMoving = false
    ballPosition = obj.Position
end
function OnCastSpell(args)
    if (args.Slot == SpellSlots.R) and Menu.Get("rCancel") then
        local enemies = GetValidNearbyHeroes("enemy")
        do
            local i = 0
            while i < #enemies do
                if IsInRange(enemies[i + 1], rRadius, rDelay) then
                    return
                end
                i = i + 1
            end
        end
        args.Process = false
    end
end
function IsInRange(enemy, range, delay)
    if delay == nil then
        delay = 0
    end
    if enemy.Position:Distance(ballPosition) > range then
        return false
    end
    local pos = enemy.Position
    if delay > 0 then
        pos = enemy:FastPrediction(delay)
    end
    return pos:Distance(ballPosition) <= range
end
function OnDraw()
    if Menu.Get("ballDraw") and (not ballMoving) then
        Core.Renderer.DrawCircle3D(ballPosition, 100, 10)
    end
end
function tryQ(enemies)
    if Q:IsReady() and (Q:GetManaCost() <= Player.Mana) then
        if (#enemies > 1) and ballOnSelf then
            local castPos = {
                Q:GetBestLinearCastPos(enemies)
            }
            if castPos[2] >= 2 then
                return Q:Cast(castPos[1])
            end
        end
        local target = Q:GetTarget()
        if not target then
            return
        end
        local result = Libs.Prediction.GetPredictedPosition(target, qInput, ballPosition)
        if result and (result.HitChance >= Enums.HitChance.Collision) then
            return Q:Cast(result.CastPosition)
        end
    end
    return false
end
function tryW(enemies)
    if W:IsReady() and (W:GetManaCost() <= Player.Mana) then
        do
            local i = 0
            while i < #enemies do
                if IsInRange(enemies[i + 1], wRadius, baseDelay) then
                    return W:Cast()
                end
                i = i + 1
            end
        end
    end
    return false
end
function Auto(allies, enemies)
    if Menu.Get("wAuto") then
        if tryW(enemies) then
            return
        end
    end
end
function Combo(allies, enemies)
    if Menu.Get("qCombo") then
        if tryQ(enemies) then
            return
        end
    end
    if Menu.Get("wCombo") and (not Menu.Get("wAuto")) then
        if tryW(enemies) then
            return
        end
    end
end
function Harass(allies, enemies)
    if Menu.Get("qHarass") then
        if tryQ(enemies) then
            return
        end
    end
    if Menu.Get("wHarass") and (not Menu.Get("wAuto")) then
        if tryW(enemies) then
            return
        end
    end
end
function OnTick()
    local allies = GetValidNearbyHeroes("ally")
    SetBallPosition(allies)
    if ((((ballMoving or Player.IsDead) or Player.IsRecalling) or (not Player.CanCast)) or Game.IsMinimized()) or Game.IsChatOpen() then
        return
    end
    local enemies = GetValidNearbyHeroes("enemy")
    if #enemies == 0 then
        return
    end
    local orbwalkerMode = Orbwalker.GetMode()
    local ____switch77 = orbwalkerMode
    if ____switch77 == "Combo" then
        goto ____switch77_case_0
    elseif ____switch77 == "Harass" then
        goto ____switch77_case_1
    elseif ____switch77 == "Lasthit" then
        goto ____switch77_case_2
    elseif ____switch77 == "Waveclear" then
        goto ____switch77_case_3
    elseif ____switch77 == "Flee" then
        goto ____switch77_case_4
    elseif ____switch77 == "nil" then
        goto ____switch77_case_5
    end
    goto ____switch77_end
    ::____switch77_case_0::
    do
        do
            Combo(allies, enemies)
            goto ____switch77_end
        end
    end
    ::____switch77_case_1::
    do
        do
            Harass(allies, enemies)
            goto ____switch77_end
        end
    end
    ::____switch77_case_2::
    do
        do
            goto ____switch77_end
        end
    end
    ::____switch77_case_3::
    do
        do
            goto ____switch77_end
        end
    end
    ::____switch77_case_4::
    do
        do
            goto ____switch77_end
        end
    end
    ::____switch77_case_5::
    do
        do
            Auto(allies, enemies)
            goto ____switch77_end
        end
    end
    ::____switch77_end::
end
if Player.CharName ~= "Orianna" then
    return false
end
Core = _G.CoreEx
ObjectManager = Core.ObjectManager
Game = Core.Game
Geometry = Core.Geometry
Enums = Core.Enums
SpellSlots = Enums.SpellSlots
Events = Enums.Events
Libs = _G.Libs
Orbwalker = Libs.Orbwalker
Menu = Libs.NewMenu
SpellLib = Libs.Spell
TargetSelector = Libs.TargetSelector()
scriptName = "PoncheOrianna"
ballSelfBuffName = "orianaghostself"
ballAllyBuffName = "orianaghost"
ballObjName = "TheDoomBall"
ballMissileNames = {"OrianaIzuna", "OrianaRedact"}
collisions = {WindWall = true, Wall = true}
qRange = 825
qSpeed = 1400
qRadius = 80
wRadius = 225
eSpeed = 1850
rRadius = 415
rDelay = 0.5
baseDelay = 0.25
mathHuge = _G.math.huge
ballPosition = Geometry.Vector()
ballMoving = false
ballOnSelf = false
qInput = {Slot = SpellSlots.Q, Range = qRange, Speed = qSpeed, Delay = baseDelay, Radius = qRadius, Type = "Linear", UseHitbox = true, Collisions = collisions}
Q = SpellLib.Skillshot(qInput)
W = SpellLib.Active({Slot = SpellSlots.W, Range = 0, Speed = mathHuge, Delay = baseDelay, Radius = wRadius, Type = "Circular", UseHitbox = false})
E = SpellLib.Skillshot({Slot = SpellSlots.E, Range = 1120, Speed = eSpeed, Delay = baseDelay, Radius = qRadius, Type = "Linear", UseHitbox = true, Collisions = collisions})
R = SpellLib.Active({Slot = SpellSlots.R, Range = 0, Speed = mathHuge, Delay = rDelay, Radius = rRadius, Type = "Circular", UseHitbox = false, Collisions = collisions})
QR = SpellLib.Skillshot({Slot = SpellSlots.Q, Range = qRange, Speed = qSpeed, Delay = baseDelay, Radius = rRadius, Type = "Circular", UseHitbox = false, Collisions = collisions})
events = {{id = Events.OnTick, callback = OnTick}, {id = Events.OnDraw, callback = OnDraw}, {id = Events.OnCreateObject, callback = OnCreateObject}, {id = Events.OnCastSpell, callback = OnCastSpell}}
function InitLog()
    module(scriptName, package.seeall, log.setup)
    clean.module(scriptName, clean.seeall, log.setup)
end
function InitMenu()
    Menu.RegisterMenu(
        scriptName,
        scriptName,
        function()
            Menu.NewTree(
                "a",
                "Q Options",
                function()
                    Menu.Checkbox("qCombo", "Combo", true)
                    Menu.Checkbox("qHarass", "Harass", true)
                    Menu.Checkbox("qKs", "Kill Steal", true)
                end
            )
            Menu.NewTree(
                "w",
                "W Options",
                function()
                    Menu.Checkbox("wCombo", "Combo", true)
                    Menu.Checkbox("wHarass", "Harass", true)
                    Menu.Checkbox("wKs", "Kill Steal", true)
                    Menu.Checkbox("wAuto", "Auto", true)
                    Menu.Checkbox("wDraw", "Draw Range", true)
                end
            )
            Menu.NewTree(
                "e",
                "E Options",
                function()
                    Menu.Checkbox("eCombo", "Combo", true)
                    Menu.Checkbox("eHarass", "Harass", true)
                    Menu.Checkbox("eKs", "Kill Steal", true)
                    Menu.Checkbox("eAuto", "Auto (Protect from dmg)", true)
                    Menu.Checkbox("eShieldSelf", "Protect self", true)
                    Menu.Checkbox("eShieldAllies", "Protect allies", true)
                    Menu.Checkbox("eDraw", "Draw Range", true)
                end
            )
            Menu.NewTree(
                "r",
                "R Options",
                function()
                    Menu.Checkbox("rCombo", "Combo", true)
                    Menu.Checkbox("rKill", "Kill Steal", true)
                    Menu.Checkbox("rAuto", "Auto", true)
                    Menu.Checkbox("eToR", "E to R", true)
                    Menu.Checkbox("qToR", "Q to R", true)
                    Menu.Checkbox("rBlock", "Cancel if no hit", true)
                    Menu.Checkbox("rDraw", "Draw Range", true)
                end
            )
            Menu.Checkbox("ballDraw", "Ball Draw", true)
        end
    )
end
function InitEvents()
    local eventManager = _G.CoreEx.EventManager
    do
        local i = 0
        while i < #events do
            eventManager.RegisterCallback(events[i + 1].id, events[i + 1].callback)
            i = i + 1
        end
    end
end
function RetrieveBallPosition()
    for key, obj in pairs(
        ObjectManager.Get("ally", "minions")
    ) do
        if IsBall(obj) then
            ballPosition = obj.Position
            return
        end
    end
end
function tryE(enemies)
    if E:IsReady() and (E:GetManaCost() <= Player.Mana) then
        if #enemies == 1 then
            return E:CastOnHitChance(enemies[1], Enums.HitChance.Low)
        else
            local castPos = {
                E:GetBestLinearCastPos(enemies)
            }
            if castPos[2] > 0 then
                if castPos[2] < 2 then
                    local target = E:GetTarget()
                    return E:CastOnHitChance(target, Enums.HitChance.Low)
                else
                    return E:Cast(castPos[1])
                end
            end
        end
    end
    return false
end
function getValuePos(enemies, delay)
    local count = 0
    do
        local i = 0
        while i < #enemies do
            if IsInRange(enemies[i + 1], rRadius, delay) then
                count = count + 1
            end
            i = i + 1
        end
    end
    return count
end
function getBestER(allies, enemies)
    local ally = nil
    local bestCount = 0
    do
        local i = 0
        while i < #allies do
            local count = 0
            local reachDelay = (ballPosition:Distance(allies[i + 1]) / eSpeed) + baseDelay
            do
                local j = 0
                while j < #enemies do
                    if IsInRange(enemies[j + 1], rRadius, reachDelay) then
                        count = count + 1
                    end
                    j = j + 1
                end
            end
            if count > bestCount then
                bestCount = count
                ally = allies[i + 1]
            end
            i = i + 1
        end
    end
    return ally, bestCount
end
function tryR(allies, enemies)
    local rValue = getValuePos(enemies, rDelay)
    local erValue = {
        getBestER(allies, enemies)
    }
end
OnLoad = function()
    InitLog()
    InitMenu()
    InitEvents()
    RetrieveBallPosition()
    return true
end
