


--[[function structure_spawner_func( event )
        local heroes_in_range = FindUnitsInRadius( event.caster:GetTeamNumber(), event.caster:GetCenter(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)    
        if heroes_in_range[1] ~= nil then
                for key, value in pairs( heroes_in_range ) do
                        local trigger = Entities:FindByNameNearest( "spawn_trigger", event.caster:GetOrigin(), 1000)
                        --DeepPrintTable( Entities:FindByClassnameNearest( "trigger_hero", event.caster:GetOrigin(), 1000), nil, true)
                        print(trigger)
                        if trigger ~= nil then
                                if trigger:IsTouching(value) == true then
                                        local ability = event.caster:GetAbilityByIndex(0)
                                        ability:CastAbility()
                                end
                        end
                end
        end
end]]


function SpawnMurlocs1(trigger)
        local building = Entities:FindByName(nil, "murloc_hut1") --2
        if building ~= nil then
                local ability = building:FindAbilityByName("spawn_murloc")
                ability:SetContextThink("SpawnLoop", function() 
                        if ability:IsFullyCastable() then 
                                building:CastAbilityNoTarget(ability, -1)
                                end 
                        return 4 
                end, 1)
        end
end
--ty Quintinity

function SpawnMurlocs2(trigger)
        local building = Entities:FindByName(nil, "murloc_hut2")
        if building ~= nil then
                local ability = building:FindAbilityByName("spawn_murloc")
                ability:SetContextThink("SpawnLoop", function() 
                                                        if ability:IsFullyCastable() then 
                                                                building:CastAbilityNoTarget(ability, -1)
                                                        end 
                                                        return 4 
                                                        end, 
                                                        1)
        end
end

function SpawnGnolls1(trigger)
        local building = Entities:FindByName(nil, "elf_farm1") --2
        if building ~= nil then
                local ability = building:FindAbilityByName("spawn_gnoll")
                ability:SetContextThink("SpawnLoop", function()
                        if ability:IsFullyCastable() then
                                ability:CastAbility();
                        end
                        return 4;
                end, 1);
        end
end

function SpawnGnolls2(trigger)
        local building = Entities:FindByName(nil, "elf_farm2")
        if building ~= nil then
                local ability = building:FindAbilityByName("spawn_gnoll")
                ability:SetContextThink("SpawnLoop", function()
                        if ability:IsFullyCastable() then
                                ability:CastAbility();
                        end
                        return 4;
                end, 1);
        end
end

function SpawnGhouls1(trigger)
        local building = Entities:FindByName(nil, "ghoul_hut1")  --2, 1 later with ziggurat model
        if building ~= nil then
                local ability = building:FindAbilityByName("spawn_ghoul")
                ability:SetContextThink("SpawnLoop", function()
                        if ability:IsFullyCastable() then
                                ability:CastAbility();
                        end
                        return 4;
                end, 1);
        end
end

function SpawnGhouls2(trigger)
        local building = Entities:FindByName(nil, "ghoul_hut2") 
        if building ~= nil then
                local ability = building:FindAbilityByName("spawn_ghoul")
                ability:SetContextThink("SpawnLoop", function()
                        if ability:IsFullyCastable() then
                                ability:CastAbility();
                        end
                        return 4;
                end, 1);
        end
end

function SpawnGhoulsZiggurat(trigger)
        local building = Entities:FindByName(nil, "ghoul_ziggurat1")
        if building ~= nil then
                local ability = building:FindAbilityByName("spawn_ghoul")
                ability:SetContextThink("SpawnLoop", function()
                        if ability:IsFullyCastable() then
                                ability:CastAbility();
                        end
                        return 4;
                end, 1);
        end
end

function SpawnGhoulsZiggurat2	(trigger)
        local building = Entities:FindByName(nil, "ghoul_ziggurat2")
        if building ~= nil then
                local ability = building:FindAbilityByName("spawn_ghoul")
                ability:SetContextThink("SpawnLoop", function()
                        if ability:IsFullyCastable() then
                                ability:CastAbility();
                        end
                        return 3;
                end, 1);
        end
end

function SpawnSatyrs1(trigger)
        local building = Entities:FindByName(nil, "forest_troll_hut1")
        if building ~= nil then
                local ability = building:FindAbilityByName("spawn_medium_satyr")
                ability:SetContextThink("SpawnLoop", function()
                        if ability:IsFullyCastable() then
                                ability:CastAbility();
                        end
                        return 4;
                end, 1);
        end
end

function SpawnGolems(trigger)
        local building = Entities:FindByName(nil, "forest_troll_hut2")
        if building ~= nil then
                local ability = building:FindAbilityByName("spawn_golem")
                ability:SetContextThink("SpawnLoop", function()
                        if ability:IsFullyCastable() then
                                ability:CastAbility();
                        end
                        return 4;
                end, 1);
        end
end

function SpawnMediumMurlocs1(trigger)
        local building = Entities:FindByName(nil, "murloc_mid_hut1") --3
        if building ~= nil then
                local ability = building:FindAbilityByName("spawn_medium_murloc")
                ability:SetContextThink("SpawnLoop", function()
                        if ability:IsFullyCastable() then
                                ability:CastAbility();
                        end
                        return 4;
                end, 1);
        end
end

function SpawnMediumMurlocs2(trigger)
        local building = Entities:FindByName(nil, "murloc_mid_hut2")
        if building ~= nil then
                local ability = building:FindAbilityByName("spawn_medium_murloc")
                ability:SetContextThink("SpawnLoop", function()
                        if ability:IsFullyCastable() then
                                ability:CastAbility();
                        end
                        return 4;
                end, 1);
        end
end

function SpawnMediumMurlocs3(trigger)
        local building = Entities:FindByName(nil, "murloc_mid_hut3")
        if building ~= nil then
                local ability = building:FindAbilityByName("spawn_medium_murloc")
                ability:SetContextThink("SpawnLoop", function()
                        if ability:IsFullyCastable() then
                                ability:CastAbility();
                        end
                        return 4;
                end, 1);
        end
end

function SpawnWaterElementals1(trigger)
        local building = Entities:FindByName(nil, "water_hut1") --2
        if building ~= nil then
                local ability = building:FindAbilityByName("spawn_water_elemental")
                ability:SetContextThink("SpawnLoop", function()
                        if ability:IsFullyCastable() then
                                ability:CastAbility();
                        end
                        return 6;
                end, 1);
        end
end


function SpawnWaterElementals2(trigger)
        local building = Entities:FindByName(nil, "water_hut2")
        if building ~= nil then
                local ability = building:FindAbilityByName("spawn_water_elemental")
                ability:SetContextThink("SpawnLoop", function()
                        if ability:IsFullyCastable() then
                                ability:CastAbility();
                        end
                        return 6;
                end, 1);
        end
end

function SpawnDarkTrolls1(trigger)
        local building = Entities:FindByName(nil, "dark_troll_hut1") --2
        if building ~= nil then
                local ability = building:FindAbilityByName("spawn_ranged_troll")
                ability:SetContextThink("SpawnLoop", function()
                        if ability:IsFullyCastable() then
                                ability:CastAbility();
                        end
                        return 3;
                end, 1);
        end
end

function SpawnDarkTrolls2(trigger)
        local building = Entities:FindByName(nil, "dark_troll_hut2")
        if building ~= nil then
                local ability = building:FindAbilityByName("spawn_ranged_troll")
                ability:SetContextThink("SpawnLoop", function()
                        if ability:IsFullyCastable() then
                                ability:CastAbility();
                        end
                        return 3;
                end, 1);
        end
end

--

function SpawnSmallSludges(trigger)
        local building = Entities:FindByName(nil, "sludge_farm")
        if building ~= nil then
                local ability = building:FindAbilityByName("spawn_small_sludge")
                ability:SetContextThink("SpawnLoop", function() 
                        if ability:IsFullyCastable() then 
                                ability:CastAbility() 
                                end 
                        return 4 
                end, 1)
        end
end

function SpawnTreants1(trigger)
        local building = Entities:FindByName(nil, "treant_farm1")
        if building ~= nil then
                local ability = building:FindAbilityByName("spawn_treant")
                ability:SetContextThink("SpawnLoop", function() 
                        if ability:IsFullyCastable() then 
                                ability:CastAbility() 
                                end 
                        return 4 
                end, 1)
        end
end

function SpawnTreants2(trigger)
        local building = Entities:FindByName(nil, "treant_farm2")
        if building ~= nil then
                local ability = building:FindAbilityByName("spawn_treant")
                ability:SetContextThink("SpawnLoop", function() 
                        if ability:IsFullyCastable() then 
                                ability:CastAbility() 
                                end 
                        return 4 
                end, 1)
        end
end
        
function SpawnKobolds(trigger)
        local building = Entities:FindByName(nil, "kobold_farm1")
        if building ~= nil then
                local ability = building:FindAbilityByName("spawn_kobold_tunneler")
                ability:SetContextThink("SpawnLoop", function() 
                        if ability:IsFullyCastable() then 
                                ability:CastAbility() 
                                end 
                        return 3 
                end, 1)
        end
end

function SpawnArchers1(trigger)
        local building = Entities:FindByName(nil, "archer_hut1")
        if building ~= nil then
                local ability = building:FindAbilityByName("spawn_frost_archer")
                ability:SetContextThink("SpawnLoop", function() 
                        if ability:IsFullyCastable() then 
                                ability:CastAbility() 
                                end 
                        return 4 
                end, 1)
        end
end

function SpawnArchers2(trigger)
        local building = Entities:FindByName(nil, "archer_hut2")
        if building ~= nil then
                local ability = building:FindAbilityByName("spawn_frost_archer")
                ability:SetContextThink("SpawnLoop", function() 
                        if ability:IsFullyCastable() then 
                                ability:CastAbility() 
                                end 
                        return 4 
                end, 1)
        end
end
        
function SpawnIceTrolls(trigger)
        local building = Entities:FindByName(nil, "ice_hut")
        if building ~= nil then
                local ability = building:FindAbilityByName("spawn_ice_priest")
                ability:SetContextThink("SpawnLoop", function() 
                        if ability:IsFullyCastable() then 
                                ability:CastAbility() 
                                end 
                        return 4 
                end, 1)
        end
end

function SpawnMediumSludges(trigger)
        local building = Entities:FindByName(nil, "sludge_ziggurat")
        if building ~= nil then
                local ability = building:FindAbilityByName("spawn_medium_sludge")
                ability:SetContextThink("SpawnLoop", function() 
                        if ability:IsFullyCastable() then 
                                ability:CastAbility() 
                                end 
                        return 4 
                end, 1)
        end
end

function SpawnWizards(trigger)
        local building = Entities:FindByName(nil, "wizard_hut")
        if building ~= nil then
                local ability = building:FindAbilityByName("spawn_wizard")
                ability:SetContextThink("SpawnLoop", function() 
                        if ability:IsFullyCastable() then 
                                ability:CastAbility() 
                                end 
                        return 7 
                end, 1)
        end
end

function SpawnHellhounds1(trigger)
        local building = Entities:FindByName(nil, "hell_hut1")
        if building ~= nil then
                local ability = building:FindAbilityByName("spawn_fellhound")
                ability:SetContextThink("SpawnLoop", function() 
                        if ability:IsFullyCastable() then 
                                ability:CastAbility() 
                                end 
                        return 6 
                end, 1)
        end
end

function SpawnHellhounds2(trigger)
        local building = Entities:FindByName(nil, "hell_hut2")
        if building ~= nil then
                local ability = building:FindAbilityByName("spawn_fellhound")
                ability:SetContextThink("SpawnLoop", function() 
                        if ability:IsFullyCastable() then 
                                ability:CastAbility() 
                                end 
                        return 6 
                end, 1)
        end
end

function SpawnBigSludges1(trigger)
        local building = Entities:FindByName(nil, "sludge_tent1")
        if building ~= nil then
                local ability = building:FindAbilityByName("spawn_big_sludge")
                ability:SetContextThink("SpawnLoop", function() 
                        if ability:IsFullyCastable() then 
                                ability:CastAbility() 
                                end 
                        return 6 
                end, 1)
        end
end

function SpawnBigSludges2(trigger)
        local building = Entities:FindByName(nil, "sludge_tent2")
        if building ~= nil then
                local ability = building:FindAbilityByName("spawn_big_sludge")
                ability:SetContextThink("SpawnLoop", function() 
                        if ability:IsFullyCastable() then 
                                ability:CastAbility() 
                                end 
                        return 6 
                end, 1)
        end
end

function SpawnMediumSatyrs(trigger)
        local building = Entities:FindByName(nil, "harpy_nest")
        if building ~= nil then
                local ability = building:FindAbilityByName("spawn_medium_satyr")
                ability:SetContextThink("SpawnLoop", function() 
                        if ability:IsFullyCastable() then 
                                ability:CastAbility() 
                                end 
                        return 4 
                end, 1)
        end
end

function SpawnLanternWeavers(event)
        local position = Vector(-2435,861,129)
        local rangedweaver = CreateUnitByName("npc_nerubian_webspinner", position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
        local meleeweaver1 = CreateUnitByName("npc_nerubian_melee", position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
        local meleeweaver2 = CreateUnitByName("npc_nerubian_melee", position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
        --[[Returns:handle
        Creates a DOTA unit by its dota_npc_units.txt name ( szUnitName, vLocation, bFindClearSpace, hNPCOwner, hUnitOwner, iTeamNumber )
        ]]
end

function SpawnLanternTrolls(event)
        local position = Vector(-1678,844,129)
        local troll1 = CreateUnitByName("npc_forest_troll", position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
        local troll2 = CreateUnitByName("npc_forest_troll", position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
        local troll3 = CreateUnitByName("npc_forest_troll", position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
        local troll4 = CreateUnitByName("npc_forest_troll", position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
        local troll5 = CreateUnitByName("npc_forest_troll", position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
        local troll6 = CreateUnitByName("npc_forest_troll", position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
        local troll7 = CreateUnitByName("npc_forest_troll", position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
        local troll8 = CreateUnitByName("npc_forest_troll", position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
end


function SpawnCircleActivated(event)
        GameRules:SendCustomMessage("The circle has been activated!<br>The magical barrier has been dispelled and now the path is clear",0,0)
        --Now, find and activate the other magic circle
        --SUCESS (blue) [on both]

        --Spawns on the way back
        position = Vector(3870, 5212, 394)
        rotationSouth = Vector(3755,-4456,128)
        local lizard2 = CreateUnitByName("npc_blue_lizard" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
        lizard2:SetForwardVector(rotationSouth)
        local ghost1 = CreateUnitByName("npc_ghost" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
        ghost1:SetForwardVector(rotationSouth)
        local ghost2 = CreateUnitByName("npc_ghost" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
        ghost2:SetForwardVector(rotationSouth)
        local ghost3 = CreateUnitByName("npc_ghost" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
        ghost3:SetForwardVector(rotationSouth)
        local ghost4 = CreateUnitByName("npc_ghost" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
        ghost4:SetForwardVector(rotationSouth)

        position = Vector(2558,3226,150)
        rotationWest = Vector(-6801,4736,126)
        local weaver1 = CreateUnitByName("npc_nerubian_webspinner" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
        weaver1:SetForwardVector(rotationWest)
        local weaver2 = CreateUnitByName("npc_nerubian_melee" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
        weaver2:SetForwardVector(rotationWest)
        local weaver3 = CreateUnitByName("npc_nerubian_melee" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
        weaver3:SetForwardVector(rotationWest)
        local ghoul1 = CreateUnitByName("npc_ghoul" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
        ghoul1:SetForwardVector(rotationWest)
        local ghoul2 = CreateUnitByName("npc_ghoul" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
        ghoul2:SetForwardVector(rotationWest)
        local ghoul3 = CreateUnitByName("npc_ghoul" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
        ghoul3:SetForwardVector(rotationWest)
        local ghoul4 = CreateUnitByName("npc_ghoul" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
        ghoul4:SetForwardVector(rotationWest)
          

        position = Vector(416, 4415, 128)
        rotationWest = Vector(-6801,4736,126)
        local bigsludge1 = CreateUnitByName("npc_big_sludge" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
        bigsludge1:SetForwardVector(rotationWest)
        local medsludge1 = CreateUnitByName("npc_medium_sludge" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
        medsludge1:SetForwardVector(rotationWest)
        local medsludge2 = CreateUnitByName("npc_medium_sludge" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
        medsludge2:SetForwardVector(rotationWest)
        local smallsludge1 = CreateUnitByName("npc_small_sludge" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
        smallsludge1:SetForwardVector(rotationWest)
        local smallsludge2 = CreateUnitByName("npc_small_sludge" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
        smallsludge2:SetForwardVector(rotationWest)
        local smallsludge3 = CreateUnitByName("npc_small_sludge" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
        smallsludge3:SetForwardVector(rotationWest)
        local smallsludge4 = CreateUnitByName("npc_small_sludge" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
        smallsludge4:SetForwardVector(rotationWest)


        position = Vector(-1512, 5841, 128)
        local wizard1 = CreateUnitByName("npc_big_wizard" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
        local elemental1 = CreateUnitByName("npc_water_elemental_nonspawned" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
        local elemental2 = CreateUnitByName("npc_water_elemental_nonspawned" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
        local mudgolem1 = CreateUnitByName("npc_mud_golem" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
        local mudgolem2 = CreateUnitByName("npc_mud_golem" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
        local priest1 = CreateUnitByName("npc_priest" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
        local priest2 = CreateUnitByName("npc_priest" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)


        position = Vector(751, 5375, 128)
        local meleeskeleton1 = CreateUnitByName("npc_skeleton_warrior" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
        local meleeskeleton2 = CreateUnitByName("npc_skeleton_warrior" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
        local meleeskeleton3 = CreateUnitByName("npc_skeleton_warrior" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
        local burnskeleton1 = CreateUnitByName("npc_burning_skeleton_archer"  , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
        local burnskeleton2 = CreateUnitByName("npc_burning_skeleton_archer"  , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
        local frostskeleton1 = CreateUnitByName( "npc_frost_skeleton_archer" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
        local frostskeleton2 = CreateUnitByName( "npc_frost_skeleton_archer" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)

end

--[[boss spawns
        //hell imps every second ]]--
