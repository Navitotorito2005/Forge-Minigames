local _G = GLOBAL

-- Create a ReForged preset with proper settings.
_G.AddPreset("dodgeball", "reforged", nil, "forge", "sandbox", "lavaarena", {no_revives = true, no_heal = true, no_restriction = true}, {atlas = "images/reforged.xml", tex = "preset_s1.tex",}, 0)
_G.STRINGS.REFORGED.PRESETS["dodgeball"] = "Dodgeball"
_G.TUNING.FORGE.RILEDLUCY.DAMAGE = 0

-- All commands start with "c_ld_" to diferentiate from other commands.

_G.c_ld_equipall = function(prefab) -- Equips all players with an specified item.
    if not prefab then
        Log("error", "Must specify a prefab")
    end
    Log("log", "Equipping all players with" .. prefab)
    for k, v in pairs(_G.AllNonSpectators) do
        _G.EquipItem(prefab, v)
    end
end

_G.c_ld_deleteall = function(prefab) -- Deletes all items from a specified prefab.
    if not prefab then
        Log("error", "Must specify a prefab")
    end
    for k, v in pairs(_G.Ents) do
        if v.prefab == prefab then
            v:Remove()
        end
    end
end

_G.c_ld_deleteequipment = function() -- Deletes all equipment. (weapons and armor)
    for k, v in pairs(_G.Ents) do
        if v.components.inventoryitem then
            v:Remove()
        end
    end
end

_G.c_ld_cleanpets = function() -- Remove all pets.
    Log("log", "Removing all pets.")
    _G.c_ld_deleteall("mean_flytrap")
    _G.c_ld_deleteall("forge_abigail")
    _G.c_ld_deleteall("forge_woby")
    _G.c_ld_deleteall("babyspider")
    _G.c_ld_deleteall("baby_ben")
end

_G.c_ld_maxhp = function(n) -- Set all players HP to 150.
    local hp = n or 150
    Log("log", "Setting all players HP to " .. hp .. ".")
    for k, v in pairs(_G.AllNonSpectators) do
        if not v.components.health:IsDead() then
            v.components.health:SetMaxHealth(hp)
        end
    end
end

_G.c_ld_reviveall = function() -- Revive all dead players.
    Log("log", "Reviving all dead players.")
    for k, v in pairs(_G.AllNonSpectators) do
        if v.components.health:IsDead() then
            v.components.revivablecorpse:SetReviveHealthPercent(1)
            v:PushEvent("respawnfromcorpse", {source=TheWorld})
        end
    end
end

_G.c_ld_spreadplayers = function() -- Spread players randomly around the center.
    local pugna = _G.c_find("lavaarena_boarlord")
    if not pugna then
        Log("error", "Could not find Battlemaster Pugna to get the map's center.")
        return
    end
    Log("log", "Spreading players around the center.")
    local x = pugna:GetPosition().x
    local z = pugna:GetPosition().z + 39
    local dist = 20
    local deg_inc = 360 / #_G.AllNonSpectators
    local deg = math.random(0, 359)
    local AllNonSpectatorsCopy = {}
    for k, v in pairs(_G.AllNonSpectators) do
        AllNonSpectatorsCopy[k] = v
    end
    _G.shuffleArray(AllNonSpectatorsCopy)
    for k, v in pairs(AllNonSpectatorsCopy) do
        v.Transform:SetPosition(x + (math.sin(math.rad(deg)) * dist), 0, z + (math.cos(math.rad(deg)) * dist))
        deg = deg + deg_inc
    end
end

_G.c_ld_spawnlucy = function() -- Spawn 4 Riled Lucys at the center.
    local pugna = _G.c_find("lavaarena_boarlord")
    if not pugna then
        Log("error", "Could not find Battlemaster Pugna to get the map's center.")
        return
    end
    Log("log", "Spawning 4 Riled Lucys at the center.")
    local x = pugna:GetPosition().x
    local z = pugna:GetPosition().z + 39
    _G.SpawnPrefab("riledlucy").Transform:SetPosition(x + 4, 0, z)
    _G.SpawnPrefab("riledlucy").Transform:SetPosition(x - 4, 0, z)
    _G.SpawnPrefab("riledlucy").Transform:SetPosition(x, 0, z + 4)
    _G.SpawnPrefab("riledlucy").Transform:SetPosition(x, 0, z - 4)
end

_G.c_ld_spawnlucy_perplayer = function() -- Spawn one Riled Lucy per player in a circle around the center.
    local pugna = _G.c_find("lavaarena_boarlord")
    if not pugna then
        Log("error", "Could not find Battlemaster Pugna to get the map's center.")
        return
    end
    Log("log", "Spawning Riled Lucys per player around the center.")
    local x = pugna:GetPosition().x
    local z = pugna:GetPosition().z + 39
    local dist = 4
    local deg_inc = 360 / #_G.AllNonSpectators
    local deg = 0
    for i = 1, #_G.AllNonSpectators do
        _G.SpawnPrefab("riledlucy").Transform:SetPosition(x + (math.sin(math.rad(deg)) * dist), 0, z + (math.cos(math.rad(deg)) * dist)) 
        deg = deg + deg_inc
    end
end

_G.c_ld_freezeplayers = function() -- Freeze all players in place.
    Log("log", "Freezing all players in place.")
    for k, v in pairs(_G.AllNonSpectators) do
        v.components.locomotor:SetExternalSpeedMultiplier(v, "c_ld_speedmult", 0)
    end
    --for k,v in pairs(_G.Ents) do
        --if v.components.rechargeable then
            --if v.prefab == "riledlucy" then
                --v.components.rechargeable:SetRechargeTime(1)
            --end
            --v.components.rechargeable:StartRecharge()
        --end
    --end
end

_G.c_ld_unfreezeplayers = function() -- Unfreeze all players.
    Log("log", "Unfreezing all players.")
    for k, v in pairs(_G.AllNonSpectators) do
        v.components.locomotor:SetExternalSpeedMultiplier(v, "c_ld_speedmult", 1)
    end
end

_G.c_ld_freezeallof = function(prefab) -- Freeze all entities of a certain prefab in place.
    if not prefab then 
        Log("error", "Must specify a prefab.")
        return
    end
    Log("log", "Freezing all \"" .. prefab .. "\" in place.")
    for k, v in pairs(_G.Ents) do
        if v.prefab == prefab then
            v.components.locomotor:SetExternalSpeedMultiplier(v, "c_ld_speedmult", 0)
        end
    end
end

_G.c_ld_unfreezeallof = function(prefab) -- Unfreeze all entities of a certain prefab.
    Log("log", "Unfreezing all \"" .. prefab .. "\".")
    for k, v in pairs(_G.Ents) do
        if v.prefab == prefab then
            v.components.locomotor:SetExternalSpeedMultiplier(v, "c_ld_speedmult", 1)
        end
    end
end

_G.c_ld_color = function(player_name, color) -- Change the color of a player.
    if not player_name then 
        Log("error", "Must specify a player name.")
        return
    end
    if not color then 
        Log("error", "Must specify a color. (Available colors: red, blue, yellow, green, default)")
        return
    end
    Log("log", "Changing the color of " .. player_name .. " to " .. (color or "default") .. ".")
    for k, v in pairs(_G.AllNonSpectators) do
        if v.name == player_name then
            if color == "red" or color == 1 then
                v.AnimState:SetAddColour(0.6, 0, 0, 1)
            elseif color == "blue" or color == 2 then
                v.AnimState:SetAddColour(0.1, 0, 0.7, 1)
            elseif color == "yellow" or color == 3 then
                v.AnimState:SetAddColour(0.2, 0.5, 0, 1)
            elseif color == "green" or color == 4 then
                v.AnimState:SetAddColour(0, 0.6, 0.2, 1)
            elseif color == nil or color == 0 then
                v.AnimState:SetAddColour(0, 0, 0, 1)
            end
        end
    end
end

_G.c_ld_teams = function(n) -- Divide players into n teams and color them accordingly. Max 4 teams.
    if not n then 
        Log("error", "Must specify a number of teams.")
        return
    end
    if n <= 1 or n > 4 then 
        Log("error", "The number of teams must be between 2 and 4.")
        return
    end
    Log("log", "Dividing players into " .. n .. " teams.")
    _G.c_ld_removecolors(false)
    local AllNonSpectatorsCopy = {}
    local maxplayers = math.floor(#_G.AllNonSpectators / n) * n
    if maxplayers < #_G.AllNonSpectators then
        Log("warning", "There are not enough players to divide into " .. n .. " teams. Only " .. maxplayers .. " players will be colored.")
    end
    for k, v in pairs(_G.AllNonSpectators) do
        AllNonSpectatorsCopy[k] = v
    end
    _G.shuffleArray(AllNonSpectatorsCopy)
    for i = 1, maxplayers/n do
        AllNonSpectatorsCopy[i].AnimState:SetAddColour(0.6, 0, 0, 1)
    end
    for i = maxplayers/n + 1, maxplayers/n*2 do
        AllNonSpectatorsCopy[i].AnimState:SetAddColour(0.1, 0, 0.7, 1)
    end
    if n < 3 then return end
    for i = maxplayers/n*2 + 1, maxplayers/n*3 do
        AllNonSpectatorsCopy[i].AnimState:SetAddColour(0.2, 0.5, 0, 1)
    end
    if n < 4 then return end
    for i = maxplayers/n*3 + 1, maxplayers do
        AllNonSpectatorsCopy[i].AnimState:SetAddColour(0, 0.6, 0.2, 1)
    end
end

_G.c_ld_removecolors = function(log) -- Remove all team colors from players.
    if log then Log("log", "Cleaning colors from all players.") end
    for k, v in pairs(_G.AllNonSpectators) do
        v.AnimState:SetAddColour(0, 0, 0, 1)
    end
end

_G.c_ld_docountdown = function(n) -- Countdown in the chat for a "n" number of seconds.
    local sec = n or 5
    Log("log", "Starting game countdown for " .. sec .. " seconds.")
    _G.TheNet:Announce("Starting game...")
    for i = sec, 1, -1 do
        _G.TheWorld:DoTaskInTime(i, function() _G.TheNet:Announce(sec - i + 1 .. "...") end)
    end
    _G.TheWorld:DoTaskInTime(sec + 1, function() 
        _G.TheNet:Announce("GO!")
        _G.c_ld_equipall("riledlucy")
        _G.c_ld_unfreezeplayers()
        _G.TheWorld.net.components.mutatormanager:UpdateMutators({friendly_fire = true})
    end)
end

_G.c_ld_setupgame = function(teams, lucy_type, timer) -- Setups the game.
    Log("log", "----------     SETTING UP LUCY DODGEBALL     ----------")
    if not timer or timer <= 0 then
        _G.TheNet:Announce("Setting up game...")
    end
    _G.TheWorld.net.components.mutatormanager:UpdateMutators({friendly_fire = false})
    _G.c_ld_deleteequipment()
    _G.c_ld_cleanpets()
    _G.c_ld_reviveall()
    _G.c_ld_equipall("reedtunic")
    _G.c_ld_maxhp(150)
    _G.c_ld_spreadplayers()
    if lucy_type then
        _G.c_ld_spawnlucy_perplayer()
    else
        _G.c_ld_spawnlucy()
    end
    if teams and teams > 1 and teams <= 4 then
        _G.c_ld_teams(teams)
    end
    _G.c_ld_freezeplayers()
    if timer and timer > 0 then
        _G.c_ld_docountdown(timer)
    end
end

-- This print function is not needed per se, but I thought it would make this mod more professional.
function Log(type, message)
    print("[LD." .. string.upper(type) .. "] " .. message)
end