require("statcollection/schema")
require('statcollection/lib/statcollection')

statInfo = LoadKeyValues('scripts/vscripts/statcollection/settings.kv')
COLLECT_STATS = not Convars:GetBool('developer')
TESTING = tobool(statInfo.TESTING)

if COLLECT_STATS or TESTING then
    ListenToGameEvent('game_rules_state_change', function(keys)
        local state = GameRules:State_Get()
        
        if state == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then

            -- Init stat collection
            statCollection:init()
        end
    end, nil)
end