--dota_launch_custom_game warchasers warchasers

--require( 'util' )
require( "camera")
require( "abilities" )


if Convars:GetBool("developer") == true then
	require( "developer" )
end






if Warchasers == nil then
	Warchasers = class({})
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
	PrecacheResource( "model", "models/props_debris/merchant_debris_key001.vmdl", context )
	PrecacheResource( "model", "models/props_debris/merchant_debris_chest001.vmdl", context )
	
	
end

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = Warchasers()
	GameRules.AddonTemplate:InitGameMode()
end

function Warchasers:InitGameMode()
	print( "Starting to load gamemode..." )

	--self:ReadDropConfiguration()
	GameMode = GameRules:GetGameModeEntity()

	GameMode:SetCameraDistanceOverride( 1000 )
	GameMode:SetAnnouncerDisabled(true)
	GameMode:SetBuybackEnabled(false)
	GameMode:SetRecommendedItemsDisabled(true) --broken

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
	local newItem = CreateItem("item_khadgars_gem", nil, nil)
    CreateItemOnPositionSync(position, newItem)

    position = Vector(-2940,3200,124)
	local newItem = CreateItem("item_stormwind_horn", nil, nil)
    CreateItemOnPositionSync(position, newItem)

    position = Vector(-3136,3200,124)
	local newItem = CreateItem("item_evasion", nil, nil)
    CreateItemOnPositionSync(position, newItem)

    -- Remove building invulnerability
    print("Make buildings vulnerable")
    local allBuildings = Entities:FindAllByClassname('npc_dota_building')
    for i = 1, #allBuildings, 1 do
        local building = allBuildings[i]
        if building:HasModifier('modifier_invulnerable') then
            building:RemoveModifierByName('modifier_invulnerable')
        end
    end
    
    --Listeners
    ListenToGameEvent( "entity_killed", Dynamic_Wrap( Warchasers, 'OnEntityKilled' ), self )
    ListenToGameEvent( "npc_spawned", Dynamic_Wrap( Warchasers, 'OnNPCSpawned' ), self )

	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )

 	
	print( "Done loading gamemode" )
end


-- Evaluate the state of the game
function Warchasers:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
	
		--Permanent Night
		GameRules:SetTimeOfDay( 0.8 )

	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 2
end	

function Warchasers:OnNPCSpawned(keys)
	print("NPC Spawned")
	local npc = EntIndexToHScript(keys.entindex)
	
	if npc:IsRealHero() and npc.bFirstSpawned == nil then
		npc.bFirstSpawned = true
		Warchasers:OnHeroInGame(npc)
	end
end

--Add Ankh
function Warchasers:OnHeroInGame(hero)
	print("Hero Spawned")
	local item = CreateItem("item_ankh", hero, hero)
	hero:AddItem(item)
	
end

function Warchasers:OnEntityKilled( event )
	local killedUnit = EntIndexToHScript( event.entindex_killed )
	print("1 mob dead")
    --self:CheckForLootItemDrop( killedUnit )
end  

--RANDOM ITEM DROPS --now done directly through datadriven KV

-- Read and assign configurable keyvalues if applicable
--[[function Warchasers:ReadDropConfiguration()
	local kv = LoadKeyValues( "scripts/maps/" .. GetMapName() .. ".txt" )
	kv = kv or {} -- Handle the case where there is not keyvalues file

	self:ReadLootItemDropsConfiguration( kv["ItemDrops"] )

end

-- If random drops are defined read in that data
function Warchasers:ReadLootItemDropsConfiguration( kvLootDrops )

	self.vLootItemDropsList = {}
	if type( kvLootDrops ) ~= "table" then
		return
	end
	for key,lootItem in pairs( kvLootDrops ) do
		table.insert( self.vLootItemDropsList, {
			szItemName = lootItem.Item or "",
			nChance = tonumber( lootItem.Chance or 0 )
		})
	end

	print("Drop Table:")
	DeepPrintTable( self.vLootItemDropsList, nil, true )
	print("------------")
end


function Warchasers:CheckForLootItemDrop( killedUnit )
	for key,itemDropInfo in pairs( self.vLootItemDropsList ) do
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
end]]
