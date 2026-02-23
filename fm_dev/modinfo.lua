------------------------------------------------------------------------------------------------------------------------
-- FORGE MINIGAMES | INFO
------------------------------------------------------------------------------------------------------------------------

name = "󰀘 Forge Minigames"
author = "Navi, HaoDZ"
version = "2.0"
forumthread = ""

dst_compatible = true
forge_compatible = true
gorge_compatible = false
dont_starve_compatible = false
reign_of_giants_compatible = false
shipwrecked_compatible = false

client_only_mod = false
server_only_mod = false
all_clients_require_mod = true
server_filter_tags = {}

priority = -999
api_version_dst = 10

icon = "modicon.tex"
icon_atlas = "modicon.xml"

description = "This mod contains a pack of console commands to host minigames in The Forge!"
    .. "\n\nMINIGAME LIST:"
    .. "\n- Lucy Dodgeball: Throw Riled Lucys at your opponents and dodge incoming Lucys to be the last one standing!"
    .. "\n- Molten Shooters: Use Molten Darts to shoot your opponents and knock them down!"
    .. "\n- Explosive Tag: Tag your opponents and avoid being tagged yourself! After a while, tagged players will explode and be eliminated!"
    .. "\n\nUse the command \"c_fm_help()\" to get a list of all available commands and their descriptions."

configuration_options = {

    -- General values.
    {
        name = "DEFAULT_COUNTDOWNTIME",
        label = "Default countdown time",
        hover = "Set the default countdown time to start a minigame.",
        options = {
            {description = "5", data = 5, hover = "Default"},
            {description = "6", data = 6},
            {description = "7", data = 7},
            {description = "8", data = 8},
            {description = "9", data = 9},
            {description = "10", data = 10},
            {description = "15", data = 15},
            {description = "20", data = 20},
            {description = "25", data = 25},
            {description = "30", data = 30}
        }, default = 5
    },
    {
        name = "FINISH_RETURNTOLOBBY",
        label = "Minigame finish action",
        hover = "Select what will happen after a minigame finishes.",
        options = {
            {description = "Return to lobby", data = true, hover = "(Default) The Forge match will end, sending everyone to lobby."},
            {description = "Revive players", data = false, hover = "All dead players will revive."}
        }, default = true
    },

    -- Vote settings.
    {name = "", label = "", options = { {description = "",   data = "0",  hover = ""}, }, default = "0",},
    {name = "", label = " - Player vote settings - ", options = { {description = "",   data = "0",  hover = ""}, }, default = "0",},
    {
        name = "VOTE_LD",
        label = "Vote to start Lucy Dodgeball",
        hover = "Let players vote to start a match of Lucy Dodgeball. (\"/ld\" on chat)",
        options = {
            {description = "Enable", data = true, hover = "Default"},
            {description = "Disable", data = false}
        }, default = true

    },
    {
        name = "VOTE_MS",
        label = "Vote to start Molten Shooters",
        hover = "Let players vote to start a match of Molten Shooters. (\"/ms\" on chat)",
        options = {
            {description = "Enable", data = true, hover = "Default"},
            {description = "Disable", data = false}
        }, default = true

    },
    {
        name = "VOTE_ET",
        label = "Vote to start Explosive Tag",
        hover = "Let players vote to start a match of Explosive Tag. (\"/et\" on chat)",
        options = {
            {description = "Enable", data = true, hover = "Default"},
            {description = "Disable", data = false}
        }, default = true

    },
    {
        name = "VOTE_TEAMS",
        label = "Vote to form teams",
        hover = "Let players vote to divide players into 2-4 teams. (\"/teams\" on chat)",
        options = {
            {description = "Enable", data = true, hover = "Default"},
            {description = "Disable", data = false}
        }, default = true

    },

    -- Lucy Dodgeball settings.
    {name = "", label = "", options = { {description = "",   data = "0",  hover = ""}, }, default = "0",},
    {name = "", label = " - Lucy Dodgeball settings - ", options = { {description = "",   data = "0",  hover = ""}, }, default = "0",},
    {
        name = "LD_PLAYERHP",
        label = "Player Max HP",
        hover = "Set the player's maximum HP on Lucy Dodgeball.",
        options = {
            {description = "50", data = 50},
            {description = "100", data = 100},
            {description = "150", data = 150, hover = "Default"},
            {description = "200", data = 200},
            {description = "250", data = 250},
            {description = "300", data = 300},
            {description = "400", data = 400},
            {description = "500", data = 500}
        }, default = 150
    },
    {
        name = "LD_LUCYTYPE",
        label = "Spawn Riled Lucys per player?",
        hover = "If enabled, one Riled Lucy will spawn per player at the center of the arena, and \"Riled Lucy count\" will have no effect.",
        options = {
            {description = "No", data = false, hover = "Default"},
            {description = "Yes", data = true}
        }, default = false
    },
    {
        name = "LD_LUCYCOUNT",
        label = "Riled Lucy count",
        hover = "Spawn \"X\" Riled Lucys at the center.",
        options = {
            {description = "0", data = 0},
            {description = "1", data = 1},
            {description = "2", data = 2},
            {description = "3", data = 3},
            {description = "4", data = 4, hover = "Default"},
            {description = "5", data = 5},
            {description = "6", data = 6},
            {description = "7", data = 7},
            {description = "8", data = 8},
            {description = "9", data = 9},
            {description = "10", data = 10}
        }, default = 4
    },

    -- Molten Shooters settings.
    {name = "", label = "", options = { {description = "",   data = "0",  hover = ""}, }, default = "0",},
    {name = "", label = " - Molten Shooters settings - ", options = { {description = "",   data = "0",  hover = ""}, }, default = "0",},
    {
        name = "MS_PLAYERHP",
        label = "Player Max HP",
        hover = "Set the player's maximum HP on Molten Shooters.",
        options = {
            {description = "50", data = 50},
            {description = "100", data = 100},
            {description = "150", data = 150},
            {description = "200", data = 200},
            {description = "250", data = 250, hover = "Default"},
            {description = "300", data = 300},
            {description = "400", data = 400},
            {description = "500", data = 500}
        }, default = 250
    },
    {
        name = "MS_MOLTENCOOLDOWN",
        label = "Molten Darts cooldown",
        hover = "Set the cooldown in seconds of Molten Darts.",
        options = {
            {description = "0",     data = 0},
            {description = "0.5",   data = 0.5},
            {description = "1",     data = 1},
            {description = "1.5",   data = 1.5, hover = "Default"},
            {description = "2",     data = 2},
            {description = "2.5",   data = 2.5},
            {description = "3",     data = 3},
            {description = "4",     data = 4},
            {description = "5",     data = 5}
        }, default = 1.5
    },

    -- Explosive Tag settings.
    {name = "", label = "", options = { {description = "",   data = "0",  hover = ""}, }, default = "0",},
    {name = "", label = " - Explosive Tag settings - ", options = { {description = "",   data = "0",  hover = ""}, }, default = "0",},
    {
        name = "ET_TAGPERCENT",
        label = "Tagged players percent",
        hover = "Set the percentage of players that will get tagged every round on Explosive Tag",
        options = {
            {description = "50% (1/2)", data = 2},
            {description = "33% (1/3)", data = 3, hover = "Default"},
            {description = "25% (1/4)", data = 4},
            {description = "20% (1/5)", data = 5},
        }, default = 3
    },
    {
        name = "ET_TAGCOUNTDOWN",
        label = "Tag countdown time",
        hover = "Set the time in seconds of the Explosive Tag countdown.",
        options = {
            {description = "5",     data = 5},
            {description = "6",     data = 6},
            {description = "7",     data = 7},
            {description = "8",     data = 8},
            {description = "9",     data = 9},
            {description = "10",    data = 10, hover = "Default"},
            {description = "11",    data = 11},
            {description = "12",    data = 12},
            {description = "13",    data = 13},
            {description = "14",    data = 14},
            {description = "15",    data = 15}
        }, default = 10
    }

}

-- Check if the mod is the development version.
folder_name = folder_name or "workshop-"
if not folder_name:find("workshop-") then
    name = "FM - Dev Version"
    description = description .. "\n\n(Development version)"
end