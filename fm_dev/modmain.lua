------------------------------------------------------------------------------------------------------------------------
-- FORGE MINIGAMES | MAIN.
------------------------------------------------------------------------------------------------------------------------

-- Set up the global variable for easier access.
GLOBAL.setmetatable(env, {__index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end})

-- Check if the gamemode is correct.
if TheNet:GetServerGameMode() ~= "lavaarena" then
    print("[FM.WARNING] Forge Minigames is designed to be played in The Forge. Admin commands will be disabled.")
    return
end

-- Set up mod config values on global table.
_G.TUNING.FM_CONFIG = {

    -- Game settings.
    DEFAULT_COUNTDOWNTIME = GetModConfigData("DEFAULT_COUNTDOWNTIME"),
    FINISH_RETURNTOLOBBY = GetModConfigData("FINISH_RETURNTOLOBBY"),

    -- Vote settings.
    VOTE_LD = GetModConfigData("VOTE_LD"),
    VOTE_MS = GetModConfigData("VOTE_MS"),
    VOTE_ET = GetModConfigData("VOTE_ET"),
    VOTE_TEAMS = GetModConfigData("VOTE_TEAMS"),

    -- Lucy Dodgeball settings.
    LD_PLAYERHP = GetModConfigData("LD_PLAYERHP"),
    LD_LUCYTYPE = GetModConfigData("LD_LUCYTYPE"),
    LD_LUCYCOUNT = GetModConfigData("LD_LUCYCOUNT"),

    -- Molten Shooters settings.
    MS_PLAYERHP = GetModConfigData("MS_PLAYERHP"),
    MS_MOLTENCOOLDOWN = GetModConfigData("MS_MOLTENCOOLDOWN"),

    -- Explosive Tag settings.
    ET_TAGPERCENT = GetModConfigData("ET_TAGPERCENT"),
    ET_TAGCOUNTDOWN = GetModConfigData("ET_TAGCOUNTDOWN")

}

-- Create a ReForged preset with proper settings.
_G.AddPreset("fm_preset", "reforged", nil, "forge", "sandbox", "lavaarena", {no_revives = true, no_heal = true, no_restriction = true}, {atlas = "images/reforged.xml", tex = "preset_s1.tex",}, 1)
_G.STRINGS.REFORGED.PRESETS["fm_preset"] = "Minigames"

-- Set the Explosive Tag kill name.
_G.STRINGS.NAMES.FM_EXPLOSIVETAG = "the Explosive Tag"

-- Sets the global table for alive players.
_G.global("AlivePlayers")

-- Require modules.
local Votes = require("fm_votes")
local Functions = require("fm_functions")

-- Set up admin commands.
modimport("scripts/fm_commands")

-- Setup vote commands.
Votes.SetupVotes()

-- Add world post init.
AddPrefabPostInit("world", Functions.WorldPostInit)

-- Setup is done!
Functions.Log("start", "Forge Minigames loaded successfully!")