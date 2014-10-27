print("AI is loading")



function log_npc( event )
	local index = event.entindex
	local unit = EntIndexToHScript(index)
	if Convars:GetBool("developer") == true then
		print("Index: "..index.." Name: "..unit:GetName().." Created time: "..GameRules:GetGameTime().." at x= "..unit:GetOrigin().x.." y= "..unit:GetOrigin().y)
	end

	if unit:GetTeam() == DOTA_TEAM_NEUTRALS then
		if unit.initial_neutral_position == nil then
			unit.initial_neutral_position = unit:GetAbsOrigin()
		end
		unit:SetContextThink("chase_distance_function", 
			function ()
				if unit:GetTeam() == DOTA_TEAM_NEUTRALS then
					if (unit.initial_neutral_position - unit:GetAbsOrigin()):Length2D() > 900 then
						unit:MoveToPosition(unit.initial_neutral_position) 

					end

					return math.random(2,6)
				else
					return nil
				end
			end
			, 5) 	
	end
end

ListenToGameEvent( "npc_spawned", log_npc, nil )

function physical_ehp( unit )
	return unit:GetHealth() * ((0.06 * unit:GetPhysicalArmorValue()) / (1 + 0.06 * unit:GetPhysicalArmorValue()))
end

function tb_miniboss_think( event )
	local dead_units = false
	for number, unit in pairs(event.target_entities) do
		if unit:IsAlive() == false then
			dead_units = true
		end
	end
	if dead_units == true and event.ability:IsChanneling() == false and event.ability:IsFullyCastable() == true  then
		event.caster:CastAbilityNoTarget(event.caster:FindAbilityByName("tb_miniboss_animate_dead"), -1)
	end
end

function tank_miniboss_think( event )
	local boss = event.caster
	local flak_spell = boss:FindAbilityByName("miniboss_flak")
	local bomb_spell = boss:FindAbilityByName("miniboss_aoe_bomb")

	local boss_current_position = boss:GetAbsOrigin() --needed?
	boss.currentWaypoint = 0 		--global stored on the caster?

	-- waypoints
	local waypoint0 = Vector(4488,1188,128) --just in front of the start position
	local waypoint1 = Vector(5424,-560,224) --first ramp
	local waypoint2 = Vector(6170,1145,128) --first arc
	local waypoint3 = Vector(7716,1285,128) --second arc
	local waypoint4 = Vector(7288,-504,224) --second ramp
	local waypoint5 = Vector(4766,-2439,128) --final door door
	local nextWaypoint = 0
	local givenMoveOrder = false

	if (boss:GetHealth() / boss:GetMaxHealth()) <= 0.20 and not givenMoveOrder then
		nextWaypoint = 5
		givenMoveOrder = true
	elseif (boss:GetHealth() / boss:GetMaxHealth()) <= 0.40 and not givenMoveOrder then
		nextWaypoint = 4
		givenMoveOrder = true
	elseif (boss:GetHealth() / boss:GetMaxHealth()) <= 0.50 and not givenMoveOrder then
		nextWaypoint = 3
		givenMoveOrder = true
	elseif (boss:GetHealth() / boss:GetMaxHealth()) <= 0.60 and not givenMoveOrder then
		nextWaypoint = 2
		givenMoveOrder = true
	elseif (boss:GetHealth() / boss:GetMaxHealth()) <= 0.80 and not givenMoveOrder then
		nextWaypoint = 1
		givenMoveOrder = true
	end

	if givenMoveOrder then
		if nextWaypoint == 1 then
			boss:MoveToPosition(waypoint1)
		elseif nextWaypoint == 2 then
			boss:MoveToPosition(waypoint2)
		elseif nextWaypoint == 3 then
			boss:MoveToPosition(waypoint3)
		elseif nextWaypoint == 4 then
			boss:MoveToPosition(waypoint4)
		elseif nextWaypoint == 5 then
			boss:MoveToPosition(waypoint5)
		end
	end
end


function final_boss_think( event )
	local boss = event.caster
	local heroes_around = FindUnitsInRadius( DOTA_TEAM_NEUTRALS, boss:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	local void_spell = boss:FindAbilityByName("final_boss_void")

	if void_spell:IsFullyCastable() == true and heroes_around[1] ~= nil then
		local target = heroes_around[1]
		local target_ehp = physical_ehp(target)

		for key, hero in pairs(heroes_around) do 
			local filtered_ehp = physical_ehp(hero)
			if filtered_ehp < target_ehp then
				target = hero
				target_ehp = filtered_ehp
			end 
		end

		boss:CastAbilityOnTarget(target, void_spell, -1)

		boss:SetForceAttackTarget(target)

		--boss:MoveToTargetToAttack(target) 
		--[[ExecuteOrderFromTable({
								UnitIndex = boss:entindex(), 
 								OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
 		 						TargetIndex = target:entindex()
								})]]
		
	else
		boss:SetForceAttackTarget(nil)
	end

	if boss:HasModifier("final_boss_powerup") == false then
		if (boss:GetHealth() / boss:GetMaxHealth()) <= 0.5 then
			boss:AddAbility("final_boss_buff")
			boss:FindAbilityByName("final_boss_buff"):SetLevel(1)
		end
	end
end

function final_boss_defeat( event )
	GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
end