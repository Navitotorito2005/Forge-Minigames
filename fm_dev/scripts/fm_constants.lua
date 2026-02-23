------------------------------------------------------------------------------------------------------------------------
-- [ CONSTANTS ]
------------------------------------------------------------------------------------------------------------------------

local CONST = {}

-- Help pages for "c_fm_help()".
CONST.HELP_STRINGS = {
    "---------- FORGE MINIGAMES COMMANDS ~ PAGE 1 ----------"
        .. "\n• c_fm_rules() - Print the rules of the game in the chat."
        .. "\n• c_fm_setup(game, teams, timer) - Setups the game."
        .. "\n• c_fm_countdown(n) - Countdown for a \"n\" number of seconds and start the game."
        .. "\n• c_fm_setupplayers() - Setups players without affecting the world."
        .. "\n• c_fm_setupworld() - Setups the world without affecting players."
        .. "\n• c_fm_equipplayer(player, prefab) - Equips a specific player with an item."
        .. "\n• c_fm_unequipplayer(player, slot) - Unequips an item from a specific player on any slot."
        .. "\n• c_fm_equipall(prefab) - Equips all players with an specified item."
        .. "\n• c_fm_deleteall(prefab) - Deletes all items from a specified prefab."
        .. "\n• c_fm_deleteequipment(only_drops) - Deletes all equipment. (weapons and armor)"
        .. "\n• c_fm_cleanpets() - Removes all pets."
        .. "\n• c_fm_maxhp(n) - Set all players HP to \"n\" or 150."
        .. "\n• c_fm_minhp(n) - Set all players minimum HP to \"n\" or 0."
        .. "\n• c_fm_reviveall() - Revives all dead players."
        .. "\n• c_fm_freezeplayers() - Freezes all players in place."
        .. "\n• c_fm_unfreezeplayers() - Unfreezes all players."
        .. "\n• c_fm_defaultdamage(n) - Sets the bare-hand damage of all players to \"n\" or default."
        .. "\n• c_fm_disableperks() - Disables all perks and passive effects."
        .. "\n[USE \"c_fm_help(2)\" TO SEE MORE COMMANDS]",

    "---------- FORGE MINIGAMES COMMANDS ~ PAGE 2 ----------"
        .. "\n• c_fm_tuneweapons(weapon) - Sets a weapon stat to \"n\" or default. (weapon = \"lucy\", \"molten\" or \"scepter\"; stat = \"damage\" or \"cooldown\")"
        .. "\n• c_fm_spreadplayers(distance) - Spreads players randomly around the center."
        .. "\n• c_fm_spawnlucy(n) - Spawns \"n\" quantity of Riled Lucys around the center, defaulting to 4. (if \"true\", spawns as many Lucys as players)"
        .. "\n• c_fm_team(target, color) - Sets the team of a player. (color = \"red\", \"blue\", \"yellow\", \"green\" or \"default\")"
        .. "\n• c_fm_removeteams(target, color) - Removes the color of a player or an object. (if no target specified, removes colors from all players)"
        .. "\n• c_fm_teams(n) - Divide players into \"n\" teams and color them accordingly. Max 4 teams."
        .. "\n• c_fm_tagkill(player) - Kills a player tagged in Explosive Tag."
        .. "\n• c_fm_getaliveplayers() - Prints the list of alive players in the console."
        .. "\n• c_fm_gettaggedplayers() - Prints the list of tagged players on Explosive Tag in the console."
        .. "\n• c_fm_getcurrentminigame() - Prints the name of the current minigame in the console."
        .. "\n• c_fm_getcurrentteams() - Prints the list of current teams in the console."
        .. "\n \n \n \n \n[USE \"c_fm_help(1)\" TO SEE MORE COMMANDS]",
}

-- Rules strings for each minigame.
CONST.RULES_STRINGS = {
    lucy = "--------------------- Lucy Dodgeball : Rules ---------------------"
        .. "\n \n• Defeat your opponents by throwing Riled Lucys at them."
        .. "\n• No melee attacks or hand-on-hand combat allowed."
        .. "\n• After all opponents are defeated, the last player/team standing wins!"
        .. "\n \n------------------------------------------------------------",

    molten = "--------------------- Molten Shooters : Rules ---------------------"
        .. "\n \n• Use Molten Darts to shoot your opponents and defeat them."
        .. "\n• Only the Molten Bolt can do damage. Don't use regular shooting or melee attacks!"
        .. "\n• After all opponents are defeated, the last player/team standing wins!"
        .. "\n \n------------------------------------------------------------",

    tag = "--------------------- Explosive Tag : Rules ---------------------"
        .. "\n \n• Tag your opponents by hitting them with the Soul Scepter. Avoid being tagged yourself!"
        .. "\n• Tagged players will explode after a while and be eliminated!"
        .. "\n• After everyone else gets eliminated, the last player standing wins!"
        .. "\n \n------------------------------------------------------------"
}

-- ReForged and Unbearable components for passive perks.
CONST.PASSIVE_PERKS = {
    -- ReForged --
    "passive_mighty",
    "passive_shock",
    "passive_amplify",
    "passive_shadows",
    "passive_battlecry",
    "passive_soul_drain",
    "passive_bloom",
    "passive_aggro",
    "corpsereviver",

    -- Unbearable --
    "passive_barbarian",
    "passive_magician",
    "shadow_spectate",
    "passive_toxic",
    "passive_piercer",
    "passive_lucky",
    "passive_nourish",
    "passive_impervious",
    "soulhopper",
    "soulreaper",
    "passive_fiery",
    "passive_ranger",
    "werecreature"
}

-- Team colors.
CONST.TEAM_COLORS = {
    ["red"] = {"0.6", "0", "0"},
    ["blue"] = {"0.1", "0", "0.7"},
    ["yellow"] = {"0.2", "0.5", "0"},
    ["green"] = {"0", "0.7", "0.2"}
}

return CONST