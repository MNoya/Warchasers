print("AI is loading")

affix_table = {}

affix_names = {}

affix_count = 0

function affix_list()
	local affix_txt = LoadKeyValues("scripts/affix_list.txt")
	--defense affixes
	for key, value in pairs(affix_txt.defense) do
		table.insert( affix_names, key)
		affix_count = affix_count + 1
	end
	--aggresive affixes
	for key, value in pairs(affix_txt.aggresive) do
		table.insert( affix_names, key)
		affix_count = affix_count + 1
	end
	--disable affixes
	for key, value in pairs(affix_txt.disable) do
		table.insert( affix_names, key)
		affix_count = affix_count + 1
	end
	print("Affixes generated")
end


affix_list()







function affix_selector()
	return affix_names[math.random(affix_count)]
end


function affix( unit)
	
	local affix_to_set = nil

	local unit_name = unit:GetUnitName() 

	for key, value in pairs(affix_table) do
		if unit_name == key then
			affix_to_set = value

		end
	end

	if affix_to_set == nil then
		affix_to_set = affix_selector()
		affix_table[unit_name] = affix_to_set
	end

	unit:AddAbility(affix_to_set)
	unit:FindAbilityByName(affix_to_set):SetLevel(1)


end


function log_npc( event )
	local index = event.entindex
	local unit = EntIndexToHScript(index)
	if Convars:GetBool("developer") == true then
		print("Index: "..index.." Name: "..unit:GetUnitName().." Created time: "..GameRules:GetGameTime().." at x= "..unit:GetOrigin().x.." y= "..unit:GetOrigin().y)
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


		affix(unit)


	else


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

function final_boss_think( event )
	local boss = event.caster
	local heroes_around = FindUnitsInRadius( DOTA_TEAM_NEUTRALS, boss:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
	local void_spell = boss:FindAbilityByName("final_boss_void_new")

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
 	Timers:CreateTimer({
    endTime = 4,
    callback = function()
     	GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
    end
  	})
	
end