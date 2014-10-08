function Teleporter(trigger)
        -- Get the position of the "point_teleport_spot"-entity we put in our map
        local point =  Entities:FindByName( nil, "teleport_spot_1" ):GetAbsOrigin()
        -- Find a spot for the hero around 'point' and teleports to it
        FindClearSpaceForUnit(trigger.activator, point, false)
        -- Stop the hero, so he doesn't move
        trigger.activator:Stop()
        -- Refocus the camera of said player to the position of the teleported hero.
        --SendToConsole("dota_camera_center") --done through flash for all clients
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
            GameRules:GetGameModeEntity():SetCameraDistanceOverride( 1400 )
        end
    end

    -- Show Quest
    heavenQuest = SpawnEntityFromTableSynchronous( "quest", { name = "HeavenQuest", title = "#HeavenQuestTimer" } )

    questTimeEnd = GameRules:GetGameTime() + 30 --Time to Finish the quest

    --bar system
    heavenKillCountSubQuest = SpawnEntityFromTableSynchronous( "subquest_base", {
        show_progress_bar = true,
        progress_bar_hue_shift = -119
    } )
    heavenQuest:AddSubquest( heavenKillCountSubQuest )
    heavenQuest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_TARGET_VALUE, 30 ) --text on the quest timer at start
    heavenQuest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, 30 ) --text on the quest timer
    heavenKillCountSubQuest:SetTextReplaceValue( SUBQUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, 30 ) --value on the bar at start
    heavenKillCountSubQuest:SetTextReplaceValue( SUBQUEST_TEXT_REPLACE_VALUE_TARGET_VALUE, 30 ) --value on the bar
    
    Timers:CreateTimer(0.9, function()
        heavenQuest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, questTimeEnd - GameRules:GetGameTime() )
        heavenKillCountSubQuest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, questTimeEnd - GameRules:GetGameTime() ) --update the bar with the time passed        
        if (questTimeEnd - GameRules:GetGameTime())<=0 and heavenQuest ~= nil then --finish the quest
            EmitGlobalSound("Tutorial.Quest.complete_01") --on game_sounds_music_tutorial, check others
            UTIL_RemoveImmediate( heavenQuest )
            heavenQuest = nil
            heavenKillCountSubQuest = nil
        end
        return 1        
    end
    )
    

    GameRules:SendCustomMessage("Welcome to paradise.", 0, 0)

    Timers:CreateTimer({
        endTime = 30,
        callback = function()
            if GameRules.SENDHELL == false and GameRules.SENDFORESTHELL == false then
                --send back everyone, no hell triggered
                local point =  Entities:FindByName( nil, "teleport_spot_back" ):GetAbsOrigin()
                --mass teleport
                for nPlayerID = 0, DOTA_MAX_PLAYERS-1 do 
                    if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
                        local entHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
                        FindClearSpaceForUnit(entHero, point, false)
                        entHero:Stop()
                    end
                end

                --open door to 2nd miniboss
                local door = Entities:FindByName(nil, "gate_4")
                if door ~= nil then
                    door:Kill()
                end

                local obstructions = Entities:FindByName(nil,"obstructions_4_1")
                obstructions:SetEnabled(false,false)

                local obstructions = Entities:FindByName(nil,"obstructions_4_2")
                obstructions:SetEnabled(false,false)

                local obstructions = Entities:FindByName(nil,"obstructions_4_3")
                obstructions:SetEnabled(false,false)

                local obstructions = Entities:FindByName(nil,"obstructions_4_4")
                obstructions:SetEnabled(false,false)
                print("Obstructions disabled")

                EmitGlobalSound("Hero_KeeperOfTheLight.Recall.End")
                Timers:CreateTimer({ useGameTime = false, endTime = 2,
                    callback = function() EmitGlobalSound("BARNDOORS_OPEN") end
                })
                Timers:CreateTimer({ useGameTime = false, endTime = 3,
                    callback = function() EmitGlobalSound("ui.crafting_slotslide") end
                })

                GameRules:GetGameModeEntity():SetCameraDistanceOverride( 1000 )
                print("Teleport Back")
            end

            --kill the vision dummy, regardless of being sent to a secret area.
            dummy:ForceKill(true)
            print("Dummy killed")
        end
    })

end

function TeleporterHell(trigger)
    local point =  Entities:FindByName( nil, "teleport_spot_hell" ):GetAbsOrigin()

    local spot_hell = Vector(-6571, 3002, 40)
    local dummy = CreateUnitByName("vision_dummy", spot_hell, true, nil, nil, DOTA_TEAM_GOODGUYS)
    GameRules.SENDHELL = true
    print("Entered Hell")
    EmitGlobalSound("DOTAMusic_Stinger.004") --EmitGlobalSound("terrorblade_arcana.stinger.respawn") how to precache?

    --mass teleport
    for nPlayerID = 0, DOTA_MAX_PLAYERS-1 do 
        if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
            local entHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
            FindClearSpaceForUnit(entHero, point, false)
            entHero:Stop()
            GameRules:GetGameModeEntity():SetCameraDistanceOverride( 1400 )
        end
    end

    -- Show Quest
    hellQuest = SpawnEntityFromTableSynchronous( "quest", { name = "HellQuest", title = "#HellQuestTimer" } )
    
    questHellTimeEnd = GameRules:GetGameTime() + 45 --Time to Finish the quest

    --bar system
    hellKillCountSubquest = SpawnEntityFromTableSynchronous( "subquest_base", {
        show_progress_bar = true,
        progress_bar_hue_shift = -119
    } )

    hellQuest:AddSubquest( hellKillCountSubquest )
    hellQuest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_TARGET_VALUE, 45 ) --text on the quest timer at start
    hellQuest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, 45 ) --text on the quest timer
    hellKillCountSubquest:SetTextReplaceValue( SUBQUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, 45 ) --value on the bar at start
    hellKillCountSubquest:SetTextReplaceValue( SUBQUEST_TEXT_REPLACE_VALUE_TARGET_VALUE, 45 ) --value on the bar
    
    Timers:CreateTimer(0.9, function()
        hellQuest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, questHellTimeEnd - GameRules:GetGameTime() )
        hellKillCountSubquest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, questHellTimeEnd - GameRules:GetGameTime() ) --update the bar with the time passed        
        if (questHellTimeEnd - GameRules:GetGameTime())<=0 and hellQuest ~= nil then
            EmitGlobalSound("Tutorial.Quest.complete_01") --on game_sounds_music_tutorial, check others
            UTIL_RemoveImmediate( hellQuest )
            hellQuest = nil
            hellKillCountSubquest = nil
        end
        return 1        
    end
    )

    GameRules:SendCustomMessage("<font color='#DBA901'>Soul Keeper:</font> Have you forgotten your previous deeds among the living?!", 0,0)
    GameRules:SendCustomMessage("Your hearts have been weighed, and only Hell waits for you now!", 0,0)

    Timers:CreateTimer({
        endTime = 45,
        callback = function()
            if GameRules.SENDFORESTHELL == false then
                -- send everyone back, no secret area discovered
                local point =  Entities:FindByName( nil, "teleport_spot_back" ):GetAbsOrigin()
                 --mass teleport
                for nPlayerID = 0, DOTA_MAX_PLAYERS-1 do 
                    if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
                        local entHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
                        FindClearSpaceForUnit(entHero, point, false)
                        entHero:Stop()
                        GameRules:GetGameModeEntity():SetCameraDistanceOverride( 1000 )
                        
                    end
                end

                --open door to 2nd miniboss
                local door = Entities:FindByName(nil, "gate_4")
                if door ~= nil then
                    door:Kill()
                end

                local obstructions = Entities:FindByName(nil,"obstructions_4_1")
                obstructions:SetEnabled(false,false)

                local obstructions = Entities:FindByName(nil,"obstructions_4_2")
                obstructions:SetEnabled(false,false)

                local obstructions = Entities:FindByName(nil,"obstructions_4_3")
                obstructions:SetEnabled(false,false)

                local obstructions = Entities:FindByName(nil,"obstructions_4_4")
                obstructions:SetEnabled(false,false)
                print("Obstructions disabled")
                
                EmitGlobalSound("Hero_KeeperOfTheLight.Recall.End")
                Timers:CreateTimer({ useGameTime = false, endTime = 2,
                    callback = function() EmitGlobalSound("BARNDOORS_OPEN") end
                })
                Timers:CreateTimer({ useGameTime = false, endTime = 3,
                    callback = function() EmitGlobalSound("ui.crafting_slotslide") end
                })

                GameRules:GetGameModeEntity():SetCameraDistanceOverride( 1000 )

            end
            
            --kill the vision dummy, regardless of being sent to a secret area.
            dummy:ForceKill(true)
            print("Teleport Back, Dummy killed")
        end
    })

end

function TeleporterBack(trigger)
    --single player
    local point =  Entities:FindByName( nil, "teleport_spot_back" ):GetAbsOrigin()
    FindClearSpaceForUnit(trigger.activator, point, false)
    trigger.activator:Stop()

    --open door to 2nd miniboss
    local door = Entities:FindByName(nil, "gate_4")
    if door ~= nil then
        door:Kill()
    end

    local obstructions = Entities:FindByName(nil,"obstructions_4_1")
    obstructions:SetEnabled(false,false)

    local obstructions = Entities:FindByName(nil,"obstructions_4_2")
    obstructions:SetEnabled(false,false)

    local obstructions = Entities:FindByName(nil,"obstructions_4_3")
    obstructions:SetEnabled(false,false)

    local obstructions = Entities:FindByName(nil,"obstructions_4_4")
    obstructions:SetEnabled(false,false)
    print("Obstructions disabled")

    EmitGlobalSound("Hero_KeeperOfTheLight.Recall.End")
    Timers:CreateTimer({ useGameTime = false, endTime = 2,
        callback = function() EmitGlobalSound("BARNDOORS_OPEN") end
    })
    Timers:CreateTimer({ useGameTime = false, endTime = 3,
        callback = function() EmitGlobalSound("ui.crafting_slotslide") end
    })

    GameRules:GetGameModeEntity():SetCameraDistanceOverride( 1000 )

end

function TeleporterBackHeaven(trigger)
    local heavenReturnSpot =  Vector(-7361,5732,0)
    FindClearSpaceForUnit(trigger.activator, heavenReturnSpot, false)
    trigger.activator:Stop()
end


function TeleporterSecret(trigger) --Sheeps
    local point =  Entities:FindByName( nil, "teleport_spot_secret" ):GetAbsOrigin()
    FindClearSpaceForUnit(trigger.activator, point, false)
    trigger.activator:Stop()
    EmitGlobalSound("DOTAMusic_Stinger.007")
    GameRules:SendCustomMessage("<font color='#2EFE2E'>HINT</font> You have found a secret area!", 0, 0) 
end

function TeleporterFrostHeaven(trigger) --Frostmourne. Teleport back to heaven with refresher timer, on cave trigger
    GameRules.SENDFROSTHEAVEN = true 

    local point =  Vector(-7935, 6662, 135)
    FindClearSpaceForUnit(trigger.activator, point, false)
    trigger.activator:Stop()
    EmitGlobalSound("DOTAMusic_Stinger.007")
    GameRules:SendCustomMessage("<font color='#2EFE2E'>HINT</font> You have found a secret area!", 0, 0) 

end

function TeleporterDarkForest(trigger) --Skull of Guldan. Teleport back is done directly through a trigger in the map
    GameRules.SENDFORESTHELL = true

    --mass teleport to map center
    local point =  Vector(0,-322,128)
    for nPlayerID = 0, DOTA_MAX_PLAYERS-1 do 
        if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
            local entHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
            FindClearSpaceForUnit(entHero, point, false)
            entHero:Stop()             
        end
    end

    EmitGlobalSound("DOTAMusic_Stinger.007")
    GameRules:SendCustomMessage("<font color='#2EFE2E'>HINT</font> You have found a secret area!", 0, 0)

    --finish the quest after discovering a secret area
    UTIL_RemoveImmediate( hellQuest )
    hellQuest = nil
    hellKillCountSubquest = nil
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
        end
    end

end


function TeleporterTanks(trigger)
    local point =  Entities:FindByName( nil, "teleport_spot_tanks" ):GetAbsOrigin()
    FindClearSpaceForUnit(trigger.activator, point, false)
    trigger.activator:Stop()
    EmitGlobalSound("Hero_KeeperOfTheLight.Recall.End")
end

function TeleporterTanksStart(trigger)

    GameRules:GetGameModeEntity():SetCameraDistanceOverride( 1200 )
     
    --render different color for each player
    --ensure a navigable slot (first player to touch the trigger will activate the game for everyone)
    if GameRules.PLAYER_COUNT >= 1 then
        local hero = PlayerResource:GetSelectedHeroEntity( 0 )
        giveUnitDataDrivenModifier(hero,hero,"modifier_out_of_game",-1)
        local position_player1 = Vector(4528,-469,146)
        local tank1 = CreateUnitByName("npc_rocknroll_steamtank", position_player1, true, hero, hero, DOTA_TEAM_GOODGUYS)
        tank1:SetRenderColor(46,106,230) --blue
        tank1:SetControllableByPlayer( 0 , true )
        tank1:SetTeam( DOTA_TEAM_GOODGUYS )
        tank1:SetOwner(hero)
    end

    if GameRules.PLAYER_COUNT >= 2 then
        local hero = PlayerResource:GetSelectedHeroEntity( 1 )
        giveUnitDataDrivenModifier(hero,hero,"modifier_out_of_game",-1)
        local position_player2 = Vector(4240,-197,146)
        local tank2 = CreateUnitByName("npc_rocknroll_steamtank", position_player2, true, hero, hero , DOTA_TEAM_GOODGUYS)
        tank2:SetRenderColor(93,230,173) --teal
        tank2:SetControllableByPlayer( 1 , true )
        tank2:SetTeam( DOTA_TEAM_GOODGUYS )
        tank2:SetOwner(hero)
        
    end

    if GameRules.PLAYER_COUNT >= 3 then
        local hero = PlayerResource:GetSelectedHeroEntity( 2 )
        giveUnitDataDrivenModifier(hero,hero,"modifier_out_of_game",-1)
        local position_player3 = Vector(4512,-213,146)
        local tank3 = CreateUnitByName("npc_rocknroll_steamtank", position_player3, true, hero, hero , DOTA_TEAM_GOODGUYS)
        tank3:SetRenderColor(173,0,173) --purple
        tank3:SetControllableByPlayer( 2 , true )
        tank3:SetTeam( DOTA_TEAM_GOODGUYS )
        tank3:SetOwner(hero)
        
    end

    if GameRules.PLAYER_COUNT >= 4 then
        local hero = PlayerResource:GetSelectedHeroEntity( 3 )
        giveUnitDataDrivenModifier(hero,hero,"modifier_out_of_game",-1)
        local position_player4 = Vector(4752.79,-213,146)
        local tank4 = CreateUnitByName("npc_rocknroll_steamtank", position_player4, true, hero, hero , DOTA_TEAM_GOODGUYS)
        tank4:SetRenderColor(220,217,10) --yellow
        tank4:SetControllableByPlayer( 3 , true )
        tank4:SetTeam( DOTA_TEAM_GOODGUYS )
        tank4:SetOwner(hero)
        
    end

    if GameRules.PLAYER_COUNT >= 5 then
        local hero = PlayerResource:GetSelectedHeroEntity( 4 )
        giveUnitDataDrivenModifier(hero,hero,"modifier_out_of_game",-1)
        local position_player5 = Vector(4512,26,146)
        local tank5 = CreateUnitByName("npc_rocknroll_steamtank", position_player5, true, hero, hero, DOTA_TEAM_GOODGUYS)
        tank5:SetRenderColor(230,98,0) --orange
        tank5:SetControllableByPlayer( 4 , true )
        tank5:SetTeam( DOTA_TEAM_GOODGUYS )
        tank5:SetOwner(hero)
        
    end

    local position = Vector(4553, -418, 135)
    local player_id = trigger.activator:GetPlayerOwnerID()
    --PlayerResource:SetCameraTarget( player_id, tank)
	local dummy = CreateUnitByName("vision_dummy_point", position, true, nil, nil, DOTA_TEAM_GOODGUYS)
end


function TeleporterFinal(trigger)

	--Teleport the real hero who owns the tank
    local point =  Entities:FindByName( nil, "teleport_spot_final" ):GetAbsOrigin()
    EmitGlobalSound("Hero_KeeperOfTheLight.Recall.End")

    local nPlayerID = trigger.activator:GetPlayerOwnerID()
    local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )

    --Remove out of game effect
    hero:RemoveModifierByName("modifier_out_of_game")

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
    trigger.activator:ForceKill(true)

end