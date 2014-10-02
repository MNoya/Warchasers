function Teleporter(trigger)
        -- Get the position of the "point_teleport_spot"-entity we put in our map
        local point =  Entities:FindByName( nil, "teleport_spot_1" ):GetAbsOrigin()
        -- Find a spot for the hero around 'point' and teleports to it
        FindClearSpaceForUnit(trigger.activator, point, false)
        -- Stop the hero, so he doesn't move
        trigger.activator:Stop()
        -- Refocus the camera of said player to the position of the teleported hero.
        SendToConsole("dota_camera_center")
        EmitGlobalSound("Hero_KeeperOfTheLight.Recall.End")
end

function TeleporterHeavenHell(trigger)
    --Randomize teleporting Heaven or Hell
    if RollPercentage(50) then
        TeleporterHell(trigger)
    else
        TeleporterHeaven(trigger)
    end
end

function TeleporterHeaven(trigger)
        local point =  Vector(-6713,5089,20)
        
        spot_heaven = Vector(-6734, 5082, 40)
        local dummy = CreateUnitByName("vision_dummy", spot_heaven, true, nil, nil, DOTA_TEAM_GOODGUYS)
        print("Entered Heaven")
        EmitGlobalSound("DOTAMusic_Stinger.003") --EmitGlobalSound("valve_dota_001.stinger.respawn") how to precache?

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
                if GameRules.SENDHELL == false then 
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
        EmitGlobalSound("DOTAMusic_Stinger.004") --EmitGlobalSound("terrorblade_arcana.stinger.respawn") how to precache?

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
        EmitGlobalSound("DOTAMusic_Stinger.007")
        GameRules:SendCustomMessage("<font color='#2EFE2E'>HINT</font> You have found a secret area!", 0, 0) 
end

function TeleporterSecret2(trigger)
        local point =  Entities:FindByName( nil, "teleport_spot_secret2" ):GetAbsOrigin()
        FindClearSpaceForUnit(trigger.activator, point, false)
        trigger.activator:Stop()
        SendToConsole("dota_camera_center")
        EmitGlobalSound("DOTAMusic_Stinger.007")
        GameRules:SendCustomMessage("<font color='#2EFE2E'>HINT</font> You have found a secret area!", 0, 0) 
end

function TeleportAtBarrier(trigger)
    GameRules:SendCustomMessage("<font color='#0000FF'>SUCCESS</font><br><br>", 0, 0)        
    GameRules:SendCustomMessage("Both circles have been activated!<br>The magical barrier has been dispelled and now the path is clear",0,0)
    EmitGlobalSound("General.MaleLevelUp")
    local point =  Entities:FindByName( nil, "teleport_circles_down" ):GetAbsOrigin()
    --mass teleport
    for nPlayerID = 0, DOTA_MAX_PLAYERS-1 do 
        if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
            local entHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
            FindClearSpaceForUnit(entHero, point, false)
            entHero:Stop()
            SendToConsole("dota_camera_center")              
        end
    end

end


function TeleporterTanks(trigger)
        local point =  Entities:FindByName( nil, "teleport_spot_tanks" ):GetAbsOrigin()
        FindClearSpaceForUnit(trigger.activator, point, false)
        trigger.activator:Stop()
        SendToConsole("dota_camera_center")
        EmitGlobalSound("Hero_KeeperOfTheLight.Recall.End")
end

function TeleporterTanksStart(trigger)

        GameRules:GetGameModeEntity():SetCameraDistanceOverride( 1200 )
        local position = Vector(4553, -418, 135)
        local hero = trigger.activator

        local tank = CreateUnitByName("npc_rocknroll_steamtank", position, true, trigger.activator, trigger.activator, DOTA_TEAM_GOODGUYS)
        tank:SetRenderColor(128,128,255)
        tank:SetControllableByPlayer( hero:GetPlayerOwnerID(), true )
        tank:SetTeam( DOTA_TEAM_GOODGUYS ) --hero:GetTeam()
        tank:SetOwner(hero)

        local player_id = trigger.activator:GetPlayerOwnerID()
        PlayerResource:SetCameraTarget( player_id, tank)
		local dummy = CreateUnitByName("vision_dummy_point", position, true, nil, nil, DOTA_TEAM_GOODGUYS)
		hero:AddNewModifier(dummy, nil, "modifier_camera_follow", {duration=0})
end


function TeleporterFinal(trigger)

		--Teleport the real hero who owns the tank
        local point =  Entities:FindByName( nil, "teleport_spot_final" ):GetAbsOrigin()
        EmitGlobalSound("Hero_KeeperOfTheLight.Recall.End")

        local nPlayerID = trigger.activator:GetPlayerOwnerID()
        local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
        FindClearSpaceForUnit(hero, point, false)
        hero:Stop()
        trigger.activator:Stop()
      
        GameRules:GetGameModeEntity():SetCameraDistanceOverride( 1300 )

		--Set Teleport Zone
		point = Vector(2193, -1400, 256)
		
		 --camera is buggy.
        local dummy = CreateUnitByName("vision_dummy_minor", point, true, nil, nil, DOTA_TEAM_GOODGUYS)
		hero:AddNewModifier(dummy, nil, "modifier_camera_follow", {duration=0})
		
		point = Vector(2193, -2200, 256)
        local dummy = CreateUnitByName("vision_dummy_minor", point, true, nil, nil, DOTA_TEAM_GOODGUYS)
		point = Vector(2193, -2900, 256)
        local dummy = CreateUnitByName("vision_dummy_minor", point, true, nil, nil, DOTA_TEAM_GOODGUYS)
	

		
		--Remove Tank from the game
        --trigger.activator:ForceKill(true)

end

function TeleporterDarkForest(trigger)
    --mass teleport
    local point =  Vector(0,-322,128)
    for nPlayerID = 0, DOTA_MAX_PLAYERS-1 do 
        if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
            local entHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
            FindClearSpaceForUnit(entHero, point, false)
            entHero:Stop()
            SendToConsole("dota_camera_center")              
        end
    end

end