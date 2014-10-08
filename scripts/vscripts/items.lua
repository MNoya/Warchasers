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
        unit:SetControllableByPlayer( hero:GetPlayerOwnerID(), true )
        unit:SetTeam( DOTA_TEAM_GOODGUYS ) --hero:GetTeam()
        unit:SetOwner(hero)
        local item = CreateItem( "item_apply_modifiers", source, source)
        item:ApplyDataDrivenModifier( unit, unit, "modifier_dominated", {})
    end
end

function HealthTomeUsed( event )
    local picker = event.caster
    local tome = event.ability
    local statBonus = event.bonus_stat
    --casterUnit:SetMaxHealth( casterUnit:GetMaxHealth() + 50 )
    --casterUnit:SetHealth(casterUnit:GetHealth() + 50)
    --BUG: When buying a new item, the Health will reset.

    --local item = CreateItem( "item_tome_of_health_modifier", source, source)
    --item:ApplyDataDrivenModifier(casterUnit, casterUnit, "modifier_tome_of_health_mod_1", {})
    if picker:HasModifier("tome_health_modifier") == false then
        tome:ApplyDataDrivenModifier( picker, picker, "tome_health_modifier", nil)
        picker:SetModifierStackCount("tome_health_modifier", picker, 50)
        picker.HealthTomesStack = 0
    else
        picker:SetModifierStackCount("tome_health_modifier", picker, (picker:GetModifierStackCount("tome_health_modifier", picker) + 50))
    end
    --print(event.caster:GetModifierStackCount("tome_health_modifier", nil))
end

function StrengthTomeUsed( event )
    local picker = event.caster
    local tome = event.ability
    local statBonus = event.bonus_stat
    --casterUnit:SetBaseStrength( casterUnit:GetBaseStrenght() + 1 )
    --casterUnit:ModifyStrength(statBonus)
    if picker:HasModifier("tome_strenght_modifier") == false then
        tome:ApplyDataDrivenModifier( picker, picker, "tome_strenght_modifier", nil)
        picker:SetModifierStackCount("tome_strenght_modifier", picker, statBonus)
    else
        picker:SetModifierStackCount("tome_strenght_modifier", picker, (picker:GetModifierStackCount("tome_strenght_modifier", picker) + statBonus))
    end
    --SetModifierStackCount(string modifierName, handle b, int modifierCount) 
    --GetModifierStackCount(string modifierName, handle b) 
    
end

function AgilityTomeUsed( event )
    local picker = event.caster
    local tome = event.ability
    local statBonus = event.bonus_stat
    --casterUnit:SetBaseAgility( casterUnit:GetBaseAgility() + 1 )
    --casterUnit:ModifyAgility(statBonus)
    if picker:HasModifier("tome_agility_modifier") == false then
        tome:ApplyDataDrivenModifier( picker, picker, "tome_agility_modifier", nil)
        picker:SetModifierStackCount("tome_agility_modifier", picker, statBonus)
    else
        picker:SetModifierStackCount("tome_agility_modifier", picker, (picker:GetModifierStackCount("tome_agility_modifier", picker) + statBonus))
    end
end

function IntellectTomeUsed( event )
    local picker = event.caster
    local tome = event.ability
    local statBonus = event.bonus_stat
    --casterUnit:SetBaseIntellect( casterUnit:GetBaseIntellect() + 1 )
    --casterUnit:ModifyIntellect(statBonus)
    if picker:HasModifier("tome_intelect_modifier") == false then
        tome:ApplyDataDrivenModifier( picker, picker, "tome_intelect_modifier", nil)
        picker:SetModifierStackCount("tome_intelect_modifier", picker, statBonus)
    else
        picker:SetModifierStackCount("tome_intelect_modifier", picker, (picker:GetModifierStackCount("tome_intelect_modifier", picker) + statBonus))
    end
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
    event.caster:GetPlayerOwner():GetAssignedHero():GiveMana(event.mana_amount)
end


function DisableRegenOnEnemyNear(event) 
    print("Checking Units in Range")
    local units_in_range = FindUnitsInRadius(   DOTA_TEAM_GOODGUYS,
                                                event.caster:GetAbsOrigin(),
                                                nil,
                                                300,
                                                DOTA_UNIT_TARGET_TEAM_ENEMY,
                                                DOTA_UNIT_TARGET_ALL,
                                                DOTA_UNIT_TARGET_FLAG_NONE,
                                                FIND_ANY_ORDER,
                                                false)   
    if units_in_range[1] ~= nil then
        print("Regen Disabled")
        event.ability:ApplyDataDrivenModifier(hero, hero, "modifier_warchasers_solo_buff_combat", {})
    else 
        print ("No Units Found")
    end
    --event.ability:ApplyDataDrivenModifier(event.caster, event.target, "modifier_warchasers_solo_buff_combat", nil) 

end

function SummonInferno(event)
    local inferno_cast = ParticleManager:CreateParticle("particles/units/heroes/hero_warlock/warlock_rain_of_chaos_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, event.target)
    local inferno_landed = ParticleManager:CreateParticle("particles/units/heroes/hero_warlock/warlock_rain_of_chaos_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, event.target)
    ParticleManager:SetParticleControl(inferno_landed, 0, event.target:GetAbsOrigin())
end

function SummonDoomGuard(event)
    local doomguard = ParticleManager:CreateParticle("particles/units/heroes/hero_doom_bringer/doom_bringer_lvl_death_bonus.vpcf", PATTACH_ABSORIGIN_FOLLOW, event.target)
    ParticleManager:SetParticleControl(doomguard, 0, event.target:GetAbsOrigin())
end

function SummonRedDrake(event)
    local reddrake = ParticleManager:CreateParticle("particles/units/heroes/hero_dragon_knight/dragon_knight_transform_red.vpcf", PATTACH_ABSORIGIN_FOLLOW, event.target)
    ParticleManager:SetParticleControl(reddrake, 0, event.target:GetAbsOrigin())
end

function SummonFellhound(event)
    local fellhound = ParticleManager:CreateParticle("particles/econ/items/doom/doom_f2p_death_effect/doom_bringer_f2p_death.vpcf", PATTACH_ABSORIGIN_FOLLOW, event.target)
    ParticleManager:SetParticleControl(fellhound, 0, event.target:GetAbsOrigin())
end

function SummonTony(event)
    local tony = ParticleManager:CreateParticle("particles/units/heroes/hero_tiny/tiny_death_rocks.vpcf", PATTACH_ABSORIGIN_FOLLOW, event.target)
    ParticleManager:SetParticleControl(tony, 0, event.target:GetAbsOrigin())
    local tony = ParticleManager:CreateParticle("particles/units/heroes/hero_tiny/tiny_transform.vpcf", PATTACH_ABSORIGIN_FOLLOW, event.target)
    ParticleManager:SetParticleControl(tony, 0, event.target:GetAbsOrigin())
end

function SummonFulborg(event)
    local bear = ParticleManager:CreateParticle("particles/units/heroes/hero_lone_druid/lone_druid_bear_spawn.vpcf", PATTACH_ABSORIGIN_FOLLOW, event.target)
    ParticleManager:SetParticleControl(bear, 0, event.target:GetAbsOrigin())
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

                EmitGlobalSound("BARNDOORS_OPEN")
                Timers:CreateTimer({ useGameTime = false, endTime = 1,
                    callback = function() EmitGlobalSound("ui.crafting_slotslide") end
                })
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

                EmitGlobalSound("BARNDOORS_OPEN")
                Timers:CreateTimer({ useGameTime = false, endTime = 1,
                    callback = function() EmitGlobalSound("ui.crafting_slotslide") end
                })
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

                EmitGlobalSound("BARNDOORS_OPEN")
                Timers:CreateTimer({ useGameTime = false, endTime = 1,
                    callback = function() EmitGlobalSound("ui.crafting_slotslide") end
                })
            end
        end              
    end
end