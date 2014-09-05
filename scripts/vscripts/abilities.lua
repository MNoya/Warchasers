print("Abilities are loading")

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






