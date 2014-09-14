--Camera Lock
print("camera_ini")

--[[function camera_umlocker( hero )
	local player_id = hero:GetPlayerOwnerID()
	PlayerResource:SetCameraTarget( player_id, nil)
	return 2
end

function camera_locker( hero )
	local player_id = hero:GetPlayerOwnerID()
	local player = hero:GetPlayerOwner()
	PlayerResource:SetCameraTarget( player_id, PlayerResource:GetPlayer(player_id):GetAssignedHero())
	return 2
end

function camera_lock_on_hero( event )
	local unit_spawned = EntIndexToHScript(event.entindex)
	if unit_spawned:IsRealHero() == true then
		if PlayerResource:IsValidPlayer( unit_spawned:GetPlayerOwnerID() ) == true then
			unit_spawned:SetContextThink( "camera_locker", camera_locker, 0)
			unit_spawned:SetContextThink( "camera_umlocker", camera_umlocker, 2)
		end
	end
end	]]
--<BMD> there is another way, via using the "modifier_camera_follow" modifier
--<Myll> if you use SetAbsOrigin on a player u can lock their camera to that position. so u can doing player:SetAbsOrigin(heroToLock:GetAbsOrigin()) in a think loop


ListenToGameEvent( "npc_spawned", camera_lock_on_hero, nil )

function increase_camera_height(trigger)
	GameRules:GetGameModeEntity():SetCameraDistanceOverride( 1400 )
end

function decrease_camera_height(trigger)
	GameRules:GetGameModeEntity():SetCameraDistanceOverride( 1000 )
end

