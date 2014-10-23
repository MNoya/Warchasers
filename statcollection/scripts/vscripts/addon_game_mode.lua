-- Load Stat collection (statcollection should be available from any script scope)
require('lib.statcollection')
statcollection.addStats({
	modID = 'XXXXXXXXXXXXXXXXXXX' --GET THIS FROM http://getdotastats.com/#d2mods__my_mods
})

print( "Example stat collection game mode loaded." )

if YourGamemode == nil then
    YourGamemode = class({})
end

--------------------------------------------------------------------------------
-- ACTIVATE
--------------------------------------------------------------------------------
function Activate()
    GameRules.YourGamemode = YourGamemode()
    GameRules.YourGamemode:InitGameMode()
end

--------------------------------------------------------------------------------
-- INIT
--------------------------------------------------------------------------------
function YourGamemode:InitGameMode()
    local GameMode = GameRules:GetGameModeEntity()

    -- Register Think
    GameMode:SetContextThink( "YourGamemode:GameThink", function() return self:GameThink() end, 0.25 )

    -- Register Game Events
end

--------------------------------------------------------------------------------
function YourGamemode:GameThink()
    -- Check to see if the game has finished
    if GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
        -- Send stats
        statcollection.sendStats()

        -- Delete the thinker
        return
    else
        -- Check again in 1 second
        return 1
    end
end