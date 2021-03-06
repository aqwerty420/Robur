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
local Core, ObjectManager, Game, Geometry, SpellSlots, Orbwalker, Menu, TargetSelector, ballBuffNames, ballObjName, ballMissileNames, qSpeed, baseDelay, ballObj, ballMoving, ballOnSelf, qInput, Q, wInput, W, eInput, E, rInput, R, QR, IsBall, GetValidNearbyHeroes, OnCreateObject, OnBuffGain, OnCastSpell, OnProcessSpell, IsToCancel, OnInterruptibleSpell, OnGapclose, OnDraw, IsInRange, getValuePos, tryQ, tryW, tryE, getBestER, getQR, tryR, Auto, Combo, Harass, Flee, OnTick
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
function OnCreateObject(obj)
    if (obj.Name == ballMissileNames[1]) or (obj.Name == ballMissileNames[2]) then
        ballOnSelf = false
        ballMoving = true
        ballObj = obj
        return
    end
    if IsBall(obj) then
        ballMoving = false
        ballObj = obj.AsMinion
    end
end
function OnBuffGain(obj, buff)
    if obj.IsMe and (buff.Name == ballBuffNames[1]) then
        ballOnSelf = true
        ballMoving = false
        ballObj = obj.AsHero
        return
    end
    if (obj.IsHero and obj.IsAlly) and (ballBuffNames[3] == buff.Name) then
        ballMoving = false
        ballOnSelf = obj.IsMe
        ballObj = obj.AsHero
    end
end
function OnCastSpell(args)
    if Menu.Get("rBlock") and (args.Slot == SpellSlots.R) then
        local enemies = GetValidNearbyHeroes("enemy")
        do
            local i = 0
            while i < #enemies do
                if IsInRange(
                    enemies[i + 1],
                    Menu.Get("rRadius"),
                    ballObj.Position,
                    rInput.Delay
                ) then
                    return
                end
                i = i + 1
            end
        end
        args.Process = false
    end
end
function OnProcessSpell(source, spell)
    if ((((((not ballMoving) and source.IsHero) and source.IsEnemy) and spell.Target) and (not spell.IsBasicAttack)) and spell.Target.IsHero) and spell.Target.IsAlly then
        if spell.Target.IsMe then
            if Menu.Get("eShieldSelf") and E:CanCast(Player) then
                E:Cast(Player)
            end
            return
        end
        local target = spell.Target.AsHero
        if Menu.Get("eShield" .. target.CharName) and E:CanCast(target) then
            E:Cast(target)
        end
    end
end
function IsToCancel(enemyName, slot)
    if slot == SpellSlots.Q then
        return Menu.Get(enemyName .. "CancelQ")
    end
    if slot == SpellSlots.W then
        return Menu.Get(enemyName .. "CancelW")
    end
    if slot == SpellSlots.E then
        return Menu.Get(enemyName .. "CancelE")
    end
    if slot == SpellSlots.R then
        return Menu.Get(enemyName .. "CancelR")
    end
end
function OnInterruptibleSpell(source, spell, danger, endTime, canMove)
    if ((((Menu.Get("rCancel") and (not ballMoving)) and source.IsEnemy) and source.IsHero) and IsToCancel(source.CharName, spell.Slot)) and (ballObj:Distance(source.Position) <= Menu.Get("rRadius")) then
        if not canMove then
            R:Cast()
        elseif source:FastPrediction(rInput.Delay):Distance(ballObj) <= Menu.Get("rRadius") then
            R:Cast()
        end
    end
end
function OnGapclose(source, dash)
    if (((Menu.Get("eToR") and (Menu.Get("rAuto") or (Menu.Get("rCombo") and (Orbwalker.GetMode() == "Combo")))) and source.IsAlly) and source.IsHero) and E:CanCast(source) then
        local enemies = GetValidNearbyHeroes("enemy")
        local dashPath = dash:GetPaths()
        local lastPos = dashPath[#dashPath].EndPos
        if getValuePos(enemies, dash.EndDelay, lastPos) >= Menu.Get("rValue") then
            E:Cast(source)
        end
    end
end
function OnDraw()
    if not ballMoving then
        if Menu.Get("ballDraw") then
            local drawBallPos = Geometry.Vector(ballObj.Position)
            local t = Core.Game.GetTime() % 0.8
            drawBallPos.y = drawBallPos.y + 100
            drawBallPos.y = drawBallPos.y + (((t < 0.4) and (function() return -50 * t end)) or (function() return -(20 - ((t - 0.4) * 50)) end))()
            Core.Renderer.DrawCircle3D(drawBallPos, 100, 10, 10)
        end
        if Menu.Get("rDraw") then
            Core.Renderer.DrawCircle3D(ballObj.Position, rInput.Radius, 10)
        end
    end
    if Menu.Get("qDraw") then
        Core.Renderer.DrawCircle3D(Player.Position, qInput.Range, 10)
    end
    if Menu.Get("eDraw") then
        Core.Renderer.DrawCircle3D(Player.Position, eInput.Range, 10)
    end
end
function IsInRange(enemy, range, position, delay)
    if enemy.Position:Distance(position) > range then
        return false
    end
    if not delay then
        return true
    end
    local enemyPos = enemy:FastPrediction(delay)
    return enemyPos:Distance(position) <= range
end
function getValuePos(enemies, delay, position)
    local count = 0
    do
        local i = 0
        while i < #enemies do
            local enemy = enemies[i + 1].AsHero
            if IsInRange(
                enemy,
                Menu.Get("rRadius"),
                position,
                delay
            ) then
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
    if (Menu.Get("eToQ") and E:IsReady()) and ((Q:GetManaCost() + E:GetManaCost()) <= Player.Mana) then
        local isBallFar = true
        do
            local i = 0
            while i < #enemies do
                if enemies[i + 1].Position:Distance(ballObj.Position) < (enemies[i + 1].Position:Distance(Player.Position) + Menu.Get("eToQDistance")) then
                    isBallFar = false
                    break
                end
                i = i + 1
            end
        end
        if isBallFar then
            return E:Cast(Player)
        end
    end
    Q:SetRangeCheckObj(ballObj)
    if #enemies > 1 then
        local castPos = {
            Q:GetBestLinearCastPos(enemies)
        }
        if castPos[2] > 1 then
            return Q:Cast(castPos[1])
        end
    end
    local target = Q:GetTarget()
    if not target then
        return false
    end
    return Q:Cast(target)
end
function tryW(enemies)
    if (not W:IsReady()) or (W:GetManaCost() > Player.Mana) then
        return false
    end
    do
        local i = 0
        while i < #enemies do
            if IsInRange(enemies[i + 1], wInput.Radius, ballObj.Position, baseDelay) then
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
            local reachDelay = (ballObj.Position:Distance(enemies[i + 1]) / eInput.Speed) + baseDelay
            local enemyPos = enemies[i + 1]:FastPrediction(reachDelay)
            local distance = enemyPos:LineDistance(ballObj.Position, Player.Position, false)
            if distance <= eInput.Radius then
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
            local reachDelay = (ballObj.Position:Distance(allies[i + 1]) / eInput.Speed) + baseDelay
            local allyPosition = allies[i + 1]:FastPrediction(reachDelay)
            do
                local j = 0
                while j < #enemies do
                    local enemy = enemies[j + 1].AsHero
                    if IsInRange(
                        enemy,
                        Menu.Get("rRadius"),
                        allyPosition,
                        reachDelay
                    ) then
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
    QR:SetRangeCheckObj(ballObj)
    local castPos = {
        QR:GetBestCircularCastPos(enemies)
    }
    do
        local j = 0
        while j < #enemies do
            local enemy = enemies[j + 1].AsHero
            if IsInRange(
                enemy,
                Menu.Get("rRadius"),
                castPos[1],
                baseDelay + (ballObj:Distance(castPos[1]) / qSpeed)
            ) then
                count = count + Menu.Get("rWeight" .. enemy.CharName)
            end
            j = j + 1
        end
    end
    return castPos[1], count
end
function tryR(allies, enemies)
    if (not R:IsReady()) or (R:GetManaCost() > Player.Mana) then
        return false
    end
    local rResult = getValuePos(enemies, rInput.Delay, ballObj.Position)
    local qrResult = {
        getQR(enemies)
    }
    local erResult = {
        getBestER(allies, enemies)
    }
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
        if tryE(enemies) then
            return
        end
    end
end
function Flee()
    if not ballOnSelf then
        if (Menu.Get("eFlee") and E:IsReady()) and (E:GetManaCost() <= Player.Mana) then
            E:Cast(Player)
        end
    else
        if (Menu.Get("wFlee") and W:IsReady()) and (W:GetManaCost() <= Player.Mana) then
            W:Cast()
        end
    end
end
function OnTick()
    if ((((ballMoving or Player.IsDead) or Player.IsRecalling) or (not Player.CanCast)) or Game.IsMinimized()) or Game.IsChatOpen() then
        return
    end
    local allies = GetValidNearbyHeroes("ally")
    local enemies = GetValidNearbyHeroes("enemy")
    local orbwalkerMode = Orbwalker.GetMode()
    if orbwalkerMode == "Flee" then
        return Flee()
    end
    if #enemies == 0 then
        return
    end
    repeat
        local ____switch137 = orbwalkerMode
        local ____cond137 = ____switch137 == "Combo"
        if ____cond137 then
            do
                Combo(allies, enemies)
                break
            end
        end
        ____cond137 = ____cond137 or (____switch137 == "Harass")
        if ____cond137 then
            do
                Harass(allies, enemies)
                break
            end
        end
        ____cond137 = ____cond137 or (____switch137 == "Lasthit")
        if ____cond137 then
            do
                break
            end
        end
        ____cond137 = ____cond137 or (____switch137 == "Waveclear")
        if ____cond137 then
            do
                break
            end
        end
        ____cond137 = ____cond137 or (____switch137 == "nil")
        if ____cond137 then
            do
                Auto(allies, enemies)
                break
            end
        end
    until true
end
if Player.CharName ~= "Orianna" then
    return false
end
Core = _G.CoreEx
ObjectManager = Core.ObjectManager
Game = Core.Game
Geometry = Core.Geometry
local Enums = Core.Enums
SpellSlots = Enums.SpellSlots
local Events = Enums.Events
local Libs = _G.Libs
Orbwalker = Libs.Orbwalker
Menu = Libs.NewMenu
local SpellLib = Libs.Spell
TargetSelector = Libs.TargetSelector()
ballBuffNames = {"orianaghostself", "orianaghost", "orianaredactshield"}
ballObjName = "TheDoomBall"
ballMissileNames = {"OrianaIzuna", "OrianaRedact"}
local qRange = 825
qSpeed = 1400
local ballRadius = 80
local rRadius = 400
baseDelay = 0.25
local mathHuge = _G.math.huge
ballObj = Player
ballMoving = false
ballOnSelf = false
qInput = {Slot = SpellSlots.Q, Range = qRange, Speed = qSpeed, Delay = baseDelay, Radius = ballRadius, Type = "Linear", UseHitbox = true, Collisions = {WindWall = true}}
Q = SpellLib.Skillshot(qInput)
wInput = {Slot = SpellSlots.W, Range = 0, Speed = mathHuge, Delay = baseDelay, Radius = 225, Type = "Circular", UseHitbox = false}
W = SpellLib.Active(wInput)
eInput = {Slot = SpellSlots.E, Range = 1120, Speed = 1850, Delay = baseDelay, Radius = ballRadius, Type = "Linear", UseHitbox = true, Collisions = {WindWall = true}}
E = SpellLib.Targeted(eInput)
rInput = {Slot = SpellSlots.R, Range = 0, Speed = mathHuge, Delay = 0.5, Radius = rRadius, Type = "Circular", UseHitbox = false}
R = SpellLib.Active(rInput)
local qrInput = {Slot = SpellSlots.Q, Range = qRange, Speed = qSpeed, Delay = baseDelay, Radius = rRadius, Type = "Circular", UseHitbox = false, Collisions = {WindWall = true}}
QR = SpellLib.Skillshot(qrInput)
local events = {{id = Events.OnTick, callback = OnTick}, {id = Events.OnDraw, callback = OnDraw}, {id = Events.OnCreateObject, callback = OnCreateObject}, {id = Events.OnCastSpell, callback = OnCastSpell}, {id = Events.OnProcessSpell, callback = OnProcessSpell}, {id = Events.OnInterruptibleSpell, callback = OnInterruptibleSpell}, {id = Events.OnGapclose, callback = OnGapclose}, {id = Events.OnBuffGain, callback = OnBuffGain}}
local function InitLog()
    module("PoncheOrianna", package.seeall, log.setup)
    clean.module("PoncheOrianna", clean.seeall, log.setup)
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
        "PoncheOrianna",
        "PoncheOrianna",
        function()
            Menu.NewTree(
                "q",
                "Q Options",
                function()
                    Menu.Checkbox("qCombo", "Combo", true)
                    Menu.Checkbox("qHarass", "Harass", true)
                    Menu.Checkbox("eToQ", "E to Q", true)
                    Menu.Slider("eToQDistance", "Min dist EQ", 350, 0, 600, 50)
                    Menu.Checkbox("qDraw", "Draw Range", true)
                end
            )
            Menu.NewTree(
                "w",
                "W Options",
                function()
                    Menu.Checkbox("wCombo", "Combo", true)
                    Menu.Checkbox("wHarass", "Harass", true)
                    Menu.Checkbox("wFlee", "Flee", true)
                    Menu.Checkbox("wAuto", "Auto", false)
                end
            )
            Menu.NewTree(
                "e",
                "E Options",
                function()
                    Menu.Checkbox("eCombo", "Combo", true)
                    Menu.Checkbox("eHarass", "Harass", false)
                    Menu.Checkbox("eFlee", "Flee", true)
                    Menu.Checkbox("eShieldSelf", "Protect self", true)
                    Menu.NewTree(
                        "eProtectList",
                        "Protect ally :",
                        function()
                            for ____, allyName in ipairs(alliesName) do
                                Menu.Checkbox("eShield" .. allyName, allyName, true)
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
                    Menu.Checkbox("rAuto", "Auto", true)
                    Menu.Slider("rRadius", "Radius", 390, 300, 400, 5)
                    Menu.Checkbox("eToR", "E to R", true)
                    Menu.Checkbox("qToR", "Q to R", true)
                    Menu.NewTree(
                        "eWaight",
                        "Enemy value :",
                        function()
                            for ____, enemyName in ipairs(enemiesName) do
                                Menu.Slider("rWeight" .. enemyName, enemyName, 1, 1, 3, 1)
                            end
                        end
                    )
                    Menu.Slider("rValue", "Value to cast", 2, 1, enemiesCount * 3, 1)
                    Menu.Checkbox("rCancel", "Use to cancel spell", true)
                    Menu.NewTree(
                        "SpellToCancel",
                        "Spell to cancel :",
                        function()
                            Menu.Text("Even ticked a spell will be cancelled", false)
                            Menu.Text("only if it is possible", false)
                            for ____, enemyName in ipairs(enemiesName) do
                                Menu.NewTree(
                                    enemyName .. "Cancel",
                                    enemyName .. " :",
                                    function()
                                        Menu.Checkbox(enemyName .. "CancelQ", "Q", true)
                                        Menu.Checkbox(enemyName .. "CancelW", "W", true)
                                        Menu.Checkbox(enemyName .. "CancelE", "E", true)
                                        Menu.Checkbox(enemyName .. "CancelR", "R", true)
                                    end
                                )
                            end
                        end
                    )
                    Menu.Checkbox("rBlock", "Block manual cast if no hit", true)
                    Menu.Checkbox("rDraw", "Draw Range", true)
                end
            )
            Menu.Checkbox("ballDraw", "Ball Draw", true)
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
local function RetrieveballObj()
    for key, obj in pairs(
        ObjectManager.Get("ally", "minions")
    ) do
        if IsBall(obj) then
            ballObj = obj
            return
        end
    end
end
local function RetrieveBallBuff()
    if Player:GetBuff(ballBuffNames[1]) then
        ballObj = Player
        ballOnSelf = true
        return
    end
    local allies = ObjectManager.Get("ally", "heroes")
    for key, obj in pairs(allies) do
        local ally = obj.AsHero
        if (not ally.IsMe) and ally:GetBuff(ballBuffNames[2]) then
            ballObj = ally
            ballOnSelf = false
        end
    end
end
OnLoad = function()
    InitLog()
    InitMenu()
    InitEvents()
    RetrieveballObj()
    RetrieveBallBuff()
    return true
end
return ____exports
