require( 'util' )

if CAddonTemplateGameMode == nil then
	CAddonTemplateGameMode = class({})
end

function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
	
	PrecacheUnitByNameSync("npc_dota_hero_magnataur", context)
	PrecacheUnitByNameSync("npc_dota_hero_sven", context)
	PrecacheUnitByNameSync("npc_dota_hero_brewmaster", context)
	PrecacheUnitByNameSync("npc_dota_hero_alchemist", context)
	PrecacheUnitByNameSync("npc_dota_hero_abaddon", context)
	PrecacheUnitByNameSync("npc_dota_hero_ember_spirit", context)
	PrecacheUnitByNameSync("npc_dota_hero_juggernaut", context)
	PrecacheUnitByNameSync("npc_dota_hero_omniknight", context)
	PrecacheUnitByNameSync("npc_dota_hero_clinkz", context)
	PrecacheUnitByNameSync("npc_dota_hero_drow_ranger", context)
	PrecacheUnitByNameSync("npc_dota_hero_abyssal_underlord", context)
	PrecacheUnitByNameSync("npc_dota_hero_lycan", context)
	PrecacheUnitByNameSync("npc_dota_hero_invoker", context)
	PrecacheUnitByNameSync("npc_dota_hero_warlock", context)
	PrecacheUnitByNameSync("npc_dota_hero_lich", context)
	PrecacheUnitByNameSync("npc_dota_hero_bane", context)
	PrecacheUnitByNameSync("npc_dota_hero_skeleton_king", context)
	PrecacheUnitByNameSync("npc_dota_hero_lone_druid", context)
	PrecacheUnitByNameSync("npc_dota_hero_mirana", context)
	PrecacheUnitByNameSync("npc_dota_hero_witch_doctor", context)
	PrecacheUnitByNameSync("npc_dota_hero_centaur", context)
	PrecacheUnitByNameSync("npc_dota_hero_enigma", context)
	PrecacheResource(particle_folder,"particles/items_fx", context)

	
end

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = CAddonTemplateGameMode()
	GameRules.AddonTemplate:InitGameMode()
end

function CAddonTemplateGameMode:InitGameMode()
	print( "Starting to load gamemode..." )

	self:_ReadGameConfiguration()
	GameMode = GameRules:GetGameModeEntity()

	GameMode:SetCameraDistanceOverride( 1000 )
	GameMode:SetAnnouncerDisabled(true)
	GameMode:SetBuybackEnabled(false)
	GameMode:SetRecommendedItemsDisabled(true) --broken?

	GameRules:SetPreGameTime(0)
	GameRules:SetHeroSelectionTime(0)
	GameRules:SetGoldPerTick(0)
	--GameRules:SetHeroRespawnEnabled(false)


	print( "GameRules set" )

	print("Dropping items on the world")
	--[["item_allerias_flute"
       "item_khadgars_gem"
       "item_stormwind_horn"
       "item_evasion"]]
    position = Vector(-2940,2996,124)
	local newItem = CreateItem("item_cloak_of_flames", nil, nil)
    CreateItemOnPositionSync(position, newItem)

    position = Vector(-3136,2996,124)
	local newItem = CreateItem("item_cloak_of_flames", nil, nil)
    CreateItemOnPositionSync(position, newItem)

    position = Vector(-2940,3200,124)
	local newItem = CreateItem("item_cloak_of_flames", nil, nil)
    CreateItemOnPositionSync(position, newItem)

    position = Vector(-3136,3200,124)
	local newItem = CreateItem("item_cloak_of_flames", nil, nil)
    CreateItemOnPositionSync(position, newItem)
    
    --Hook
    ListenToGameEvent( "entity_killed", Dynamic_Wrap( CAddonTemplateGameMode, 'OnEntityKilled' ), self )

	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )
	GameRules:GetGameModeEntity():SetThink( "CameraLock", self, "CameraThink", 1 )
 	
	print( "Done loading gamemode" )
end


-- Evaluate the state of the game
function CAddonTemplateGameMode:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then

		--print( "Template addon script is running." )	
		--Permanent Night
		GameRules:SetTimeOfDay( 0.8 )
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end	

--Camera Lock

function CAddonTemplateGameMode:CameraLock()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then

		SendToConsole("dota_camera_center")
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 0.1
end	


--RANDOM ITEM DROPS

-- Read and assign configurable keyvalues if applicable
function CAddonTemplateGameMode:_ReadGameConfiguration()
	local kv = LoadKeyValues( "scripts/maps/" .. GetMapName() .. ".txt" )
	kv = kv or {} -- Handle the case where there is not keyvalues file

	self:_ReadLootItemDropsConfiguration( kv["ItemDrops"] )

end

-- If random drops are defined read in that data
function CAddonTemplateGameMode:_ReadLootItemDropsConfiguration( kvLootDrops )

	self._vLootItemDropsList = {}
	if type( kvLootDrops ) ~= "table" then
		return
	end
	for _,lootItem in pairs( kvLootDrops ) do
		table.insert( self._vLootItemDropsList, {
			szItemName = lootItem.Item or "",
			nChance = tonumber( lootItem.Chance or 0 )
		})
	end

	print("Drop Table:")
	DeepPrintTable( self._vLootItemDropsList, nil, true )
	print("------------")
end

function CAddonTemplateGameMode:OnEntityKilled( event )
	local killedUnit = EntIndexToHScript( event.entindex_killed )
	print("1 mob dead")
    self:CheckForLootItemDrop( killedUnit )
end  

function CAddonTemplateGameMode:CheckForLootItemDrop( killedUnit )
	for _,itemDropInfo in pairs( self._vLootItemDropsList ) do
		print("Calculating Drops")
		print(RollPercentage( itemDropInfo.nChance ) )

		if RollPercentage( itemDropInfo.nChance ) then
			print("Item Dropped")
			print(itemDropInfo.szItemName)
			local newItem = CreateItem( itemDropInfo.szItemName, nil, nil )
			newItem:SetPurchaseTime( 0 )
			if newItem:IsPermanent() and newItem:GetShareability() == ITEM_FULLY_SHAREABLE then
				item:SetStacksWithOtherOwners( true )
			end
			local drop = CreateItemOnPositionSync( killedUnit:GetAbsOrigin(), newItem )
		end
	end
end