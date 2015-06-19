-- dota_launch_custom_game warchasers warchasers


WARCHASERS_VERSION = "1.3.1" -- Reborn

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
	GameMode:SetUseCustomHeroLevels ( true )

	--GameRules:SetCustomGameEndDelay(1)
	--GameRules:SetCustomVictoryMessageDuration(0.1)

	--GameRules:SetPreGameTime(0)
	GameRules:SetPostGameTime(60)
	--GameRules:SetHeroSelectionTime(0)
	--GameRules:SetGoldPerTick(0)
	--GameRules:SetHeroRespawnEnabled(false)

	Convars:RegisterCommand( "tank", function(name, parameter)
	    --Get the player that triggered the command
	    local cmdPlayer = Convars:GetCommandClient()
		
	    --If the player is valid: call our handler
	    if cmdPlayer then 
	        return Warchasers:TestTank()
	    end
	 end, "Test Tank", FCVAR_CHEAT )


	 -- Change random seed
	local timeTxt = string.gsub(string.gsub(GetSystemTime(), ':', ''), '0','')
	math.randomseed(tonumber(timeTxt))

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

	GameRules.Player0DEAD = false
	GameRules.Player1EAD = false
	GameRules.Player2DEAD = false
	GameRules.Player3DEAD = false
	GameRules.Player4DEAD = false

	GameRules.CURRENT_SOUNDTRACK = 0

	GameRules.PLAYER_VOTES = {}
	GameRules.DIFFICULTY = 0
	GameRules.difficulty_selected = false

	GameRules.savepoint1 = Entities:FindByName(nil, "savepoint1") --start
	GameRules.savepoint2 = Entities:FindByName(nil, "savepoint2") --1st key door
	GameRules.savepoint3 = Entities:FindByName(nil, "savepoint3") --2nd key door
				--1st teleport: teleport_spot_1 save point
	GameRules.savepoint4 = Entities:FindByName(nil, "savepoint4") --3rd key door
	GameRules.savepoint5 = Entities:FindByName(nil, "savepoint5") --necro after bridge
				--tank zone has its own save point used for teleporting, tank_spawn_point
				--hall of heroes, last savepoint, also has its own teleport_spot_final point

	GameRules.CURRENT_SAVEPOINT = GameRules.savepoint1


    -- Remove building invulnerability
    print("Make buildings vulnerable")
    local allBuildings = Entities:FindAllByClassname('npc_dota_building')
    for i = 1, #allBuildings, 1 do
        local building = allBuildings[i]
        if building:HasModifier('modifier_invulnerable') then
            building:RemoveModifierByName('modifier_invulnerable')
            building:AddNewModifier(building, nil, "modifier_tower_truesight_aura", {})
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

	---------------------------
	-- Reborn Custom_Game_Setup
	GameRules:SetCustomGameSetupTimeout( 0 ) -- set the custom game setup phase to last 60 seconds, set to 0 skip the custom game setup, or -1 to disable the timeout
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 5 )
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 0 )

	-- Auto launch is enabled by default, disable it
	GameRules:EnableCustomGameSetupAutoLaunch( false )
	PlayerResource:SetCustomTeamAssignment( 0, DOTA_TEAM_GOODGUYS )
	PlayerResource:SetCustomTeamAssignment( 1, DOTA_TEAM_GOODGUYS )
	PlayerResource:SetCustomTeamAssignment( 2, DOTA_TEAM_GOODGUYS )
	PlayerResource:SetCustomTeamAssignment( 3, DOTA_TEAM_GOODGUYS )
	PlayerResource:SetCustomTeamAssignment( 4, DOTA_TEAM_GOODGUYS )

	---------------------------

	--Variables for tracking
	self.nRadiantKills = 0
  	self.nDireKills = 0

  	self.bSeenWaitForPlayers = false

  	-- Full units file to get the model scales (Valve please add GetModelScale function back)
  	GameRules.UnitsCustomKV = LoadKeyValues("scripts/npc/npc_units_custom.txt")

	print( "Done loading gamemode" )

end

function Warchasers:PostLoadPrecache()
	print("Performing Post-Load precache")
end



if Convars:GetBool("developer") == true then
	require( "developer" )
end

--[[statcollection.addStats({
	modID = '07dac9699d6c9b7442f8ee7c18c18126' --GET THIS FROM http://getdotastats.com/#d2mods__my_mods
})]]


function set_items_ownership()
	for player_id = 0, 4 do
		local hero = PlayerResource:GetSelectedHeroEntity(player_id) 
		if hero ~= nil then
			for item_slot = 0, 5 do

				local item = hero:GetItemInSlot(item_slot)
				if item ~= nil then
					item:SetPurchaser(hero) 
				end

			end
		end
	end
end



-- Evaluate the state of the game
function Warchasers:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		GameRules:SetTimeOfDay( 0.8 )
		set_items_ownership()
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		    		
        -- Delete the thinker
        return
	end
	return 1
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

function Warchasers:SoundThink()
	
	local soundTrack = RandomInt(1, 6)
	local soundString = nil

	if GameRules.CURRENT_SOUNDTRACK == 0 then
		soundTrack = 0
		soundString = "valve_dota_001.music.ui_world_map" --first track
		EmitGlobalSound(soundString)
		soundTimer = 170
		GameRules.CURRENT_SOUNDTRACK = 1
	else
		if soundTrack == 1 then
			if RollPercentage(80) then 
				soundString = "valve_dota_001.music.ui_world_map" --"Warchasers.HumanX1"
				EmitGlobalSound(soundString)
				soundTimer = 170 --284
			else --rare
				soundString = "Warchasers.PowerOfTheHorde"
				EmitGlobalSound(soundString)
				soundTimer = 281
			end
		elseif soundTrack == 2 then
			soundString = "valve_dota_001.music.laning_03_layer_01"
			EmitGlobalSound(soundString)
			soundTimer = 100
		elseif soundTrack == 3 then
			soundString = "Warchasers.ti4_laning_03_layer_01"
			EmitGlobalSound(soundString)
			soundTimer = 113
		elseif soundTrack == 4 then
			soundString = "valve_dota_001.music.laning_01_layer_01"
			EmitGlobalSound(soundString)
			soundTimer = 161
		elseif soundTrack == 5 then
			soundString = "valve_dota_001.music.ui_main"
			EmitGlobalSound(soundString)
			soundTimer = 111
		elseif soundTrack == 6 then
			soundString = "valve_dota_001.music.ui_world_map"
			EmitGlobalSound(soundString)
			soundTimer = 170
		else 
			return 5
		end
		GameRules.CURRENT_SOUNDTRACK = soundTrack
	end

	print("Playing soundtrack number " .. soundTrack .. " named " .. soundString)
	return soundTimer
end

function Warchasers:CheckForDefeat()
	--[[if GameRules.Player0DEAD == true then --stay dead
		PlayerResource:GetSelectedHeroEntity(0):SetTimeUntilRespawn(999)
	end
	if GameRules.Player1DEAD == true then
		PlayerResource:GetSelectedHeroEntity(1):SetTimeUntilRespawn(999)
	end
	if GameRules.Player2DEAD == true then
		PlayerResource:GetSelectedHeroEntity(2):SetTimeUntilRespawn(999)
	end
	if GameRules.Player3DEAD == true then
		PlayerResource:GetSelectedHeroEntity(3):SetTimeUntilRespawn(999)
	end
	if GameRules.Player4DEAD == true then
		PlayerResource:GetSelectedHeroEntity(4):SetTimeUntilRespawn(999)
	end	]]
end

function Warchasers:OnGameRulesStateChange(keys)
  	print("GameRules State Changed")


  	
  	if nNewState == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		GameRules:LockCustomGameSetupTeamAssignment( true )
		GameRules:FinishCustomGameSetup()
	end

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

function Warchasers:OnGameInProgress()
	print("Game started.")
	--Start at Night
	GameRules:SetTimeOfDay( 0.8 )

end


function Warchasers:OnAllPlayersLoaded()
	print("All Players Have Loaded")
	AnnouncerChoose()

		if GameRules.SHOWPOPUP then
			--ShowGenericPopup( "#popup_title", "#popup_body", "", "", DOTA_SHOWGENERICPOPUP_TINT_SCREEN )
			GameRules.SHOWPOPUP = false
		end

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

		--Spawning Bosses

		local owner_location = Vector(-7970,-7767,512)
		GameRules.soul_keeper = CreateUnitByName("npc_soul_keeper", owner_location, true, nil, nil, DOTA_TEAM_NEUTRALS)
		
		local boss_location = Vector(-5512,-5497,-112)
		local boss_rotation = Vector(-7872,-5504,265)
		local boss1 = CreateUnitByName("npc_doom_miniboss", boss_location, true, GameRules.soul_keeper, GameRules.soul_keeper, DOTA_TEAM_NEUTRALS)
		boss1:SetForwardVector(boss_rotation)
		boss1.initial_neutral_position = boss_location

		local boss_location = Vector(-1408,-7560,137)
		local boss_rotation = Vector(-1408,6540,256)
		local boss2 = CreateUnitByName("npc_tb_miniboss", boss_location, true, GameRules.soul_keeper, GameRules.soul_keeper, DOTA_TEAM_NEUTRALS)
		boss2:SetForwardVector(boss_rotation)
		boss2.initial_neutral_position = boss_location


		local boss_location = Vector(2038, -7212, 257)
		local boss_rotation = Vector(7662, -7152, 113)
		local final_boss = CreateUnitByName("npc_boss", boss_location, true, GameRules.soul_keeper, GameRules.soul_keeper, DOTA_TEAM_NEUTRALS)
		final_boss:SetForwardVector(boss_rotation)
		final_boss.initial_neutral_position = boss_location


end

function Warchasers:OnNPCSpawned(keys)
	--print("NPC Spawned")
	local npc = EntIndexToHScript(keys.entindex)
	
	if npc:IsHero() then
		npc.strBonus = 0
        npc.intBonus = 0
        npc.agilityBonus = 0
        npc.attackspeedBonus = 0
    end
	
	if npc:IsRealHero() then

		local heroPlayerID = npc:GetPlayerID()
		print("Player ID: " .. heroPlayerID)
		local heroName = PlayerResource:GetSelectedHeroName(heroPlayerID)
		print("Hero Name: " .. heroName)

		local playercounter = 0
		for nPlayerID = 0, DOTA_MAX_PLAYERS-1 do
			-- ignore broadcasters to count players for the solo buff
			if PlayerResource:IsValidPlayer(nPlayerID) and not PlayerResource:IsBroadcaster(nPlayerID) then 
				playercounter=playercounter+1
			end
		end

		GameRules.PLAYER_COUNT = playercounter
		print("Total Players: " .. GameRules.PLAYER_COUNT)

		if npc.bFirstSpawned == nil then
			npc.bFirstSpawned = true

			--Add Ankh
			local item = CreateItem("item_ankh", npc, npc)
			npc:AddItem(item)

			Warchasers:OnHeroInGame(npc)

			-- Developer Tools
			if Convars:GetBool("developer") then
				local item = CreateItem("item_cosmetic_scythe", npc, npc) --testing items
				npc:AddItem(item)

				-- Test Unit
				local dummy1 = CreateUnitByName("npc_small_murloc", npc:GetAbsOrigin()+Vector(200, 200, 0), true, nil, nil, DOTA_TEAM_GOODGUYS)			
				Timers:CreateTimer(0.1, function() 
					FindClearSpaceForUnit(dummy1, npc:GetAbsOrigin(), true) 
					dummy1:SetControllableByPlayer(0, true)
					dummy1:Stop() 
				end)
			end
			
		elseif npc.bFirstSpawned == true then --respawn through Ankh
			--Warchasers:ModifyStatBonuses(spawnedUnitIndex)
			Warchasers:OnHeroInGame(npc)
			npc:SetHealth(500) --it's a little more based on the STR
			print(npc:GetHealth())
		end
	end
end

function Warchasers:OnHeroInGame(hero)
	print("Hero Spawned")

	GameRules.PLAYERS_PICKED_HERO=GameRules.PLAYERS_PICKED_HERO+1

	print("Total Players In Game: " .. GameRules.PLAYER_COUNT)
	print("Players with a hero picked: " .. GameRules.PLAYERS_PICKED_HERO)

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
    if (GameRules.PLAYERS_PICKED_HERO==GameRules.PLAYER_COUNT) then
    	Warchasers:OnEveryonePicked()
    end

end

function Warchasers:OnEveryonePicked()
    --GameRules:GetGameModeEntity():SetThink("SoundThink", self) --DISABLED FOR NOW
    GameRules:SendCustomMessage("Welcome to <font color='#2EFE2E'>Warchasers!</font>", 0, 0) -- ##9A2EFE
    GameRules:SendCustomMessage("Ported by <font color='#2EFE2E'>Noya</font> & <font color='#2EFE2E'>igo</font>", 0, 0)
    GameRules:SendCustomMessage("Version: " .. WARCHASERS_VERSION, 0, 0)
    GameRules:SendCustomMessage("Please report bugs and leave feedback in our workshop page", 0, 0)

    --[[Warchasers:OnEveryoneVoted()

    Timers:CreateTimer(5, function()	
	    GameRules:SendCustomMessage("Difficulty Level: <font color='#2EFE2E'>Reborn</font>", 0, 0)
	    GameRules:SendCustomMessage("Higher difficulty levels will be added as soon as we fix some bugs.<br>Thank you for playing, enjoy your run!", 0, 0)
    end)]]

    GameRules:SendCustomMessage("<br>2 minutes to select a difficulty",0,0)
    Timers:CreateTimer(60,function() if not GameRules.difficulty_selected then GameRules:SendCustomMessage("60 seconds remaining",0,0) end end)
    Timers:CreateTimer(90,function() if not GameRules.difficulty_selected then GameRules:SendCustomMessage("30 seconds remaining",0,0) end end)
    Timers:CreateTimer(110,function() if not GameRules.difficulty_selected then GameRules:SendCustomMessage("10 seconds remaining!",0,0) end end)
    Timers:CreateTimer(120,function() if not GameRules.difficulty_selected then Warchasers:OnEveryoneVoted() end end)
end

--Item checking
function Warchasers:OnItemPickedUp( event )
	local item_handle = EntIndexToHScript(event.ItemEntityIndex)
	if event.HeroEntityIndex ~= nil then
		local picker_handle = EntIndexToHScript(event.HeroEntityIndex) 
		item_handle:SetPurchaser(picker_handle)
	end
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

	if killedUnit:GetUnitName() == "npc_boss" then
		ScreenShake(killerEntity:GetAbsOrigin(), 50.0, 50.0, 5.0, 9000, 0, true)
		PlayerResource:SetCameraTarget(killerEntity:GetPlayerOwnerID(), killedUnit)
		EmitGlobalSound("diretide_roshdeath_Stinger")
		boss_dead() --endgame message
		local messageinfo = { message = "YOU DEFEATED", duration = 5}
		FireGameEvent("show_center_message",messageinfo)
		Warchasers:PrintEndgameMessage()
		Timers:CreateTimer(15, function() GameRules:MakeTeamLose( DOTA_TEAM_BADGUYS) end)
	end

	if killedUnit:GetUnitName() == "npc_doom_miniboss" then
		AnnouncerProgress()
		EmitGlobalSound("n_creep_dragonspawnOverseer.Death")

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

	--creep death sounds
	if killedUnit:GetUnitName() == "npc_archer_gnoll" then
		EmitGlobalSound("Warchasers.GnollDeath")
	elseif killedUnit:GetUnitName() == "npc_small_murloc_a" or killedUnit:GetUnitName() == "npc_small_murloc_b" or killedUnit:GetUnitName() == "npc_small_murloc"
		or killedUnit:GetUnitName() == "npc_medium_murloc" or killedUnit:GetUnitName() == "npc_big_murloc" then
		EmitGlobalSound("Warchasers.MurlocDeath")
	elseif killedUnit:GetUnitName() == "npc_small_dragon" then
		EmitGlobalSound("n_creep_blackdrake.Death")
	elseif killedUnit:GetUnitName() == "npc_blue_drake" then
		EmitGlobalSound("n_creep_blackdragon.Death")
	elseif killedUnit:GetUnitName() == "npc_green_lizard" or killedUnit:GetUnitName() == "npc_red_lizard" or killedUnit:GetUnitName() == "npc_blue_lizard" then
		EmitGlobalSound("n_creep_Thunderlizard_Big.Death")
	elseif killedUnit:GetUnitName() == "npc_mud_golem" or killedUnit:GetUnitName() == "npc_rock_golem" or killedUnit:GetUnitName() == "npc_rock_golem_spawn" then
		EmitGlobalSound("n_creep_golemRock.Death")
	elseif killedUnit:GetUnitName() == "npc_water_elemental" or killedUnit:GetUnitName() == "npc_water_elemental_nonspawned" 
		or killedUnit:GetUnitName() == "warchasers_beast_knight_water_elemental_3" or killedUnit:GetUnitName() == "warchasers_beast_knight_water_elemental_2"
		or killedUnit:GetUnitName() == "warchasers_beast_knight_water_elemental_1" then
		EmitGlobalSound("Hero_Morphling.Death")
	elseif killedUnit:GetUnitName() ==  "npc_ogre" then
		EmitGlobalSound("n_creep_ogres.Death")
	elseif killedUnit:GetUnitName() ==  "npc_wizard" or killedUnit:GetUnitName() == "npc_wizard_nonspawned" or killedUnit:GetUnitName() == "npc_big_wizard" then
		EmitGlobalSound("Hero_KeeperOfTheLight.Death")
	elseif killedUnit:GetUnitName() == "npc_doom_guard" or killedUnit:GetUnitName() == "npc_soul_smasher" or killedUnit:GetUnitName() == "npc_doom_guard_spawn"then
		EmitGlobalSound("Warchasers.DoomGuardDeath")
	elseif killedUnit:GetUnitName() ==  "npc_wendigo" or killedUnit:GetUnitName() ==  "npc_furbolg" or killedUnit:GetUnitName() == "npc_big_satyr" or killedUnit:GetUnitName() ==  "npc_furbolg_spawn" then
		EmitGlobalSound("n_creep_centaurKhan.Death")
	elseif killedUnit:GetUnitName() ==  "npc_infernal" or killedUnit:GetUnitName() ==  "npc_furbolg" or killedUnit:GetUnitName() == "npc_big_satyr" then
		EmitGlobalSound("Hero_Warlock.Death")
	end

	if killedUnit:GetUnitName() == "npc_tb_miniboss" then

		EmitGlobalSound("Hero_Terrorblade.Death")
		AnnouncerProgress()

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

	if killedUnit:GetUnitName() == "npc_kitt_steamtank" then
		AnnouncerProgress()
		local door = Entities:FindByName(nil, "gate_tanks")
        if door ~= nil then
            print("Door detected")
            door:Kill()
        end

        local obstructions = Entities:FindByName(nil, "obstructions_tanks_1")
        obstructions:SetEnabled(false,false)
        local obstructions = Entities:FindByName(nil, "obstructions_tanks_2")
        obstructions:SetEnabled(false,false)
        local obstructions = Entities:FindByName(nil, "obstructions_tanks_3")
        obstructions:SetEnabled(false,false)
		local obstructions = Entities:FindByName(nil, "obstructions_tanks_4")
        obstructions:SetEnabled(false,false)
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

    	if KilledPlayerID==0 and GameRules.P0_ANKH_COUNT <= 0 then  
    		--[[GameRules.DEAD_PLAYER_COUNT=GameRules.DEAD_PLAYER_COUNT+1
    		respawning=false
    		GameRules.Player0DEAD = true]]

    		--Fire the event. The second parameter is an object with all the event's parameters as properties
   			FireGameEvent('warchasers_player_died', { player_ID = 0 })
    	end

    	if KilledPlayerID==1 and GameRules.P1_ANKH_COUNT <= 0 then  
    		--[[GameRules.DEAD_PLAYER_COUNT=GameRules.DEAD_PLAYER_COUNT+1
    		respawning=false
    		GameRules.Player1DEAD = true]]
    		FireGameEvent('warchasers_player_died', { player_ID = 1 })
    	end
	      
	    if KilledPlayerID==2 and GameRules.P2_ANKH_COUNT <= 0 then  
    		--[[GameRules.DEAD_PLAYER_COUNT=GameRules.DEAD_PLAYER_COUNT+1
    		respawning=false
    		GameRules.Player2DEAD = true]]
    		FireGameEvent('warchasers_player_died', { player_ID = 2 })
    	end

    	if KilledPlayerID==3 and GameRules.P3_ANKH_COUNT <= 0 then  
    		--[[GameRules.DEAD_PLAYER_COUNT=GameRules.DEAD_PLAYER_COUNT+1
    		respawning=false
    		GameRules.Player3DEAD = true]]
    		FireGameEvent('warchasers_player_died', { player_ID = 3 })
    	end

    	if KilledPlayerID==4 and GameRules.P4_ANKH_COUNT <= 0 then  
    		--[[GameRules.DEAD_PLAYER_COUNT = GameRules.DEAD_PLAYER_COUNT+1
    		respawning=false
    		GameRules.Player4DEAD = true]]
    		FireGameEvent('warchasers_player_died', { player_ID = 4 })
    	end 
 	
	end

	--Count Creep kills as scoreboard kills
	if not killedUnit:IsRealHero() and killedUnit:GetTeam() ~= DOTA_TEAM_GOODGUYS then
		print("1 mob dead")
	    self.nRadiantKills = self.nRadiantKills + 1
	    --update personal score
		if killerEntity:GetOwner() ~= nil and not killerEntity:IsRealHero() and killerEntity:GetTeam() == DOTA_TEAM_GOODGUYS then 
				--it's a friendly summon killing something, credit to the owner
				if killerEntity:GetOwner() ~= nil and killerEntity:GetOwner():IsRealHero() then
					killerEntity:GetOwner():IncrementKills(1)
				end
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

function Warchasers:TestTank()
	local hero = PlayerResource:GetSelectedHeroEntity(0)
	TeleporterTanksStart()
end






-- register the 'PlayerVotedDifficulty' command in our console
Convars:RegisterCommand( "PlayerVotedDifficulty", function(name, p)
    --get the player that sent the command
    local cmdPlayer = Convars:GetCommandClient()
    if cmdPlayer then 
        --if the player is valid, register the vote
        return Warchasers:UpdateVotes( cmdPlayer , p)
    end
end, "A player voted a difficulty", 0 )

function Warchasers:UpdateVotes( player, difficulty )
    
    --get the player's ID
    local pID = player:GetPlayerID()

    --get the hero handle
    local hero = player:GetAssignedHero()

    if not GameRules.difficulty_selected then
		table.insert(GameRules.PLAYER_VOTES,difficulty)
		print("========VOTE TABLE========")
		DeepPrintTable(GameRules.PLAYER_VOTES)
		print("==========================")

	  	local difficulty_level = 0
	    for k,v in pairs(GameRules.PLAYER_VOTES) do
	    	difficulty_level = difficulty_level + v
	    end

	    difficulty_level = difficulty_level / #GameRules.PLAYER_VOTES
	    print("Average: " ..difficulty_level)
	    difficulty_level = math.floor(difficulty_level+0.5)
	    print("Rounded difficulty: ".. difficulty_level)
	    GameRules.DIFFICULTY = difficulty_level

	    if (#GameRules.PLAYER_VOTES==GameRules.PLAYER_COUNT) then
	    	Warchasers:OnEveryoneVoted()
	    end
	end
end

function Warchasers:OnEveryoneVoted()
	
	--Fire Game Event to our UI
	FireGameEvent('warchasers_finished_voting', {})

    GameRules:SendCustomMessage("<font color='#2EFE2E'>Finished voting!</font>", 0, 0)

    -- Set the difficulty here.
    GameRules.difficulty_selected = true
    add_affixes_to_pre_dificulty_creeps()

    -- Change this to the proper strings later
    if GameRules.DIFFICULTY == 0 then
    	GameRules:SendCustomMessage("Difficulty Level: <font color='#2EFE2E'>Classic</font>", 0, 0)
    	GameRules:SendCustomMessage("Hey, Not Too Rough", 0, 0)
    elseif GameRules.DIFFICULTY == 1 then
    	GameRules:SendCustomMessage("Difficulty Level: <font color='#2EFE2E'>Ascendant (1)</font>", 0, 0)
    	GameRules:SendCustomMessage("Bring it on!", 0, 0)
    elseif GameRules.DIFFICULTY == 2 then
    	GameRules:SendCustomMessage("Difficulty Level: <font color='#2EFE2E'>Elder (2)</font>", 0, 0)
    	GameRules:SendCustomMessage("Hurt Me Plenty", 0, 0)
    elseif GameRules.DIFFICULTY == 3 then
    	GameRules:SendCustomMessage("Difficulty Level: <font color='#2EFE2E'>Mythical (3)</font>", 0, 0)
    	GameRules:SendCustomMessage("Ultra-Violence" , 0, 0)
    elseif GameRules.DIFFICULTY == 4 then
    	GameRules:SendCustomMessage("Difficulty Level: <font color='#2EFE2E'>Legendary (4)</font>", 0, 0)
    	GameRules:SendCustomMessage("Nightmare!" , 0, 0)
    end

    -- Add settings to our stat collector
    --[[statcollection.addStats({
        modes = {
            difficulty = GameRules.DIFFICULTY
        }
    })]]

    -- Find the barrier_voting and obstructions_voting entities in the map and disable them
    local barrier = Entities:FindByName(nil,"barrier_voting")
	barrier:RemoveSelf()

	local obstructions = Entities:FindAllByName("obstructions_voting")
	for _,v in pairs(obstructions) do
		v:SetEnabled(false,false)
		print("Obstructions disabled")
	end
	
end

-- register the 'RespawnAsGhost' command in our console
Convars:RegisterCommand( "RespawnAsGhost", function(name, p)
    --get the player that sent the command
    local cmdPlayer = Convars:GetCommandClient()
    if cmdPlayer then 
        --if the player is valid, register the vote
        return Warchasers:RespawnAsGhost( cmdPlayer )
    end
end, "A player wants to keep playing", 0 )

function Warchasers:RespawnAsGhost( player )
	--get the player's ID
    local pID = player:GetPlayerID()

    --get the hero handle
    local hero = player:GetAssignedHero()

    if hero:UnitCanRespawn() then
    	hero:SetRespawnPosition(GameRules.CURRENT_SAVEPOINT:GetAbsOrigin())
    	hero:RespawnHero(false, false, false)
	end
end

-- register the 'GG' command in our console
Convars:RegisterCommand( "GG", function(name, p)
    --get the player that sent the command
    local cmdPlayer = Convars:GetCommandClient()
    if cmdPlayer then 
        --if the player is valid, register the vote
        return Warchasers:GG( cmdPlayer )
    end
end, "A player gives up", 0 )

function Warchasers:GG( player )
	 --get the player's ID
    local pID = player:GetPlayerID()

    GameRules:SendCustomMessage(PlayerResource:GetPlayerName(pID).." has lost its soul forever...", 0, 0)
    GameRules.DEAD_PLAYER_COUNT = GameRules.DEAD_PLAYER_COUNT+1

    --this should keep the respawn at 999 forever if they GG out.
    --[[if pID == 0 then
    	GameRules.Player0DEAD = true
    elseif pID == 1 then
    	GameRules.Player1DEAD = true
    elseif pID == 2 then
    	GameRules.Player2DEAD = true
    elseif pID == 3 then
    	GameRules.Player3DEAD = true
    elseif pID == 4 then
    	GameRules.Player4DEAD = true
    end]]

    --Check for defeat
 	print("Dead Players: " .. GameRules.DEAD_PLAYER_COUNT)
 	print("Total Players: " .. GameRules.PLAYER_COUNT)
	if GameRules.DEAD_PLAYER_COUNT == GameRules.PLAYER_COUNT then
		print("THEY'RE ALL DEAD BibleThump")
		local messageinfo = { message = "RIP IN PIECES", duration = 5}
		FireGameEvent("show_center_message",messageinfo)
		Warchasers:PrintEndgameMessage()
		Timers:CreateTimer(15, function() GameRules:MakeTeamLose( DOTA_TEAM_GOODGUYS) end)		
	end
end

function Warchasers:PrintEndgameMessage()

	Timers:CreateTimer(5, function() GameRules:SendCustomMessage("<font color='#DBA901'><br>Game will end in 10 seconds</font>",0,0) end)
	Timers:CreateTimer(10, function() GameRules:SendCustomMessage("<font color='#DBA901'>Please leave your feedback at our workshop page</font>",0,0) end)

	--Send stats
	--Timers:CreateTimer(10, function() statcollection.sendStats() end)
	Timers:CreateTimer(12, function() GameRules:SendCustomMessage("<font color='#DBA901'>3</font>",0,0) end)
	Timers:CreateTimer(13, function() GameRules:SendCustomMessage("<font color='#DBA901'>2</font>",0,0) end)
	Timers:CreateTimer(14, function() GameRules:SendCustomMessage("<font color='#DBA901'>1...</font>",0,0) end)
end