function Teleporter(trigger)
        -- Get the position of the "point_teleport_spot"-entity we put in our map
        local point =  Entities:FindByName( nil, "teleport_spot_1" ):GetAbsOrigin()
        -- Find a spot for the hero around 'point' and teleports to it
        FindClearSpaceForUnit(trigger.activator, point, false)
        -- Stop the hero, so he doesn't move
        trigger.activator:Stop()
        -- Refocus the camera of said player to the position of the teleported hero.
        SendToConsole("dota_camera_center")
end
function Teleporter2(trigger)
        local point =  Entities:FindByName( nil, "teleport_spot_2" ):GetAbsOrigin()
        FindClearSpaceForUnit(trigger.activator, point, false)
        trigger.activator:Stop()
        SendToConsole("dota_camera_center")
        GameRules:GetGameModeEntity():SetCameraDistanceOverride( 1200 )
		point = Vector(2193, -1400, 256)
        local dummy = CreateUnitByName("vision_dummy_minor", point, true, nil, nil, DOTA_TEAM_GOODGUYS)
        print("Entered Heaven")
		point = Vector(2193, -2200, 256)
        local dummy = CreateUnitByName("vision_dummy_minor", point, true, nil, nil, DOTA_TEAM_GOODGUYS)
        print("Entered Heaven")
		point = Vector(2193, -2900, 256)
        local dummy = CreateUnitByName("vision_dummy_minor", point, true, nil, nil, DOTA_TEAM_GOODGUYS)
        print("Entered Heaven")

end

function TeleporterHeaven(trigger)
        local point =  Entities:FindByName( nil, "teleport_spot_heaven" ):GetAbsOrigin()
        
        spot_heaven = Vector(-6734, 5082, 40)
        local dummy = CreateUnitByName("vision_dummy", spot_heaven, true, nil, nil, DOTA_TEAM_GOODGUYS)
        print("Entered Heaven")

        --mass teleport
        for nPlayerID = 0, DOTA_MAX_PLAYERS-1 do 
            if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
                local entHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
                FindClearSpaceForUnit(entHero, point, false)
                entHero:Stop()
                SendToConsole("dota_camera_center")
                GameRules:GetGameModeEntity():SetCameraDistanceOverride( 1400 )
            end
        end

        local messageinfo = {
            message = "Some seconds in Heaven",
            duration = 5
        }
        FireGameEvent("show_center_message",messageinfo) 

        GameRules:SendCustomMessage("Welcome to paradise. Rest your weary vessels.", 0, 0)

        Timers:CreateTimer({
            endTime = 30, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
            callback = function()
                if SENDHELL == false then 
                    local point =  Entities:FindByName( nil, "teleport_spot_back" ):GetAbsOrigin()
                    --mass teleport
                    for nPlayerID = 0, DOTA_MAX_PLAYERS-1 do 
                        if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
                            local entHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
                            FindClearSpaceForUnit(entHero, point, false)
                            entHero:Stop()
                            SendToConsole("dota_camera_center")
                            GameRules:GetGameModeEntity():SetCameraDistanceOverride( 1000 )
                            
                        end
                    end
                end
                --kill the vision dummy
                dummy:ForceKill(true)
                print("Teleport Back, Dummy killed")
            end
        })

end

function TeleporterHell(trigger)
        local point =  Entities:FindByName( nil, "teleport_spot_hell" ):GetAbsOrigin()

        local spot_hell = Vector(-6571, 3002, 40)
        local dummy = CreateUnitByName("vision_dummy", spot_hell, true, nil, nil, DOTA_TEAM_GOODGUYS)
        print("Entered Hell")
        --mass teleport
        for nPlayerID = 0, DOTA_MAX_PLAYERS-1 do 
            if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
                local entHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
                FindClearSpaceForUnit(entHero, point, false)
                entHero:Stop()
                SendToConsole("dota_camera_center")
                GameRules:GetGameModeEntity():SetCameraDistanceOverride( 1400 )
            end
        end

        local messageinfo = {
        message = "Some seconds in Hell",
        duration = 5
        }
        FireGameEvent("show_center_message",messageinfo)

        GameRules:SendCustomMessage("<font color='#DBA901'>Soul Keeper:</font> Have you forgotten your previous deeds among the living?!", 0,0)
        GameRules:SendCustomMessage("Your hearts have been weighed, and only Hell waits for you now!", 0,0)

        Timers:CreateTimer({
            endTime = 40, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
            callback = function()
                    local point =  Entities:FindByName( nil, "teleport_spot_back" ):GetAbsOrigin()
                     --mass teleport
                    for nPlayerID = 0, DOTA_MAX_PLAYERS-1 do 
                        if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
                            local entHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
                            FindClearSpaceForUnit(entHero, point, false)
                            entHero:Stop()
                            SendToConsole("dota_camera_center")
                            GameRules:GetGameModeEntity():SetCameraDistanceOverride( 1000 )
                            
                        end
                    end
                --kill the vision dummy
                dummy:ForceKill(true)
                print("Teleport Back, Dummy killed")
            end
        })
        
end

--[[function TeleporterBack(trigger)
        local point =  Entities:FindByName( nil, "teleport_spot_back" ):GetAbsOrigin()
        FindClearSpaceForUnit(trigger.activator, point, false)
        trigger.activator:Stop()
        SendToConsole("dota_camera_center")
end]]

function TeleporterSecret(trigger)
        local point =  Entities:FindByName( nil, "teleport_spot_secret" ):GetAbsOrigin()
        FindClearSpaceForUnit(trigger.activator, point, false)
        trigger.activator:Stop()
        SendToConsole("dota_camera_center")
        GameRules:SendCustomMessage("<font color='#2EFE2E'>HINT</font> You have found a secret area!", 0, 0) 
end

function TeleporterSecret2(trigger)
        local point =  Entities:FindByName( nil, "teleport_spot_secret2" ):GetAbsOrigin()
        FindClearSpaceForUnit(trigger.activator, point, false)
        trigger.activator:Stop()
        SendToConsole("dota_camera_center")
        GameRules:SendCustomMessage("<font color='#2EFE2E'>HINT</font> You have found a secret area!", 0, 0) 
end