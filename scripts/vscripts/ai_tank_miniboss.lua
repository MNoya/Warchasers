--[[
Steamtank Miniboss AI
]]
-- "vscripts"			"ai_tank_miniboss.lua"

function Spawn( entityKeyValues )
	ABILILTY_bomb_spell = thisEntity:FindAbilityByName("miniboss_aoe_bomb")
	ABILITY_calldown_spell = thisEntity:FindAbilityByName("gyrocopter_call_down")
	ABILITY_flak_spell = thisEntity:FindAbilityByName("miniboss_flak")
	ABILITY_spawn_spell = thisEntity:FindAbilityByName("miniboss_launch_skeletons")

	thisEntity:SetContextThink( "SteamtankThink", SteamtankThink, 0.25 )
	print("Starting AI for "..thisEntity:GetUnitName().." "..thisEntity:GetEntityIndex()))

	thisEntity.currentWaypoint = 1

end

function CollectWaypoints()

	local waypoint1 = Vector(4488,1188,128) --just in front of the start position
	local waypoint2 = Vector(5424,-560,224) --first ramp
	local waypoint3 = Vector(6170,1145,128) --first arc
	local waypoint4 = Vector(7716,1285,128) --second arc
	local waypoint5 = Vector(7288,-504,224) --second ramp
	local waypoint6 = Vector(4766,-2439,128) --final door door

	local waypoints = { waypoint1, waypoint2, waypoint3, waypoint4, waypoint5, waypoint6 }
	
	for k,v in pairs(waypoints) do
		print("Checking waypoint number " .. k .. " value " .. v)
	end

	return waypoints
end

POSITIONS = CollectWaypoints()

function SteamtankThink()
	if not thisEntity:IsAlive() then
		return nil
	end

	-- Move to the next waypoint after taking enough damage
	local healthRemaining = thisEntity:GetHealth() / thisEntity:GetMaxHealth()
	if healthRemaining <= 0.8 and thisEntity.currentWaypoint == 1 then 
		MoveToNextWaypoint(1) 
		return 1
	elseif healthRemaining <= 0.6 and thisEntity.currentWaypoint == 2 then
		thisEntity:MoveToPosition(POSITIONS[3])
		thisEntity:currentWaypoint = 3
		print("Tank is moving to the waypoint number " .. thisEntity:currentWaypoint)
		return 1
	elseif healthRemaining <= 0.5 and thisEntity.currentWaypoint == 3 then
		thisEntity:MoveToPosition(POSITIONS[4])
		thisEntity:currentWaypoint = 4
		print("Tank is moving to the waypoint number " .. thisEntity:currentWaypoint)
		return 1
	elseif healthRemaining <= 0.4 and thisEntity.currentWaypoint == 4 then
		thisEntity:MoveToPosition(POSITIONS[5])
		thisEntity:currentWaypoint = 5
		print("Tank is moving to the waypoint number " .. thisEntity:currentWaypoint)
		return 1
	elseif healthRemaining <= 0.2 and thisEntity.currentWaypoint == 5 then
		thisEntity:MoveToPosition(POSITIONS[6])
		thisEntity:currentWaypoint = 6 --final
		print("Tank is moving to the waypoint number " .. thisEntity:currentWaypoint)
		--apply Modifier Enrage
		-- later if the boss is Enraged, everytime it casts a spell the CD will be refreshed, to allow spell spamming
		return 1
	end

	-- Cast Bomb whenever we're able to do so.
	-- Make abilities INSTANT and not stop movement, so the unit continues moving while casting
	if ABILILTY_bomb_spell:IsFullyCastable() then
		local units = FindUnitsInRadius(thisEntity:GetTeamNumber(), thisEntity:GetAbsOrigin(), 
										thisEntity, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 
										DOTA_UNIT_TARGET_FLAG_NONE, FIND_FARTHEST, false)

		if units ~= nil then
			local target = units[1]
			local dummy = CreateUnitByName("dummy_unit", target:GetAbsOrigin(), false, thisEntity, thisEntity, DOTA_TEAM_NEUTRALS)
			thisEntity:CastAbilityOnTarget(dummy, ABILILTY_bomb_spell, -1) 
		-- ADD "AbilityUnitTargetFlags"		"DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES | DOTA_UNIT_TARGET_FLAG_INVULNERABLE" to the spell
		end
		return 1.0
	end

	-- Cast Spawn whenever we're able to do so.
	if ABILITY_spawn_spell:IsFullyCastable() then
		local units = FindUnitsInRadius(thisEntity:GetTeamNumber(), thisEntity:GetAbsOrigin(), 
										thisEntity, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 
										DOTA_UNIT_TARGET_FLAG_NONE, FIND_FARTHEST, false)

		if units ~= nil then
			local target = units[1]
			local dummy = CreateUnitByName("dummy_unit", target:GetAbsOrigin(), false, thisEntity, thisEntity, DOTA_TEAM_NEUTRALS)
			thisEntity:CastAbilityOnTarget(dummy, ABILILTY_bomb_spell, -1) 
		-- ADD "AbilityUnitTargetFlags"		"DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES | DOTA_UNIT_TARGET_FLAG_INVULNERABLE" to the spell
		end

	-- Cast Flak whenever we're able to do so.
	if ABILITY_flak_spell:IsFullyCastable() then
		thisEntity:CastAbilityImmediately( ABILITY_flak_spell, -1 )
		return 1.0
		local units = FindUnitsInRadius(thisEntity:GetTeamNumber(), thisEntity:GetAbsOrigin(), 
										thisEntity, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 
										DOTA_UNIT_TARGET_FLAG_NONE, FIND_FARTHEST, false)

		if units ~= nil then
			local target = units[1]
			local dummy = CreateUnitByName("dummy_unit", target:GetAbsOrigin(), false, thisEntity, thisEntity, DOTA_TEAM_NEUTRALS)
			thisEntity:CastAbilityOnTarget(dummy, ABILITY_flak_spell, -1) 
		-- ADD "AbilityUnitTargetFlags"		"DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES | DOTA_UNIT_TARGET_FLAG_INVULNERABLE" to the spell
		end
		return 1.0
	end

	return 0.25 + RandomFloat( 0.25, 0.5 )
end

function MoveToNextWaypoint( number )
	thisEntity:MoveToPosition(POSITIONS[number+1])
	thisEntity:currentWaypoint = number+1
	print("Tank is moving to the waypoint number " .. thisEntity:currentWaypoint)
end