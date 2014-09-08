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
        duration = 35
        }
        FireGameEvent("show_center_message",messageinfo) 
        GameRules:SendCustomMessage("Welcome to paradise. Rest your weary vessels.", 0, 0) 
end

function TeleporterHell(trigger)
          local point =  Entities:FindByName( nil, "teleport_spot_hell" ):GetAbsOrigin()
          FindClearSpaceForUnit(trigger.activator, point, false)
         trigger.activator:Stop()
        SendToConsole("dota_camera_center")
        local messageinfo = {
        message = "Some seconds in Hell",
        duration = 45
        }
        FireGameEvent("show_center_message",messageinfo) 
end

function TeleporterBack(trigger)
        local point =  Entities:FindByName( nil, "teleport_spot_back" ):GetAbsOrigin()
        FindClearSpaceForUnit(trigger.activator, point, false)
        trigger.activator:Stop()
        SendToConsole("dota_camera_center")
end

function TeleporterSecret(trigger)
        local point =  Entities:FindByName( nil, "teleport_spot_secret" ):GetAbsOrigin()
        FindClearSpaceForUnit(trigger.activator, point, false)
        trigger.activator:Stop()
        SendToConsole("dota_camera_center")
        GameRules:SendCustomMessage("<font color='#2EFE2E'>HINT</font> You have found a secret area!", 0, 0) 
end