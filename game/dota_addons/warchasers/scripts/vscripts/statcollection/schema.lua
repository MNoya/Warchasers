customSchema = class({})

function customSchema:init()

    print('customSchema:init()')

    -- Listen for changes in the current state
    ListenToGameEvent('game_rules_state_change', function(keys)
        -- Grab the current state
        local state = GameRules:State_Get()
    
        if state == DOTA_GAMERULES_STATE_POST_GAME then
    
            -- Build game array
            local game = BuildGameArray()

            -- Build players array
            local players = BuildPlayersArray()

            DeepPrintTable(game)
            DeepPrintTable(players)

            -- Send custom stats
            statCollection:sendCustom({game=game, players=players})
        end
    end, nil)
end

-------------------------------------

function customSchema:submitRound(args)
end

-------------------------------------

function BuildGameArray()
    local game = {}
    game.difficulty = GameRules.DIFFICULTY
    return game
end

function BuildPlayersArray()
    players = {}
    for playerID = 0, DOTA_MAX_PLAYERS do
        if PlayerResource:IsValidPlayerID(playerID) then
            if not PlayerResource:IsBroadcaster(playerID) then
                local hero = PlayerResource:GetSelectedHeroEntity(playerID)
                table.insert(players, {
                    --steamID32 required in here
                    steamID32 = PlayerResource:GetSteamAccountID(playerID),
                    i1 = GetItemName(hero, 1),
                    i2 = GetItemName(hero, 2),
                    i3 = GetItemName(hero, 3),
                    i4 = GetItemName(hero, 4),
                    i5 = GetItemName(hero, 5),
                    i6 = GetItemName(hero, 6),
                })
            end
        end
    end

    return players
end

function GetItemName(hero, slot)
    local item = hero:GetItemInSlot(slot)
    if item then
        return item:GetAbilityName()
    else
        return ""
    end
end