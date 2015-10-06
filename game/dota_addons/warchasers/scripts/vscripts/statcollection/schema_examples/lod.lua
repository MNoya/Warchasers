--[[
Usage:

This is an example custom schema. You must assemble your game and players tables, which
are submitted to the library via a call like:

statCollection:sendCustom(schemaAuthKey, game, players)

The schemaAuthKey is important, and can only be obtained via site admins.

Come bug us in our IRC channel or get in contact via the site chatbox. http://getdotastats.com/#contact

]]
local customSchema = class({})
function customSchema:init(options)
    -- The schema version we are currently using
    self.SCHEMA_KEY = 'XXXXXXXXX' -- GET THIS FROM AN ADMIN ON THE SITE, THAT APPROVES YOUR SCHEMA
    -- Do we need to enable the round API or not.
    self.HAS_ROUNDS = false
    -- Do we want statCollection to use team winner for game victory?
    self.GAME_WINNER = true
    -- Do we want statCollection to use ancient explosions for game victory?
    self.ANCIENT_EXPLOSION = true
    --We want to have a reference to this later
    self.statCollection = options.statCollection
    -- Grab the current state
    local state = GameRules:State_Get()

    if state >= DOTA_GAMERULES_STATE_POST_GAME then

        -- Build game array
        local game = {}
        table.insert(game, {
            game_duration = GameRules:GetGameTime(),
            game_picks_num = tonumber(Options.getOption('lod', MAX_REGULAR, maxSkills))
        })


        -- Build players array
        local players = {}
        for i = 1, (PlayerResource:GetPlayerCount() or 1) do
            table.insert(players, {
                --steamID32 required in here
                steamID32 = PlayerResource:GetSteamAccountID(i - 1),
                player_hero_id = PlayerResource:GetSelectedHeroID(i - 1),
                player_kills = PlayerResource:GetKills(i - 1),
                player_assists = PlayerResource:GetAssists(i - 1),
                player_deaths = PlayerResource:GetDeaths(i - 1)
            })
        end

        -- Send custom stats
        statCollection:sendCustom(game, players)
    end
end
function customSchema:submitRound(args)
end
return customSchema
