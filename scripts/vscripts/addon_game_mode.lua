--dota_launch_custom_game warchasers warchasers

--require( 'util' )
--require( 'camera' ) --drives me crazy, can't pick/drop items
require( 'abilities' )
require( 'timers')
require( 'teleport')


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
	PrecacheResource( "particle_folder","particles/items_fx", context) --check if it changes without ""

	PrecacheResource( "model", "models/props_debris/merchant_debris_key001.vmdl", context )
	PrecacheResource( "model", "models/props_debris/merchant_debris_chest001.vmdl", context )
	PrecacheResource( "model", "models/creeps/neutral_creeps/n_creep_dragonspawn_a/n_creep_dragonspawn_a.vmdl", context )

	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_dragon_knight.vsndevts", context )
  	PrecacheResource( "particle_folder", "particles/units/heroes/hero_dragon_knight", context )
  	PrecacheResource( "particle_folder", "particles/units/heroes/hero_juggernaut", context ) --check bladestorm pink bug
	
	
end

XP_PER_LEVEL_TABLE = {
	     0, -- 1
	  200, -- 2
	  500, -- 3
	  900, -- 4
	 1400, -- 5
	 2000, -- 6
	 2700, -- 7
	 3500, -- 8
	 4400, -- 9
	 5400, -- 10
 }

SENDHELL = false
SHOWPOPUP = true
P0_HAS_ANKH = true
P1_HAS_ANKH = true
P2_HAS_ANKH = true
P3_HAS_ANKH = true
P4_HAS_ANKH = true
DEAD_PLAYER_COUNT = 0
PLAYER_COUNT = 0

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
	GameMode:SetFixedRespawnTime(999)
	GameMode:SetTopBarTeamValuesVisible( true ) --customized top bar values
	GameMode:SetTopBarTeamValuesOverride( true ) --display the top bar score/count

	GameMode:SetCustomHeroMaxLevel( 10 )
	GameMode:SetCustomXPRequiredToReachNextLevel( XP_PER_LEVEL_TABLE )

	--GameRules:SetPreGameTime(0)
	--GameRules:SetHeroSelectionTime(0)
	--GameRules:SetGoldPerTick(0)
	--GameRules:SetHeroRespawnEnabled(false)

	print( "GameRules set" )

	print("Dropping items on the world")
    position = Vector(-2940,2996,124)
	local newItem = CreateItem("item_allerias_flute", nil, nil)
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

    position = Vector(52,2145,128)
	local newItem = CreateItem("item_key3", nil, nil)
    CreateItemOnPositionSync(position, newItem)
	
	--[[global drops 
		heaven
			restoration scroll
			animate scroll
			orb of fire
			evasion

		hell
			5potion of healing
			spiked collar

		secret area
			gloves of haste (add many towers and sheeps)]]

    -- Remove building invulnerability
    print("Make buildings vulnerable")
    local allBuildings = Entities:FindAllByClassname('npc_dota_building')
    for i = 1, #allBuildings, 1 do
        local building = allBuildings[i]
        if building:HasModifier('modifier_invulnerable') then
            building:RemoveModifierByName('modifier_invulnerable')
        end
    end
    
    print("Applying Unit Modifiers")
    local source = Entities:FindByName(nil, "cherub1")
    local target = Entities:FindByName(nil, "cherub1")
    giveUnitDataDrivenModifier(source, target, "modifier_make_deniable",-1) -- "-1" means that it will last forever (or until its removed)
	local source = Entities:FindByName(nil, "cherub2")
    local target = Entities:FindByName(nil, "cherub2")
    giveUnitDataDrivenModifier(source, target, "modifier_make_deniable",-1) -- "-1" means that it will last forever (or until its removed)
    local source = Entities:FindByName(nil, "cherub3")
    local target = Entities:FindByName(nil, "cherub3")
    giveUnitDataDrivenModifier(source, target, "modifier_make_deniable",-1) -- "-1" means that it will last forever (or until its removed)


    --Listeners
    ListenToGameEvent( "entity_killed", Dynamic_Wrap( Warchasers, 'OnEntityKilled' ), self )
    ListenToGameEvent( "npc_spawned", Dynamic_Wrap( Warchasers, 'OnNPCSpawned' ), self )
    --ListenToGameEvent('last_hit', Dynamic_Wrap( Warchasers, 'OnLastHit'), self) --Add Score?
    --ListenToGameEvent('dota_player_killed', Dynamic_Wrap( Warchasers, 'OnPlayerKilled'), self)

	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )

	--Variables for tracking
	self.nRadiantKills = 0
  	self.nDireKills = 0

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
		SendToConsole("dota_camera_lock 1")
		SendToConsole("dota_camera_center")
		if npc:GetTeam() == DOTA_TEAM_GOODGUYS then
			PLAYER_COUNT = PLAYER_COUNT +1
		end
		Warchasers:OnHeroInGame(npc)
	end
end

--Add Ankh
function Warchasers:OnHeroInGame(hero)
	print("Hero Spawned")
	local item = CreateItem("item_ankh", hero, hero)
	hero:AddItem(item)

	if SHOWPOPUP then
		ShowGenericPopup( "#popup_title", "#popup_body", "", "", DOTA_SHOWGENERICPOPUP_TINT_SCREEN )
		SHOWPOPUP = false
	end
end

function Warchasers:OnEntityKilled( event )
	local killedUnit = EntIndexToHScript( event.entindex_killed )
	local killerEntity = EntIndexToHScript( event.entindex_attacker )

	if killedUnit:IsRealHero() then 
		
		local KilledPlayerID = killedUnit:GetPlayerID()
    	local respawning = false

		--credit dire for the kill even if the player reincarnates
		if killedUnit:GetTeam() == DOTA_TEAM_GOODGUYS then
		      self.nDireKills = self.nDireKills + 1
		end    	

		--Problems to fix with the current version: 
			--doesn't work with multiple Ankhs
			--doesn't work with dropping/picking Ankhs (will probably disable this)
    	--check if the killed player has ankh
      	if KilledPlayerID==0 and P0_HAS_ANKH then  
    		P0_HAS_ANKH = false
    		respawning = true
    		GameRules:SendCustomMessage("Player 0 died but used Ankh",0,0)
    	end

    	if KilledPlayerID==1 and P1_HAS_ANKH then  
    		P1_HAS_ANKH = false
    		respawning = true
    		GameRules:SendCustomMessage("Player 1 died but used Ankh",0,0)
    	end
	      
	    if KilledPlayerID==2 and P2_HAS_ANKH then  
    		P2_HAS_ANKH = false
    		respawning = true
    		GameRules:SendCustomMessage("Player 2 died but used Ankh",0,0)
    	end

    	if KilledPlayerID==3 and P3_HAS_ANKH then  
    		P3_HAS_ANKH = false
    		respawning = true
    		GameRules:SendCustomMessage("Player 3 died but used Ankh",0,0)
    	end

    	if KilledPlayerID==4 and P4_HAS_ANKH then  
    		P4_HAS_ANKH = false
    		respawning = true
    		GameRules:SendCustomMessage("Player 4 died but used Ankh",0,0)
    	end     

    	--RIP
    	if not respawning then
	    	if KilledPlayerID==0 and not P0_HAS_ANKH then  
	    		GameRules:SendCustomMessage("RIP Blue",0,0)
	    		DEAD_PLAYER_COUNT = DEAD_PLAYER_COUNT+1
	    	end

	    	if KilledPlayerID==1 and not P1_HAS_ANKH then  
	    		GameRules:SendCustomMessage("RIP Teal",0,0)
	    		DEAD_PLAYER_COUNT = DEAD_PLAYER_COUNT+1
	    	end
		      
		    if KilledPlayerID==2 and not P2_HAS_ANKH then  
	    		GameRules:SendCustomMessage("RIP Purple",0,0)
	    		DEAD_PLAYER_COUNT = DEAD_PLAYER_COUNT+1
	    	end

	    	if KilledPlayerID==3 and not P3_HAS_ANKH then  
	    		GameRules:SendCustomMessage("RIP Yellow",0,0)
	    		DEAD_PLAYER_COUNT = DEAD_PLAYER_COUNT+1
	    	end

	    	if KilledPlayerID==4 and not P4_HAS_ANKH then  
	    		GameRules:SendCustomMessage("RIP Orange",0,0)
	    		DEAD_PLAYER_COUNT = DEAD_PLAYER_COUNT+1
	    	end  
	 		
	 		--Check for defeat
		    if DEAD_PLAYER_COUNT == PLAYER_COUNT then
		    	print("THEY'RE ALL DEAD BibleThump")
				local messageinfo = {
				        message = "YOU DEFEATED",
				        duration = 2}
				Timers:CreateTimer({
	    			endTime = 1, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
	    			callback = function()
						FireGameEvent("show_center_message",messageinfo)
						GameRules:SetFogOfWarDisabled(true)
						GameRules:SetGameWinner( DOTA_TEAM_BADGUYS )
					end
				})
			end
		end
	end

	--Count Creep kills as scoreboard kills
	if not killedUnit:IsRealHero() then
		print("1 mob dead")
	    self.nRadiantKills = self.nRadiantKills + 1
	    --update personal score
	    killerEntity:IncrementKills(1)
	end

	--update team scores
	GameMode:SetTopBarTeamValue ( DOTA_TEAM_BADGUYS, self.nDireKills )
    GameMode:SetTopBarTeamValue ( DOTA_TEAM_GOODGUYS, self.nRadiantKills )

    --if it's a cherubin, send to hell
    if killedUnit:GetName()=="cherub1" or killedUnit:GetName()=="cherub2" or killedUnit:GetName()=="cherub3" then
    	GameRules:SendCustomMessage("<font color='#DBA901'>Soul Keeper:</font> Have you forgotten your previous deeds among the living?!", 0,0)
        GameRules:SendCustomMessage("Your hearts have been weighed, and only Hell waits for you now!", 0,0)
    	
    	--send to hell
    	SENDHELL = true
    	local point =  Entities:FindByName( nil, "teleport_spot_hell" ):GetAbsOrigin()

    	--mass teleport
    	for nPlayerID = 0, DOTA_MAX_PLAYERS-1 do 
    		if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
    			local entHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
	        	FindClearSpaceForUnit(entHero, point, false)
	        	entHero:Stop()
	        	SendToConsole("dota_camera_center")
        	end
        end

       
        local messageinfo = {
        message = "Some seconds in Hell",
        duration = 5
        }
        FireGameEvent("show_center_message",messageinfo)

        --seconds later, teleport back
        Timers:CreateTimer({
	    	endTime = 40, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
	    	callback = function()
	      		local point =  Entities:FindByName( nil, "teleport_spot_back" ):GetAbsOrigin()
        		--mass teleport
    			for nPlayerID = 0, DOTA_MAX_PLAYERS-1 do 
    				if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
	    			local entHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
		        	FindClearSpaceForUnit(entHero, point, false)
		        	entHero:Stop()
		        	SendToConsole("dota_camera_center")
	        		end
        		end
       			print("Teleport Back")
	    	end
	    })
    end
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
