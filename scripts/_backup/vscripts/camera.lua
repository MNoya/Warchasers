--Camera Lock
print("camera_ini")

function camera_umlocker( hero )
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
end	

ListenToGameEvent( "npc_spawned", camera_lock_on_hero, nil )
