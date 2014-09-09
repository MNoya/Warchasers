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
end

function TeleporterHeaven(trigger)
        local point =  Entities:FindByName( nil, "teleport_spot_heaven" ):GetAbsOrigin()
        FindClearSpaceForUnit(trigger.activator, point, false)
        trigger.activator:Stop()
        SendToConsole("dota_camera_center")
        local messageinfo = {
            message = "Some seconds in Heaven",
            duration = 30
        }
        FireGameEvent("show_center_message",messageinfo) 

        GameRules:SendCustomMessage("Welcome to paradise. Rest your weary vessels.", 0, 0)

        Timers:CreateTimer({
            endTime = 30, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
            callback = function()
                if SENDHELL == false then 
                    local point =  Entities:FindByName( nil, "teleport_spot_back" ):GetAbsOrigin()
                    FindClearSpaceForUnit(trigger.activator, point, false)
                    trigger.activator:Stop()
                    SendToConsole("dota_camera_center")
                    print("Teleport Back")
                end
            end
        })
end

function TeleporterHell(trigger)
          local point =  Entities:FindByName( nil, "teleport_spot_hell" ):GetAbsOrigin()
          FindClearSpaceForUnit(trigger.activator, point, false)
         trigger.activator:Stop()
        SendToConsole("dota_camera_center")
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
                    FindClearSpaceForUnit(trigger.activator, point, false)
                    trigger.activator:Stop()
                    SendToConsole("dota_camera_center")
                    print("Teleport Back")
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