


function structure_spawner_func( event )
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
end






















function SpawnMurlocs1(trigger)
        local building = Entities:FindByName(nil, "murloc_hut1") --2
        if building ~= nil then
                local ability = building:FindAbilityByName("spawn_murloc")
                --ability:SetContextThink("SpawnLoop", function() if ability:IsFullyCastable() then ability:CastAbility() end return 4 end, 1)
        end
end
--ty Quintinity

function SpawnMurlocs2(trigger)
        local building = Entities:FindByName(nil, "murloc_hut2")
        if building ~= nil then
                local ability = building:FindAbilityByName("spawn_murloc")
                --ability:SetContextThink("SpawnLoop", function() if ability:IsFullyCastable() then ability:CastAbility() end return 4 end, 1)
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

function SpawnGhoulsZigguratFast(trigger)
        local building = Entities:FindByName(nil, "ghoul_ziggurat2")
        if building ~= nil then
                local ability = building:FindAbilityByName("spawn_ghoul")
                ability:SetContextThink("SpawnLoop", function()
                        if ability:IsFullyCastable() then
                                ability:CastAbility();
                        end
                        return 2;
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

--[[//High Elven Farm spawns:
        //mini sludges
        //corrupted treants
        //burning archers
        //kobol tunneler

//ziggurat spawns
        //medium sludges every 6

//Ice Troll Hut spawns
        //skeletal marksman

//Blue Dragon Roost just drops Red Egg
        //Tauren tent spawns
        //Ice troll priests

//Fulborg hut spawns
        //wizards every 7

//Centaur tent spawns
        //hellhounds every 6
        //big sludges

//harpy nest spawns
        //medium satyrs

//boss spawns
        //hell imps every second ]]--
