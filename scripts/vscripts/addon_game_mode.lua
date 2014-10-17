--dota_launch_custom_game warchasers warchasers

--require( 'util' )
require( 'camera' )
require( 'abilities' )
require( 'timers')
require( 'teleport')
require( 'ai' )
require( 'spawn' )
local hints = require( 'hints' )


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
	
	PrecacheUnitByNameSync("npc_dota_hero_sven", context)
	PrecacheUnitByNameSync("npc_dota_hero_templar_assassin", context)
	PrecacheUnitByNameSync("npc_dota_hero_shredder", context)
	PrecacheUnitByNameSync("npc_dota_hero_juggernaut", context)
	PrecacheUnitByNameSync("npc_dota_hero_shadow_demon", context)
	PrecacheUnitByNameSync("npc_dota_hero_chaos_knight", context)
	PrecacheUnitByNameSync("npc_dota_hero_razor", context)
	PrecacheUnitByNameSync("npc_dota_hero_drow_ranger", context)
	PrecacheUnitByNameSync("npc_dota_hero_wisp", context)

	PrecacheUnitByNameSync("npc_dota_hero_magnataur", context)
	PrecacheUnitByNameSync("npc_dota_hero_brewmaster", context)
	PrecacheUnitByNameSync("npc_dota_hero_alchemist", context)
	PrecacheUnitByNameSync("npc_dota_hero_abaddon", context)
	PrecacheUnitByNameSync("npc_dota_hero_ember_spirit", context)
	PrecacheUnitByNameSync("npc_dota_hero_omniknight", context)
	PrecacheUnitByNameSync("npc_dota_hero_clinkz", context)
	PrecacheUnitByNameSync("npc_dota_hero_abyssal_underlord", context)
	PrecacheUnitByNameSync("npc_dota_hero_lycan", context)
	--PrecacheUnitByNameSync("npc_dota_hero_invoker", context)
	--PrecacheUnitByNameSync("npc_dota_hero_warlock", context)
	PrecacheUnitByNameSync("npc_dota_hero_lich", context)
	PrecacheUnitByNameSync("npc_dota_hero_bane", context)
	PrecacheUnitByNameSync("npc_dota_hero_skeleton_king", context)
	PrecacheUnitByNameSync("npc_dota_hero_lone_druid", context)
	PrecacheUnitByNameSync("npc_dota_hero_mirana", context)
	PrecacheUnitByNameSync("npc_dota_hero_witch_doctor", context)
	PrecacheUnitByNameSync("npc_dota_hero_centaur", context)
	PrecacheUnitByNameSync("npc_dota_hero_enigma", context)
	PrecacheUnitByNameSync("npc_dota_hero_venomancer", context)
	PrecacheUnitByNameSync("npc_dota_hero_legion_commander", context)
	--PrecacheUnitByNameSync("npc_dota_hero_huskar", context)
	PrecacheUnitByNameSync("npc_dota_hero_enchantress", context)
	PrecacheUnitByNameSync("npc_dota_hero_necrolyte", context)
	PrecacheUnitByNameSync("npc_soul_keeper", context)
	PrecacheUnitByNameSync("npc_dota_hero_zuus", context)
	PrecacheUnitByNameSync("npc_dota_hero_pudge", context)
	PrecacheUnitByNameSync("npc_dota_hero_doom_bringer", context)
	PrecacheUnitByNameSync("npc_dota_hero_skywrath_mage", context)
	PrecacheUnitByNameSync("npc_dota_hero_axe", context)
	PrecacheUnitByNameSync("npc_dota_hero_luna", context)
	PrecacheUnitByNameSync("npc_dota_hero_troll_warlord", context)
	PrecacheUnitByNameSync("npc_dota_hero_slark", context)
	PrecacheUnitByNameSync("npc_dota_hero_ogre_magi", context)
	PrecacheUnitByNameSync("npc_dota_hero_keeper_of_the_light", context)
	PrecacheUnitByNameSync("npc_dota_hero_night_stalker", context)
	PrecacheUnitByNameSync("npc_dota_hero_furion", context)
	PrecacheUnitByNameSync("npc_dota_hero_meepo", context)
	PrecacheUnitByNameSync("npc_dota_hero_clinkz", context)
	PrecacheUnitByNameSync("npc_skeleton_archer", context)
	PrecacheUnitByNameSync("npc_dota_hero_broodmother", context)
	PrecacheUnitByNameSync("npc_dota_hero_tiny", context)
	PrecacheUnitByNameSync("npc_dota_hero_terrorblade", context)
	PrecacheUnitByNameSync("npc_dota_hero_abaddon", context)

	PrecacheUnitByNameSync("npc_timber", context)
	PrecacheUnitByNameSync("npc_dota_hero_optimus_primo", context)
	PrecacheUnitByNameSync("npc_jugg", context)
	PrecacheUnitByNameSync("npc_dota_hero_blade_berserker", context)
	PrecacheUnitByNameSync("npc_drow", context)
	PrecacheUnitByNameSync("npc_dota_hero_snake_eyes", context)
	PrecacheUnitByNameSync("npc_ck", context)
	PrecacheUnitByNameSync("npc_warchasers_hero_beast_knight", context)
	PrecacheUnitByNameSync("npc_sd", context)
	PrecacheUnitByNameSync("npc_dota_hero_mummrah", context)
	PrecacheUnitByNameSync("npc_templar", context)
	PrecacheUnitByNameSync("npc_dota_hero_assassin", context)
	PrecacheUnitByNameSync("npc_sven", context)
	PrecacheUnitByNameSync("npc_dota_hero_megotron", context)
	PrecacheUnitByNameSync("npc_razor", context)
	PrecacheUnitByNameSync("npc_dota_hero_skeletorus", context)

	PrecacheUnitByNameSync("npc_doom_miniboss", context)
	PrecacheUnitByNameSync("npc_tb_miniboss", context)
	PrecacheUnitByNameSync("npc_boss", context)

  	PrecacheResource( "model", "models/props_debris/merchant_debris_key001.vmdl", context )
	PrecacheResource( "model", "models/props_debris/merchant_debris_chest001.vmdl", context )
	PrecacheResource("model", "models/kappakey.vmdl", context)
	PrecacheResource("model", "models/chest_worlddrop.vmdl", context)
	PrecacheResource("model", "models/props_items/monkey_king_bar01.vmdl", context)
	PrecacheResource("model", "models/props_items/blinkdagger.vmdl", context)
	PrecacheResource("model", "models/props_items/assault_cuirass.vmdl" , context)
	PrecacheResource( "model", "models/creeps/neutral_creeps/n_creep_dragonspawn_a/n_creep_dragonspawn_a.vmdl", context )
	PrecacheResource( "model", "models/npc_minions/draft_siege_good.vmdl", context)
	PrecacheResource( "model", "models/items/abaddon/alliance_abba_weapon/alliance_abba_weapon.vmdl", context)
	PrecacheResource("model", "models/props_items/necronomicon.vmdl", context)
	
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_dragon_knight.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/music/valve_dota_001/stingers/game_sounds_stingers.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_stingers_diretide.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_creeps.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_crystalmaiden.vsndevts", context)
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_clinkz.vsndevts", context)
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_lina.vsndevts", context)
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_chen.vsndevts", context)
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_nyx_assassin.vsndevts", context)
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_wisp.vsndevts", context)
	PrecacheResource( "soundfile", "soundevents/voscripts/game_sounds_vo_wisp.vsndevts", context)
	
  	PrecacheResource( "particle_folder", "particles/units/heroes/hero_dragon_knight", context )
  	PrecacheResource( "particle_folder", "particles/units/heroes/hero_juggernaut", context )
  	PrecacheResource( "particle_folder", "particles/units/heroes/hero_chen", context )
	PrecacheResource( "particle_folder","particles/items_fx", context)
	PrecacheResource( "particle_folder","particles/items2_fx", context)
	PrecacheResource( "particle_folder","particles/newplayer_fx", context)
	PrecacheResource( "particle_folder","particles/econ/items", context)
	PrecacheResource( "particle_folder","particles/econ/courier", context)
	PrecacheResource( "particle_folder","particles/econ/events/ti4", context)
	PrecacheResource( "particle_folder","particles/generic_gameplay", context)
	PrecacheResource( "particle_folder", "particles/neutral_fx", context)
	
	--[[--NEED TO PRECACHE ALL HATS
	print('[Precache] Start')
	local wearables = LoadKeyValues("scripts/items/items_game.txt")

	local wearablesList = {}
	local precacheWearables = {}
	for k, v in pairs(wearables) do
		if k == 'items' then
			wearablesList = v
		end
	end
	local hatCounter = 0
	
	--check wearablesList for jugg hats
	for k, v in pairs(wearablesList) do
	  	if IsForHero("npc_dota_hero_juggernaut", k, wearablesList[k]) then
            for key, value in pairs(wearablesList[k]) do
				if key == 'model_player' then
					print("Precache jugg hat")
					hatCounter = hatCounter+1
					precacheWearables[value] = true
				end
			end
		end
		if IsForHero("npc_dota_hero_shredder", k, wearablesList[k]) then
            for key, value in pairs(wearablesList[k]) do
				if key == 'model_player' then
					print("Precache timber hat")
					hatCounter = hatCounter+1
					precacheWearables[value] = true
				end
			end
		end
		if IsForHero("npc_dota_hero_drow_ranger", k, wearablesList[k]) then
            for key, value in pairs(wearablesList[k]) do
				if key == 'model_player' then
					print("Precache drow hat")
					hatCounter = hatCounter+1
					precacheWearables[value] = true
				end
			end
		end
		if IsForHero("npc_dota_hero_sven", k, wearablesList[k]) then
            for key, value in pairs(wearablesList[k]) do
				if key == 'model_player' then
					print("Precache sven hat")
					hatCounter = hatCounter+1
					precacheWearables[value] = true
				end
			end
		end
		if IsForHero("npc_dota_hero_chaos_knight", k, wearablesList[k]) then
            for key, value in pairs(wearablesList[k]) do
				if key == 'model_player' then
					print("Precache ck hat")
					hatCounter = hatCounter+1
					precacheWearables[value] = true
				end
			end
		end
		if IsForHero("npc_dota_hero_shadow_demon", k, wearablesList[k]) then
            for key, value in pairs(wearablesList[k]) do
				if key == 'model_player' then
					print("Precache sd hat")
					hatCounter = hatCounter+1
					precacheWearables[value] = true
				end
			end
		end
		if IsForHero("npc_dota_hero_razor", k, wearablesList[k]) then
            for key, value in pairs(wearablesList[k]) do
				if key == 'model_player' then
					print("Precache razor hat")
					hatCounter = hatCounter+1
					precacheWearables[value] = true
				end
			end
		end
		if IsForHero("npc_dota_hero_templar", k, wearablesList[k]) then
            for key, value in pairs(wearablesList[k]) do
				if key == 'model_player' then
					print("Precache templar hat")
					hatCounter = hatCounter+1
					precacheWearables[value] = true
				end
			end
		end
	end

	for wearable,_ in pairs( precacheWearables ) do
		print("Precache: " .. wearable)
		PrecacheResource( "model", wearable, context )
	end
	print('[Precache]' .. hatCounter .. " models loaded!")
	print('[Precache] End')]]

end

--thanks Aderum
function IsForHero(hero, k, wearablesListEntry)
	for key, value in pairs(wearablesListEntry) do
		if key == 'used_by_heroes' then
			print("Precache used_by_heroes Entry")
			DeepPrintTable(wearablesListEntry)
			if (wearablesListEntry[key]) ~= nil and (type(wearablesListEntry[key]) == "table") then
				print("wearablesListEntry[key] is a table")
				for key_hero,value_bool in pairs (wearablesListEntry[key]) do
					if key_hero == hero then
						return true
					end
				end
			end
		end
	end
	return false
end

XP_PER_LEVEL_TABLE = {
	     0, -- 1
	  200, -- 2 +200
	  500, -- 3 +300
	  900, -- 4 +400
	 1400, -- 5 +500
	 2000, -- 6 +600
	 2700, -- 7 +700
	 3500, -- 8 +800
	 4400, -- 9 +900
	 5400 -- 10 +1000
 }

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = Warchasers()
	GameRules.AddonTemplate:InitGameMode()
end

function Warchasers:InitGameMode()
	print( "Starting to load gamemode..." )

	--self:ReadDropConfiguration()
	GameMode = GameRules:GetGameModeEntity()

	GameMode:SetCameraDistanceOverride( 1600 )
	GameMode:SetAnnouncerDisabled(true)
	GameMode:SetBuybackEnabled(false)
	GameMode:SetRecommendedItemsDisabled(true) --broken
	GameMode:SetFixedRespawnTime(999)
	GameMode:SetTopBarTeamValuesVisible( true ) --customized top bar values
	GameMode:SetTopBarTeamValuesOverride( true ) --display the top bar score/count

	GameMode:SetCustomHeroMaxLevel( 10 )
	GameMode:SetCustomXPRequiredToReachNextLevel( XP_PER_LEVEL_TABLE )
	GameMode:SetUseCustomHeroLevels ( true )

	--GameRules:SetCustomGameEndDelay(0.1)
	--GameRules:SetCustomVictoryMessageDuration(0.1)

	--GameRules:SetPreGameTime(0)
	--GameRules:SetPostGameTime(0)
	--GameRules:SetHeroSelectionTime(0)
	--GameRules:SetGoldPerTick(0)
	--GameRules:SetHeroRespawnEnabled(false)

	print( "GameRules set" )

	GameRules.FIRST_CIRCLE_ACTIVADED = false
	GameRules.SENDHELL = false
	GameRules.SENDFROSTHEAVEN = false
	GameRules.SENDFORESTHELL = false
	GameRules.SHOWPOPUP = true
	GameRules.SENDSPIDERHALL = false

	GameRules.DEAD_PLAYER_COUNT = 0
	GameRules.PLAYER_COUNT = 0
	GameRules.PLAYERS_PICKED_HERO = 0
	GameRules.HALL_CLEARED = false
	GameRules.TANK_BOSS_KILLED = false

	GameRules.P0_ANKH_COUNT = 0
	GameRules.P1_ANKH_COUNT = 0
	GameRules.P2_ANKH_COUNT = 0
	GameRules.P3_ANKH_COUNT = 0
	GameRules.P4_ANKH_COUNT = 0

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
    ListenToGameEvent( "dota_player_pick_hero", Dynamic_Wrap( Warchasers, "OnPlayerPicked" ), self )
    --ListenToGameEvent('dota_player_killed', Dynamic_Wrap( Warchasers, 'OnPlayerKilled'), self)
    ListenToGameEvent('game_rules_state_change', Dynamic_Wrap( Warchasers, 'OnGameRulesStateChange'), self)
    ListenToGameEvent('dota_item_picked_up', Dynamic_Wrap(Warchasers, 'OnItemPickedUp'), self)
	
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 1 )
	GameRules:GetGameModeEntity():SetThink("AnkhThink", self)

	--Variables for tracking
	self.nRadiantKills = 0
  	self.nDireKills = 0

  	self.bSeenWaitForPlayers = false

	print( "Done loading gamemode" )

end


-- Evaluate the state of the game
function Warchasers:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
	
		Warchasers:CheckForDefeat()

		GameRules:SetTimeOfDay( 0.8 )
		
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 2
end

-- Evaluate Ankh counters
function Warchasers:AnkhThink()
	--for all valid players
	for nPlayerID = 0, DOTA_MAX_PLAYERS-1 do
    	if PlayerResource:IsValidPlayer(nPlayerID) and PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
			--go through their inventories
			local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
			if hero~=nil and hero:IsAlive() then
				local ankh_counter = 0
				for itemSlot = 0, 5, 1 do
		            local Item = hero:GetItemInSlot( itemSlot )
		            if Item ~= nil and Item:GetName() == "item_ankh" then 
		 				ankh_counter = ankh_counter+1 --set Ankh numbers
		 			end
		 		end
		 		if nPlayerID == 0 then
 					GameRules.P0_ANKH_COUNT = ankh_counter
 					--print("Player 0 Ankh Count: " .. GameRules.P0_ANKH_COUNT)
				elseif nPlayerID == 1 then
 					GameRules.P1_ANKH_COUNT = ankh_counter
					--print("Player 1 Ankh Count: " .. GameRules.P1_ANKH_COUNT)
 				elseif nPlayerID == 2 then
 					GameRules.P2_ANKH_COUNT = ankh_counter
 					--print("Player 2 Ankh Count: " .. GameRules.P2_ANKH_COUNT)
 				elseif nPlayerID == 3 then
 					GameRules.P3_ANKH_COUNT = ankh_counter
 					--print("Player 3 Ankh Count: " .. GameRules.P3_ANKH_COUNT)
 				elseif nPlayerID == 4 then
 					GameRules.P4_ANKH_COUNT = ankh_counter
 					--print("Player 4 Ankh Count: " .. GameRules.P4_ANKH_COUNT)
 				end
		 	end		
	 	end
	end			
	return 1
end

function Warchasers:CheckForDefeat()
	
	-- local bAllPlayersDead = true
	-- for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		-- if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
			-- if not PlayerResource:HasSelectedHero( nPlayerID ) then
				-- bAllPlayersDead = false
			-- else
				-- local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
				-- if hero and hero:IsAlive() then
					-- bAllPlayersDead = false
				-- end
			-- end
		-- end
	-- end

end

function Warchasers:OnGameRulesStateChange(keys)
  	print("GameRules State Changed")

  	local newState = GameRules:State_Get()
  	if newState == DOTA_GAMERULES_STATE_WAIT_FOR_PLAYERS_TO_LOAD then
    	self.bSeenWaitForPlayers = true
  	elseif newState == DOTA_GAMERULES_STATE_INIT then
    	Timers:RemoveTimer("alljointimer")
  	elseif newState == DOTA_GAMERULES_STATE_HERO_SELECTION then
    	local et = 6
    	if self.bSeenWaitForPlayers then
      		et = .01
    	end
    	Timers:CreateTimer("alljointimer", {
	      	useGameTime = true,
	      	endTime = et,
	      	callback = function()
	        if PlayerResource:HaveAllPlayersJoined() then
	          	Warchasers:PostLoadPrecache()
	          	Warchasers:OnAllPlayersLoaded()
	          	return 
	        end
        return 1
      	end
      	})
  	elseif newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
    	Warchasers:OnGameInProgress()
  	end
end

function Warchasers:PostLoadPrecache()
	print("Performing Post-Load precache")

  	PrecacheUnitByNameAsync("npc_dota_hero_sven", function(...) end)
	PrecacheUnitByNameAsync("npc_dota_hero_templar_assassin", function(...) end)
	PrecacheUnitByNameAsync("npc_dota_hero_shredder", function(...) end)
	PrecacheUnitByNameAsync("npc_dota_hero_juggernaut", function(...) end)
	PrecacheUnitByNameAsync("npc_dota_hero_shadow_demon", function(...) end)
	PrecacheUnitByNameAsync("npc_dota_hero_chaos_knight", function(...) end)
	PrecacheUnitByNameAsync("npc_dota_hero_razor", function(...) end)
	PrecacheUnitByNameAsync("npc_dota_hero_drow_ranger", function(...) end)
	PrecacheUnitByNameAsync("npc_dota_hero_wisp", function(...) end)

end

function Warchasers:OnGameInProgress()
	print("Game started.")
	--Start at Night
	GameRules:SetTimeOfDay( 0.8 )

	--EmitGlobalSound("valve_dota_001.music.ui_startup")

	if GameRules.SHOWPOPUP then
		ShowGenericPopup( "#popup_title", "#popup_body", "", "", DOTA_SHOWGENERICPOPUP_TINT_SCREEN )
		GameRules.SHOWPOPUP = false
	end
end


function Warchasers:OnAllPlayersLoaded()
	print("All Players Have Loaded")

		--Create Dummy so we can see the particle glow
	    position = Vector(-6719,5541,40)
        local dummy1 = CreateUnitByName("vision_dummy_tiny", position, true, nil, nil, DOTA_TEAM_GOODGUYS)

        --Create Dummy so we can see the particle glow
	    position = Vector(-3062,2976,192) --secret
        local dummy2 = CreateUnitByName("vision_dummy_tiny", position, true, nil, nil, DOTA_TEAM_GOODGUYS)

        --Create Dummy so we can see the particle glow
	    position = Vector(123,2174,129) --sunkey
        local dummy3 = CreateUnitByName("vision_dummy_tiny", position, true, nil, nil, DOTA_TEAM_GOODGUYS)

        position = Vector(-1404,7732,256) --books
        local dummy4 = CreateUnitByName("vision_dummy_tiny", position, true, nil, nil, DOTA_TEAM_GOODGUYS) 


        --WORLD ITEMDROPS
		print("Creating itemdrops")

		position = Vector(124,2175,128)
		local newItem = CreateItem("item_key3", nil, nil)
		CreateItemOnPositionSync(position, newItem)

		position = Vector(-2940,2996,128)
		local newItem = CreateItem("item_allerias_flute", nil, nil)
	    CreateItemOnPositionSync(position, newItem)

	    position = Vector(-3136,2996,128)
		local newItem = CreateItem("item_khadgars_gem", nil, nil)
	    CreateItemOnPositionSync(position, newItem)

	    position = Vector(-2940,3200,128)
		local newItem = CreateItem("item_stormwind_horn", nil, nil)
	    CreateItemOnPositionSync(position, newItem)

	    position = Vector(-3136,3200,128)
		local newItem = CreateItem("item_bone_chimes", nil, nil)
	    CreateItemOnPositionSync(position, newItem)

        local newItem = CreateItem("item_potion_of_healing", nil, nil)
        hell1 = Vector(-7585.9, 3618.39, 40)
        CreateItemOnPositionSync(hell1, newItem)

        local newItem = CreateItem("item_potion_of_healing", nil, nil)
        hell2 = Vector(-7634.45, 2930.77, 40)
        CreateItemOnPositionSync(hell2, newItem)

        local newItem = CreateItem("item_potion_of_healing", nil, nil)
        hell3 = Vector(-7550.46, 2382.61, 40)
        CreateItemOnPositionSync(hell3, newItem)

        local newItem = CreateItem("item_potion_of_healing", nil, nil)
        hell4 = Vector(-5834.61, 3493.86, 40)
        CreateItemOnPositionSync(hell4, newItem)

        local newItem = CreateItem("item_potion_of_healing", nil, nil)
        hell5 = Vector(-5658.03, 2879.14, 40)
        CreateItemOnPositionSync(hell5, newItem)

        local newItem = CreateItem("item_potion_of_healing", nil, nil)
        hell6 = Vector(-5719.82, 2403.32, 40)
        CreateItemOnPositionSync(hell6, newItem)


        local newItem = CreateItem("item_book_of_the_dead", nil, nil)
        book1 = Vector(-1540,7713,256)
        CreateItemOnPositionSync(book1, newItem)

        local newItem = CreateItem("item_book_of_the_dead", nil, nil)
        book2 = Vector(-1316,7713,256)
        CreateItemOnPositionSync(book2, newItem)

		Timers:CreateTimer({
            endTime = 1, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
            callback = function()
				dummy1:ForceKill(true)
				dummy2:ForceKill(true)
				dummy3:ForceKill(true)
				dummy4:ForceKill(true)
			end
		})

		--Create Hall of Heroes
		
		local origin = Vector(-2955,-5280,512)
		local dummy1 = CreateUnitByName("vision_dummy_hall", origin, true, nil, nil, DOTA_TEAM_GOODGUYS)
		local origin = Vector(-2955,-6045,512)
		local dummy2 = CreateUnitByName("vision_dummy_hall", origin, true, nil, nil, DOTA_TEAM_GOODGUYS)
		local origin = Vector(-2955,-6657,512)
		local dummy3 = CreateUnitByName("vision_dummy_hall", origin, true, nil, nil, DOTA_TEAM_GOODGUYS)
		--kill after everyone picked their heroes


		--left row
		local origin = Entities:FindByName( nil, "timber_circle" ):GetAbsOrigin()
		local timbersaw = CreateUnitByName("npc_timber", origin, true, nil, nil, DOTA_TEAM_GOODGUYS)
		timbersaw:AddNewModifier(nil, nil, "modifier_tutorial_forceanimation", {act=ACT_DOTA_CAST_ABILITY_1, loop=1})
		print("modifier added")

		local origin = Entities:FindByName( nil, "jugg_circle" ):GetAbsOrigin()
		local juggernaut = CreateUnitByName("npc_jugg", origin, true, nil, nil, DOTA_TEAM_GOODGUYS)

		local origin = Entities:FindByName( nil, "drow_circle" ):GetAbsOrigin()
		local drow = CreateUnitByName("npc_drow", origin, true, nil, nil, DOTA_TEAM_GOODGUYS)

		local origin = Entities:FindByName( nil, "ck_circle" ):GetAbsOrigin()
		local ck = CreateUnitByName("npc_ck", origin, true, nil, nil, DOTA_TEAM_GOODGUYS)



		--right row
		local origin = Entities:FindByName( nil, "sd_circle" ):GetAbsOrigin()
		local rotation = Vector(-6912,-5856,500)
		local sd = CreateUnitByName("npc_sd", origin, true, nil, nil, DOTA_TEAM_GOODGUYS)
		sd:SetForwardVector(rotation)

		local origin = Entities:FindByName( nil, "templar_circle" ):GetAbsOrigin()
		local templar = CreateUnitByName("npc_templar", origin, true, nil, nil, DOTA_TEAM_GOODGUYS)
		templar:SetForwardVector(rotation)

		local origin = Entities:FindByName( nil, "sven_circle" ):GetAbsOrigin()
		local sven = CreateUnitByName("npc_sven", origin, true, nil, nil, DOTA_TEAM_GOODGUYS)
		sven:SetForwardVector(rotation)

		local origin = Entities:FindByName( nil, "razor_circle" ):GetAbsOrigin()
		local razor = CreateUnitByName("npc_razor", origin, true, nil, nil, DOTA_TEAM_GOODGUYS)
		razor:SetForwardVector(rotation)

		--Spawning Bosses

		local owner_location = Vector(-7970,-7767,512)
		local soul_keeper = CreateUnitByName("npc_soul_keeper", owner_location, true, nil, nil, DOTA_TEAM_NEUTRALS)
		
		local boss_location = Vector(-5512,-5497,-112)
		local boss_rotation = Vector(-7872,-5504,265)
		local boss1 = CreateUnitByName("npc_doom_miniboss", boss_location, true, soul_keeper, soul_keeper, DOTA_TEAM_NEUTRALS)
		boss1:SetForwardVector(boss_rotation)

		local boss_location = Vector(-1408,-7560,137)
		local boss_rotation = Vector(-1408,6540,256)
		local boss2 = CreateUnitByName("npc_tb_miniboss", boss_location, true, soul_keeper, soul_keeper, DOTA_TEAM_NEUTRALS)
		boss2:SetForwardVector(boss_rotation)

		local boss_location = Vector(2038, -7212, 257)
		local boss_rotation = Vector(7662, -7152, 113)
		local final_boss = CreateUnitByName("npc_boss", boss_location, true, soul_keeper, soul_keeper, DOTA_TEAM_NEUTRALS)
		final_boss:SetForwardVector(boss_rotation)


end

function Warchasers:OnNPCSpawned(keys)
	print("NPC Spawned")
	local npc = EntIndexToHScript(keys.entindex)
	
	if npc:IsHero() then
		npc.strBonus = 0
        npc.intBonus = 0
        npc.agilityBonus = 0
        npc.attackspeedBonus = 0
    end
	
	if npc:IsRealHero() then
		--Warchasers:RemoveWearables(npc) --doesn't work

		local heroPlayerID = npc:GetPlayerID()
		print("Player ID: " .. heroPlayerID)
		local heroName = PlayerResource:GetSelectedHeroName(heroPlayerID)
		print("Hero Name: " .. heroName)

		if npc:GetTeam() == DOTA_TEAM_BADGUYS then
			giveUnitDataDrivenModifier(npc, npc,"modifier_out_of_game",{-1})
		end

		if heroName == "npc_dota_hero_wisp" then
			--[[local item = CreateItem("item_talisman_of_the_wild", npc, npc) --testing items
			npc:AddItem(item)]]
			giveUnitDataDrivenModifier(npc, npc,"wisp",{-1})
			local playercounter = 0
			for nPlayerID = 0, DOTA_MAX_PLAYERS-1 do
				if PlayerResource:IsValidPlayer(nPlayerID) then 
					playercounter=playercounter+1
				end
			end

			GameRules.PLAYER_COUNT = playercounter
			print("Total Players: " .. GameRules.PLAYER_COUNT)

		else --if heroName ~= "npc_dota_hero_wisp" then
			--GameRules:GetGameModeEntity():SetCameraDistanceOverride( 1000 )
			if npc.bFirstSpawned == nil then
				npc.bFirstSpawned = true
				--Add Ankh
				local item = CreateItem("item_ankh", npc, npc)
				npc:AddItem(item)
				if Convars:GetBool("developer") then
					local item = CreateItem("item_ublink", npc, npc) --testing items
					npc:AddItem(item)
				end
				Warchasers:OnHeroInGame(npc)
			elseif npc.bFirstSpawned == true then --respawn through Ankh
				--Warchasers:ModifyStatBonuses(spawnedUnitIndex)
				Warchasers:OnHeroInGame(npc)
				npc:SetHealth(500) --it's a little more based on the STR
				print(npc:GetHealth())
			end
		end	
	end
end

function Warchasers:OnHeroInGame(hero)
	print("Hero Spawned") --not a wisp

	GameRules.PLAYERS_PICKED_HERO=GameRules.PLAYERS_PICKED_HERO+1 --real players, not wisps

	print("Total Players In Game: " .. GameRules.PLAYER_COUNT)
	print("Players with a hero picked: " .. GameRules.PLAYERS_PICKED_HERO)
	if (GameRules.PLAYERS_PICKED_HERO==GameRules.PLAYER_COUNT) and not GameRules.HALL_CLEARED then --every player selected a hero, no wisps remaining
		--find and kill the npcs in the hall
		local hallOrigin = Vector(-2955,-6000,512)
		local allNPCNear = Entities:FindAllByClassnameWithin("npc_dota_creature", hallOrigin, 2000)
		for i = 1, #allNPCNear, 1 do
                local creep = allNPCNear[i]
                local name = creep:GetUnitName()
                if 	name == "npc_timber" or 
                	name == "npc_jugg" or 
                	name == "npc_drow" or 
                	name == "npc_ck" or 
                	name == "npc_sd" or 
                	name == "npc_templar" or 
                	name == "npc_sven" or
                	name == "npc_razor" or
                	name == "vision_dummy_hall" then
                        creep:ForceKill(true)
                        print(name .. " killed")
                end
        end

		--disable hero triggers (prevent weird reroll case)
		local trigger = Entities:FindByName( nil, "circle_timber" )
		trigger:Disable()
		local trigger = Entities:FindByName( nil, "circle_jugg" )
		trigger:Disable()
		local trigger = Entities:FindByName( nil, "circle_drow" )
		trigger:Disable()
		local trigger = Entities:FindByName( nil, "circle_ck" )
		trigger:Disable()
		local trigger = Entities:FindByName( nil, "circle_sd" )
		trigger:Disable()
		local trigger = Entities:FindByName( nil, "circle_templar" )
		trigger:Disable()
		local trigger = Entities:FindByName( nil, "circle_sven" )
		trigger:Disable()
		local trigger = Entities:FindByName( nil, "circle_razor" )
		trigger:Disable()

		

		GameRules.HALL_CLEARED = true
		print("Hall of Heroes Cleared")

		GameRules:GetGameModeEntity():SetCameraDistanceOverride( 1000 )
	end

	Warchasers:ModifyStatBonuses(hero)
    giveUnitDataDrivenModifier(hero, hero, "modifier_make_deniable",-1) --friendly fire
	giveUnitDataDrivenBuff(hero, hero, "modifier_warchasers_stat_rules",-1)

	

    if GameRules.PLAYER_COUNT==1 then --apply solo buff
    	Timers:CreateTimer({
			endTime = 0.5, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
			callback = function()
				giveUnitDataDrivenModifier(hero, hero, "modifier_warchasers_solo_buff",-1)
			end
		})
    end

end

function Warchasers:OnPlayerPicked( event )
    local spawnedUnitIndex = EntIndexToHScript(event.heroindex)
    -- Apply timer to update stats
    --Warchasers:ModifyStatBonuses(spawnedUnitIndex)
end

--Item checking
function Warchasers:OnItemPickedUp( event )

end



--Custom Stat Rules
function Warchasers:ModifyStatBonuses(unit)
	local spawnedUnitIndex = unit
	print("Modifying Stats Bonus")
		Timers:CreateTimer(DoUniqueString("updateHealth_" .. spawnedUnitIndex:GetPlayerID()), {
		endTime = 0.25,
		callback = function()
			-- ==================================
			-- Adjust health based on strength
			-- ==================================
 
			-- Get player strength
			local strength = spawnedUnitIndex:GetStrength()
			--Check if strBonus is stored on hero, if not set it to 0
			if spawnedUnitIndex.strBonus == nil then
				spawnedUnitIndex.strBonus = 0
			end
 
			-- If player strength is different this time around, start the adjustment
			if strength ~= spawnedUnitIndex.strBonus or spawnedUnitIndex:GetModifierStackCount("tome_health_modifier", spawnedUnitIndex) ~= spawnedUnitIndex.HealthTomesStack then
				-- Modifier values
				local bitTable = {128,64,32,16,8,4,2,1}
 
				-- Gets the list of modifiers on the hero and loops through removing and health modifier
				local modCount = spawnedUnitIndex:GetModifierCount()
				for i = 0, modCount do
					for u = 1, #bitTable do
						local val = bitTable[u]
						if spawnedUnitIndex:GetModifierNameByIndex(i) == "modifier_health_mod_" .. val  then
							spawnedUnitIndex:RemoveModifierByName("modifier_health_mod_" .. val)
						end
					end
				end
 
				-- Creates temporary item to steal the modifiers from
				local healthUpdater = CreateItem("item_health_modifier", nil, nil) 
				for p=1, #bitTable do
					local val = bitTable[p]
					local count = math.floor(strength / val)
					if count >= 1 then
						healthUpdater:ApplyDataDrivenModifier(spawnedUnitIndex, spawnedUnitIndex, "modifier_health_mod_" .. val, {})
						strength = strength - val
					end
				end
				-- Cleanup
				UTIL_RemoveImmediate(healthUpdater)
				healthUpdater = nil
			end
			-- Updates the stored strength bonus value for next timer cycle
			spawnedUnitIndex.strBonus = spawnedUnitIndex:GetStrength()
			spawnedUnitIndex.HealthTomesStack = spawnedUnitIndex:GetModifierStackCount("tome_health_modifier", spawnedUnitIndex)
			-- ==================================
			-- Adjust mana based on intellect
			-- ==================================
 
			-- Get player intellect
			local intellect = spawnedUnitIndex:GetIntellect()
 
			--Check if intBonus is stored on hero, if not set it to 0
			if spawnedUnitIndex.intBonus == nil then
				spawnedUnitIndex.intBonus = 0
			end
 
			-- If player intellect is different this time around, start the adjustment
			if intellect ~= spawnedUnitIndex.intBonus then
				-- Modifier values
				local bitTable = {128,64,32,16,8,4,2,1}
 
				-- Gets the list of modifiers on the hero and loops through removing and mana modifier
				local modCount = spawnedUnitIndex:GetModifierCount()
				for i = 0, modCount do
					for u = 1, #bitTable do
						local val = bitTable[u]
						if spawnedUnitIndex:GetModifierNameByIndex(i) == "modifier_mana_mod_" .. val  then
							spawnedUnitIndex:RemoveModifierByName("modifier_mana_mod_" .. val)
						end
					end
				end
 
				-- Creates temporary item to steal the modifiers from
				local manaUpdater = CreateItem("item_mana_modifier", nil, nil) 
				for p=1, #bitTable do
					local val = bitTable[p]
					local count = math.floor(intellect / val)
					if count >= 1 then
						manaUpdater:ApplyDataDrivenModifier(spawnedUnitIndex, spawnedUnitIndex, "modifier_mana_mod_" .. val, {})
						intellect = intellect - val
					end
				end
				-- Cleanup
				UTIL_RemoveImmediate(healthUpdater)
				manaUpdater = nil
			end
			-- Updates the stored intellect bonus value for next timer cycle
			spawnedUnitIndex.intBonus = spawnedUnitIndex:GetIntellect()
	
			-- ==================================
			-- Adjust attackspeed based on agility
			-- ==================================
 
			-- Get player agility
			local agility = spawnedUnitIndex:GetAgility()
 
			--Check if intBonus is stored on hero, if not set it to 0
			if spawnedUnitIndex.attackspeedBonus == nil then
				spawnedUnitIndex.attackspeedBonus = 0
			end
 
			-- If player agility is different this time around, start the adjustment
			if agility ~= spawnedUnitIndex.attackspeedBonus then
				-- Modifier values
				local bitTable = {128,64,32,16,8,4,2,1}
 
				-- Gets the list of modifiers on the hero and loops through removing and attackspeed modifier
				local modCount = spawnedUnitIndex:GetModifierCount()
				for i = 0, modCount do
					for u = 1, #bitTable do
						local val = bitTable[u]
						if spawnedUnitIndex:GetModifierNameByIndex(i) == "modifier_attackspeed_mod_" .. val  then
							spawnedUnitIndex:RemoveModifierByName("modifier_attackspeed_mod_" .. val)
						end
					end
				end
 
				-- Creates temporary item to steal the modifiers from
				local attackspeedUpdater = CreateItem("item_attackspeed_modifier", nil, nil) 
				for p=1, #bitTable do
					local val = bitTable[p]
					local count = math.floor(agility / val)
					if count >= 1 then
						attackspeedUpdater:ApplyDataDrivenModifier(spawnedUnitIndex, spawnedUnitIndex, "modifier_attackspeed_mod_" .. val, {})
						agility = agility - val
					end
				end
				-- Cleanup
				UTIL_RemoveImmediate(healthUpdater)
				attackspeedUpdater = nil
			end
			-- Updates the stored agility bonus value for next timer cycle
			spawnedUnitIndex.attackspeedBonus = spawnedUnitIndex:GetAgility()
			
			
			-- ==================================
			-- Adjust armor based on agi 
			-- Added as +Armor and not Base Armor because there's no BaseArmor modifier (please...)
			-- ==================================

			-- Get player primary stat value
			local agility = spawnedUnitIndex:GetAgility()

			--Check if primaryStatBonus is stored on hero, if not set it to 0
			if spawnedUnitIndex.agilityBonus == nil then
				spawnedUnitIndex.agilityBonus = 0
			end

			-- If player int is different this time around, start the adjustment
			if agility ~= spawnedUnitIndex.agilityBonus then
				-- Modifier values
				local bitTable = {64,32,16,8,4,2,1}

				-- Gets the list of modifiers on the hero and loops through removing and armor modifier
				for u = 1, #bitTable do
					local val = bitTable[u]
					if spawnedUnitIndex:HasModifier( "modifier_armor_mod_" .. val)  then
						spawnedUnitIndex:RemoveModifierByName("modifier_armor_mod_" .. val)
					end
					
					if spawnedUnitIndex:HasModifier( "modifier_negative_armor_mod_" .. val)  then
						spawnedUnitIndex:RemoveModifierByName("modifier_negative_armor_mod_" .. val)
					end
				end
				print("========================")
				agility = agility / 7
				print("Agi / 7: "..agility)
				-- Remove Armor
				-- Creates temporary item to steal the modifiers from
				local armorUpdater = CreateItem("item_armor_modifier", nil, nil) 
				for p=1, #bitTable do
					local val = bitTable[p]
					local count = math.floor(agility / val)
					if count >= 1 then
						armorUpdater:ApplyDataDrivenModifier(spawnedUnitIndex, spawnedUnitIndex, "modifier_negative_armor_mod_" .. val, {})
						print("Adding modifier_negative_armor_mod_" .. val)
						agility = agility - val
					end
				end

				agility = spawnedUnitIndex:GetAgility()
				agility = agility / 3
				print("Agi / 3: "..agility)
				for p=1, #bitTable do
					local val = bitTable[p]
					local count = math.floor(agility / val)
					if count >= 1 then
						armorUpdater:ApplyDataDrivenModifier(spawnedUnitIndex, spawnedUnitIndex, "modifier_armor_mod_" .. val, {})
						agility = agility - val
						print("Adding modifier_armor_mod_" .. val)
					end
				end

				-- Cleanup
				UTIL_RemoveImmediate(armorUpdater)
				armorUpdater = nil
			end
			-- Updates the stored Int bonus value for next timer cycle
			spawnedUnitIndex.agilityBonus = spawnedUnitIndex:GetAgility()

			return 0.25
		end
	})

end



function Warchasers:OnEntityKilled( event )
	local killedUnit = EntIndexToHScript( event.entindex_killed )
	local killerEntity = EntIndexToHScript( event.entindex_attacker )

	--if killedUnit:GetName()=="finalboss" then
		--GameRules:SetGameWinner( DOTA_TEAM_GOODGUYS )
	--end

	if killedUnit:GetUnitName() == "npc_doom_miniboss" then

		local door = Entities:FindByName(nil, "gate_1_a")
        door:Kill()
        local door = Entities:FindByName(nil, "gate_1_b")
        door:Kill()
        				
		local obstructions = Entities:FindAllByName("obstructions_1")
		for i = 1, #obstructions, 1 do
	        obstructions[i]:SetEnabled(false,false)     
    	end     

    	announce_open_doors(event)
    	hint_keydrop(event)
            

	end

	if killedUnit:GetUnitName() == "npc_tb_miniboss" then

		local obstructions = Entities:FindByName(nil,"obstructions_4_1")
        obstructions:SetEnabled(false,false)

        local obstructions = Entities:FindByName(nil,"obstructions_4_2")
        obstructions:SetEnabled(false,false)

        local obstructions = Entities:FindByName(nil,"obstructions_4_3")
        obstructions:SetEnabled(false,false)

        local obstructions = Entities:FindByName(nil,"obstructions_4_4")
        obstructions:SetEnabled(false,false)
        print("Obstructions disabled")

        local triggerino = Entities:FindByName(nil,"tb_miniboss_dead")
        triggerino:ForceKill(true)

    	miniboss2_dead(event) 		
	end

	if killedUnit:GetName() == "tank_boss" then
		print("Tank Area Cleared")
		GameRules.TANK_BOSS_KILLED=true
	end

	if killedUnit:GetUnitName() == "npc_rocknroll_steamtank" and GameRules.TANK_BOSS_KILLED == false then
		--remove all ankhs if possible, then kill the player
		local tankHero = killedUnit:GetOwner()
		for itemSlot = 0, 5, 1 do
            if tankHero ~= nil then
                local Item = tankHero:GetItemInSlot( itemSlot )
                if Item ~= nil and Item:GetName() == "item_ankh" then
                    tankHero:RemoveItem(Item)
                end
            end
        end
       --wait time for ankh update thinker
       Timers:CreateTimer({
			endTime = 2,
			callback = function()
				tankHero:ForceKill(true)
			end
		})
	end
	
	if killedUnit:IsRealHero() then 
		
		local KilledPlayerID = killedUnit:GetPlayerID()
    	local respawning = false

		--credit dire for the kill even if the player reincarnates
		if killedUnit:GetTeam() == DOTA_TEAM_GOODGUYS then
		      self.nDireKills = self.nDireKills + 1
		end    	

    	--check if the killed player has ankh
      	if KilledPlayerID==0 and GameRules.P0_ANKH_COUNT > 0 then  
    		respawning = true
    		GameRules:SendCustomMessage("<font color='#9A2EFE'>The Ankh of Reincarnation glows brightly...</font>",0,0)
    	end

    	if KilledPlayerID==1 and GameRules.P1_ANKH_COUNT > 0 then  
    		respawning = true
    		GameRules:SendCustomMessage("<font color='#9A2EFE'>The Ankh of Reincarnation glows brightly...</font>",0,0)
    	end
	      
	    if KilledPlayerID==2 and GameRules.P2_ANKH_COUNT > 0 then  
    		respawning = true
    		GameRules:SendCustomMessage("<font color='#9A2EFE'>The Ankh of Reincarnation glows brightly...</font>",0,0)
    	end

    	if KilledPlayerID==3 and GameRules.P3_ANKH_COUNT > 0 then  
    		respawning = true
    		GameRules:SendCustomMessage("<font color='#9A2EFE'>The Ankh of Reincarnation glows brightly...</font>",0,0)
    	end

    	if KilledPlayerID==4 and GameRules.P4_ANKH_COUNT > 0 then  
    		respawning = true
    		GameRules:SendCustomMessage("<font color='#9A2EFE'>The Ankh of Reincarnation glows brightly...</font>",0,0)
    	end   

    	if KilledPlayerID==0 and GameRules.P0_ANKH_COUNT == 0 then  
    		GameRules.DEAD_PLAYER_COUNT=GameRules.DEAD_PLAYER_COUNT+1
    		respawning=false
    	end

    	if KilledPlayerID==1 and GameRules.P1_ANKH_COUNT == 0 then  
    		GameRules.DEAD_PLAYER_COUNT=GameRules.DEAD_PLAYER_COUNT+1
    		respawning=false
    	end
	      
	    if KilledPlayerID==2 and GameRules.P2_ANKH_COUNT == 0 then  
    		GameRules.DEAD_PLAYER_COUNT=GameRules.DEAD_PLAYER_COUNT+1
    		respawning=false
    	end

    	if KilledPlayerID==3 and GameRules.P3_ANKH_COUNT == 0 then  
    		GameRules.DEAD_PLAYER_COUNT=GameRules.DEAD_PLAYER_COUNT+1
    		respawning=false
    	end

    	if KilledPlayerID==4 and GameRules.P4_ANKH_COUNT == 0 then  
    		GameRules.DEAD_PLAYER_COUNT = GameRules.DEAD_PLAYER_COUNT+1
    		respawning=false
    	end 
 		
 		--Check for defeat
 		print("Dead Players: " .. GameRules.DEAD_PLAYER_COUNT)
 		print("Total Players: " .. GameRules.PLAYER_COUNT)
 		if not respawning then
		    if GameRules.DEAD_PLAYER_COUNT == GameRules.PLAYER_COUNT then
		    	print("THEY'RE ALL DEAD BibleThump")
				local messageinfo = {
				        message = "RIP IN PIECES",
						duration = 2}
				
				Timers:CreateTimer({
		    			endTime = 1, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
		    			callback = function()
							FireGameEvent("show_center_message",messageinfo)
							GameMode:SetFogOfWarDisabled(true)
							--GameRules:SetGameWinner( DOTA_TEAM_BADGUYS )
							GameRules:MakeTeamLose( DOTA_TEAM_GOODGUYS )
						end
					})
			end
		end
	end

	--Count Creep kills as scoreboard kills
	if not killedUnit:IsRealHero() and killedUnit:GetTeam() ~= DOTA_TEAM_GOODGUYS then
		print("1 mob dead")
	    self.nRadiantKills = self.nRadiantKills + 1
	    --update personal score
		if killerEntity:GetOwner() ~= nil and not killerEntity:IsRealHero() and killerEntity:GetTeam() == DOTA_TEAM_GOODGUYS then 
				--it's a friendly summon killing something, credit to the owner
				killerEntity:GetOwner():IncrementKills(1)
		elseif killerEntity:IsRealHero() then
			killerEntity:IncrementKills(1) 
		end
	end

	--update team scores
	GameMode:SetTopBarTeamValue ( DOTA_TEAM_BADGUYS, self.nDireKills )
    GameMode:SetTopBarTeamValue ( DOTA_TEAM_GOODGUYS, self.nRadiantKills )

    --if it's a cherubin, send to hell
    if killedUnit:GetName()=="cherub" and GameRules.SENDHELL == false then
    	GameRules.SENDHELL = true
    	EmitGlobalSound("diretide_eventstart_Stinger")
    	GameRules:SendCustomMessage("<font color='#DBA901'>Soul Keeper:</font> Have you forgotten your previous deeds among the living?!", 0,0)
    	GameRules:SendCustomMessage("Your hearts have been weighed, and only Hell waits for you now!", 0,0)
    	Timers:CreateTimer({
	    	endTime = 3, 
	    	callback = function()
    			TeleporterHell( event )
    		end
    	})
    end	

	if killedUnit:GetUnitName() == "npc_skull" then
		GameRules:SendCustomMessage("<font color='#2EFE2E'>Skull consumed</font>", 0, 0)
		EmitGlobalSound("DOTAMusic_Diretide_Finale") 
		local ShakeOn = Vector(3558, -7210, 160)
		ScreenShake(ShakeOn, 10.0, 10.0, 7.0, 99999, 0, true)
		if killerEntity:IsRealHero() then
			giveUnitDataDrivenBuff(killerEntity, killerEntity, "modifier_warchasers_guldan_powers",-1)
		else --apply to the owner
			giveUnitDataDrivenBuff(killerEntity:GetOwner(), killerEntity:GetOwner(), "modifier_warchasers_guldan_powers",-1)
		end
	end

	if killedUnit:GetName() == "casket" then
		GameRules:SendCustomMessage("<font color='#2EFE2E'>Frostmourne released</font>", 0, 0)
		EmitGlobalSound("DOTAMusic_Diretide_Finale") 
		local ShakeOn = Vector(3558, -7210, 160)
		ScreenShake(ShakeOn, 10.0, 10.0, 7.0, 99999, 0, true)
		
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

function Warchasers:RemoveWearables(hero) 
	local wearables = {}
	print("Removing Wearables")
	-- Store all of the wearables into the wearables array
	local cur = hero:FirstMoveChild()
	print(cur:GetName())
 	while cur ~= nil do
    cur = cur:NextMovePeer()
    print(cur:GetName())
    if cur ~= nil and cur:GetClassname() ~= "" and cur:GetClassname() == "dota_item_wearable" then
      print(cur:GetClassname())  -- also can use cur:GetName()
      print(cur:GetName())
      table.insert(wearables, cur)
    end
  end

  print("Wearables List")
  DeepPrintTable(wearables)
   -- Remove all the wearables
  for i=1, #wearables do
  	UTIL_RemoveImmediate(wearables[i])
	end
end


