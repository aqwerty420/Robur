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
            __TS__ArrayPush(heroes, obj.AsHero)
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
    if IsBall(obj) then
        ballMoving = false
        ballPosition = obj.Position
        return
    end
end
function OnCastSpell(args)
    if Menu.Get("rBlock") and (args.Slot == SpellSlots.R) then
        local enemies = GetValidNearbyHeroes("enemy")
        do
            local i = 0
            while i < #enemies do
                if IsInRange(enemies[i + 1], rRadius, ballPosition, rDelay) then
                    return
                end
                i = i + 1
            end
        end
        args.Process = false
    end
end
function OnProcessSpell(source, spell)
    if ((((((not ballMoving) and source.IsEnemy) and source.IsHero) and spell.Target) and (not spell.IsBasicAttack)) and spell.Target.IsHero) and spell.Target.IsAlly then
        if spell.Target.IsMe then
            if Menu.Get("eShieldSelf") and E:CanCast(Player) then
                E:Cast(Player)
            end
            return
        end
        local target = spell.Target.AsHero
        if Menu.Get("eShield" .. target.CharName) and E:CanCast(target) then
            E:Cast(target)
            return
        end
    end
end
function OnDraw()
    local drawBallPos = Geometry.Vector(ballPosition)
    local t = Core.Game.GetTime() % 0.8
    drawBallPos.y = drawBallPos.y + 100
    drawBallPos.y = drawBallPos.y + (((t < 0.4) and (function() return -50 * t end)) or (function() return -(20 - ((t - 0.4) * 50)) end))()
    if Menu.Get("ballDraw") and (not ballMoving) then
        Core.Renderer.DrawCircle3D(drawBallPos, 100, 10)
    end
end
function IsInRange(enemy, range, position, delay)
    if delay == nil then
        delay = 0
    end
    if enemy.Position:Distance(position) > range then
        return false
    end
    if delay == 0 then
        return true
    end
    local enemyPos = enemy:FastPrediction(delay)
    return enemyPos:Distance(position) <= range
end
function getValuePos(enemies, delay)
    local count = 0
    do
        local i = 0
        while i < #enemies do
            local enemy = enemies[i + 1].AsHero
            if IsInRange(enemy, rRadius, ballPosition, delay) then
                count = count + Menu.Get("rWeight" .. enemy.CharName)
            end
            i = i + 1
        end
    end
    return count
end
function tryQ(enemies)
    if (not Q:IsReady()) or (Q:GetManaCost() > Player.Mana) then
        return false
    end
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
    return false
end
function tryW(enemies)
    if (not W:IsReady()) or (W:GetManaCost() > Player.Mana) then
        return false
    end
    do
        local i = 0
        while i < #enemies do
            if IsInRange(enemies[i + 1], wRadius, ballPosition, baseDelay) then
                return W:Cast()
            end
            i = i + 1
        end
    end
    return false
end
function tryE(enemies)
    if (not E.IsReady) or (E:GetManaCost() > Player.Mana) then
        return false
    end
    do
        local i = 0
        while i < #enemies do
            local reachDelay = (ballPosition:Distance(enemies[i + 1]) / eSpeed) + baseDelay
            local enemyPos = enemies[i + 1]:FastPrediction(reachDelay)
            local distance = enemyPos:LineDistance(ballPosition, Player.Position, false)
            if distance <= ballRadius then
                return E:Cast(Player)
            end
            i = i + 1
        end
    end
    return false
end
function getBestER(allies, enemies)
    if ((not Menu.Get("eToR")) or (not E:IsReady())) or ((E:GetManaCost() + R:GetManaCost()) > Player.Mana) then
        return nil, 0
    end
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
                    local enemy = enemies[j + 1].AsHero
                    if IsInRange(enemy, rRadius, allies[i + 1].Position, reachDelay) then
                        count = count + Menu.Get("rWeight" .. enemy.CharName)
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
function getQR(enemies)
    if ((not Menu.Get("qToR")) or (not Q:IsReady())) or ((Q:GetManaCost() + R:GetManaCost()) > Player.Mana) then
        return nil, 0
    end
    local count = 0
    if ballOnSelf then
        local castPos = {
            QR:GetBestCircularCastPos(enemies)
        }
        do
            local j = 0
            while j < #enemies do
                local enemy = enemies[j + 1].AsHero
                if IsInRange(
                    enemy,
                    rRadius,
                    castPos[1],
                    baseDelay + (ballPosition:Distance(castPos[1]) / qSpeed)
                ) then
                    count = count + Menu.Get("rWeight" .. enemy.CharName)
                end
                j = j + 1
            end
        end
        return castPos[1], count
    end
    return nil, 0
end
function tryR(allies, enemies)
    if (not R.IsReady) or (R:GetManaCost() > Player.Mana) then
        return false
    end
    local rResult = getValuePos(enemies, rDelay)
    local qrResult = {
        getQR(enemies)
    }
    local erResult = {
        getBestER(allies, enemies)
    }
    print(
        tostring(erResult[2])
    )
    if ((rResult >= Menu.Get("rValue")) and (rResult >= qrResult[2])) and (rResult >= erResult[2]) then
        return R:Cast()
    end
    if (erResult[2] >= Menu.Get("rValue")) and (erResult[2] >= qrResult[2]) then
        return E:Cast(erResult[1])
    end
    if qrResult[2] >= Menu.Get("rValue") then
        return Q:Cast(qrResult[1])
    end
    return false
end
function Auto(allies, enemies)
    if Menu.Get("rAuto") then
        if tryR(allies, enemies) then
            return
        end
    end
    if Menu.Get("wAuto") then
        if tryW(enemies) then
            return
        end
    end
end
function Combo(allies, enemies)
    if Menu.Get("rCombo") then
        if tryR(allies, enemies) then
            return
        end
    end
    if Menu.Get("qCombo") then
        if tryQ(enemies) then
            return
        end
    end
    if Menu.Get("wCombo") then
        if tryW(enemies) then
            return
        end
    end
    if Menu.Get("eCombo") then
        if tryE(enemies) then
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
    if Menu.Get("wHarass") then
        if tryW(enemies) then
            return
        end
    end
    if Menu.Get("eHarass") then
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
    local ____switch104 = orbwalkerMode
    if ____switch104 == "Combo" then
        goto ____switch104_case_0
    elseif ____switch104 == "Harass" then
        goto ____switch104_case_1
    elseif ____switch104 == "Lasthit" then
        goto ____switch104_case_2
    elseif ____switch104 == "Waveclear" then
        goto ____switch104_case_3
    elseif ____switch104 == "Flee" then
        goto ____switch104_case_4
    elseif ____switch104 == "nil" then
        goto ____switch104_case_5
    end
    goto ____switch104_end
    ::____switch104_case_0::
    do
        do
            Combo(allies, enemies)
            goto ____switch104_end
        end
    end
    ::____switch104_case_1::
    do
        do
            Harass(allies, enemies)
            goto ____switch104_end
        end
    end
    ::____switch104_case_2::
    do
        do
            goto ____switch104_end
        end
    end
    ::____switch104_case_3::
    do
        do
            goto ____switch104_end
        end
    end
    ::____switch104_case_4::
    do
        do
            goto ____switch104_end
        end
    end
    ::____switch104_case_5::
    do
        do
            Auto(allies, enemies)
            goto ____switch104_end
        end
    end
    ::____switch104_end::
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
ballSelfBuffName = "orianaghostself"
ballAllyBuffName = "orianaghost"
ballObjName = "TheDoomBall"
ballMissileNames = {"OrianaIzuna", "OrianaRedact"}
collisions = {WindWall = true, Wall = true}
qRange = 825
qSpeed = 1400
ballRadius = 80
wRadius = 225
eSpeed = 1850
rRadius = 415
rDelay = 0.5
baseDelay = 0.25
mathHuge = _G.math.huge
ballPosition = Geometry.Vector()
ballMoving = false
ballOnSelf = false
qInput = {Slot = SpellSlots.Q, Range = qRange, Speed = qSpeed, Delay = baseDelay, Radius = ballRadius, Type = "Linear", UseHitbox = true, Collisions = collisions}
Q = SpellLib.Skillshot(qInput)
W = SpellLib.Active({Slot = SpellSlots.W, Range = 0, Speed = mathHuge, Delay = baseDelay, Radius = wRadius, Type = "Circular", UseHitbox = false})
E = SpellLib.Targeted({Slot = SpellSlots.E, Range = 1120, Speed = eSpeed, Delay = baseDelay, Radius = ballRadius, Type = "Linear", UseHitbox = true, Collisions = collisions})
R = SpellLib.Active({Slot = SpellSlots.R, Range = 0, Speed = mathHuge, Delay = rDelay, Radius = rRadius, Type = "Circular", UseHitbox = false, Collisions = collisions})
QR = SpellLib.Skillshot({Slot = SpellSlots.Q, Range = qRange, Speed = qSpeed, Delay = baseDelay, Radius = rRadius, Type = "Circular", UseHitbox = false, Collisions = collisions})
events = {{id = Events.OnTick, callback = OnTick}, {id = Events.OnDraw, callback = OnDraw}, {id = Events.OnCreateObject, callback = OnCreateObject}, {id = Events.OnCastSpell, callback = OnCastSpell}, {id = Events.OnProcessSpell, callback = OnProcessSpell}}
function InitLog()
    module("PoncheOrianna", package.seeall, log.setup)
    clean.module("PoncheOrianna", clean.seeall, log.setup)
end
function InitMenu()
    local enemies = ObjectManager.Get("enemy", "heroes")
    local allies = ObjectManager.Get("ally", "heroes")
    local enemiesCount = 0
    for key, obj in pairs(enemies) do
        enemiesCount = enemiesCount + 1
    end
    if enemiesCount == 0 then
        enemiesCount = 1
    end
    Menu.RegisterMenu(
        "PoncheOrianna",
        "PoncheOrianna",
        function()
            Menu.NewTree(
                "q",
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
                    Menu.Checkbox("eHarass", "Harass", false)
                    Menu.Checkbox("eKs", "Kill Steal", true)
                    Menu.Checkbox("eShieldSelf", "Protect self", true)
                    Menu.NewTree(
                        "eProtectList",
                        "Protect ally :",
                        function()
                            for key, obj in pairs(allies) do
                                local ally = obj.AsHero
                                if not obj.IsMe then
                                    Menu.Checkbox("eShield" .. ally.CharName, ally.CharName, true)
                                end
                            end
                        end
                    )
                    Menu.Checkbox("eShieldAllies", "Protect allies", true)
                    Menu.Checkbox("eDraw", "Draw Range", false)
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
                    Menu.NewTree(
                        "eWaight",
                        "Enemy value :",
                        function()
                            for key, obj in pairs(enemies) do
                                local enemy = obj.AsHero
                                Menu.Slider("rWeight" .. enemy.CharName, enemy.CharName, 1, 1, 3, 1)
                                break
                            end
                        end
                    )
                    Menu.Slider("rValue", "Value to R", 1, 1, enemiesCount * 3, 1)
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
OnLoad = function()
    InitLog()
    InitMenu()
    InitEvents()
    RetrieveBallPosition()
    return true
end
