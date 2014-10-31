--[[
Steamtank Miniboss AI
]]
-- "vscripts"			"ai_tank_miniboss.lua"

function Spawn( entityKeyValues )
	ABILILTY_bomb_spell = thisEntity:FindAbilityByName("miniboss_aoe_bomb")
	ABILITY_calldown_spell = thisEntity:FindAbilityByName("miniboss_call_down")
	ABILITY_flak_spell = thisEntity:FindAbilityByName("miniboss_flak")
	ABILILTY_barrage_spell = thisEntity:FindAbilityByName("miniboss_barrage")
	ABILITY_spawn_spell = thisEntity:FindAbilityByName("miniboss_launch_skeletons")

	thisEntity:SetContextThink( "SteamtankThink", SteamtankThink , 1)
	print("Starting AI for "..thisEntity:GetUnitName().." "..thisEntity:GetEntityIndex())

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
		print(k,v)
	end

	return waypoints
end

POSITIONS = CollectWaypoints()

currentWaypoint = 1
givenOrder = false
reachedWaypoint = true

function SteamtankThink()
	if not thisEntity:IsAlive() then
		return nil
	end

	-- Move to the next waypoint after taking enough damage
	local healthRemaining = thisEntity:GetHealth() / thisEntity:GetMaxHealth()

	if not givenOrder then
		if ( (healthRemaining <= 0.80) and (currentWaypoint == 1) ) then
			currentWaypoint = 2 --where to go next
			givenOrder = true
		elseif ( (healthRemaining <= 0.60) and (currentWaypoint == 2) ) then
			currentWaypoint = 3
			givenOrder = true
		elseif ( (healthRemaining <= 0.50) and (currentWaypoint == 3) ) then
			currentWaypoint = 4
			givenOrder = true
		elseif ( (healthRemaining <= 0.40) and (currentWaypoint == 4) ) then
			currentWaypoint = 5
			givenOrder = true
		elseif ( (healthRemaining <= 0.20) and (currentWaypoint == 5) ) then
			currentWaypoint = 6
			givenOrder = true
		end

		if givenOrder == true then
			print("Given Order. Tank wants to move to a new waypoint: "..currentWaypoint)
			thisEntity:MoveToPosition(POSITIONS[currentWaypoint])
			reachedWaypoint = false
		end
	end

	local distanceToWaypoint = (thisEntity:GetOrigin() - POSITIONS[currentWaypoint]):Length2D()
	if distanceToWaypoint > 100 and not reachedWaypoint then
		print( "Current distance to waypoint ".. distanceToWaypoint)
		thisEntity:MoveToPosition(POSITIONS[currentWaypoint])
	elseif distanceToWaypoint <=100 and not reachedWaypoint then
		print("Reached waypoint")
		reachedWaypoint = true --stop moving to the current waypoint
		givenOrder = false --accept a new order
	end


	--Cast Bomb whenever we're able to do so.
	if ABILILTY_bomb_spell:IsFullyCastable() then
		print("Tank can cast Meteor Bomb")
					--FindUnitsInRadius( iTeamNumber, vPosition, hCacheUnit, flRadius, iTeamFilter, iTypeFilter, iFlagFilter, iOrder, bCanGrowCache )
		local units = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, 1500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO, FIND_FARTHEST, false )

		if units ~= nil then
			if #units >= 1 then
				print("Tank wants to cast Meteor Bomb, ".. #units .." enemy near.")
				local target = units[1]
				local dummy = CreateUnitByName("dummy_unit_spellcast", target:GetAbsOrigin(), false, thisEntity, thisEntity, DOTA_TEAM_GOODGUYS)
				thisEntity:CastAbilityOnTarget(dummy, ABILILTY_bomb_spell, -1) 
			else 
				print("No units found to cast the spell on")
			end
		end
	end

	--Cast Spawn whenever we're able to do so.
	if ABILITY_spawn_spell:IsFullyCastable() then
		print("Tank can cast Launch Skeletons")
					--FindUnitsInRadius( iTeamNumber, vPosition, hCacheUnit, flRadius, iTeamFilter, iTypeFilter, iFlagFilter, iOrder, bCanGrowCache )
		local units = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO, FIND_FARTHEST, false )

		if units ~= nil then
			if #units >= 1 then
				print("Tank wants to cast Launch Skeletons, ".. #units .." enemy near.")
				local target = units[1]
				local dummy = CreateUnitByName("dummy_unit_spellcast", target:GetAbsOrigin(), false, thisEntity, thisEntity, DOTA_TEAM_GOODGUYS)
				thisEntity:CastAbilityOnTarget(dummy, ABILITY_spawn_spell, -1) 
			else 
				print("No units found to cast the spell on")
			end
		end
	end

	if ABILILTY_barrage_spell:IsFullyCastable() then
		print("Tank wants to cast Barrage")
		thisEntity:CastAbilityNoTarget(ABILILTY_barrage_spell, -1)
	end

	-- Cast calldown whenever we're able to do so.
	if ABILITY_calldown_spell:IsFullyCastable() and healthRemaining <= 0.25 then
		print("Tank can cast Call Down")
					--FindUnitsInRadius( iTeamNumber, vPosition, hCacheUnit, flRadius, iTeamFilter, iTypeFilter, iFlagFilter, iOrder, bCanGrowCache )
		local units = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO, FIND_FARTHEST, false )

		if units ~= nil then
			if #units >= 1 then
				print("Tank wants to cast cast Call Down, ".. #units .." enemy near.")
				local target = units[1]
				thisEntity:CastAbilityOnPosition(target:GetAbsOrigin(), ABILITY_calldown_spell, -1)
			else 
				print("No units found to cast the spell on")
			end
		end
		--Refresh the cooldown of the other spells
		--if healthRemaining <= 0.05 then -- last stand
		--	ABILITY_calldown_spell:EndCooldown()
		--end

		ABILILTY_bomb_spell:EndCooldown()
		ABILITY_spawn_spell:EndCooldown()
		ABILILTY_barrage_spell:EndCooldown()		
	end

	print("-------")
	return 1

end