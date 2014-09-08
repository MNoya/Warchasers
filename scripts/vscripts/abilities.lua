print("Abilities are loading")





function warchasers_blade_berserker_immolation_function( event )
	if event.caster:GetMana() >= 7 then
		event.caster:SpendMana( 7, event.ability)
		for key, unit in pairs(event.target_entities) do
			ApplyDamage({
						victim = unit,
						attacker = event.caster,
						damage = 5 + 5 * event.ability:GetLevel(),
						damage_type = DAMAGE_TYPE_MAGICAL
						})
		end
	else
		event.ability:ToggleAbility()
	end
end

function warchasers_muhrah_animate_dead_killer( event )
	event.caster:Kill(event.abilty, event.caster)
end


function warchasers_muhrah_animate_dead_ini( event )
	local owner = event.caster
	local player_id = event.caster:GetPlayerID()
	local team_id = event.caster:GetTeamNumber()
	local number_of_resurrections = 0
	for number, unit in pairs(event.target_entities) do
		if unit:IsAlive() == false and number_of_resurrections < 7 then
			unit:SetOwner(owner)
			unit:SetControllableByPlayer(player_id, true)
			unit:SetTeam(team_id)
			unit:RespawnUnit()
			unit:AddAbility("warchasers_muhrah_animate_dead_helper")
			unit:FindAbilityByName("warchasers_muhrah_animate_dead_helper"):SetLevel(1)
			number_of_resurrections = number_of_resurrections + 1
		end
	end
end

function unit_hurt_container( event )
	local attacker = EntIndexToHScript(event.entindex_attacker)
	local target = EntIndexToHScript(event.entindex_killed)

	--Thorns aura
	if target:HasModifier("warchasers_megatron_thorns_aura_marker") == true then
		if attacker:IsAttackingEntity(target) == true and attacker:IsRangedAttacker() == false then
			ApplyDamage({
						victim = attacker,
						attacker = target,
						damage = attacker:GetAverageTrueAttackDamage() * 0.1 * Entities:FindByClassnameNearest("npc_dota_hero_sven", target:GetOrigin(), 2000):FindAbilityByName("warchasers_megatron_thorns_aura"):GetLevel(),
						damage_type = DAMAGE_TYPE_MAGICAL
						}) 
		end
	end

end

ListenToGameEvent("entity_hurt", unit_hurt_container, nil) 


function warchasers_assassin_entangle_definator( event )
	if event.target:IsHero() == true then
		event.target:RemoveModifierByName("warchasers_assassin_entangle_creep_debuff")
	else
		event.target:RemoveModifierByName("warchasers_assassin_entangle_hero_debuff")
	end
end


function star_fall_ender( event )
	event.caster.star_fall_dummy:ForceKill(true)
	event.caster.star_fall_dummy = nil
end


function star_fall_thinker( event )
	--event.caster:CastAbilityNoTarget(event.caster:FindAbilityByName("mirana_starfall"), event.caster:GetPlayerOwnerID()) 
	event.caster:FindAbilityByName("mirana_starfall"):CastAbility()
end

function star_fall_ini( event )
	local dummy = CreateUnitByName("dummy_unit", event.caster:GetOrigin(), false, event.caster:GetOwner(), event.caster:GetOwner(), event.caster:GetTeam())
	--dummy:SetControllableByPlayer( event.caster:GetPlayerOwnerID(), true)
	dummy:AddAbility("warchasers_starfall_dummy_helper")
	dummy:AddAbility("mirana_starfall")
	dummy:FindAbilityByName("warchasers_starfall_dummy_helper"):SetLevel(1)
	dummy:FindAbilityByName("mirana_starfall"):SetLevel(1)
	event.caster.star_fall_dummy = dummy
end






--FindByClassnameNearest("npc_dota_hero_sven", target:GetOrigin(), 2000):FindAbilityByName("warchasers_megatron_thorns_aura"):GetLevel()