customSchema = class({})

function customSchema:init()

    -- Listen for changes in the current state
    ListenToGameEvent('game_rules_state_change', function(keys)
        -- Grab the current state
        local state = GameRules:State_Get()
    
        if state == DOTA_GAMERULES_STATE_POST_GAME then
    
            -- Build game array
            local game = BuildGameArray()

            -- Build players array
            local players = BuildPlayersArray()

            -- Print the schema data to the console
            if statCollection.TESTING then
                PrintSchema(game,players)
            end

            -- Send custom stats
            if statCollection.HAS_SCHEMA then
                statCollection:sendCustom({game=game, players=players})
            end
        end
    end, nil)
end

-------------------------------------

function customSchema:submitRound(args)
end

-------------------------------------
--          Stat Functions         --
-------------------------------------

function PrintSchema( gameArray, playerArray )
    print("-------- GAME DATA --------")
    DeepPrintTable(gameArray)
    print("\n-------- PLAYER DATA --------")
    DeepPrintTable(playerArray)
    print("-------------------------------------")
end

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
                    hn = GetHeroName(hero),
                    il = GetItemList(hero),

                    -- Tomes Consumed
                    st = GetTomesConsumed(hero, "tome_strenght_modifier"), --STR Tomes
                    at = GetTomesConsumed(hero, "tome_agility_modifier"), --AGI Tomes
                    it = GetTomesConsumed(hero, "tome_intelect_modifier"), --INT Tomes
                    ht = GetTomesConsumed(hero, "tome_health_modifier") / 30, --Health Tomes (Each one gives 30)
                })
            end
        end
    end

    return players
end

function GetHeroName( hero )
    local heroName = hero:GetUnitName()
    heroName = string.gsub(heroName,"npc_dota_hero_","")
    return heroName
end

function GetItemList(hero)
    local itemTable = {}

    for i=0,5 do
        local item = hero:GetItemInSlot(i)
        if item then
            local itemName = string.gsub(item:GetAbilityName(),"item_","")
            table.insert(itemTable,itemName)
        end
    end

    table.sort(itemTable)
    local itemList = table.concat(itemTable, "_")

    return itemList
end

function GetTomesConsumed( hero, modifierName )
    local modifier = hero:FindModifierByName(modifierName)
    if modifier then
        return modifier:GetStackCount()
    else 
        return 0
    end
end

-------------------------------------

if Convars:GetBool('developer') then
    Convars:RegisterCommand("test_schema", function() PrintSchema(BuildGameArray(),BuildPlayersArray()) end, "Test the custom schema arrays", 0)
end