function DropItemOnDeath(event) -- event is the information sent by the ability
    print( "DropItemOnDeath Called" )
    local killedUnit = EntIndexToHScript( event.caster_entindex ) -- EntIndexToHScript takes the event.caster_entindex, which is the number assigned to the entity that ran the function from the ability, and finds the actual entity from it.
    local itemName = tostring(event.ability:GetAbilityName()) -- In order to drop only the item that ran the ability, the name needs to be grabbed. event.ability gets the actual ability and then GetAbilityName() gets the configname of that ability such as juggernaut_blade_dance.
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

function Ankh( event )
    local killedPosition = event.caster:GetAbsOrigin()
    GameRules:SendCustomMessage("<font color='#9A2EFE'>The Ankh of Reincarnation glows brightly...</font>",0,0)
end

function Dominate( event )
    local hero = event.caster
    local unit = event.target
    if unit:GetLevel() < 6 then
        unit:SetControllableByPlayer( hero:GetPlayerOwner():GetPlayerID(), true )
    end
end

function HealthTomeUsed( event )
    local casterUnit = event.caster
    --casterUnit:SetMaxHealth( casterUnit:GetMaxHealth() + 50 )
    --casterUnit:SetHealth(casterUnit:GetHealth() + 50)
    --BUG: When buying a new item, the Health will reset.
    local item = CreateItem( "item_tome_of_health_modifier", source, source)
    item:ApplyDataDrivenModifier(casterUnit, casterUnit, "modifier_tome_of_health_mod_1", {})
end

function StrengthTomeUsed( event )
    local casterUnit = event.caster
    local statBonus = event.bonus_stat
    --casterUnit:SetBaseStrength( casterUnit:GetBaseStrenght() + 1 )
    casterUnit:ModifyStrength(statBonus)
    
end

function AgilityTomeUsed( event )
    local casterUnit = event.caster
    local statBonus = event.bonus_stat
    --casterUnit:SetBaseAgility( casterUnit:GetBaseAgility() + 1 )
    casterUnit:ModifyAgility(statBonus)
end

function IntellectTomeUsed( event )
    local casterUnit = event.caster
    local statBonus = event.bonus_stat
    --casterUnit:SetBaseIntellect( casterUnit:GetBaseIntellect() + 1 )
    casterUnit:ModifyIntellect(statBonus)
end

function Heal(event)
    event.caster:GetPlayerOwner():GetAssignedHero():Heal(event.heal_amount, event.caster)
end

function ReplenishMana(event)
    event.caster:GetPlayerOwner():GetAssignedHero():GiveMana(event.mana_amount)
end

function ReplenishManaAOE(event)

    -- Find units
    units = FindUnitsInRadius(DOTA_TEAM_GOODGUYS,
                              event.caster:GetAbsOrigin(),
                              nil,
                              250,
                              DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                              DOTA_UNIT_TARGET_ALL,
                              DOTA_UNIT_TARGET_FLAG_NONE,
                              FIND_ANY_ORDER,
                              false)
 
    for _,unit in pairs(units) do
        unit:GetPlayerOwner():GetAssignedHero():GiveMana(event.mana_amount)
    end
end

function CheckForKey(trigger)
    print("Checking for Key")
    local hero = trigger.activator
    local itemName = "item_key1"
    if hero ~= nil then   
        for itemSlot = 0, 5, 1 do
            local Item = hero:GetItemInSlot( itemSlot )
            if Item ~= nil and Item:GetName() == itemName then
                print("Key detected")
                local door = Entities:FindByName(nil, "gate_2")
                if door ~= nil then
                    print("Door detected")
                    door:Kill()
                end

                local hint_trigger = Entities:FindByName(nil,"show_hint_key1")
                   hint_trigger:Disable()

                local obstructions = Entities:FindByName(nil,"obstructions_2_1")
                obstructions:SetEnabled(false,false)

                local obstructions = Entities:FindByName(nil,"obstructions_2_2")
                obstructions:SetEnabled(false,false)
    
                local obstructions = Entities:FindByName(nil,"obstructions_2_3")
                obstructions:SetEnabled(false,false)

                local obstructions = Entities:FindByName(nil,"obstructions_2_4")
                obstructions:SetEnabled(false,false)
				print("Obstructions disabled")

                hero:RemoveItem(Item)
            end
        end              
    end
end

function CheckForKey2(trigger)
    print("Checking for Key")
    local hero = trigger.activator
    local itemName = "item_key2"
    if hero ~= nil then   
        for itemSlot = 0, 5, 1 do
            local Item = hero:GetItemInSlot( itemSlot )
            if Item ~= nil and Item:GetName() == itemName then
                print("Key detected")
                local door = Entities:FindByName(nil, "gate_3")
                if door ~= nil then
                    print("Door detected")
                    door:Kill()
                end
				
				 local hint_trigger = Entities:FindByName(nil,"show_hint_key2")
                   hint_trigger:Disable()

                local obstructions = Entities:FindByName(nil,"obstructions_3_1")
                obstructions:SetEnabled(false,false)

                local obstructions = Entities:FindByName(nil,"obstructions_3_2")
                obstructions:SetEnabled(false,false)
    
                local obstructions = Entities:FindByName(nil,"obstructions_3_3")
                obstructions:SetEnabled(false,false)

                local obstructions = Entities:FindByName(nil,"obstructions_3_4")
                obstructions:SetEnabled(false,false)
                print("Obstructions disabled")

                hero:RemoveItem(Item)
            end
        end              
    end
end

function CheckForKey3(trigger)
    print("Checking for Key")
    local hero = trigger.activator
    local itemName = "item_key3"
    if hero ~= nil then   
        for itemSlot = 0, 5, 1 do
            local Item = hero:GetItemInSlot( itemSlot )
            if Item ~= nil and Item:GetName() == itemName then
                print("Key detected")
                local door = Entities:FindByName(nil, "gate_6")
                if door ~= nil then
                    print("Door detected")
                    door:Kill()
                end
				
				local hint_trigger = Entities:FindByName(nil,"show_hint_key3")
                   hint_trigger:Disable()

                local obstructions = Entities:FindByName(nil,"obstructions_6_1")
                obstructions:SetEnabled(false,false)

                local obstructions = Entities:FindByName(nil,"obstructions_6_2")
                obstructions:SetEnabled(false,false)
    
                local obstructions = Entities:FindByName(nil,"obstructions_6_3")
                obstructions:SetEnabled(false,false)

                local obstructions = Entities:FindByName(nil,"obstructions_6_4")
                obstructions:SetEnabled(false,false)
                print("Obstructions disabled")

                hero:RemoveItem(Item)
            end
        end              
    end
end