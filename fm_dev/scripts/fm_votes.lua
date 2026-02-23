------------------------------------------------------------------------------------------------------------------------
-- [ VOTE SETUP ]
------------------------------------------------------------------------------------------------------------------------

local VoteUtil = require("voteutil")
local Functions = require("fm_functions")

local VOTE = {}

-- Setup all vote commands.
function VOTE.SetupVotes()

    -- Lucy Dodgeball vote settings.
    if _G.TUNING.FM_CONFIG.VOTE_LD then 
        AddUserCommand("lucydodgeball", {
            aliases = {"ld", "lucy", "dodgeball"},
            prettyname = "Lucy Dodgeball (Vote)",
            desc = "Vote to start a game of Lucy Dodgeball.",
            permission = _G.COMMAND_PERMISSION.MODERATOR,
            confirm = true,
            slash = true,
            usermenu = false,
            servermenu = true,
            menusort = 3,
            params = {},
            vote = true,
            votetimeout = nil,
            voteminstartage = nil,
            voteminpasscount = 1,
            votecountvisible = true,
            voteallownotvoted = true,
            voteoptions = nil,
            votetitlefmt = "Should we start a match of\nLucy Dodgeball?",
            votenamefmt = "vote to start Lucy Dodgeball",
            votepassedfmt = "Vote passed! Starting Lucy Dodgeball...",
            votecanstartfn = VoteUtil.DefaultCanStartVote,
            voteresultfn = VoteUtil.YesNoMajorityVote,
            canstartfn = function(command, caller, targetid)
                if Functions.CURRENT_MINIGAME then
                    return false
                end
                return true
            end,
            serverfn = function(params, caller)
                _G.c_fm_setup("lucy", nil, _G.TUNING.FM_CONFIG.DEFAULT_COUNTDOWNTIME, true)
            end
        }) 
    end

    -- Molten Shooters vote settings.
    if _G.TUNING.FM_CONFIG.VOTE_MS then 
        AddUserCommand("moltenshooters", {
            aliases = {"ms", "molten", "mshooter"},
            prettyname = "Molten Shooters (Vote)",
            desc = "Vote to start a game of Molten Shooters.",
            permission = _G.COMMAND_PERMISSION.MODERATOR,
            confirm = true,
            slash = true,
            usermenu = false,
            servermenu = true,
            menusort = 4,
            params = {},
            vote = true,
            votetimeout = nil,
            voteminstartage = nil,
            voteminpasscount = 1,
            votecountvisible = true,
            voteallownotvoted = true,
            voteoptions = nil,
            votetitlefmt = "Should we start a match of\nMolten Shooters?",
            votenamefmt = "vote to start Molten Shooters",
            votepassedfmt = "Vote passed! Starting Molten Shooters...",
            votecanstartfn = VoteUtil.DefaultCanStartVote,
            voteresultfn = VoteUtil.YesNoMajorityVote,
            canstartfn = function(command, caller, targetid)
                if Functions.CURRENT_MINIGAME then
                    return false
                end
                return true
            end,
            serverfn = function(params, caller)
                _G.c_fm_setup("molten", nil, _G.TUNING.FM_CONFIG.DEFAULT_COUNTDOWNTIME, true)
            end
        }) 
    end

    -- Explosive Tag vote settings.
    if _G.TUNING.FM_CONFIG.VOTE_ET then 
        AddUserCommand("explosivetag", {
            aliases = {"et", "explosive", "tag"},
            prettyname = "Explosive Tag (Vote)",
            desc = "Vote to start a game of Explosive Tag.",
            permission = _G.COMMAND_PERMISSION.MODERATOR,
            confirm = true,
            slash = true,
            usermenu = false,
            servermenu = true,
            menusort = 5,
            params = {},
            vote = true,
            votetimeout = nil,
            voteminstartage = nil,
            voteminpasscount = 1,
            votecountvisible = true,
            voteallownotvoted = true,
            voteoptions = nil,
            votetitlefmt = "Should we start a match of\nExplosive Tag?",
            votenamefmt = "vote to start Explosive Tag",
            votepassedfmt = "Vote passed! Starting Explosive Tag...",
            votecanstartfn = VoteUtil.DefaultCanStartVote,
            voteresultfn = VoteUtil.YesNoMajorityVote,
            canstartfn = function(command, caller, targetid)
                if Functions.CURRENT_MINIGAME then
                    return false
                end
                return true
            end,
            serverfn = function(params, caller)
                _G.c_fm_setup("tag", nil, _G.TUNING.FM_CONFIG.DEFAULT_COUNTDOWNTIME, true)
            end
        }) 
    end

    -- Vote to setup teams.
    if _G.TUNING.FM_CONFIG.VOTE_TEAMS then 
        AddUserCommand("teams", {
            aliases = {"team", "t"},
            prettyname = "Team Setup (Vote)",
            desc = "Vote to divide players into 2 - 4 teams.",
            permission = _G.COMMAND_PERMISSION.USER,
            confirm = false,
            slash = true,
            usermenu = false,
            servermenu = false,
            params = {},
            vote = true,
            votetimeout = nil,
            voteminstartage = nil,
            voteminpasscount = 1,
            votecountvisible = true,
            voteallownotvoted = true,
            voteoptions = {"None", "2", "3", "4"},
            votenamefmt = "vote to divide players into teams",
            votetitlefmt = "How many teams should\nwe create?",
            votepassedfmt = "Vote passed!",
            votecanstartfn = VoteUtil.DefaultCanStartVote,
            voteresultfn = VoteUtil.DefaultMajorityVote,
            canstartfn = function(command, caller, targetid)
                if Functions.CURRENT_MINIGAME then
                    return false
                end
                return true
            end,
            serverfn = function(params, caller)
                local n = params and tonumber(params.voteselection) or 1
                if n < 2 then
                    _G.c_announce("Teams will not be made. Current teams will get disbanded.")
                    _G.c_fm_removeteams()
                    return
                end
                _G.c_announce("Dividing players into " .. n .. " teams...")
                _G.c_fm_teams(n)
            end
        }) 
    end

    -- Rules command (non-vote).
    AddUserCommand("rules", {
        aliases = {"r", "mr"},
        prettyname = "Minigame Rules",
        desc = "Prints the rules of the specified minigame in chat.",
        permission = _G.COMMAND_PERMISSION.USER,
        confirm = false,
        slash = true,
        usermenu = false,
        servermenu = false,
        params = {"minigame"},
        paramsoptional = {false},
        vote = false,
        localfn = function(params, caller)
            if not params.minigame then return end

            local game = params.minigame

            if game == "ld" or game == "lucydodgeball" then
                game = "lucy"
            elseif game == "ms" or game == "moltenshooters" then
                game = "molten"
            elseif game == "et" or game == "explosivetag" then
                game = "tag"
            end

            local str = Functions.GetMinigameRules(game)

            if not str then
                ChatHistory:SendCommandResponse(
                    "Unknown minigame name. The available minigames are:"
                    .. "\nLucy Dodgeball: \"lucydodgeball\", \"lucy\" or \"ld\""
                    .. "\nMolten Shooters: \"moltenshooters\", \"molten\" or \"ms\""
                    .. "\nExplosive Tag: \"explosivetag\", \"tag\" or \"et\""
                )
                return
            end
            
            ChatHistory:SendCommandResponse(str)
        end
    })



end

return VOTE