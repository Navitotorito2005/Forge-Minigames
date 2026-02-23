------------------------------------------------------------------------------------------------------------------------
-- [ FUNCTIONS ]
------------------------------------------------------------------------------------------------------------------------

local Constants = require("fm_constants")

local FUNC = {}

-- Global state variables.
FUNC.TAGGED_PLAYERS = {}
FUNC.CURRENT_MINIGAME = nil
FUNC.CURRENT_TEAMS = nil

-- Logging function.
function FUNC.Log(type, message)
    print("[FM." .. string.upper(type) .. "] " .. message)
end

-- Check if minigame exists.
function FUNC.DoesMinigameExists(name)
    if type(name) == "number" then
        name = FUNC.NumberToMinigame(name)
    end

    if name == "lucy" or name == "molten" or name == "tag" then
        return true
    else
        FUNC.Log("error", "Invalid minigame name. Must be \"lucy\", \"molten\" or \"tag\".")
        return false
    end
end

-- Convert number to minigame name.
function FUNC.NumberToMinigame(n)
    if n == 1 then
        return "lucy"
    elseif n == 2 then
        return "molten"
    elseif n == 3 then
        return "tag"
    else
        FUNC.Log("error", "Invalid minigame number. Must be 1 (Lucy Dodgeball), 2 (Molten Shooters) or 3 (Explosive Tag).")
        return
    end
end

-- Get proper name of minigame.
function FUNC.GetMinigameName(name)
    if type(name) == "number" then
        name = FUNC.NumberToMinigame(name)
    end

    if not FUNC.DoesMinigameExists(name) then return
    elseif name == "lucy" then return "Lucy Dodgeball"
    elseif name == "molten" then return "Molten Shooters"
    elseif name == "tag" then return "Explosive Tag"
    end
end

-- Get rules string of minigame.
function FUNC.GetMinigameRules(n)
    if type(n) == "number" then
        n = FUNC.NumberToMinigame(n)
    end

    if not n or n ~= "lucy" and n ~= "molten" and n ~= "tag" then 
        FUNC.Log("error", "Must specify a minigame to print the rules of. (\"lucy\", \"molten\" or \"tag\")")
        return nil
    end

    return tostring(Constants.RULES_STRINGS[n])
end

-- Get forge world center.
function FUNC.GetForgeWorldCenter()
    local pugna = _G.c_find("lavaarena_boarlord")
    if not pugna then
        FUNC.Log("warning", "Couldn't find Battlemaster Pugna to get the world center coordinates. Defaulting to (0, 0).")
        return 0, 0
    end

    local x = pugna:GetPosition().x
    local z = pugna:GetPosition().z + 39

    return x, z
end

-- Spawn a Riled Lucy.
function FUNC.SpawnDodgeballLucy()
    local inst = _G.c_spawn("riledlucy")
    inst:ListenForEvent("onthrown", function() inst.no_return = true end)
    return inst
end

-- Join a player to a team.
function FUNC.JoinTeam(player, team)
    if not player or not player:HasTag("player") then
        FUNC.Log("error", "Must specify a player instance.")
        return
    end

    if not team or team and (team ~= "red" and team ~= "blue" and team ~= "yellow" and team ~= "green") then
        FUNC.Log("error", "Must specify a color. (Available colors: red, blue, yellow, green, default)")
        return
    end

    if player.currentteam then
        FUNC.LeaveTeam(player)
    end

    if not FUNC.CURRENT_TEAMS then
        FUNC.CURRENT_TEAMS = {}
    end

    if not FUNC.CURRENT_TEAMS[team] then
        FUNC.CURRENT_TEAMS[team] = {}
    end

    local c = Constants.TEAM_COLORS[team]
    if not c then 
        FUNC.Log("error", "Expected team colors, got " .. tostring(c))
        return
    end

    player.AnimState:SetAddColour(tonumber(c[1]), tonumber(c[2]), tonumber(c[3]), 1)

    player.currentteam = team
    table.insert(FUNC.CURRENT_TEAMS[team], player)
end

-- Leave a team.
function FUNC.LeaveTeam(player)
    if not player or not player:HasTag("player") then
        FUNC.Log("error", "Must specify a player instance.")
        return
    end

    if not player.currentteam then
        FUNC.Log("warning", player.name .. " is not currently part of any team.")
        return
    end

    if not FUNC.CURRENT_TEAMS then
        FUNC.Log("warning", "There are no current teams settled up.")
        return
    end

    table.removearrayvalue(FUNC.CURRENT_TEAMS[player.currentteam], player)
    if #FUNC.CURRENT_TEAMS[player.currentteam] <= 0 then
        FUNC.CURRENT_TEAMS[player.currentteam] = nil
    end

    player.AnimState:SetAddColour(0, 0, 0, 1)
    player.currentteam = nil
end

-- Tag a player in Explosive Tag.
function FUNC.TagPlayer(player)
    table.insert(FUNC.TAGGED_PLAYERS, player)

    player:AddTag("fm_tagged")
    player:ListenForEvent("onattackother", FUNC.OnAttackPlayerTag)
    _G.c_fm_equipplayer(player, "teleport_staff")

    if player.tagtask then
        player.tagtask[2]:Cancel()
    end

    player.tagtask = {
        "0",
        player:DoPeriodicTask(0, function(player)
            player.tagtask[1] = player.tagtask[1] + 15
            player.AnimState:SetAddColour(0.75 + math.cos(math.rad(player.tagtask[1])) * 0.25, 0, 0, 1)
        end)
    }
end

-- Untag a player.
function FUNC.UntagPlayer(player)
    table.removearrayvalue(FUNC.TAGGED_PLAYERS, player)

    player:RemoveTag("fm_tagged")
    player:RemoveEventCallback("onattackother", FUNC.OnAttackPlayerTag)
    _G.c_fm_unequipplayer(player, "hands")

    player.AnimState:SetAddColour(0, 0, 0, 1)

    if player.tagtask then
        player.tagtask[2]:Cancel()
        player.tagtask = nil
    end
end

-- Tag multiple players.
function FUNC.TagMultiple()
    local p_list = {}
    for k, v in pairs(_G.AlivePlayers) do
        p_list[k] = v
    end
    
    if #p_list <= 1 then
        FUNC.Log("warning", "Not enough players to tag multiple.")
        return
    end
    
    _G.shuffleArray(p_list)
    local p_num = math.floor((#p_list / _G.TUNING.FM_CONFIG.ET_TAGPERCENT) + 0.5)

    local pugna_speech = _G.c_find("lavaarena_boarlord").components.talker
    local str = ""

    for i = 1, p_num do
        local player = p_list[i]
        FUNC.TagPlayer(player)
        str = str .. player.name .. (i < p_num and (i + 1 == p_num and " and " or ", ") or " ")
    end

    if p_num > 1 then
        str = str .. "have been tagged!"
    else
        str = str .. "has been tagged!"
    end

    pugna_speech:Say(str)
    TheWorld:DoTaskInTime(5, function() FUNC.TagCountdown(_G.TUNING.FM_CONFIG.ET_TAGCOUNTDOWN) end)
end

-- Countdown for tagged players.
function FUNC.TagCountdown(n)
    local pugna_speech = _G.c_find("lavaarena_boarlord").components.talker

    if n > 0 then
        pugna_speech:Say("" .. n)
        TheWorld:DoTaskInTime(1, function() FUNC.TagCountdown(n - 1) end)
    else
        while #FUNC.TAGGED_PLAYERS > 0 do
            _G.c_fm_tagkill(FUNC.TAGGED_PLAYERS[1])
        end

        FUNC.TAGGED_PLAYERS = {}
        pugna_speech:Say("BOOM!")

        if #_G.AlivePlayers > 1 then
            TheWorld:DoTaskInTime(5, function() FUNC.TagMultiple() end)
        end
    end
end

-- Handle attack event in Explosive Tag.
function FUNC.OnAttackPlayerTag(inst, data)
    local victim = data.target
    if victim ~= nil and victim:HasTag("player") and not victim:HasTag("fm_tagged") then
        if inst.prefab ~= "wes" and inst.prefab ~= "spectator" then
            inst.components.talker:Say("Tag, you're it!")
        end
        FUNC.TagPlayer(victim)
        FUNC.UntagPlayer(inst)
    end
end

-- Check if game is finished.
function FUNC.CheckIfGameFinished()
    if not FUNC.CURRENT_MINIGAME then return end

    local name_str = ""
    local game_str = ""

    if FUNC.CURRENT_TEAMS and #FUNC.CURRENT_TEAMS then
        local win_team = nil

        for k, v in pairs(FUNC.CURRENT_TEAMS) do
            if #v > 0 then
                if not win_team then win_team = tostring(k)
                else return end
            end
        end

        if not win_team then
            FUNC.Log("warning", "All teams are empty, cannot determine winner.")
            return
        end

        local upper_str = string.upper(string.sub(win_team, 1, 1)) .. string.sub(win_team, 2)
        name_str = upper_str .. " Team"
    else
        if #_G.AlivePlayers > 1 or #_G.AlivePlayers <= 0 then return end
        
        local winner = _G.AlivePlayers[1]
        
        if not winner or not winner.name then
            FUNC.Log("warning", "Winner player is invalid.")
            return
        end
        
        name_str = winner.name
    end

    game_str = FUNC.GetMinigameName(FUNC.CURRENT_MINIGAME)

    _G.c_fm_deleteall("riledlucy")
    _G.c_fm_deleteequipment(true)
    _G.c_fm_deleteequipment(false)
    _G.c_fm_removeteams()

    TheWorld.net.components.mutatormanager:UpdateMutators({friendly_fire = false})

    if _G.TUNING.FM_CONFIG.FINISH_RETURNTOLOBBY then
        FUNC.FinishGame(name_str, game_str)
    else
        local pugna_speech = _G.c_find("lavaarena_boarlord").components.talker
        pugna_speech:Say(name_str .. " has won the " .. game_str .. " game!")

        TheWorld:DoTaskInTime(3, function()
            FUNC.CURRENT_MINIGAME = nil
            FUNC.CURRENT_TEAMS = nil
            _G.c_fm_reviveall()
        end)
    end
end

-- End the game.
function FUNC.FinishGame(name_str, game_str)
    if not name_str and type(name_str) ~= "string" or not game_str and type(game_str) ~= "string" then
        FUNC.Log("error", "Could not finish the game due to missing parameters.")
        return
    end

    FUNC.Log("log", "--------------- FINISHING GAME. RETURNING TO LOBBY ---------------")

    local end_str = {
        name_str .. " has won the " .. game_str .. " game!",
        "Well played, everyone!",
        "Returning to lobby..."
    }

    _G.STRINGS.BOARLORD_MINIGAME_FINISH = end_str
    _G.STRINGS.UI.HUD.LAVAARENA_WIN_TITLE = "Finish!"
    _G.STRINGS.UI.HUD.LAVAARENA_WIN_BODY = "The game has finished. " .. name_str .. " wins! GG!"

    local data = require("wavesets/" .. REFORGED_SETTINGS.gameplay.waveset)
    data.endgame_speech.victory.speech = "BOARLORD_MINIGAME_FINISH"

    TheWorld.components.lavaarenaevent.command_executed = true
    TheWorld.components.lavaarenaevent:End(true)
end

-- World post init - track alive players.
function FUNC.WorldPostInit(world)
    local AlivePlayers = {}
    _G.AlivePlayers = AlivePlayers

    world:ListenForEvent("ms_playerjoined", function(world, player)
        if player.components.health and not player.components.health:IsDead() then
            table.insert(AlivePlayers, player)
        end

        player:ListenForEvent("respawnfromcorpse", function(player)
            table.insert(AlivePlayers, player)
        end)

        player:ListenForEvent("death", function(player)
            table.removearrayvalue(AlivePlayers, player)
            FUNC.LeaveTeam(player)
            TheWorld:DoTaskInTime(1, function() FUNC.CheckIfGameFinished() end)
        end)
    end)

    world:ListenForEvent("ms_playerleft", function(world, player)
        table.removearrayvalue(AlivePlayers, player)
        FUNC.LeaveTeam(player)
        TheWorld:DoTaskInTime(1, function() FUNC.CheckIfGameFinished() end)
    end)
end

-- Get current minigame.
function FUNC.GetCurrentMinigame()
    return FUNC.CURRENT_MINIGAME
end

-- Set current minigame.
function FUNC.SetCurrentMinigame(game)
    FUNC.CURRENT_MINIGAME = game
end

-- Get current teams.
function FUNC.GetCurrentTeams()
    return FUNC.CURRENT_TEAMS
end

-- Set current teams.
function FUNC.SetCurrentTeams(teams)
    FUNC.CURRENT_TEAMS = teams
end

return FUNC