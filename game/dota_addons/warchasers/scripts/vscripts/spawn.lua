


function attack_agro_func( event )
        for key, unit in pairs(event.target_entities) do
                if unit:GetAttackTarget() == nil then
                        unit:MoveToPositionAggressive(event.attacker:GetAbsOrigin()) 
                end
        end
end


function StartSpawnForBuilding( building_name, ability_name, unit_name, spawn_limit, spawn_interval, sound)
    local building = Entities:FindByName(nil, building_name)
    if building ~= nil then
        local ability = building:FindAbilityByName(ability_name)
        ability:SetContextThink("SpawnLoop", function() 
            if ability:IsFullyCastable() then
                ability:StartCooldown(spawn_interval)
                SpawnUnit(unit_name, building, spawn_limit, sound)
            end 
            return spawn_interval 
        end, 1)
    end
end


function SpawnUnit(unit_name, building, limit, sound)
    if not building.unit_table then
        building.unit_table = {}
    end

    if #building.unit_table < limit then
        local unit = CreateUnitByName(unit_name, building:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_NEUTRALS)
        local particle = ParticleManager:CreateParticle("particles/warchasers/spawn/abaddon_death_coil_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
        ParticleManager:SetParticleControl(particle, 0, unit:GetAbsOrigin())
        ParticleManager:SetParticleControl(particle, 1, unit:GetAbsOrigin())
        unit:EmitSound(sound)
        table.insert(building.unit_table, unit)
    end

    -- Cleanup the table
    local aux_build_table = {}
    for _,unit in pairs(building.unit_table) do
        if unit and IsValidEntity(unit) then
            table.insert(aux_build_table, unit)
        end
    end
    building.unit_table = aux_build_table
end

function SpawnMurlocs1(trigger)
    local building_name = "murloc_hut1"
    local ability_name = "spawn_murloc_a"
    local unit_name = "npc_small_murloc_a"
    local spawn_limit = 8
    local spawn_interval = 2
    local sound = "Hero_Abaddon.DeathCoil.Target"

    StartSpawnForBuilding(building_name, ability_name, unit_name, spawn_limit, spawn_interval, sound)
end

function SpawnMurlocs2(trigger)
    local building_name = "murloc_hut2"
    local ability_name = "spawn_murloc_b"
    local unit_name = "npc_small_murloc_b"
    local spawn_limit = 8
    local spawn_interval = 2
    local sound = "Hero_Abaddon.DeathCoil.Target"

    StartSpawnForBuilding(building_name, ability_name, unit_name, spawn_limit, spawn_interval, sound)
end

function SpawnGnolls1(trigger)
    local building_name = "elf_farm1"
    local ability_name = "spawn_gnoll"
    local unit_name = "npc_archer_gnoll"
    local spawn_limit = 10
    local spawn_interval = 2
    local sound = "Hero_Abaddon.DeathCoil.Target"

    StartSpawnForBuilding(building_name, ability_name, unit_name, spawn_limit, spawn_interval, sound)
end

function SpawnGnolls2(trigger)
    local building_name = "elf_farm2"
    local ability_name = "spawn_gnoll"
    local unit_name = "npc_archer_gnoll"
    local spawn_limit = 10
    local spawn_interval = 2
    local sound = "Hero_Abaddon.DeathCoil.Target"

    StartSpawnForBuilding(building_name, ability_name, unit_name, spawn_limit, spawn_interval, sound)
end

function SpawnGhouls1(trigger)
    local building_name = "ghoul_hut1"
    local ability_name = "spawn_ghoul"
    local unit_name = "npc_ghoul"
    local spawn_limit = 10
    local spawn_interval = 4
    local sound = "Hero_LifeStealer.Consume"

    StartSpawnForBuilding(building_name, ability_name, unit_name, spawn_limit, spawn_interval, sound)
end

function SpawnGhouls2(trigger)
    local building_name = "ghoul_hut2"
    local ability_name = "spawn_ghoul"
    local unit_name = "npc_ghoul"
    local spawn_limit = 10
    local spawn_interval = 4
    local sound = "Hero_LifeStealer.Consume"

    StartSpawnForBuilding(building_name, ability_name, unit_name, spawn_limit, spawn_interval, sound)
end

function SpawnGhoulsZiggurat(trigger)
    local building_name = "ghoul_ziggurat1"
    local ability_name = "spawn_ghoul"
    local unit_name = "npc_ghoul"
    local spawn_limit = 10
    local spawn_interval = 3
    local sound = "Hero_LifeStealer.Consume"

    StartSpawnForBuilding(building_name, ability_name, unit_name, spawn_limit, spawn_interval, sound)
end

function SpawnGhoulsZiggurat2	(trigger)
    local building_name = "ghoul_ziggurat2"
    local ability_name = "spawn_ghoul"
    local unit_name = "npc_ghoul"
    local spawn_limit = 10
    local spawn_interval = 3
    local sound = "Hero_LifeStealer.Consume"

    StartSpawnForBuilding(building_name, ability_name, unit_name, spawn_limit, spawn_interval, sound)
end

function SpawnGhoulsZiggurat3	(trigger)
    local building_name = "ghoul_ziggurat3"
    local ability_name = "spawn_ghoul"
    local unit_name = "npc_ghoul"
    local spawn_limit = 10
    local spawn_interval = 2
    local sound = "Hero_LifeStealer.Consume"
end

function SpawnSatyrs1(trigger)
    local building_name = "forest_troll_hut1"
    local ability_name = "spawn_medium_satyr"
    local unit_name = "npc_medium_satyr"
    local spawn_limit = 20
    local spawn_interval = 3
    local sound = "Hero_Abaddon.DeathCoil.Target"

    StartSpawnForBuilding(building_name, ability_name, unit_name, spawn_limit, spawn_interval, sound)
end

function SpawnGolems(trigger)
    local building_name = "forest_troll_hut2"
    local ability_name = "spawn_golem"
    local unit_name = "npc_mud_golem"
    local spawn_limit = 20
    local spawn_interval = 4
    local sound = "Hero_Abaddon.DeathCoil.Target"

    StartSpawnForBuilding(building_name, ability_name, unit_name, spawn_limit, spawn_interval, sound)
end

function SpawnMediumMurlocs1(trigger)
    local building_name = "murloc_mid_hut1"
    local ability_name = "spawn_medium_murloc"
    local unit_name = "npc_medium_murloc"
    local spawn_limit = 8
    local spawn_interval = 4
    local sound = "Hero_Abaddon.DeathCoil.Target"

    StartSpawnForBuilding(building_name, ability_name, unit_name, spawn_limit, spawn_interval, sound)
end

function SpawnMediumMurlocs2(trigger)
    local building_name = "murloc_mid_hut2"
    local ability_name = "spawn_medium_murloc"
    local unit_name = "npc_medium_murloc"
    local spawn_limit = 8
    local spawn_interval = 4
    local sound = "Hero_Abaddon.DeathCoil.Target"

    StartSpawnForBuilding(building_name, ability_name, unit_name, spawn_limit, spawn_interval, sound)
end

function SpawnMediumMurlocs3(trigger)
    local building_name = "murloc_mid_hut3"
    local ability_name = "spawn_medium_murloc"
    local unit_name = "npc_medium_murloc"
    local spawn_limit = 8
    local spawn_interval = 4
    local sound = "Hero_Abaddon.DeathCoil.Target"

    StartSpawnForBuilding(building_name, ability_name, unit_name, spawn_limit, spawn_interval, sound)
end

function SpawnWaterElementals1(trigger)
    local building_name = "water_hut1"
    local ability_name = "spawn_water_elemental"
    local unit_name = "npc_water_elemental"
    local spawn_limit = 10
    local spawn_interval = 6
    local sound = "Hero_Abaddon.DeathCoil.Target"

    StartSpawnForBuilding(building_name, ability_name, unit_name, spawn_limit, spawn_interval, sound)
end


function SpawnWaterElementals2(trigger)
    local building_name = "water_hut2"
    local ability_name = "spawn_water_elemental"
    local unit_name = "npc_water_elemental"
    local spawn_limit = 10
    local spawn_interval = 6
    local sound = "Hero_Abaddon.DeathCoil.Target"

    StartSpawnForBuilding(building_name, ability_name, unit_name, spawn_limit, spawn_interval, sound)
end

function SpawnDarkTrolls1(trigger)
    local building_name = "dark_troll_hut1"
    local ability_name = "spawn_ranged_troll"
    local unit_name = "npc_dark_troll_archer"
    local spawn_limit = 8
    local spawn_interval = 3
    local sound = "Hero_TrollWarlord.WhirlingAxes.Ranged"

    StartSpawnForBuilding(building_name, ability_name, unit_name, spawn_limit, spawn_interval, sound)
end

function SpawnDarkTrolls2(trigger)
    local building_name = "dark_troll_hut2"
    local ability_name = "spawn_ranged_troll"
    local unit_name = "npc_dark_troll_archer"
    local spawn_limit = 8
    local spawn_interval = 3
    local sound = "Hero_TrollWarlord.WhirlingAxes.Ranged"

    StartSpawnForBuilding(building_name, ability_name, unit_name, spawn_limit, spawn_interval, sound)
end

--

function SpawnSmallSludges(trigger)
    local building_name = "sludge_farm"
    local ability_name = "spawn_small_sludge"
    local unit_name = "npc_small_sludge"
    local spawn_limit = 10
    local spawn_interval = 4
    local sound = "Hero_Enigma.Demonic_Conversion"

    StartSpawnForBuilding(building_name, ability_name, unit_name, spawn_limit, spawn_interval, sound)
end

function SpawnTreants1(trigger)
    local building_name = "treant_farm1"
    local ability_name = "spawn_burning_archer"
    local unit_name = "npc_burning_skeleton_archer"
    local spawn_limit = 20
    local spawn_interval = 3
    local sound = "Hero_Abaddon.DeathCoil.Target"

    StartSpawnForBuilding(building_name, ability_name, unit_name, spawn_limit, spawn_interval, sound)
end

function SpawnTreants2(trigger)
    local building_name = "treant_farm2"
    local ability_name = "spawn_treant"
    local unit_name = "npc_treant"
    local spawn_limit = 20
    local spawn_interval = 3
    local sound = "Hero_Abaddon.DeathCoil.Target"

    StartSpawnForBuilding(building_name, ability_name, unit_name, spawn_limit, spawn_interval, sound)
end
        
function SpawnKobolds(trigger)
    local building_name = "kobold_farm1"
    local ability_name = "spawn_kobold_tunneler"
    local unit_name = "npc_kobold_tunneler"
    local spawn_limit = 6
    local spawn_interval = 3
    local sound = "Hero_Meepo.Poof.End"

    StartSpawnForBuilding(building_name, ability_name, unit_name, spawn_limit, spawn_interval, sound)
end

function SpawnArchers1(trigger)
    local building_name = "archer_hut1"
    local ability_name = "spawn_frost_archer"
    local unit_name = "npc_frost_skeleton_archer"
    local spawn_limit = 6
    local spawn_interval = 3
    local sound = "Hero_Abaddon.DeathCoil.Target"

    StartSpawnForBuilding(building_name, ability_name, unit_name, spawn_limit, spawn_interval, sound)
end

function SpawnArchers2(trigger)
    local building_name = "archer_hut2"
    local ability_name = "spawn_frost_archer"
    local unit_name = "npc_frost_skeleton_archer"
    local spawn_limit = 20
    local spawn_interval = 4
    local sound = "Hero_Abaddon.DeathCoil.Target"

    StartSpawnForBuilding(building_name, ability_name, unit_name, spawn_limit, spawn_interval, sound)
		
	--add vision dummy to properly show the particle effect of the key (weird but works)
	local point = Vector(118, 2185,136)
	local dummy = CreateUnitByName("vision_dummy_minor", point, true, nil, nil, DOTA_TEAM_GOODGUYS)
	--kill it later, after the key is used
	Timers:CreateTimer({
			endTime = 100,
			callback = function()
			  dummy1:ForceKill(true)
			  dummy2:ForceKill(true)
			  dummy3:ForceKill(true)
			end
		})
	

end
        
function SpawnIceTrolls(trigger)
    local building_name = "ice_hut"
    local ability_name = "spawn_ice_priest"
    local unit_name = "npc_ice_troll_priest"
    local spawn_limit = 20
    local spawn_interval = 4
    local sound = "Hero_Abaddon.DeathCoil.Target"

    StartSpawnForBuilding(building_name, ability_name, unit_name, spawn_limit, spawn_interval, sound)
end

function SpawnMediumSludges(trigger)
    local building_name = "sludge_ziggurat"
    local ability_name = "spawn_medium_sludge"
    local unit_name = "npc_ice_troll_priest"
    local spawn_limit = 20
    local spawn_interval = 4
    local sound = "Hero_Enigma.Demonic_Conversion"

    StartSpawnForBuilding(building_name, ability_name, unit_name, spawn_limit, spawn_interval, sound)
end

function SpawnWizards(trigger)
    local building_name = "wizard_hut"
    local ability_name = "spawn_wizard"
    local unit_name = "npc_wizard"
    local spawn_limit = 20
    local spawn_interval = 4
    local sound = "Hero_KeeperOfTheLight.Spawn"

    StartSpawnForBuilding(building_name, ability_name, unit_name, spawn_limit, spawn_interval, sound)
end

function SpawnHellhounds1(trigger)
    local building_name = "hell_hut1"
    local ability_name = "spawn_fellhound"
    local unit_name = "npc_fellhound"
    local spawn_limit = 10
    local spawn_interval = 6
    local sound = "Hero_Abaddon.DeathCoil.Target"

    StartSpawnForBuilding(building_name, ability_name, unit_name, spawn_limit, spawn_interval, sound)
end

function SpawnHellhounds2(trigger)
    local building_name = "hell_hut2"
    local ability_name = "spawn_fellhound"
    local unit_name = "npc_fellhound"
    local spawn_limit = 10
    local spawn_interval = 6
    local sound = "Hero_Abaddon.DeathCoil.Target"

    StartSpawnForBuilding(building_name, ability_name, unit_name, spawn_limit, spawn_interval, sound)
end

function SpawnBigSludges1(trigger)
    local building_name = "sludge_tent1"
    local ability_name = "spawn_big_sludge"
    local unit_name = "npc_big_sludge"
    local spawn_limit = 15
    local spawn_interval = 6
    local sound = "Hero_Enigma.Black_Hole.Stop"

    StartSpawnForBuilding(building_name, ability_name, unit_name, spawn_limit, spawn_interval, sound)
end

function SpawnBigSludges2(trigger)
    local building_name = "sludge_tent2"
    local ability_name = "spawn_big_sludge"
    local unit_name = "npc_big_sludge"
    local spawn_limit = 15
    local spawn_interval = 6
    local sound = "Hero_Enigma.Black_Hole.Stop"

    StartSpawnForBuilding(building_name, ability_name, unit_name, spawn_limit, spawn_interval, sound)
end

function SpawnMediumSatyrs(trigger)
    local building_name = "harpy_nest"
    local ability_name = "spawn_medium_satyr_shadowdancer"
    local unit_name = "npc_medium_satyr_range"
    local spawn_limit = 30
    local spawn_interval = 2
    local sound = "Hero_Abaddon.DeathCoil.Target"

    StartSpawnForBuilding(building_name, ability_name, unit_name, spawn_limit, spawn_interval, sound)
end

--initial_neutral_position

function SpawnLanternWeavers(event)
        local position = Vector(-2435,861,129)
        EmitGlobalSound("DOTAMusic_Stinger.005")
        local rangedweaver = CreateUnitByName("npc_nerubian_webspinner", position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
        rangedweaver.initial_neutral_position = position
        local rangedweaver = CreateUnitByName("npc_nerubian_webspinner", position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
        rangedweaver.initial_neutral_position = position
        local meleeweaver1 = CreateUnitByName("npc_nerubian_melee", position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
        meleeweaver1.initial_neutral_position = position
        local meleeweaver2 = CreateUnitByName("npc_nerubian_melee", position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
        meleeweaver2.initial_neutral_position = position
        local meleeweaver1 = CreateUnitByName("npc_nerubian_melee", position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
        meleeweaver1.initial_neutral_position = position
        local meleeweaver2 = CreateUnitByName("npc_nerubian_melee", position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
        meleeweaver2.initial_neutral_position = position
        local meleeweaver1 = CreateUnitByName("npc_nerubian_melee", position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
        meleeweaver1.initial_neutral_position = position
        local meleeweaver2 = CreateUnitByName("npc_nerubian_melee", position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
        meleeweaver2.initial_neutral_position = position
end

function SpawnLanternTrolls(event)
        local position = Vector(-1678,844,129)
        EmitGlobalSound("DOTAMusic_Stinger.005")
        Timers:CreateTimer({
            endTime = 3,
            callback = function()
                EmitGlobalSound("General.PingRune")
                        GameRules:SendCustomMessage("<font color='#2EFE2E'>HINT</font> - A key has been dropped!", 0, 0) 
            end
                })
        local troll1 = CreateUnitByName("npc_forest_troll", position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
        troll1.initial_neutral_position = position
        local troll2 = CreateUnitByName("npc_forest_troll", position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
        troll2.initial_neutral_position = position
        local troll3 = CreateUnitByName("npc_forest_troll", position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
        troll3.initial_neutral_position = position
        local troll4 = CreateUnitByName("npc_forest_troll", position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
        troll4.initial_neutral_position = position
        local troll5 = CreateUnitByName("npc_forest_troll", position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
        troll5.initial_neutral_position = position
        local troll6 = CreateUnitByName("npc_forest_troll", position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
        troll6.initial_neutral_position = position
        local troll7 = CreateUnitByName("npc_forest_troll", position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
        troll7.initial_neutral_position = position
        local troll8 = CreateUnitByName("npc_forest_troll", position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
        troll8.initial_neutral_position = position
		
		--add vision dummy to properly show the particle effect of the key (weird but works)
		local point = Vector(-1280, 256, 256)
		local dummy1 = CreateUnitByName("vision_dummy_point", point, true, nil, nil, DOTA_TEAM_GOODGUYS)
		
		--cosmetic vision dummies
		local point = Vector(-1280, 768, 256)
		local dummy2 = CreateUnitByName("vision_dummy_point", point, true, nil, nil, DOTA_TEAM_GOODGUYS)
		
		local point = Vector(-1280, 1280, 256)
		local dummy3 = CreateUnitByName("vision_dummy_point", point, true, nil, nil, DOTA_TEAM_GOODGUYS)
		

		Timers:CreateTimer({
			endTime = 100,
			callback = function()
			  dummy1:ForceKill(true)
			  dummy2:ForceKill(true)
			  dummy3:ForceKill(true)
			end
		})

end

function SpawnCircleActivated1(event)
        GameRules:SendCustomMessage("The circle has been activated!",0,0)
        EmitGlobalSound("Loot_Drop_Stinger_Short")

        if not GameRules.FIRST_CIRCLE_ACTIVADED then
                GameRules.FIRST_CIRCLE_ACTIVADED = true
                print(GameRules.FIRST_CIRCLE_ACTIVADED)
                
                --SUCESS (blue) [on both]

                GameRules:SendCustomMessage("Now, find and activate the other magic circle.<br><br>",0,0)
                --Spawns on the way back
                position = Vector(3870,5148,394)
                rotationSouth = Vector(3755,-4456,128)
                --red lizard area
                local lizard2 = CreateUnitByName("npc_blue_lizard" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
                lizard2:SetForwardVector(rotationSouth)
                lizard2.initial_neutral_position = position

                position = Vector(3739,5058,385)
                local ghost1 = CreateUnitByName("npc_ghost" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
                ghost1:SetForwardVector(rotationSouth)
                ghost1.initial_neutral_position = position

                position = Vector(4054,5059,400)
                local ghost2 = CreateUnitByName("npc_ghost" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
                ghost2:SetForwardVector(rotationSouth)
                ghost2.initial_neutral_position = position

                position = Vector(4036,5424,393)
                local ghost3 = CreateUnitByName("npc_ghost" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
                ghost3:SetForwardVector(rotationSouth)
                ghost3.initial_neutral_position = position

                position = Vector(3730,5405, 393)
                local ghost4 = CreateUnitByName("npc_ghost" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
                ghost4:SetForwardVector(rotationSouth)
                ghost4.initial_neutral_position = position             

                --2nd pack sludges
                position = Vector(178,4676,128)
                rotationWest = Vector(-6801,4736,126)
                local bigsludge1 = CreateUnitByName("npc_big_sludge" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
                bigsludge1:SetForwardVector(rotationWest)
                bigsludge1.initial_neutral_position = position

                position = Vector(214,4546,128)
                local medsludge1 = CreateUnitByName("npc_medium_sludge" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
                medsludge1:SetForwardVector(rotationWest)
                medsludge1.initial_neutral_position = position

                position = Vector(302,4651,128)
                local medsludge2 = CreateUnitByName("npc_medium_sludge" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
                medsludge2:SetForwardVector(rotationWest)
                medsludge2.initial_neutral_position = position

                position = Vector(296,4460,128)
                local smallsludge1 = CreateUnitByName("npc_small_sludge" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
                smallsludge1:SetForwardVector(rotationWest)
                smallsludge1.initial_neutral_position = position

                position = Vector(305,4576,128)
                local smallsludge2 = CreateUnitByName("npc_small_sludge" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
                smallsludge2:SetForwardVector(rotationWest)
                smallsludge2.initial_neutral_position = position

                position = Vector(290,4576,128)
                local smallsludge3 = CreateUnitByName("npc_small_sludge" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
                smallsludge3:SetForwardVector(rotationWest)
                smallsludge3.initial_neutral_position = position

                position = Vector(305,4415,128)
                local smallsludge4 = CreateUnitByName("npc_small_sludge" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
                smallsludge4:SetForwardVector(rotationWest)
                smallsludge4.initial_neutral_position = position


                position = Vector(-1370,5814, 128)
                local wizard1 = CreateUnitByName("npc_big_wizard" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
                wizard1.initial_neutral_position = position

                position = Vector(-1114,5814, 128)
                local elemental1 = CreateUnitByName("npc_water_elemental_nonspawned" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
                elemental1.initial_neutral_position = position

                position = Vector(-1114,5735, 128)
                local elemental2 = CreateUnitByName("npc_water_elemental_nonspawned" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
                elemental2.initial_neutral_position = position

                position = Vector(-1178,5814, 128)               
                local mudgolem1 = CreateUnitByName("npc_mud_golem" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
                mudgolem1.initial_neutral_position = position

                 position = Vector(-1178,5735, 128)
                local mudgolem2 = CreateUnitByName("npc_mud_golem" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
                mudgolem2.initial_neutral_position = position

                position = Vector(-1438, 5948, 129)
                local priest1 = CreateUnitByName("npc_priest" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
                priest1.initial_neutral_position = position

                position = Vector (-1310, 5564, 128)
                local priest2 = CreateUnitByName("npc_priest" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
                priest2.initial_neutral_position = position


                position = Vector(751, 5375, 128)
                local meleeskeleton1 = CreateUnitByName("npc_skeleton_warrior" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
                meleeskeleton1.initial_neutral_position = position

                position = Vector(751, 5247, 128)
                local meleeskeleton2 = CreateUnitByName("npc_skeleton_warrior" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
                meleeskeleton2.initial_neutral_position = position

                position = Vector(751, 5503, 128)
                local meleeskeleton3 = CreateUnitByName("npc_skeleton_warrior" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
                meleeskeleton3.initial_neutral_position = position

                position = Vector(652, 5167, 128)
                local frostskeleton1 = CreateUnitByName( "npc_frost_skeleton_archer" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
                frostskeleton1.initial_neutral_position = position

                position = Vector(652, 5295, 128)
                local burnskeleton2 = CreateUnitByName("npc_burning_skeleton_archer"  , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
                burnskeleton2.initial_neutral_position = position

                position = Vector(652, 5423, 128)
                local burnskeleton1 = CreateUnitByName("npc_burning_skeleton_archer"  , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
                burnskeleton1.initial_neutral_position = position

                position = Vector(652, 5551, 128)
                local frostskeleton2 = CreateUnitByName( "npc_frost_skeleton_archer" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
                frostskeleton2.initial_neutral_position = position
        end
end

function SpawnCircleActivated2(event)
        GameRules:SendCustomMessage("The circle has been activated!",0,0)
        EmitGlobalSound("Loot_Drop_Stinger_Short")

        print(GameRules.FIRST_CIRCLE_ACTIVADED)
        if not GameRules.FIRST_CIRCLE_ACTIVADED then
                GameRules.FIRST_CIRCLE_ACTIVADED = true
                print(GameRules.FIRST_CIRCLE_ACTIVADED)
                
                GameRules:SendCustomMessage("Now, find and activate the other magic circle.<br><br>",0,0)
                --Spawns on the way back

                --ziggurat area
                position = Vector(3967, 7705, 384)
                rotationWest = Vector(-6801,4736,126)
                local weaver1 = CreateUnitByName("npc_nerubian_webspinner" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
                weaver1:SetForwardVector(rotationWest)
                weaver1.initial_neutral_position = position

                position = Vector(3801, 7808, 384)
                local weaver2 = CreateUnitByName("npc_nerubian_melee" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
                weaver2:SetForwardVector(rotationWest)
                weaver2.initial_neutral_position = position

                position = Vector(3811, 7624, 384)
                local weaver3 = CreateUnitByName("npc_nerubian_melee" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
                weaver3:SetForwardVector(rotationWest)
                weaver3.initial_neutral_position = position

                position = Vector(3616, 7880, 392)         
                local ghoul1 = CreateUnitByName("npc_ghoul" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
                ghoul1:SetForwardVector(rotationWest)
                ghoul1.initial_neutral_position = position

                position = Vector(3616, 7780, 392)   
                local ghoul2 = CreateUnitByName("npc_ghoul" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
                ghoul2:SetForwardVector(rotationWest)
                ghoul2.initial_neutral_position = position

                position = Vector(3616, 7680, 392)   
                local ghoul3 = CreateUnitByName("npc_ghoul" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
                ghoul3:SetForwardVector(rotationWest)
                ghoul3.initial_neutral_position = position

                position = Vector(3616, 7580, 392)   
                local ghoul4 = CreateUnitByName("npc_ghoul" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
                ghoul4:SetForwardVector(rotationWest)
                ghoul4.initial_neutral_position = position

                --sapper area
                rotationSouth = Vector(3755,-4456,128)

                position = Vector(2335,7704,256)
                local ghost1 = CreateUnitByName("npc_ghost" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
                ghost1:SetForwardVector(rotationSouth)
                ghost1.initial_neutral_position = position

                position = Vector(1835,7704,256)
                local ghost2 = CreateUnitByName("npc_ghost" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
                ghost2:SetForwardVector(rotationSouth)
                ghost2.initial_neutral_position = position

                position = Vector(1335,7704,256)
                local ghost3 = CreateUnitByName("npc_ghost" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
                ghost3:SetForwardVector(rotationSouth)
                ghost3.initial_neutral_position = position

                position = Vector(835,7704,256)
                local ghost4 = CreateUnitByName("npc_ghost" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
                ghost4:SetForwardVector(rotationSouth)
                ghost4.initial_neutral_position = position  

                position = Vector(541, 7052, 256)
                local ghost6 = CreateUnitByName("npc_ghost" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
                ghost6:SetForwardVector(rotationSouth) 
                ghost6.initial_neutral_position = position

                position = Vector(181, 6693, 256)
                local ghost7 = CreateUnitByName("npc_ghost" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
                ghost7:SetForwardVector(rotationSouth) 
                ghost7.initial_neutral_position = position

                position = Vector(-161, 7054, 256)
                local ghost8 = CreateUnitByName("npc_ghost" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
                ghost8:SetForwardVector(rotationSouth) 
                ghost8.initial_neutral_position = position

                position = Vector(171, 7424, 256)
                local ghost9 = CreateUnitByName("npc_ghost" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
                ghost9:SetForwardVector(rotationSouth) 
                ghost9.initial_neutral_position = position

                
        end
end



function SpawnSappers(event)
        print("Don not run, we are your friends!")
        EmitGlobalSound("Warchasers.DoNotRun")

        rotation = Vector(-3958, 6636,416) --west of the bridge

        for i=1,10 do
                Timers:CreateTimer(i,function()
                        for k=1,GameRules.PLAYER_COUNT*2 do
                                position = Vector(7418,6661,640)+RandomVector(200) --[[Returns:Vector
                                Get a random 2D ''vector''. Argument (''float'') is the minimum length of the returned vector.
                                ]]
                                local sapperino = CreateUnitByName("npc_sapper" , position, true, event.caster, event.caster, DOTA_TEAM_NEUTRALS)
                                sapper1:SetForwardVector(rotation)         
                        end
                end)
        end

end


function LaunchSkeletons( event )
    local target = event.target
    local count = event.Count
    local radius = event.Radius
    for i=1,count do
        local unit = CreateUnitByName("npc_roadkill_skeleton", target:GetAbsOrigin() + RandomVector(radius), true, nil, nil, DOTA_TEAM_NEUTRALS)
    end
end