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
    self.HAS_ROUNDS = true
    -- Do we want statCollection to use team winner for game victory?
    self.GAME_WINNER = false
    -- Do we want statCollection to use ancient explosions for game victory?
    self.ANCIENT_EXPLOSION = false
    --We want to have a reference to this later
    self.statCollection = options.statCollection
end
function customSchema:submitRound(args)
    winners = {}
    game = {}
    players = {}
    for k,v in pairs(GameRules.CURRENT_PLAYERS) do
        if GameRules.PLAYER_IS_PREDATOR[v] then
            game.predator = PlayerResource:GetSteamAccountID(v)
            game.random = args.random --0 for not random, 1 for timeout random, 2 for pick random
            game.timer = args.timer
        end
        table.insert(players, {
            --steamID32 required in here
            steamID32 = PlayerResource:GetSteamAccountID(v),
            score = GameRules.PLAYER_POINTS[v],
            spell = -1 --kek, use GameRules.UNIQUE_SPELLS and loop through invokers until we know
        })
        winners[PlayerResource:GetSteamAccountID(v)] = 1
    end
    self.statCollection:sendCustom({game=game, players=players})
    return {
        winners = winners,
        lastRound = args.roundsLeft == 0
    }
end
return customSchema