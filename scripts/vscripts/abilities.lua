print("Abilities are loading")

function warchasers_tranquility_heal( event )
	local heal_percent = (event.ability:GetLevelSpecialValueFor("heal_percent", (event.ability:GetLevel() - 1)) * 0.01 )
	for key, unit in pairs(event.target_entities)do
		unit:Heal( unit:GetMaxHealth() * heal_percent, event.caster) 
	end
end


function warchasers_tb_miniboss_animate_dead_killer( event )
	event.target:Kill(event.abilty, event.target)
end

function warchasers_tb_miniboss_animate_dead( event )
	local owner = event.caster
	local team_id = event.caster:GetTeamNumber()
	for number, unit in pairs(event.target_entities) do
		if unit:IsAlive() == false then
			unit:SetOwner(owner)
			unit:SetTeam(team_id)
			unit:RespawnUnit()
			event.ability:ApplyDataDrivenModifier( owner, unit, "warchasers_tb_miniboss_animate_dead_helper_timer", nil)
		end
	end
end

function mana_burn( event )
	event.caster:AddAbility("necronomicon_archer_mana_burn")
	local ability = event.caster:FindAbilityByName("necronomicon_archer_mana_burn")
	ability:SetLevel(event.ability:GetLevel())
	event.caster:CastAbilityOnTarget( event.target, ability, event.caster:GetPlayerOwnerID())
	event.caster:RemoveAbility("necronomicon_archer_mana_burn")
end

function wizard_purge( event )
	event.caster:AddAbility("satyr_trickster_purge")
	local ability = event.caster:FindAbilityByName("satyr_trickster_purge")
	ability:SetLevel(1)
	event.caster:CastAbilityOnTarget( event.target, ability, event.caster:GetPlayerOwnerID())
	event.caster:RemoveAbility("satyr_trickster_purge")
end

function firestorm_cast( event )
	local point = event.target_points[1]
	local dummy = CreateUnitByName("dummy_unit", point, false, event.caster, event.caster, event.caster:GetTeam())
	dummy:AddAbility("abyssal_underlord_firestorm")
	local ability = dummy:FindAbilityByName("abyssal_underlord_firestorm")
	ability:SetLevel(1)
	print(ability:GetLevel().. " = " .. event.ability:GetLevel())
	dummy:CastAbilityOnPosition(point, ability, event.caster:GetPlayerOwnerID())
	
	Timers:CreateTimer({
			    			endTime = 7, 
			    			callback = function()
								dummy:ForceKill(true)
								print("Firestorm end")
							end
						})
end

function calldown_cast( event )
	local point = event.target_points[1]
	local dummy = CreateUnitByName("dummy_unit", point, false, event.caster, event.caster, event.caster:GetTeam())
	dummy:AddAbility("gyrocopter_call_down")
	local ability = dummy:FindAbilityByName("gyrocopter_call_down")
	ability:SetLevel(1)
	print(ability:GetLevel().. " = " .. event.ability:GetLevel())
	dummy:CastAbilityOnPosition(point, ability, event.caster:GetPlayerOwnerID())
	
	Timers:CreateTimer({
			    			endTime = 5, 
			    			callback = function()
								dummy:ForceKill(true)
								print("Call Down end")
							end
						})
end


function holy_light_cast( event )
	if event.target ~= event.caster then --not self target
		if event.target:GetTeamNumber() ~= event.caster:GetTeamNumber() then
			event.target:EmitSound("Hero_Omniknight.Purification")
			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_purification.vpcf", PATTACH_ABSORIGIN_FOLLOW, event.target)
			ApplyDamage({
						victim = event.target,
						attacker = event.caster,
						damage = event.ability:GetLevelSpecialValueFor("target_damage", (event.ability:GetLevel()-1)),
						damage_type = DAMAGE_TYPE_MAGICAL
						})
		else
			event.target:EmitSound("Hero_Omniknight.Purification")
			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_purification.vpcf", PATTACH_ABSORIGIN_FOLLOW, event.target)
			event.target:Heal( event.ability:GetLevelSpecialValueFor("heal_amount", (event.ability:GetLevel()-1)), event.caster)
		end
	else --disable self target, refund spell. callback event.ability:OnChannelFinish(true) not needed
		event.caster:GetPlayerOwner():GetAssignedHero():GiveMana(event.ability:GetManaCost(1))
		event.ability:EndCooldown()
		EmitSoundOnClient("General.CastFail_InvalidTarget_Hero", event.caster:GetPlayerOwner())
		FireGameEvent( 'custom_error_show', { player_ID = pID, _error = "Ability Can't Target Self" } )
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
	local manacost_per_second = event.ability:GetLevelSpecialValueFor("mana_cost_per_second", (event.ability:GetLevel() - 1))
	if event.caster:GetMana() >= manacost_per_second then
		event.caster:SpendMana( manacost_per_second, event.ability)
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
	if event.target:IsHero() == true or event.target:IsAncient() == true then
		event.ability:ApplyDataDrivenModifier(event.caster, event.target, "warchasers_assassin_entangle_hero_debuff", nil)
	else
		event.ability:ApplyDataDrivenModifier(event.caster, event.target, "warchasers_assassin_entangle_creep_debuff", nil)
	end
end

function warchasers_muhrah_sleep_definator( event )
	if event.target:IsHero() == true or event.target:IsAncient() == true then
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
	local dummy = CreateUnitByName("dummy_unit", event.caster:GetAbsOrigin(), false, event.caster, event.caster, event.caster:GetTeam())
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

function MeteorCannon( keys )
	point = keys.target_points[1]
	caster = keys.caster
	ability = keys.ability
    
  local info = {
    EffectName = "particles/units/heroes/hero_invoker/invoker_chaos_meteor.vpcf",
    Ability = ability,
    vSpawnOrigin = caster:GetAbsOrigin(),
    fDistance = 5000,
    fStartRadius = 125,
    fEndRadius = 125,
    Source = caster,
    bHasFrontalCone = false,
    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_OTHER,
    --fMaxSpeed = 5200,
    fExpireTime = GameRules:GetGameTime() + 8.0,
  }

  local speed = 300

  point.z = 0
  local pos = caster:GetAbsOrigin()
  pos.z = 0
  local diff = point - pos
  info.vVelocity = diff:Normalized() * speed

  ProjectileManager:CreateLinearProjectile( info )
end

function RemoveMeteorModifiers( event )
	
end

function void_damage( event )
	local target = event.target
	local void_damage = 400
	target:ModifyHealth(target:GetHealth()-void_damage, event.caster, false, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)

	local popup = require('popups')
	PopupHPRemovalDamage(target, 400)
end


function HealingWave( event )
	local hero = event.caster
	local target = event.target
	local bounces = event.ability:GetLevelSpecialValueFor("max_bounces", (event.ability:GetLevel()-1))
	local healing = event.ability:GetSpecialValueFor("healing")
	local decay = event.ability:GetSpecialValueFor("wave_decay_percent")  * 0.01
	local radius = event.ability:GetSpecialValueFor("bounce_range")

	-- main target first
	local particle = ParticleManager:CreateParticle("particles/warchasers/dazzle_shadow_wave.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
	ParticleManager:SetParticleControl(particle, 0, hero:GetAbsOrigin()) --origin
	ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin()) --destination

	local particle = ParticleManager:CreateParticle("particles/warchasers/dazzle_shadow_wave_copy.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
	ParticleManager:SetParticleControl(particle, 0, hero:GetAbsOrigin()) --origin
	ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin()) --destination

	EmitSoundOn("Hero_Dazzle.Shadow_Wave",target)
	if target:GetHealth() ~= target:GetMaxHealth()  then 
		target:Heal(healing, target) 
		PopupHealing(target,math.floor(healing))
	end

	local targetsHealed = {}
	target.healedByWave = true
	table.insert(targetsHealed,target)

	local dummy = nil
	local units = nil
	local jump_interval = 0.3

	bounces = bounces -1

	-- do bounces from target to new targets
	Timers:CreateTimer(DoUniqueString("HealingWave"), {
		endTime = jump_interval,
		callback = function()
	
			-- unit selection and counting
			local allies = FindUnitsInRadius(target:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 
												DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false)

			-- particle
			targetVec = target:GetAbsOrigin()
			targetVec.z = target:GetAbsOrigin().z + target:GetBoundingMaxs().z
			if dummy ~= nil then
				dummy:RemoveSelf()
			end
			dummy = CreateUnitByName("dummy_unit", targetVec, false, hero, hero, hero:GetTeam())

			-- select a target randomly from the table and heal. while loop makes sure the target doesn't select itself.			
			local possibleTargetsBounce = {}
			-- Add the 
			for _,v in pairs(allies) do
				-- if not healed and not on full health
				if not v.healedByWave and v:GetHealth() ~= v:GetMaxHealth() then
					table.insert(possibleTargetsBounce,v)
				end
			end

			target = possibleTargetsBounce[math.random(1,#possibleTargetsBounce)]
			if target then
				target.healedByWave = true
				table.insert(targetsHealed,target)		
			else
				-- clear the struck table and end
				for _,v in pairs(targetsHealed) do
			    	v.healedByWave = false
			    	v = nil
			    end
				return
			end

			local particle = ParticleManager:CreateParticle("particles/warchasers/dazzle_shadow_wave.vpcf", PATTACH_ABSORIGIN_FOLLOW, dummy)
			ParticleManager:SetParticleControl(particle,0,dummy:GetAbsOrigin()) --Vector(dummy:GetAbsOrigin().x,dummy:GetAbsOrigin().y,dummy:GetAbsOrigin().z + dummy:GetBoundingMaxs().z ))	-- origin
			local particle2 = ParticleManager:CreateParticle("particles/warchasers/dazzle_shadow_wave_copy.vpcf", PATTACH_ABSORIGIN_FOLLOW, dummy)
			ParticleManager:SetParticleControl(particle2,0,dummy:GetAbsOrigin()) --Vector(dummy:GetAbsOrigin().x,dummy:GetAbsOrigin().y,dummy:GetAbsOrigin().z + dummy:GetBoundingMaxs().z ))	-- origin

			-- heal and decay
			healing = healing - (healing*decay)
			target:Heal(healing, target) 
			PopupHealing(target,math.floor(healing))

			-- make the particle shoot to the target
			ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin()) --destination
			ParticleManager:SetParticleControl(particle2, 1, target:GetAbsOrigin()) --destination

			-- sound

			-- decrement remaining spell bounces
			bounces = bounces - 1

			-- fire the timer again if spell bounces remain
			if bounces > 0 then
				return jump_interval
			end
		end
	})
	
	Timers:CreateTimer(5,function() 
		-- double check
		for _,v in pairs(targetsHealed) do
		   	v.healedByWave = false
		   	v = nil
		end
	end)
end


function ForkedLightning( event )
	local hero = event.caster
	local target = event.target
	local max_units = event.ability:GetLevelSpecialValueFor("max_units", (event.ability:GetLevel() - 1))

	-- get units near the target to select some in the cone (just 300 radius from the main target because I'm lazy to do many finds)
	local units = FindUnitsInRadius(hero:GetTeamNumber(), target:GetAbsOrigin(), target, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, 
						DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, true)

	-- hit the main target
	local lightningBolt = ParticleManager:CreateParticle("particles/items_fx/chain_lightning.vpcf", PATTACH_WORLDORIGIN, hero)
	ParticleManager:SetParticleControl(lightningBolt,0,Vector(hero:GetAbsOrigin().x,hero:GetAbsOrigin().y,hero:GetAbsOrigin().z + hero:GetBoundingMaxs().z ))	
	ParticleManager:SetParticleControl(lightningBolt,1,Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))
	ApplyDamage({ victim = target,	attacker = hero, damage = event.ability:GetAbilityDamage(),	damage_type = event.ability:GetAbilityDamageType() })
	EmitSoundOn("Hero_Zuus.ArcLightning.Target", target)

	local units_hit = 1
	for _,v in pairs(units) do
		if units_hit < max_units and v ~= target then
			local lightningBolt2 = ParticleManager:CreateParticle("particles/items_fx/chain_lightning.vpcf", PATTACH_WORLDORIGIN, hero)
			ParticleManager:SetParticleControl(lightningBolt2,0,Vector(hero:GetAbsOrigin().x,hero:GetAbsOrigin().y,hero:GetAbsOrigin().z + hero:GetBoundingMaxs().z ))	
			ParticleManager:SetParticleControl(lightningBolt2,1,Vector(v:GetAbsOrigin().x,v:GetAbsOrigin().y,v:GetAbsOrigin().z + v:GetBoundingMaxs().z ))	
			ApplyDamage({ victim = v,	attacker = hero, damage = event.ability:GetAbilityDamage(),	damage_type = event.ability:GetAbilityDamageType() })
			units_hit = units_hit + 1
		end
	end
end


-- Not used, spawned with datadriven SpawnUnit
function SpawnDarkMinion( event )
	local hero = event.caster
	local minion = CreateUnitByName("npc_skeleton_archer", event.unit:GetAbsOrigin(), false, hero, hero, hero:GetTeam())
	minion:SetTeam( DOTA_TEAM_GOODGUYS )
    minion:SetOwner(hero)
    minion:SetControllableByPlayer( hero:GetPlayerOwnerID(), true )
end


function Spin(keys)
    local target = keys.target
    local total_degrees = keys.Angle
    target:SetForwardVector(RotatePosition(Vector(0,0,0), QAngle(0,total_degrees,0), target:GetForwardVector()))
end

function TornadoParticle(event)
	local target = event.target
	target.tornado = ParticleManager:CreateParticle("particles/neutral_fx/tornado_ambient.vpcf", PATTACH_WORLDORIGIN, event.caster)
	ParticleManager:SetParticleControl(target.tornado, 0, Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z - 50 ))
end

function EndTornadoParticle(event)
	local target = event.target
	ParticleManager:DestroyParticle(target.tornado,false)
end

function GiveCrit(event)

	print("giff crit")
	if event.target == event.caster then
		event.ability:ApplyDataDrivenModifier( event.caster, event.target, "modifier_warden_crit", nil)
	end

end

function KillVengeanceSpirits(event)
	local avatar = event.caster

	local units = FindUnitsInRadius(avatar:GetTeamNumber(), avatar:GetAbsOrigin(), avatar, 3000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
						DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, true)

	for _,v in pairs(units) do
		if v:GetUnitName() == "npc_spirit_of_vengeance" then
			v:ForceKill(false)
		end
	end
end

--- NEW CREEP MODIFIERS WOHOOO ---

function AvengeDeath(event)
	local unit = event.caster

	print("AVENGE ME BROTHERS")

	-- find nearby allies
	local units = FindUnitsInRadius(unit:GetTeamNumber(), unit:GetAbsOrigin(), unit, 3000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
						DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, true)

	-- make them grow, hit harder and faster
	for _,v in pairs(units) do
		if v:GetUnitName() == unit:GetUnitName() then
			if not v:HasModifier("modifier_avenge_me") then
				event.ability:ApplyDataDrivenModifier(v, v, "modifier_avenge_me", nil)
				v:SetModifierStackCount("modifier_avenge_me", event.ability, 1)
				print(v:GetModifierStackCount("modifier_avenge_me", v))
			else
				v:SetModifierStackCount("modifier_avenge_me", event.ability, (v:GetModifierStackCount("modifier_avenge_me", v) + 1))
			end
			-- Lookup in the parsed units KV later to get the size...
			local unitName = v:GetUnitName()
			local baseModelScale = GameRules.UnitsCustomKV[unitName].ModelScale
			print("Base Model Scale :"..baseModelScale)
			v:SetModelScale(baseModelScale + v:GetModifierStackCount("modifier_avenge_me", v)*0.1)
		end
	end

end

function DesecrationParticles(event)
	local duration = event.ability:GetSpecialValueFor("duration")

	local target = event.target:GetAbsOrigin()
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_jakiro/jakiro_macropyre.vpcf", PATTACH_ABSORIGIN_FOLLOW, event.target)
	ParticleManager:SetParticleControl(particle, 0, target) -- origin
	ParticleManager:SetParticleControl(particle, 1, target) -- origin
    ParticleManager:SetParticleControl(particle, 2, Vector(12,0,0)) -- duration
end

function ExtraHealth(event)
	local health_multiplier = event.ability:GetLevelSpecialValueFor("health_bonus_percentage", (event.ability:GetLevel() - 1))
	local unit = event.caster

	local unitHP = unit:GetMaxHealth()
	local newHP = unitHP * (1+health_multiplier*0.01)
	unit:SetMaxHealth(newHP)
	unit:SetHealth(newHP)
	
	Timers:CreateTimer(0.5,function()
		-- scale up a bit
		local unitName = unit:GetUnitName()
		print(unitName)
		local baseModelScale = GameRules.UnitsCustomKV[unitName].ModelScale
		unit:SetModelScale(baseModelScale + 0.1)
	end)
end

function ElectrifiedSparks(event)
	local min = event.ability:GetLevelSpecialValueFor("min_bolts_per_attack", (event.ability:GetLevel() - 1))
	local max = event.ability:GetLevelSpecialValueFor("max_bolts_per_attack", (event.ability:GetLevel() - 1))
	local spark_count = RandomInt( min , max )
	local caster = event.caster
	local ability = event.ability

	for i=1,spark_count do
		point = (caster:GetAbsOrigin()+Vector(RandomInt(-1000,1000),RandomInt(-1000,1000),RandomInt(-1000,1000)))
			    
	  local info = {
	  	-- FIX PARTICLE GOING TO THE ROOF
	    EffectName = "particles/warchasers/test_particles/puck_electrified.vpcf",
	    Ability = ability,
	    vSpawnOrigin = caster:GetAbsOrigin(),
	    fDistance = 1000,
	    fStartRadius = 125,
	    fEndRadius = 125,
	    Source = caster,
	    bHasFrontalCone = false,
	    bReplaceExisting = false,
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_OTHER,
	    --fMaxSpeed = 5200,
	    fExpireTime = GameRules:GetGameTime() + 5,
	  }

	  local speed = 300

	  point.z = 0
	  local pos = caster:GetAbsOrigin()
	  pos.z = 0
	  local diff = point - pos
	  info.vVelocity = diff:Normalized() * speed

	  ProjectileManager:CreateLinearProjectile( info )
	end

end

function FrozenExplosion( event )
	
end

function Disorient( event )
	local vector = event.target:GetAbsOrigin() + RandomVector(600)
	event.target:MoveToPosition(vector)
end