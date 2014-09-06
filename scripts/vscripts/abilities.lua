print("Abilities are loading")


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