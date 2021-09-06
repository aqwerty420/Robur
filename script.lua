-- Lua Library inline imports
function __TS__ArrayPush(arr, ...)
    local items = {...}
    for ____, item in ipairs(items) do
        arr[#arr + 1] = item
    end
    return #arr
end

function __TS__SourceMapTraceBack(fileName, sourceMap)
    _G.__TS__sourcemap = _G.__TS__sourcemap or ({})
    _G.__TS__sourcemap[fileName] = sourceMap
    if _G.__TS__originalTraceback == nil then
        _G.__TS__originalTraceback = debug.traceback
        debug.traceback = function(thread, message, level)
            local trace
            if ((thread == nil) and (message == nil)) and (level == nil) then
                trace = _G.__TS__originalTraceback()
            else
                trace = _G.__TS__originalTraceback(thread, message, level)
            end
            if type(trace) ~= "string" then
                return trace
            end
            local result = string.gsub(
                trace,
                "(%S+).lua:(%d+)",
                function(file, line)
                    local fileSourceMap = _G.__TS__sourcemap[file .. ".lua"]
                    if fileSourceMap and fileSourceMap[line] then
                        return (file .. ".ts:") .. tostring(fileSourceMap[line])
                    end
                    return (file .. ".lua:") .. line
                end
            )
            return result
        end
    end
end

__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["42"] = 214,["43"] = 215,["44"] = 214,["45"] = 218,["46"] = 219,["47"] = 221,["48"] = 221,["49"] = 221,["50"] = 224,["51"] = 224,["54"] = 226,["55"] = 218,["56"] = 229,["57"] = 230,["58"] = 231,["59"] = 232,["60"] = 233,["64"] = 236,["65"] = 236,["66"] = 237,["67"] = 238,["68"] = 239,["69"] = 240,["72"] = 236,["75"] = 229,["76"] = 246,["77"] = 247,["78"] = 248,["79"] = 249,["82"] = 252,["85"] = 253,["86"] = 254,["87"] = 246,["88"] = 257,["89"] = 258,["90"] = 259,["92"] = 260,["93"] = 260,["94"] = 261,["97"] = 260,["100"] = 265,["102"] = 257,["103"] = 269,["104"] = 269,["105"] = 269,["107"] = 270,["108"] = 270,["110"] = 271,["111"] = 271,["113"] = 272,["114"] = 273,["115"] = 269,["116"] = 276,["117"] = 283,["118"] = 284,["120"] = 276,["121"] = 288,["122"] = 289,["123"] = 289,["125"] = 290,["126"] = 291,["127"] = 291,["129"] = 292,["130"] = 293,["133"] = 296,["134"] = 297,["137"] = 298,["138"] = 303,["139"] = 304,["141"] = 305,["142"] = 288,["143"] = 308,["144"] = 309,["145"] = 309,["148"] = 310,["149"] = 310,["150"] = 311,["151"] = 312,["153"] = 310,["156"] = 315,["157"] = 308,["158"] = 318,["159"] = 319,["160"] = 319,["163"] = 320,["164"] = 320,["165"] = 321,["166"] = 322,["167"] = 323,["168"] = 328,["169"] = 329,["171"] = 320,["174"] = 332,["175"] = 318,["176"] = 372,["177"] = 373,["178"] = 374,["182"] = 372,["183"] = 378,["184"] = 379,["185"] = 380,["189"] = 382,["190"] = 383,["194"] = 385,["195"] = 386,["199"] = 378,["200"] = 390,["201"] = 391,["202"] = 392,["206"] = 394,["207"] = 395,["211"] = 397,["212"] = 398,["216"] = 390,["217"] = 402,["218"] = 403,["219"] = 404,["220"] = 407,["223"] = 416,["224"] = 418,["227"] = 420,["228"] = 422,["229"] = 423,["231"] = 427,["233"] = 431,["235"] = 435,["237"] = 439,["239"] = 443,["246"] = 424,["253"] = 428,["278"] = 444,["283"] = 402,["284"] = 24,["285"] = 27,["287"] = 30,["288"] = 31,["289"] = 32,["290"] = 34,["291"] = 35,["292"] = 36,["293"] = 37,["294"] = 39,["295"] = 40,["296"] = 41,["297"] = 42,["298"] = 43,["299"] = 45,["300"] = 46,["301"] = 47,["302"] = 48,["303"] = 49,["304"] = 52,["305"] = 53,["306"] = 54,["307"] = 55,["308"] = 56,["309"] = 57,["310"] = 58,["311"] = 59,["312"] = 60,["313"] = 62,["314"] = 66,["315"] = 67,["316"] = 68,["317"] = 70,["318"] = 81,["319"] = 83,["320"] = 93,["321"] = 104,["322"] = 115,["323"] = 126,["324"] = 145,["325"] = 148,["326"] = 151,["327"] = 145,["328"] = 154,["329"] = 155,["330"] = 155,["331"] = 155,["332"] = 155,["333"] = 156,["334"] = 156,["335"] = 156,["336"] = 156,["337"] = 157,["338"] = 158,["339"] = 160,["340"] = 156,["341"] = 156,["342"] = 163,["343"] = 163,["344"] = 163,["345"] = 163,["346"] = 164,["347"] = 165,["348"] = 167,["349"] = 168,["350"] = 169,["351"] = 163,["352"] = 163,["353"] = 171,["354"] = 171,["355"] = 171,["356"] = 171,["357"] = 172,["358"] = 173,["359"] = 175,["360"] = 176,["361"] = 177,["362"] = 178,["363"] = 179,["364"] = 171,["365"] = 171,["366"] = 181,["367"] = 181,["368"] = 181,["369"] = 181,["370"] = 182,["371"] = 183,["372"] = 184,["373"] = 185,["374"] = 186,["375"] = 188,["376"] = 189,["377"] = 181,["378"] = 181,["379"] = 191,["380"] = 155,["381"] = 155,["382"] = 154,["383"] = 195,["384"] = 196,["386"] = 197,["387"] = 197,["388"] = 198,["389"] = 197,["392"] = 195,["393"] = 202,["394"] = 204,["395"] = 204,["396"] = 204,["397"] = 207,["398"] = 208,["402"] = 202,["403"] = 335,["404"] = 336,["406"] = 337,["407"] = 337,["408"] = 338,["409"] = 339,["411"] = 337,["414"] = 342,["415"] = 335,["416"] = 345,["417"] = 349,["418"] = 350,["420"] = 351,["421"] = 351,["422"] = 352,["423"] = 353,["425"] = 354,["426"] = 354,["427"] = 355,["428"] = 356,["430"] = 354,["433"] = 359,["434"] = 360,["435"] = 361,["437"] = 351,["440"] = 364,["441"] = 345,["442"] = 367,["443"] = 368,["444"] = 369,["445"] = 369,["447"] = 367,["448"] = 450,["449"] = 451,["450"] = 452,["451"] = 453,["452"] = 454,["453"] = 455,["454"] = 450});
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
    if delay == 0 then
        return true
    end
    local enemyPos = enemy:FastPrediction(delay)
    return enemyPos:Distance(ballPosition) <= range
end
function OnDraw()
    if Menu.Get("ballDraw") and (not ballMoving) then
        Core.Renderer.DrawCircle3D(ballPosition, 100, 10)
    end
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
            if IsInRange(enemies[i + 1], wRadius, baseDelay) then
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
    local ____switch78 = orbwalkerMode
    if ____switch78 == "Combo" then
        goto ____switch78_case_0
    elseif ____switch78 == "Harass" then
        goto ____switch78_case_1
    elseif ____switch78 == "Lasthit" then
        goto ____switch78_case_2
    elseif ____switch78 == "Waveclear" then
        goto ____switch78_case_3
    elseif ____switch78 == "Flee" then
        goto ____switch78_case_4
    elseif ____switch78 == "nil" then
        goto ____switch78_case_5
    end
    goto ____switch78_end
    ::____switch78_case_0::
    do
        do
            Combo(allies, enemies)
            goto ____switch78_end
        end
    end
    ::____switch78_case_1::
    do
        do
            Harass(allies, enemies)
            goto ____switch78_end
        end
    end
    ::____switch78_case_2::
    do
        do
            goto ____switch78_end
        end
    end
    ::____switch78_case_3::
    do
        do
            goto ____switch78_end
        end
    end
    ::____switch78_case_4::
    do
        do
            goto ____switch78_end
        end
    end
    ::____switch78_case_5::
    do
        do
            Auto(allies, enemies)
            goto ____switch78_end
        end
    end
    ::____switch78_end::
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
E = SpellLib.Skillshot({Slot = SpellSlots.E, Range = 1120, Speed = eSpeed, Delay = baseDelay, Radius = ballRadius, Type = "Linear", UseHitbox = true, Collisions = collisions})
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
