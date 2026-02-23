------------------------------------------------------------------------------------------------------------------------
-- [ COMMANDS ]
------------------------------------------------------------------------------------------------------------------------

local Functions = require("fm_functions")
local Constants = require("fm_constants")

-- All FM commands start with "c_fm_" to differentiate from regular DST commands.

-- Equip a specific player with an item.
_G.c_fm_equipplayer = function(player, prefab)
    if not player or not player:HasTag("player") then
        Functions.Log("error", "Must specify a player instance.")
        return
    end

    if not prefab then
        Functions.Log("error", "Must specify a prefab.")
        return
    end

    local item = prefab == "riledlucy" and Functions.SpawnDodgeballLucy() or _G.c_spawn(prefab)

    Functions.Log("log", "Equipping " .. player.name .. " with \"" .. item.name .. "\".")

    local slot = item.components.equippable.equipslot

    local p_inv = player.components.inventory
    local p_item = p_inv:GetEquippedItem(slot)
    if p_item then p_item:Remove() end

    p_inv:Equip(item)
end

-- Unequip an item from a player.
_G.c_fm_unequipplayer = function(player, slot)
    if not player or not player:HasTag("player") then
        Functions.Log("error", "Must specify a player instance.")
        return
    end

    if not slot or not _G.EQUIPSLOTS[string.upper(slot)] or slot == "beard" or slot == "BEARD" then
        Functions.Log("error", "Must specify an equipment slot. (\"hands\", \"head\" or \"body\")")
        return
    end

    slot = string.upper(slot)
    local p_inv = player.components.inventory
    local p_item = p_inv:GetEquippedItem(_G.EQUIPSLOTS[slot])
    if p_item then 
        Functions.Log("log", "Unequipping " .. player.name .. " from \"" .. p_item.name .. "\".")
        p_item:Remove() 
    else
        Functions.Log("warning", player.name .. " has nothing equipped on the " .. string.lower(slot) .. " slot.")
    end
end

-- Equip all players with an item.
_G.c_fm_equipall = function(prefab)
    if not prefab then
        Functions.Log("error", "Must specify a prefab.")
        return
    end

    for k, v in pairs(_G.AllNonSpectators) do
        _G.c_fm_equipplayer(v, prefab)
    end
end

-- Delete all items of a prefab.
_G.c_fm_deleteall = function(prefab)
    if not prefab then
        Functions.Log("error", "Must specify a prefab.")
        return
    end

    Functions.Log("log", "Deleting all of \"" .. prefab .. "\".")

    for k, v in pairs(_G.Ents) do
        if v.prefab == prefab then
            v:Remove()
        end
    end
end

-- Delete all equipment.
_G.c_fm_deleteequipment = function(only_drops)
    Functions.Log("log", "Deleting all equipment " .. (only_drops and "dropped on the ground" or "from all players") .. ".")

    for k, v in pairs(_G.Ents) do
        if v.components.inventoryitem then
            if (only_drops and v.components.inventoryitem.owner == nil) or not only_drops and v.components.inventoryitem.owner ~= nil then
                v:Remove()
            end
        end
    end
end

-- Remove all pets.
_G.c_fm_cleanpets = function()
    Functions.Log("log", "Removing all pets.")

    _G.c_fm_deleteall("mean_flytrap")
    _G.c_fm_deleteall("forge_abigail")
    _G.c_fm_deleteall("forge_woby")
    _G.c_fm_deleteall("babyspider")
    _G.c_fm_deleteall("baby_ben")
    _G.c_fm_deleteall("ub_shadowduelist")
end

-- Set all players HP.
_G.c_fm_maxhp = function(n)
    local hp = n or 150

    Functions.Log("log", "Setting all players HP to " .. hp .. ".")

    for k, v in pairs(_G.AllNonSpectators) do
        if not v.components.health:IsDead() then
            v.components.health:SetMaxHealth(hp)
        end
    end
end

-- Set all players minimum HP.
_G.c_fm_minhp = function(n)
    local hp = n or 0

    Functions.Log("log", "Setting all players minimum HP to " .. hp .. ".")

    for k, v in pairs(_G.AllNonSpectators) do
        v.components.health:SetMinHealth(hp)
    end
end

-- Revive all dead players.
_G.c_fm_reviveall = function()
    Functions.Log("log", "Reviving all dead players.")

    local old_name = TheWorld.name
    TheWorld.name = "Forge Minigames' Server Command"

    for k, v in pairs(_G.AllNonSpectators) do
        if v.components.health:IsDead() then
            v.components.revivablecorpse:SetReviveHealthPercent(1)
            v:PushEvent("respawnfromcorpse", {source = TheWorld, user = TheWorld})
        end
    end

    TheWorld.name = old_name
end

-- Kill tagged player in Explosive Tag.
_G.c_fm_tagkill = function(player)
    if not player or not player:HasTag("player") then
        Functions.Log("error", "Must specify a player instance.")
        return
    end

    Functions.Log("log", "Killing " .. player.name .. " with the Explosive Tag.")

    local pos = player:GetPosition()
    local hp = player.components.health
    
    hp:SetMinHealth(0)
    hp:DoDelta(-hp.currenthealth - 1, nil, "fm_explosivetag", true, nil, true)
    
    _G.c_spawn("explosivehit").Transform:SetPosition(pos.x, pos.y, pos.z)

    Functions.UntagPlayer(player)
end

-- Spread players around center.
_G.c_fm_spreadplayers = function(dist)
    Functions.Log("log", "Spreading players around the center.")

    local x, z = Functions.GetForgeWorldCenter()
    local dist = dist or 20
    local deg_inc = 360 / #_G.AllNonSpectators
    local deg = math.random(0, 359)

    local AffectedPlayers = {}
    for k, v in pairs(_G.AllNonSpectators) do
        AffectedPlayers[k] = v
    end

    _G.shuffleArray(AffectedPlayers)
    
    for k, v in pairs(AffectedPlayers) do
        v.Transform:SetPosition(x + (math.sin(math.rad(deg)) * dist), 0, z + (math.cos(math.rad(deg)) * dist))
        deg = deg + deg_inc
    end
end

-- Spawn Riled Lucys.
_G.c_fm_spawnlucy = function(n)
    local count = n or 4
    if type(count) == "boolean" then
        if count then
            count = #_G.AllNonSpectators
        else
            count = 4
        end
    end

    Functions.Log("log", "Spawning " .. count .. " Riled Lucys around the center.")
    local x, z = Functions.GetForgeWorldCenter()
    local dist = 4
    local deg_inc = 360 / count
    local deg = 0
    for i = 1, count do
        Functions.SpawnDodgeballLucy().Transform:SetPosition(x + (math.sin(math.rad(deg)) * dist), 0, z + (math.cos(math.rad(deg)) * dist)) 
        deg = deg + deg_inc
    end
end

-- Freeze all players.
_G.c_fm_freezeplayers = function()
    Functions.Log("log", "Freezing all players in place.")

    for k, v in pairs(_G.AllNonSpectators) do
        v.components.locomotor:SetExternalSpeedMultiplier(v, "fm_speedmult", 0)
    end
end

-- Unfreeze all players.
_G.c_fm_unfreezeplayers = function()
    Functions.Log("log", "Unfreezing all players.")

    for k, v in pairs(_G.AllNonSpectators) do
        v.components.locomotor:SetExternalSpeedMultiplier(v, "fm_speedmult", 1)
    end
end

-- Set default damage.
_G.c_fm_defaultdamage = function(n)
    local dmg = n or _G.TUNING.UNARMED_DAMAGE

    Functions.Log("log", "Setting default damage to " .. dmg .. ".")

    for k, v in pairs(_G.AllNonSpectators) do
        v.components.combat:SetDefaultDamage(dmg)
    end
end

-- Tune weapons.
_G.c_fm_tuneweapons = function(weapon, type, n)
    if not weapon or (weapon ~= "lucy" and weapon ~= "molten" and weapon ~= "scepter") then
        Functions.Log("error", "Must specify a weapon. (\"lucy\", \"molten\" or \"scepter\")")
        return
    end

    if not type then
        Functions.Log("error", "Must specify a stat to tune. (\"damage\" or \"cooldown\")")
        return
    end

    if weapon == "lucy" and type == "cooldown" then
        Functions.Log("error", "Can't modify the cooldown of Riled Lucy.")
        return
    end
    
    local stat = n or 0

    Functions.Log("log", "Setting " .. (weapon == "lucy" and "Riled Lucy's" or weapon == "molten" and "Molten Darts'" or "Soul Scepter's") .. " " .. type .. " to " .. stat .. ".")

    if weapon == "lucy" then
        _G.TUNING.FORGE.RILEDLUCY.DAMAGE = stat
    elseif weapon == "molten" then
        _G.TUNING.FORGE.MOLTENDARTS[string.upper(type)] = stat
    else
        _G.TUNING.FORGE.TELEPORT_STAFF[string.upper(type)] = stat
    end
end

-- Disable all perks.
_G.c_fm_disableperks = function()
    Functions.Log("log", "Disabling all passive perks.")

    for k, v in pairs(_G.AllNonSpectators) do
        local is_wormwood = v.components.passive_bloom or v.components.passive_nourish
        if is_wormwood then
            is_wormwood:StopBloom()
        end

        local is_wanda = v.components.revivablecorpse
        if is_wanda and is_wanda:HasReviveCharges(is_wanda) then
            for i,data in pairs(is_wanda.revive_priority) do
                table.remove(is_wanda.revive_priority, i)
            end
        end

        local is_agewanda = v.components.health.regensources
        if is_agewanda and is_agewanda[v].tasks then
            for _, i in pairs(is_agewanda[v].tasks) do
                i.task:Cancel()
            end
            v.components.health:RemoveRegen("wanda_perk")
            v.components.combat:RemoveDamageBuff("age_perk")
        end

        local is_ubwoodie = v.components.werecreature
        if is_ubwoodie then
            is_ubwoodie:OnRemoveFromEntity()
            is_ubwoodie:SetUndying()
            is_ubwoodie:StopRegen("moose")
            TheWorld:DoTaskInTime(0.6, function()
                v.components.health:SetMaxHealth(Functions.GetCurrentMinigame() and (Functions.GetCurrentMinigame() == "molten" and _G.TUNING.FM_CONFIG.MS_PLAYERHP) or _G.TUNING.FM_CONFIG.LD_PLAYERHP)
            end)
        end

        local is_ubwortox = v.components.passive_impervious
        if is_ubwortox then
            is_ubwortox:RemoveImpervious()
        end

        for _, perk in pairs(Constants.PASSIVE_PERKS) do
            v:RemoveComponent(perk)
        end
    end
end

-- Set player team.
_G.c_fm_team = function(target, team)
    if not target then 
        Functions.Log("error", "Must specify a player name or player instance.")
        return
    end

    if type(target) == "string" then
        local found = false
        for k, v in pairs(_G.AllNonSpectators) do
            if v.name == target then
                target = v
                found = true
                break
            end
        end

        if not found then 
            Functions.Log("error", "Could not find player with name \"" .. target .. "\".")
            return
        end
    end

    if not team then
        Functions.Log("error", "Must specify a color. (Available colors: red, blue, yellow, green, default)")
        return
    end

    if type(team) == "number" then
        if team == 1 then team = "red" 
        elseif team == 2 then team = "blue" 
        elseif team == 3 then team = "yellow" 
        elseif team == 4 then team = "green"
        end
    end

    if team == "red" or team == "blue" or team == "yellow" or team == "green" then
        Functions.Log("log", "Setting the team of " .. target.name .. " to " .. team .. ".")
        Functions.JoinTeam(target, team)
    else
        Functions.Log("log", "Kicking " .. target.name .. " out of their team.")
        Functions.LeaveTeam(target)
    end
end

-- Divide players into teams.
_G.c_fm_teams = function(n)
    if not n then
        Functions.Log("error", "Must specify a number of teams.")
        return
    end

    if n < 2 or n > 4 then
        Functions.Log("error", "The number of teams must be between 2 and 4.")
        return
    end

    Functions.Log("log", "Dividing players into " .. n .. " teams.")

    _G.c_fm_removeteams(nil, true)

    local count = #_G.AllNonSpectators
    if count % n ~= 0 then
        TheNet:Announce("WARNING: Teams will be uneven (" .. count .. " players / " .. n .. " teams).")
    end

    local AffectedPlayers = {}
    for i = 1, count do
        AffectedPlayers[i] = _G.AllNonSpectators[i]
    end

    _G.shuffleArray(AffectedPlayers)

    for i = 1, count do
        local team = ((i - 1) % n) + 1
        _G.c_fm_team(AffectedPlayers[i], team)
    end
end

-- Remove team colors.
_G.c_fm_removeteams = function(player, log)
    if player then
        Functions.LeaveTeam(player)
        return
    end

    if not log then Functions.Log("log", "Kicking all players from their teams.") end

    for k, v in pairs(_G.AllNonSpectators) do
        Functions.LeaveTeam(v)
    end

    Functions.SetCurrentTeams(nil)
end

-- Countdown.
_G.c_fm_countdown = function(n, is_vote)
    if not Functions.GetCurrentMinigame() then
        Functions.Log("error", "No minigame selected. Please setup a game first using \"c_fm_setup()\".")
        return
    end

    local sec = n or _G.TUNING.FM_CONFIG.DEFAULT_COUNTDOWNTIME
    if sec < 1 then sec = 1 end

    Functions.Log("log", "Starting game countdown for " .. sec .. " seconds.")

    if not is_vote then TheNet:Announce("Starting " .. Functions.GetMinigameName(Functions.GetCurrentMinigame()) .. "...") end

    for i = sec - 1, 1, -1 do
        TheWorld:DoTaskInTime(i, function()
            TheNet:Announce(sec - i + 1 .. "...")
        end)
    end
    
    TheWorld:DoTaskInTime(sec, function()
        TheNet:Announce("1...")
        if Functions.GetCurrentMinigame() ~= "tag" then 
            _G.c_fm_equipall(Functions.GetCurrentMinigame() == "lucy" and "riledlucy" or "moltendarts") 
        end
    end)

    TheWorld:DoTaskInTime(sec + 1, function() 
        _G.c_fm_unfreezeplayers()
        TheNet:Announce("GO!")
        TheWorld.net.components.mutatormanager:UpdateMutators({friendly_fire = true})
        if Functions.GetCurrentMinigame() == "tag" then
            TheWorld:DoTaskInTime(5, function() Functions.TagMultiple() end)
        end
    end)
end

-- Setup game.
_G.c_fm_setup = function(game, teams, timer, is_vote)
    if type(game) == "number" then
        game = Functions.NumberToMinigame(game)
    end

    if not Functions.DoesMinigameExists(game) then
        Functions.Log("error", "Must specify a minigame to setup. (\"lucy\", \"molten\" or \"tag\")")
        return
    end

    Functions.Log("log", "----------     SETTING UP " .. string.upper(Functions.GetMinigameName(game)) .." MINIGAME     ----------")

    Functions.SetCurrentMinigame(game)

    if not timer or timer <= 0 then
        TheNet:Announce("Setting up " .. Functions.GetMinigameName(game) .. "...")
    end

    _G.c_fm_setupplayers(game, true)
    _G.c_fm_setupworld(game, true)

    if game == "tag" then _G.c_fm_removeteams(nil, true) end

    if teams and teams > 1 and teams <= 4 and game ~= "tag" then
        _G.c_fm_teams(teams)
    end

    if timer and timer > 0 then
        _G.c_fm_countdown(timer, is_vote)
    end
end

-- Setup players.
_G.c_fm_setupplayers = function(game, log)
    if type(game) == "number" then
        game = Functions.NumberToMinigame(game)
    end

    if not Functions.DoesMinigameExists(game) then
        Functions.Log("error", "Must specify a minigame to setup. (\"lucy\", \"molten\" or \"tag\")")
        return
    end

    if not log then
        Functions.Log("log", "--- Setting up players. ---")
        TheNet:Announce("Setting up players...")
        Functions.SetCurrentMinigame(game)
    end

    TheWorld.net.components.mutatormanager:UpdateMutators({friendly_fire = false})
    _G.c_fm_disableperks()
    _G.c_fm_deleteequipment(false)
    _G.c_fm_reviveall()
    _G.c_fm_defaultdamage(0)
    _G.c_fm_minhp(Functions.GetCurrentMinigame() == "tag" and 150 or 0)
    _G.c_fm_maxhp(game == "molten" and _G.TUNING.FM_CONFIG.MS_PLAYERHP or _G.TUNING.FM_CONFIG.LD_PLAYERHP)
    if game ~= "tag" then _G.c_fm_equipall("reedtunic") end
end

-- Setup world.
_G.c_fm_setupworld = function(game, log)
    if type(game) == "number" then
        game = Functions.NumberToMinigame(game)
    end

    if not Functions.DoesMinigameExists(game) then
        Functions.Log("error", "Must specify a minigame to setup. (\"lucy\", \"molten\" or \"tag\")")
        return
    end

    if not log then
        Functions.Log("log", "--- Setting up world. ---")
        TheNet:Announce("Setting up world...")
        Functions.SetCurrentMinigame(game)
    end

    _G.c_fm_deleteequipment(true)
    _G.c_fm_cleanpets()
    _G.c_fm_freezeplayers()
    _G.c_fm_spreadplayers(20 - (game == "tag" and 13 or 0))
    _G.c_fm_tuneweapons(game == "lucy" and "lucy" or game == "molten" and "molten" or "scepter", "damage", 0)
    if game == "molten" then _G.c_fm_tuneweapons("molten", "cooldown", _G.TUNING.FM_CONFIG.MS_MOLTENCOOLDOWN) end
    if game == "lucy" then _G.c_fm_spawnlucy(_G.TUNING.FM_CONFIG.LD_LUCYTYPE or _G.TUNING.FM_CONFIG.LD_LUCYCOUNT) end
end

-- Get alive players.
_G.c_fm_getaliveplayers = function()
    if #_G.AlivePlayers <= 0 then
        Functions.Log("warning", "There are no players alive.")
        return
    end

    Functions.Log("log", "Getting alive players and showing them on debug log.")

    for k, v in pairs(_G.AlivePlayers) do
        local t_str = v.currentteam and (" ~ " .. string.upper(v.currentteam)) or ""
        Functions.Log("list", "[" .. k .. "] (" .. v.userid .. ") " .. v.name .. " <" .. v.prefab ..">" .. t_str)
    end
end

-- Get tagged players.
_G.c_fm_gettaggedplayers = function()
    if #Functions.TAGGED_PLAYERS <= 0 then
        Functions.Log("warning", "There are no players tagged.")
        return
    end

    Functions.Log("log", "Getting tagged players and showing them on debug log.")

    for k, v in pairs(Functions.TAGGED_PLAYERS) do
        Functions.Log("list", "[" .. k .. "] (" .. v.userid .. ") " .. v.name .. " <" .. v.prefab ..">")
    end
end

-- Get the name of the current minigame.
_G.c_fm_getcurrentminigame = function()
    if not Functions.CURRENT_MINIGAME then
        Functions.Log("warning", "There is not a minigame settled up currently.")
        return
    end
    Functions.Log("log", "The current minigame is: \"" .. Functions.GetMinigameName(Functions.GetCurrentMinigame()) .. "\".")
end

-- Get the current teams.
_G.c_fm_getcurrentteams = function()
    if not Functions.CURRENT_TEAMS then
        Functions.Log("warning", "There aren't any teams settled up currently.")
        return
    end
    Functions.Log("log", "Getting all current teams.")
    for k, v in pairs(Functions.CURRENT_TEAMS) do
        Functions.Log("log", string.upper(k) .. " TEAM:")
        for i, j in pairs(v) do
            Functions.Log("list", "[" .. i .. "] (" .. j.userid .. ") " .. j.name .. " <" .. j.prefab ..">")
        end
    end
end

-- Print rules.
_G.c_fm_rules = function(n)
    local str = Functions.GetMinigameRules(n)
    if str then TheNet:Announce(str) end
end

-- Print help.
_G.c_fm_help = function(n)
    if not n then 
        Functions.Log("error", "Must specify a page number between 1 and " .. #Constants.HELP_STRINGS .. ".")
        return
    end

    if n < 1 or n > #Constants.HELP_STRINGS then 
        Functions.Log("error", "Page number must be between 1 and " .. #Constants.HELP_STRINGS .. ".")
        return
    end

    Functions.Log("help", Constants.HELP_STRINGS[n])
end

-- Debug: spawn NPCs.
_G.fm_debugspawnnpcs = function()
    local chars = {"wilson", "willow", "wolfgang", "wendy", "wx78", "wickerbottom", "woodie", "wes", "waxwell", "wathgrithr", "webber", "winona", "wortox", "wormwood", "walter", "wanda"}
    for i = 1, #chars do
        _G.c_spawn(chars[i])
    end
end

-- Debug: finish game.
_G.fm_debugfinishgame = function(n, g)
    Functions.FinishGame(n, g)
end