if itemFunctions == nil then
    print ( '[ItemFunctions] creating itemFunctions' )
    itemFunctions = {} -- Creates an array to let us beable to index itemFunctions when creating new functions
    itemFunctions.__index = itemFunctions
end
 
function itemFunctions:new() -- Creates the new class
    print ( '[ItemFunctions] itemFunctions:new' )
    o = o or {}
    setmetatable( o, itemFunctions )
    return o
end
 
function itemFunctions:start() -- Runs whenever the itemFunctions.lua is ran
    print('[ItemFunctions] itemFunctions started!')
end
 
function DropItemOnDeath(keys) -- keys is the information sent by the ability
    print( '[ItemFunctions] DropItemOnDeath Called' )
    local killedUnit = EntIndexToHScript( keys.caster_entindex ) -- EntIndexToHScript takes the keys.caster_entindex, which is the number assigned to the entity that ran the function from the ability, and finds the actual entity from it.
    local itemName = tostring(keys.ability:GetAbilityName()) -- In order to drop only the item that ran the ability, the name needs to be grabbed. keys.ability gets the actual ability and then GetAbilityName() gets the configname of that ability such as juggernaut_blade_dance.
    if killedUnit:IsHero() or killedUnit:HasInventory() then -- In order to make sure that the unit that died actually has items, it checks if it is either a hero or if it has an inventory.
        for itemSlot = 0, 5, 1 do --a For loop is needed to loop through each slot and check if it is the item that it needs to drop
                if killedUnit ~= nil then --checks to make sure the killed unit is not nonexistent.
                        local Item = killedUnit:GetItemInSlot( itemSlot ) -- uses a variable which gets the actual item in the slot specified starting at 0, 1st slot, and ending at 5,the 6th slot.
                        if Item ~= nil and Item:GetName() == itemName then -- makes sure that the item exists and making sure it is the correct item
                            local newItem = CreateItem(itemName, nil, nil) -- creates a new variable which recreates the item we want to drop and then sets it to have no owner
                                CreateItemOnPositionSync(killedUnit:GetOrigin(), newItem) -- takes the newItem variable and creates the physical item at the killed unit's location
                                killedUnit:RemoveItem(Item) -- finally, the item is removed from the original units inventory.
                        end
                end
        end
    end
end

function Increase50HP( keys )
    local casterUnit = keys.caster
    local casterLevel = casterUnit:GetLevel()
    casterUnit:SetMaxHealth( casterUnit:GetMaxHealth() + 50 )
    casterUnit:SetHealth( casterUnit:GetHealth() + 50 )
    
    --hero:ModifyHealth(hero:GetHealth()+50, hero, true, 50)
end

function HealthTomeUsed( keys )
    local casterUnit = keys.caster
    local casterLevel = casterUnit:GetLevel()
    casterUnit:SetMaxHealth( casterUnit:GetMaxHealth() + 50 )
    casterUnit:SetHealth(casterUnit:GetHealth() + 50)
    --BUG: When buying a new item, the Health will reset. 
    --Use ModifyHealth or try to apply a datadriven modifier
end

--[[function HealthTomeUsed( event )
        local playerID = tonumber(event.PlayerID)
        local playerHandle = PlayerResource:GetPlayer(playerID)
        print(playerHandle)
        local unit_to_pick_powerup =  playerHandle:GetAssignedHero()
    unit_to_pick_powerup:SetMaxHealth( unit_to_pick_powerup:GetMaxHealth() + 50 )
    unit_to_pick_powerup:SetHealth( unit_to_pick_powerup:GetHealth() + 50)
end

ListenToGameEvent( "dota_rune_activated_server", HealthTomeUsed, self )--]]

function StrengthTomeUsed( keys )
    local casterUnit = keys.caster
    --casterUnit:SetBaseStrength( casterUnit:GetBaseStrenght() + 1 )
    casterUnit:ModifyStrength(1)
    
end

function AgilityTomeUsed( keys )
    local casterUnit = keys.caster
    --casterUnit:SetBaseAgility( casterUnit:GetBaseAgility() + 1 )
    casterUnit:ModifyAgility(1)
end

function IntellectTomeUsed( keys )
    local casterUnit = keys.caster
    --casterUnit:SetBaseIntellect( casterUnit:GetBaseIntellect() + 1 )
    casterUnit:ModifyIntellect(1)
end

function Heal(keys)
    keys.caster:GetPlayerOwner():GetAssignedHero():Heal(keys.heal_amount, keys.caster)
end

function ReplenishMana(keys)
    keys.caster:GetPlayerOwner():GetAssignedHero():GiveMana(keys.mana_amount)
end