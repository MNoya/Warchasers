-- Begin module
module('statcollectionRPG', package.seeall)

-- Require libs
local JSON = require('lib.json')

-- example of the json files we want to read can be found in http://getdotastats.com/d2mods/list_messages.php

--add require('lib.statcollectionRPG') to addon_game_mode_lua
	-- alternatively add this console command to test it:
		-- Convars:RegisterCommand( "data", function(...) return statcollectionRPG.LoadData() end, "Test Command", FCVAR_CHEAT )


function LoadData()
	print("Loading Data")

	--read the data. local string for now
	local path = "C:\\Program Files (x86)\\Steam\\SteamApps\\common\\dota 2 beta\\dota_ugc\\game\\dota_addons\\warchasers\\scripts\\vscripts\\string.txt"
	local myString = nil

	--need to find a better way to read this.
	file = assert(io.open(path, "r"))
	local line = file:read()
	if string.sub(line, 1, 1) ~= '#' then
	  myString = line
	end
	file:close()

	--DECODING
	local result = JSON:decode(line)

	for k,v in pairs(result.rounds.players) do -- 'round' table has the main info we want to load
		for key,values in pairs(result.rounds.players[k]) do -- for each player
			print(key,values)
			if result.rounds.players[k].steamID32 == PlayerResource:GetSteamAccountID(0) then -- load for that particular SteamID
				-- LoadDataForPlayer
				if key=="items" then
					ClearItemsForPlayer( 0 )
					for _,itemData in pairs(values) do --item data
						--print(itemData.itemName)
						GiveItemToPlayer( 0, itemData.itemName )
					end
				elseif key=="hero" then
					--print(values.heroID)
					if values.heroID == PlayerResource:GetSelectedHeroID(0) then -- load the data for that particular heroID e.g. 18 = Sven
						SetLevelsForPlayer(0 , values)
					end
				elseif key=="abilities" then
					for _,abilityData in pairs(values) do --skill data
						--print(abilityData.abilityName)
						SetAbilityLevelForPlayer(0, abilityData)
					end
				end
			end
		end
		print('------------------------')
	end
end

-- This function takes a hero table and updates playerID
function SetLevelsForPlayer( playerID , table)
	local hero = PlayerResource:GetSelectedHeroEntity(playerID)

	-- Level Up
	--print(table.level)
	local current_hero_level = PlayerResource:GetLevel(playerID) --just to be sure we dont level over the stored level
	local new_hero_level = table.level - current_hero_level
	for i=1,new_hero_level do
		hero:HeroLevelUp(false)
	end

	-- Set Deaths
	--print(table.deaths)
	local current_hero_deaths = PlayerResource:GetDeaths(playerID)
	local new_hero_deaths = table.deaths - current_hero_deaths
	for i=1,new_hero_deaths do
		PlayerResource:IncrementDeaths(playerID)
	end

	-- Set Deaths
	--print(table.gold)
	PlayerResource:SetGold(0, table.gold, false)

	-- Set Lasthits
	--print(table.lastHits)
	local current_hero_lasthits = PlayerResource:GetLastHits(playerID)
	local new_hero_lasthits = table.lastHits - current_hero_lasthits
	for i=1,new_hero_lasthits do
		PlayerResource:IncrementLastHits(playerID)
	end

	-- Set Assists
	--print(table.assists)
	local current_hero_assists = PlayerResource:GetAssists(playerID)
	local new_hero_assists = table.assists - current_hero_assists
	for i=1,new_hero_assists do
		PlayerResource:IncrementAssists(playerID)
	end

	-- Set Kills
	--print(table.kills)
	local current_hero_kills = PlayerResource:GetKills(playerID)
	local new_hero_kills = table.kills - current_hero_kills
	for i=1,new_hero_kills do
		PlayerResource:IncrementKills(playerID,new_hero_kills)
	end

	-- Set Denies
	--print(table.denies)
	local current_hero_denies = PlayerResource:GetDenies(playerID)
	local new_hero_denies = table.denies - current_hero_denies
	for i=1,new_hero_denies do
		PlayerResource:IncrementDenies(playerID)
	end
end

-- This function takes an abilities table and updates the ability for playerID
function SetAbilityLevelForPlayer( playerID , abilityData)
	local hero = PlayerResource:GetSelectedHeroEntity(playerID)

	--print("Setting Skill Level of " .. abilityData.abilityName)
    -- Grab an ability
    local ab = hero:FindAbilityByName(abilityData.abilityName)

    -- Check if it is valid
    if IsValidEntity(ab) then
        -- Set Level of the ability
        ab:SetLevel(abilityData.level)
    end	
end

-- This function removes all the items for playerID, in preparation to give the stored items back
function ClearItemsForPlayer( playerID )
	local hero = PlayerResource:GetSelectedHeroEntity(playerID)
	local itemCount = 0
	while itemCount < 12 do
	    -- Grab an item
	    local item = hero:GetItemInSlot(itemCount)

	    -- Check if the item is valid
	    if IsValidEntity(item) then
	        -- Remove the item
            hero:RemoveItem(item)
        end

	    -- Move onto the next item
	    itemCount = itemCount + 1
	end
end

-- This function gives itemname to playerID
function GiveItemToPlayer( playerID , itemName )
	local hero = PlayerResource:GetSelectedHeroEntity(playerID)
	local newItem = CreateItem(itemName, nil, nil)
	hero:AddItem(newItem)
end