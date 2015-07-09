function clear_items()
    local items_shells = Entities:FindAllByClassname("dota_item_drop")

    for key, value in pairs(items_shells) do
        local item_entity = value:GetContainedItem()
        
        if (item_entity:GetPurchaser()) ~= nil and string.find(item_entity:GetName(), "key") == nil then



            local heroes = FindUnitsInRadius( DOTA_TEAM_NEUTRALS, value:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)



            if heroes[1] == nil then
                value:RemoveSelf()
                item_entity:RemoveSelf()
            end

        end
    end

end






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

        GameRules.CURRENT_SAVEPOINT = Entities:FindByName( nil, "teleport_spot_1" )
        local messageinfo = { message = "CHECKPOINT REACHED",duration = 3}
        FireGameEvent("show_center_message",messageinfo)
    
end

function TeleporterHeavenHell(trigger)
    --Randomize teleporting Heaven or Hell
    local chance = RandomInt(1,2)
    if chance == 1 then
        GameRules:SendCustomMessage("<font color='#DBA901'>Soul Keeper:</font> Have you forgotten your previous deeds among the living?!", 0,0)
        GameRules:SendCustomMessage("Your hearts have been weighed, and only Hell waits for you now!", 0,0)
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
    EmitGlobalSound("Warchasers.Heaven") --"DOTAMusic_Stinger.003"

    --mass teleport
    for nPlayerID = 0, DOTA_MAX_PLAYERS-1 do 
        if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
            local entHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
            FindClearSpaceForUnit(entHero, point, false)
            entHero:Stop()
            GameRules:GetGameModeEntity():SetCameraDistanceOverride( 1400 )
        end
    end

    Timers:CreateTimer(function()
        heaven1 = Vector(-6762, 5583, 40)
        local newItem = CreateItem("item_orb_of_fire", nil, nil)
        CreateItemOnPositionSync(heaven1, newItem)

        heaven2 = Vector(-6762, 5475, 40)
        local newItem = CreateItem("item_restoration_scroll", nil, nil)
        CreateItemOnPositionSync(heaven2, newItem)

        heaven3 = Vector(-6652, 5475, 40)
        local newItem = CreateItem("item_restoration_scroll", nil, nil)
        CreateItemOnPositionSync(heaven3, newItem)

        heaven4 = Vector(-6652, 5583, 40)
        local newItem = CreateItem("item_evasion", nil, nil)
        CreateItemOnPositionSync(heaven4, newItem)
    end)

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

              --find and kill necro dummy
            local necrodummy = Vector(-1625,-3072,129)
            local allCreepsNear = Entities:FindAllByClassnameWithin("npc_dota_creature", necrodummy, 1000)
            for i = 1, #allCreepsNear, 1 do
                local creep = allCreepsNear[i]
                local name = creep:GetUnitName()
                if name == "vision_dummy_ground" then
                    creep:ForceKill(true)
                end
            end

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
            giveUnitDataDrivenModifier(entHero, entHero, "modifier_hell_burn",45)
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

    -- Potion Drops
    local newItem = CreateItem("item_potion_of_healing", nil, nil)
    hell1 = Vector(-7585.9, 3618.39, 40)
    CreateItemOnPositionSync(hell1, newItem)

    local newItem = CreateItem("item_potion_of_healing", nil, nil)
    hell2 = Vector(-7634.45, 2930.77, 40)
    CreateItemOnPositionSync(hell2, newItem)

    local newItem = CreateItem("item_potion_of_healing", nil, nil)
    hell3 = Vector(-7550.46, 2382.61, 40)
    CreateItemOnPositionSync(hell3, newItem)

    local newItem = CreateItem("item_potion_of_healing", nil, nil)
    hell4 = Vector(-5834.61, 3493.86, 40)
    CreateItemOnPositionSync(hell4, newItem)

    local newItem = CreateItem("item_potion_of_healing", nil, nil)
    hell5 = Vector(-5658.03, 2879.14, 40)
    CreateItemOnPositionSync(hell5, newItem)

    local newItem = CreateItem("item_potion_of_healing", nil, nil)
    hell6 = Vector(-5719.82, 2403.32, 40)
    CreateItemOnPositionSync(hell6, newItem)

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
                        entHero:RemoveModifierByName("modifier_hell_burn")                     
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

              --find and kill necro dummy
            local necrodummy = Vector(-1625,-3072,129)
            local allCreepsNear = Entities:FindAllByClassnameWithin("npc_dota_creature", necrodummy, 1000)
            for i = 1, #allCreepsNear, 1 do
                local creep = allCreepsNear[i]
                local name = creep:GetUnitName()
                if name == "vision_dummy_ground" then
                    creep:ForceKill(true)
                end
            end

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
    --find and kill necro dummy
    local necrodummy = Vector(-1625,-3072,129)
    local allCreepsNear = Entities:FindAllByClassnameWithin("npc_dota_creature", necrodummy, 1000)
    for i = 1, #allCreepsNear, 1 do
        local creep = allCreepsNear[i]
        local name = creep:GetUnitName()
        if name == "vision_dummy_ground" then
            creep:ForceKill(true)
        end
    end

end

function TeleporterBackHeaven(trigger)
    local heavenReturnSpot =  Vector(-7361,5732,0)
    FindClearSpaceForUnit(trigger.activator, heavenReturnSpot, false)
    trigger.activator:Stop()
end


function TeleporterSecret(trigger) --Sheeps

    if GameRules.SENDSPIDERHALL == false then
        EmitGlobalSound("DOTAMusic_Stinger.007")
        GameRules:SendCustomMessage("<font color='#2EFE2E'>HINT</font> You have found a secret area!", 0, 0)
        GameRules.SENDSPIDERHALL = true

        --Secret Shop Item Drops
        position = Vector(-2940,2996,128)
        local dummy1 = CreateUnitByName("vision_dummy_tiny", position, true, nil, nil, DOTA_TEAM_GOODGUYS)
        Timers:CreateTimer(function()
            local newItem = CreateItem("item_allerias_flute", nil, nil)
            CreateItemOnPositionSync(position, newItem)

            position = Vector(-3136,2996,128)
            local newItem = CreateItem("item_khadgars_gem", nil, nil)
            CreateItemOnPositionSync(position, newItem)

            position = Vector(-2940,3200,128)
            local newItem = CreateItem("item_stormwind_horn", nil, nil)
            CreateItemOnPositionSync(position, newItem)

            position = Vector(-3136,3200,128)
            local newItem = CreateItem("item_bone_chimes", nil, nil)
            CreateItemOnPositionSync(position, newItem)
        end)

        Timers:CreateTimer(1, function()
            dummy1:RemoveSelf()
        end)

    end

    local point =  Entities:FindByName( nil, "teleport_spot_secret" ):GetAbsOrigin()
    FindClearSpaceForUnit(trigger.activator, point, false)
    trigger.activator:Stop()
    
end

function TeleporterFrostHeaven(trigger) --Frostmourne. Teleport back to heaven with refresher timer, on cave trigger
    
    if GameRules.SENDFROSTHEAVEN == false then 
        EmitGlobalSound("DOTAMusic_Stinger.007")
        GameRules:SendCustomMessage("<font color='#2EFE2E'>HINT</font> You have found a secret area!", 0, 0) 
        GameRules.SENDFROSTHEAVEN = true 
    end
    local point =  Vector(-7935, 6662, 135)
    FindClearSpaceForUnit(trigger.activator, point, false)
    trigger.activator:Stop()
    

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
            entHero:RemoveModifierByName("modifier_hell_burn")            
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

    local tank_spawn_point = Vector(4466,1100,128)
    if not GameRules.TankStarted then
        GameRules.TankStarted = true
        TANK = CreateUnitByName("npc_kitt_steamtank", tank_spawn_point, true, GameRules.soul_keeper, GameRules.soul_keeper, DOTA_TEAM_NEUTRALS)
        TANK:SetRenderColor(150, 150, 150)
         
         GameRules.CURRENT_SAVEPOINT = Entities:FindByName( nil, "tank_savepoint" )
        local messageinfo = { message = "CHECKPOINT REACHED",duration = 3}
         FireGameEvent("show_center_message",messageinfo)

        --ensure a navigable slot (first player to touch the trigger will activate the game for everyone)
        if GameRules.PLAYER_COUNT >= 1 then
            local hero = PlayerResource:GetSelectedHeroEntity( 0 )
            local point = Vector(4528,-469,146)
            FindClearSpaceForUnit(hero, point, false)
            hero:Stop()
        end

        if GameRules.PLAYER_COUNT >= 2 then
            local hero = PlayerResource:GetSelectedHeroEntity( 1 )
            local point = Vector(4240,-197,146)
            FindClearSpaceForUnit(hero, point, false)
            hero:Stop()     
        end

        if GameRules.PLAYER_COUNT >= 3 then
            local hero = PlayerResource:GetSelectedHeroEntity( 2 )
            local point = Vector(4512,-213,146)
            FindClearSpaceForUnit(hero, point, false)
            hero:Stop() 
        end

        if GameRules.PLAYER_COUNT >= 4 then
            local hero = PlayerResource:GetSelectedHeroEntity( 3 )
            local point = Vector(4752.79,-213,146)
            FindClearSpaceForUnit(hero, point, false)
            hero:Stop()
        end

        if GameRules.PLAYER_COUNT >= 5 then
            local hero = PlayerResource:GetSelectedHeroEntity( 4 )
            local point = Vector(4512,26,146)
        end

        local position = Vector(4553, -418, 135)
    	local dummy = CreateUnitByName("vision_dummy_point", position, true, nil, nil, DOTA_TEAM_GOODGUYS)
    end
end


function TeleporterFinal(trigger)

	--Teleport the real hero who owns the tank
    local point =  Entities:FindByName( nil, "teleport_spot_final" )
    EmitGlobalSound("Hero_KeeperOfTheLight.Recall.End")

    GameRules.CURRENT_SAVEPOINT = point
    local messageinfo = { message = "CHECKPOINT REACHED",duration = 3}
     FireGameEvent("show_center_message",messageinfo)

    FindClearSpaceForUnit(trigger.activator, point:GetAbsOrigin(), false)
    trigger.activator:Stop()

    GameRules:GetGameModeEntity():SetCameraDistanceOverride( 1300 )

	--Set Teleport Zone
	point = Vector(2193, -1400, 256)
    local dummy = CreateUnitByName("vision_dummy_minor", point, true, nil, nil, DOTA_TEAM_GOODGUYS)	
	point = Vector(2193, -2200, 256)
    local dummy = CreateUnitByName("vision_dummy_minor", point, true, nil, nil, DOTA_TEAM_GOODGUYS)
	point = Vector(2193, -2900, 256)
    local dummy = CreateUnitByName("vision_dummy_minor", point, true, nil, nil, DOTA_TEAM_GOODGUYS)

end


function TeleporterDesert(trigger)
    local position =  Vector(-6769,-128,263)
    FindClearSpaceForUnit(trigger.activator, position, false)
    trigger.activator:Stop()
end

function TeleporterDesertBack(trigger)
    local position =  Vector(-4954,-126,263)
    FindClearSpaceForUnit(trigger.activator, position, false)
    trigger.activator:Stop()
end