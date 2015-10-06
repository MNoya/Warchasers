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
    winners = BuildRoundWinnerArray()
    game = BuildGameArray()
    players = BuildPlayersArray()

    self.statCollection:sendCustom({game=game, players=players})
    
    return {winners = winners, lastRound = false}
end

-------------------------------------

function BuildRoundWinnerArray()
    local winners = {}
    local current_winner_team = GetTeamWithHighestKillScore()
    for playerID = 0, DOTA_MAX_PLAYERS do
        if PlayerResource:IsValidPlayerID(playerID) then
            if not PlayerResource:IsBroadcaster(playerID) then
                winners[PlayerResource:GetSteamAccountID(playerID)] = (PlayerResource:GetTeam(playerID) == current_winner_team) and 1 or 0
            end
        end
    end
    return winners
end

function BuildGameArray()
    local game = {}
    game.boss_killed = GetBossKilled()
    game.times_traded = GetTimesTraded()
    return game
end

function BuildPlayersArray()
    players = {}
    for playerID = 0, DOTA_MAX_PLAYERS do
        if PlayerResource:IsValidPlayerID(playerID) then
            if not PlayerResource:IsBroadcaster(playerID) then
                local player_upgrades = PMP:GetUpgradeList(playerID)
                table.insert(players, {
                    --steamID32 required in here
                    steamID32 = PlayerResource:GetSteamAccountID(playerID),
                    player_hero_id = PlayerResource:GetSelectedHeroID(playerID),
                    player_kills = PlayerResource:GetKills(playerID),
                    player_deaths = PlayerResource:GetDeaths(playerID),
                    player_level = GetHeroLevel(playerID),
                    
                    -- Resources
                    total_gold_earned = GetTotalEarnedGold(playerID),
                    total_lumber_earned = GetTotalEarnedLumber(playerID),
                    total_xp_earned = GetTotalEarnedXP(playerID),
                    player_food = GetFoodLimit(playerID),
                    player_spawn_rate = GetSpawnRate(playerID),

                    -- Upgrades
                    upgrade_weapon = player_upgrades["weapon"] or 0,
                    upgrade_helm = player_upgrades["helm"] or 0,
                    upgrade_armor = player_upgrades["armor"] or 0,
                    upgrade_wings = player_upgrades["wings"] or 0,
                    upgrade_health = player_upgrades["health"] or 0,

                    -- Passive ability upgrades
                    ability_critical_strike = player_upgrades["critical_strike"] or 0,
                    ability_stun_hit = player_upgrades["stun_hit"] or 0,
                    ability_poisoned_weapons = player_upgrades["poisoned_weapons"] or 0,
                    ability_pulverize = player_upgrades["pulverize"] or 0,
                    ability_dodge = player_upgrades["dodge"] or 0,
                    ability_spiked_armor = player_upgrades["spiked_armor"] or 0,
                    
                    -- Hero global upgrades
                    pimp_damage = player_upgrades["pimp_damage"] or 0,
                    pimp_armor = player_upgrades["pimp_armor"] or 0,
                    pimp_speed = player_upgrades["pimp_speed"] or 0,
                    pimp_regen = player_upgrades["pimp_regen"] or 0,
                })
            end
        end
    end

    return players
end

-------------------------------------

return customSchema
