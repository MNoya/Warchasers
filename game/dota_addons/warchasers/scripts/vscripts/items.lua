
function cloak_of_shadows_cast( event )
    event.caster:AddAbility("templar_assassin_meld")

    event.caster:CastAbilityImmediately(event.caster:FindAbilityByName("templar_assassin_meld"), event.caster:GetPlayerOwnerID())
    event.caster:Stop()
    event.caster:SetContextThink("meld_removal", function() 
                                                if event.caster:HasModifier("modifier_templar_assassin_meld") == false then
                                                    event.caster:RemoveAbility("templar_assassin_meld")
                                                    return nil
                                                else
                                                    return 0.5
                                                end 
                                                end,
                                                0)
    

end

function consumable_check( item_name )
    if string.find(item_name, "tome") ~= nil then
        return "tome"
    elseif string.find(item_name, "potion") ~= nil then
        return "potion"
    else
        return "for_sale"
    end
end

function items_attack( event )
    if event.target.GetContainedItem ~= nil then
        local item = event.target:GetContainedItem()
        event.target:RemoveSelf()
        item:SetPurchaser(event.attacker)
        local type_of_item = consumable_check(item:GetName() )
        if type_of_item == "potion" then
            event.attacker:AddItem(item)
            event.attacker:CastAbilityNoTarget(item, event.attacker:GetPlayerOwnerID())
        elseif type_of_item == "tome" then
            event.attacker:AddItem(item)
        elseif type_of_item == "for_sale" then
            local itemSellPrice = (item:GetCost() * 0.5)
            event.attacker:ModifyGold(itemSellPrice, false, 0) 
            event.attacker:EmitSound("General.Sell")
            
            local goldPopUp = require("popups")
            PopupGoldGain(event.attacker, itemSellPrice)

            item:RemoveSelf()
        end
    end
end


function DropItemOnDeath(event) -- event is the information sent by the ability
    print( "DropItemOnDeath Called" )
    local killedUnit = EntIndexToHScript( event.caster_entindex ) -- EntIndexToHScript takes the event.caster_entindex, which is the number assigned to the entity that ran the function from the ability, and finds the actual entity from it.
    local itemName = tostring(event.ability:GetAbilityName()) -- In order to drop only the item that ran the ability, the name needs to be grabbed. event.ability gets the actual ability and then GetAbilityName() gets the configname of that ability such as juggernaut_blade_dance.
    if killedUnit:IsHero() or killedUnit:HasInventory() then -- In order to make sure that the unit that died actually has items, it checks if it is either a hero or if it has an inventory.
        if not hasAnkh(killedUnit) then
            print("No Ankh detected, dropping item`")
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
end

function hasAnkh(hero)
    --Ankhs are used before we can get the hero killed, so we need to compare the global ANKH_COUNT variable
    local nPlayerID = hero:GetPlayerID()

    if nPlayerID == 0 then
        return (GameRules.P0_ANKH_COUNT>0)
     elseif nPlayerID == 1 then
        return (GameRules.P1_ANKH_COUNT>0)
    elseif nPlayerID == 2 then
        return (GameRules.P2_ANKH_COUNT>0)
    elseif nPlayerID == 3 then
        return (GameRules.P3_ANKH_COUNT>0)
    elseif nPlayerID == 4 then
        return (GameRules.P4_ANKH_COUNT>0)
    end
end

function DropFrostmourne(event)
    local killedUnit = EntIndexToHScript( event.caster_entindex )
    local itemName = tostring(event.ability:GetAbilityName()) 
    if killedUnit:IsHero() or killedUnit:HasInventory() then 
        for itemSlot = 0, 5, 1 do
            if killedUnit ~= nil then
                local Item = killedUnit:GetItemInSlot( itemSlot )
                if Item ~= nil and Item:GetName() == itemName then
                    local newItem = CreateItem(itemName, nil, nil)
                    CreateItemOnPositionSync(killedUnit:GetOrigin(), newItem)
                    killedUnit:RemoveItem(Item)
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
    local unit_hp = unit:GetHealth()
    if unit:GetLevel() < 6 then
        unit:Stop()
        unit:SetTeam( DOTA_TEAM_GOODGUYS )
        unit:SetOwner(hero)
        unit:SetControllableByPlayer( hero:GetPlayerOwnerID(), true )
        event.ability:ApplyDataDrivenModifier( hero, unit, "item_scepter_of_mastery_dominate_modifier", nil)
        unit:RespawnUnit()
        unit:SetHealth(unit_hp)
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
    if picker:IsRealHero() == false then
    	picker = picker:GetPlayerOwner():GetAssignedHero()
    end
    if picker:HasModifier("tome_health_modifier") == false then
        tome:ApplyDataDrivenModifier( picker, picker, "tome_health_modifier", nil)
        picker:SetModifierStackCount("tome_health_modifier", picker, 30)
        picker.HealthTomesStack = 0
    else
        picker:SetModifierStackCount("tome_health_modifier", picker, (picker:GetModifierStackCount("tome_health_modifier", picker) + 30))
    end
    --print(event.caster:GetModifierStackCount("tome_health_modifier", nil))

    local TomePopUp = require("popups")
    PopupHealthTome(picker, 30)
end

function StrengthTomeUsed( event )
    local picker = event.caster
    local tome = event.ability
    local statBonus = event.bonus_stat
    --casterUnit:SetBaseStrength( casterUnit:GetBaseStrenght() + 1 )
    --casterUnit:ModifyStrength(statBonus)
    if picker:IsRealHero() == false then
    	picker = picker:GetPlayerOwner():GetAssignedHero()
    end


    if picker:HasModifier("tome_strenght_modifier") == false then
        tome:ApplyDataDrivenModifier( picker, picker, "tome_strenght_modifier", nil)
        picker:SetModifierStackCount("tome_strenght_modifier", picker, statBonus)
    else
        picker:SetModifierStackCount("tome_strenght_modifier", picker, (picker:GetModifierStackCount("tome_strenght_modifier", picker) + statBonus))
    end
    --SetModifierStackCount(string modifierName, handle b, int modifierCount) 
    --GetModifierStackCount(string modifierName, handle b) 
    
    local TomePopUp = require("popups")
    PopupStrTome(picker, statBonus)
end

function AgilityTomeUsed( event )
    local picker = event.caster
    local tome = event.ability
    local statBonus = event.bonus_stat
    --casterUnit:SetBaseAgility( casterUnit:GetBaseAgility() + 1 )
    --casterUnit:ModifyAgility(statBonus)
    if picker:IsRealHero() == false then
    	picker = picker:GetPlayerOwner():GetAssignedHero()
    end
    if picker:HasModifier("tome_agility_modifier") == false then
        tome:ApplyDataDrivenModifier( picker, picker, "tome_agility_modifier", nil)
        picker:SetModifierStackCount("tome_agility_modifier", picker, statBonus)
    else
        picker:SetModifierStackCount("tome_agility_modifier", picker, (picker:GetModifierStackCount("tome_agility_modifier", picker) + statBonus))
    end

    local TomePopUp = require("popups")
    PopupAgiTome(picker, statBonus)
end

function IntellectTomeUsed( event )
    local picker = event.caster
    local tome = event.ability
    local statBonus = event.bonus_stat
    --casterUnit:SetBaseIntellect( casterUnit:GetBaseIntellect() + 1 )
    --casterUnit:ModifyIntellect(statBonus)
    if picker:IsRealHero() == false then
    	picker = picker:GetPlayerOwner():GetAssignedHero()
    end
    if picker:HasModifier("tome_intelect_modifier") == false then
        tome:ApplyDataDrivenModifier( picker, picker, "tome_intelect_modifier", nil)
        picker:SetModifierStackCount("tome_intelect_modifier", picker, statBonus)
    else
        picker:SetModifierStackCount("tome_intelect_modifier", picker, (picker:GetModifierStackCount("tome_intelect_modifier", picker) + statBonus))
    end

    local TomePopUp = require("popups")
    PopupIntTome(picker, statBonus)
end

function Heal(event)
    event.caster:GetPlayerOwner():GetAssignedHero():Heal(event.heal_amount, event.caster)
    local HealingPopUp = require("popups")
    PopupHealing(event.caster, event.heal_amount)
end

function ReplenishMana(event)
    event.caster:GetPlayerOwner():GetAssignedHero():GiveMana(event.mana_amount)
    local ManaPopUp = require("popups")
    PopupMana(event.caster, event.mana_amount)
end

function ReplenishManaAOE(event)

    -- Find units
    units = FindUnitsInRadius(event.caster:GetTeamNumber(),
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

    --event.target:SetModel(DKMODEL) & setRenderColor or try to change the skin
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

function FrostmourneAttack(event)
    --Deal 5% of the target's current health in physical damage
    ApplyDamage({
                    victim = event.target,
                    attacker = event.caster,
                    damage = event.target:GetHealth() * 0.05,
                    damage_type = DAMAGE_TYPE_PHYSICAL
                    })
end

function FrostmourneRuin(event)
    --take 15% of targets max HP
    local targetHP = event.target:GetMaxHealth() * 0.15
    ApplyDamage({
                    victim = event.target,
                    attacker = event.caster,
                    damage = event.target:GetMaxHealth() * 0.15,
                    damage_type = DAMAGE_TYPE_PHYSICAL
                    })
    event.caster:Heal(targetHP, event.caster)
    local coil = ParticleManager:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_aphotic_shield_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, event.target)
    ParticleManager:SetParticleControl(coil, 0, event.target:GetAbsOrigin())

end

function GuldanSkull(event)

    local hero = EntIndexToHScript( event.caster_entindex )
    --hero:SetRenderColor(0, 0, 0)
    hero:SetModel("models/heroes/warlock/warlock_demon.vmdl")
    local feet_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/terrorblade_feet_effects.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)

    local transform_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis_transform.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)

    if hero:IsRangedAttacker() then
        hero:SetRangedProjectileName("particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis_base_attack.vpcf")
    else
        hero:SetAttackCapability(2)
        hero:SetRangedProjectileName("particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis_base_attack.vpcf")
    end

    if hero:HasModifier("modifier_warchasers_solo_buff") then
        print("Removed Modifier")
        hero:RemoveModifierByName("modifier_warchasers_solo_buff")
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

                local dummy = Vector(118, 2185,136)
                local allCreepsNear = Entities:FindAllByClassnameWithin("npc_dota_creature", dummy, 1000)
                for i = 1, #allCreepsNear, 1 do
                    local creep = allCreepsNear[i]
                    local name = creep:GetUnitName()
                    if name == "vision_dummy_minor" then
                        creep:ForceKill(true)
                        print("Vision dummy killed")
                    end
                end

            end
        end              
    end
end