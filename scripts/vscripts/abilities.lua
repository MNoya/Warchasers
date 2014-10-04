print("Abilities are loading")

function holy_light_check( event )
	if event.target == event.caster then --disable self target, refund spell
		event.caster:GetPlayerOwner():GetAssignedHero():GiveMana(event.ability:GetManaCost(1))
		event.ability:EndCooldown()
		EmitSoundOnClient("General.CastFail_InvalidTarget_Hero", event.caster:GetPlayerOwner())
	else
		event.ability:OnChannelFinish(true)
	end
end

function holy_light_cast( event )
	if event.target:GetTeamNumber() ~= event.caster:GetTeamNumber() then
		ApplyDamage({
					victim = event.target,
					attacker = event.caster,
					damage = event.ability:GetLevelSpecialValueFor("target_damage", (event.ability:GetLevel()-1)),
					damage_type = DAMAGE_TYPE_MAGICAL
					})
	else
		event.target:Heal( event.ability:GetLevelSpecialValueFor("heal_amount", (event.ability:GetLevel()-1)), event.caster)
	end
end

function warchasers_titan_reincarnation_outro( event )
	if event.caster.titan_reincarnate_thinker_eval_count ~= nil then
		if event.caster.titan_reincarnate_thinker_eval_count >= 15 then
			event.caster:RespawnUnit()
			event.caster:AddAbility("drop_level6")
			event.caster:AddAbility("drop_potion_of_healing")
			event.caster:RemoveModifierByName("warchasers_titan_reincarnation_death_mod")
		else
			event.caster.titan_reincarnate_thinker_eval_count = event.caster.titan_reincarnate_thinker_eval_count + 1
		end
	end
end

function warchasers_titan_reincarnation_ini( event )
	event.caster.titan_reincarnate_thinker_eval_count = 0
end


function warchasers_vampiric_aura_damage( event )
	event.caster:RemoveModifierByName("warchasers_vampiric_aura_helper_modifier")
end

function warchasers_vampiric_aura_ini( event )
	if event.target.GetInvulnCount == nil and event.target:IsMechanical() == false then
		local level_aura = event.ability:GetLevel()
		event.attacker:AddAbility("warchasers_vampiric_aura_helper")
		event.attacker:FindAbilityByName("warchasers_vampiric_aura_helper"):SetLevel(level_aura)
		event.attacker:RemoveAbility("warchasers_vampiric_aura_helper")
	end
end

function giveUnitDataDrivenModifier(source, target, modifier,dur)
    --source and target should be hscript-units. The same unit can be in both source and target
    local item = CreateItem( "item_apply_modifiers", source, source)
    item:ApplyDataDrivenModifier( source, target, modifier, {duration=dur} )
end

function giveUnitDataDrivenBuff(source, target, modifier,dur)
    --source and target should be hscript-units. The same unit can be in both source and target
    local item = CreateItem( "item_apply_buff", source, source)
    item:ApplyDataDrivenModifier( source, target, modifier, {duration=dur} )
end


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


function warchasers_steamtank_immolation_function( event )
	if event.caster:GetMana() >= 7 then
		event.caster:SpendMana( 7, event.ability)
		for key, unit in pairs(event.target_entities) do
			ApplyDamage({
						victim = unit,
						attacker = event.caster,
						damage = 10,
						damage_type = DAMAGE_TYPE_MAGICAL
						})
		end
	else
		event.ability:ToggleAbility()
	end
end

function warchasers_muhrah_animate_dead_killer( event )
	event.target:Kill(event.abilty, event.caster)
end


function warchasers_muhrah_animate_dead_ini( event )
	local owner = event.caster
	local player_id = event.caster:GetPlayerID()
	local team_id = event.caster:GetTeamNumber()
	local number_of_resurrections = 0
	local resurrections_limit = event.ability:GetLevelSpecialValueFor( "resurrections_limit", (event.ability:GetLevel() - 1))
	for number, unit in pairs(event.target_entities) do
		if unit:IsAlive() == false and number_of_resurrections < resurrections_limit then
			unit:SetOwner(owner)
			unit:SetTeam(team_id)
			unit:RespawnUnit()
			unit:SetControllableByPlayer(player_id, true)
			event.ability:ApplyDataDrivenModifier( owner, unit, "warchasers_muhrah_animate_dead_helper_timer", nil)
			--[[unit:AddAbility("warchasers_muhrah_animate_dead_helper")
			unit:FindAbilityByName("warchasers_muhrah_animate_dead_helper"):SetLevel(1)]]
			number_of_resurrections = number_of_resurrections + 1
		end
	end
end

function megatron_thorns_aura_damage( event )
	local thorn_damage = event.unit.thorns_aura_ini_hp - event.unit:GetHealth()
	local thorn_attacker = EntIndexToHScript(event.unit.thorns_aura_attacker)
	ApplyDamage({
							victim = thorn_attacker,
							attacker = event.unit,
							damage = thorn_damage * 0.01 * event.ability:GetLevelSpecialValueFor("damage_return_percentage", (event.ability:GetLevel() - 1)),
							damage_type = DAMAGE_TYPE_MAGICAL
							}) 
	event.unit:RemoveModifierByName("thorns_aura_helper")
	event.unit.thorns_aura_ini_hp = nil
end

function megatron_thorns_aura_func( event )
	if  event.attacker:IsRangedAttacker() == false then
		event.target.thorns_aura_attacker = event.attacker:GetEntityIndex()
		event.target.thorns_aura_ini_hp = event.target:GetHealth()
		event.ability:ApplyDataDrivenModifier(event.caster, event.target, "thorns_aura_helper", nil) 
		--[[event.caster:AddAbility("warchasers_megatron_thorns_aura_helper")
		event.caster:FindAbilityByName("warchasers_megatron_thorns_aura_helper"):SetLevel(1)
		event.caster:RemoveAbility("warchasers_megatron_thorns_aura_helper")]]
	end
end




function unit_hurt_container( event )
	if event.entindex_attacker~=nil then --still fails when it's a DoT from a Dead target			
		local attacker = EntIndexToHScript(event.entindex_attacker)
		local target = EntIndexToHScript(event.entindex_killed)

		--[[Thorns aura
		if target:HasModifier("warchasers_megatron_thorns_aura_marker") == true then
			if attacker ~= nil and attacker:IsAttackingEntity(target) == true and attacker:IsRangedAttacker() == false then
				ApplyDamage({
							victim = attacker,
							attacker = target,
							damage = attacker:GetAverageTrueAttackDamage() * 0.1 * Entities:FindByClassnameNearest("npc_dota_hero_sven", target:GetOrigin(), 2000):FindAbilityByName("warchasers_megatron_thorns_aura"):GetLevel(),
							damage_type = DAMAGE_TYPE_MAGICAL
							}) 
			end
		end]]
	end

end

--ListenToGameEvent("entity_hurt", Dynamic_Wrap(Warchasers_abilities, "unit_hurt_container"), nil) 


function warchasers_assassin_entangle_definator( event )
	if event.target:IsHero() == true then
		event.target:RemoveModifierByName("warchasers_assassin_entangle_creep_debuff")
	else
		event.target:RemoveModifierByName("warchasers_assassin_entangle_hero_debuff")
	end
end

function warchasers_muhrah_sleep_definator( event )
	if event.target:IsHero() == true then
		event.target:RemoveModifierByName("warchasers_muhrah_sleep_creep_debuff")
	else
		event.target:RemoveModifierByName("warchasers_muhrah_sleep_hero_debuff")
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
	local dummy = CreateUnitByName("dummy_unit", event.caster:GetOrigin(), false, event.caster, event.caster, event.caster:GetTeam())
	--dummy:SetControllableByPlayer( event.caster:GetPlayerOwnerID(), true)
	dummy:AddAbility("warchasers_starfall_dummy_helper")
	dummy:AddAbility("mirana_starfall")
	dummy:FindAbilityByName("warchasers_starfall_dummy_helper"):SetLevel(1)
	dummy:FindAbilityByName("mirana_starfall"):SetLevel(1)
	event.caster.star_fall_dummy = dummy
end


function warchasers_avatar_scale( event )
	--Scale Up
	for i=1,100 do
		Timers:CreateTimer({
	    			endTime = i/75, 
	    			callback = function()
						event.caster:SetModelScale(1+ (i/500) ) --1.20
						if i==100 then print("Scaled to 1 + " .. i/500 .. " in " .. endTime .. " seconds.") end
					end
				})
	end

	--Scale Down
	for i=1,100 do
		Timers:CreateTimer({
	    			endTime = 59 + (i/50),
	    			callback = function()
						event.caster:SetModelScale(1.20-i/500)
					if i==100 then print("Scaled to 1 + " .. i/500 .. " in " .. endTime .. " seconds.") end
					end
				})
	end
end



--FindByClassnameNearest("npc_dota_hero_sven", target:GetOrigin(), 2000):FindAbilityByName("warchasers_megatron_thorns_aura"):GetLevel()