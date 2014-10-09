print("AI is loading")

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