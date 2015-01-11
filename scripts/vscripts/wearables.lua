-- Works decent on Sven, apart from all sven swords
-- Axe models/items/axe/gross/gross.vmdl
-- Katana models/items/juggernaut/generic_sword_nodachi.vmdl
-- Jugg has many working models/items/juggernaut/dragon_sword.vmdl
-- PA blade models/items/phantom_assassin/sentblade_001/sentblade_001.vmdl
-- Warglaive models/items/spectre/tr_weapon/tr_weapon.vmdl
-- Scythe models/items/abaddon/phantoms_reaper/phantoms_reaper.vmdl
-- Scythe models/items/axe/reaper_scythe/reaper_scythe.vmdl
-- BigassSword models/items/brewmaster/wep_brewmaster_cleaver_01/wep_brewmaster_cleaver_01.vmdl (a bit off)
-- Centaur weapons are attached but are way off
-- CM Staff models/items/crystal_maiden/dragonfish_sceptre/dragonfish_sceptre.vmdl
-- Dazzul Deso models/items/dazzle/shadowflame_weapon/shadowflame_weapon.vmdl
-- Furion models/items/furion/natures_grasp/natures_grasp.vmdl a bit off
-- Magnus questionable models/items/magnataur/magnoceri_weapon/magnoceri_weapon.vmdl
-- Looks sick models/items/necrolyte/death_protest_weapon/death_protest_weapon.vmdl
-- Most Necrolyte scythes work fine like models/items/necrolyte/tenplagues_necrolyte_weapon/tenplagues_necrolyte_weapon.vmdl
-- OmniHammers models/items/omniknight/omnivus.vmdl models/items/omniknight/guardofbasilius_weapon/guardofbasilius_weapon.vmdl
-- Excellent Hammer models/items/omniknight/magmallet/magmallet.vmdl
-- PL Lances models/items/phantom_lancer/eye_of_niuhi/eye_of_niuhi.vmdl models/items/phantom_lancer/diffusal_lance/diffusal_lance.vmdl
-- MKB models/items/phantom_lancer/infinite_waves_serpent_weapon/infinite_waves_serpent_weapon.vmdl
-- Rubick Aghs models/items/rubick/weapon_agh/weapon_agh.vmdl
-- Naga models/items/siren/exile_offhand_weapon/exile_offhand_weapon.vmdl
-- More Naga models/items/siren/slashing_quickslicer/slashing_quickslicer.vmdl
-- WK models/items/skeleton_king/spine_splitter/spine_splitter.vmdl
-- HOLY SHIT models/items/slardar/trident_of_the_deep_one/trident_of_the_deep_one.vmdl
-- More Slardar models/items/slardar/royal_guard_trident/royal_guard_trident.vmdl
-- SB models/items/spirit_breaker/sb_ice_weapon_final/sb_ice_weapon_final.vmdl
-- SB models/items/spirit_breaker/fury_weapon/fury_weapon.vmdl
-- Staff models/items/warlock/gemstaff/gemstaff.vmdl
-- Warlock staffs models/items/warlock/breathofdeath_weapon/breathofdeath_weapon.vmdl
-- WD models/items/witchdoctor/demon_skull_staff.vmdl

-- Abaddon
-- Omoz models/items/doom/weapon_eyeoffetitzu/weapon_eyeoffetitzu.vmdl

function EquipWeapon( event )
    local hero = event.caster
    local newWeaponModel = "models/items/necrolyte/heretic_weapon/heretic_weapon.vmdl"
    if hero.originalWeaponModel == nil then
    	hero.originalWeaponModel = "models/heroes/sven/sven_sword.vmdl"
    end

    local model = hero:FirstMoveChild()
    while model ~= nil do
        if model:GetClassname() ~= "" and model:GetClassname() == "dota_item_wearable" then
            local modelName = model:GetModelName()
            if modelName == hero.originalWeaponModel then
                -- Set the weapon model, save both the new and original model names in the caster handle to call OnUnequip
                print("FOUND "..modelName.." SWAPPING TO "..newWeaponModel)
                hero.originalWeaponModel = modelName
                hero.weapon = newWeaponModel
                model:SetModel(newWeaponModel)
            end
        end
        model = model:NextMovePeer()
        if model ~= nil and model:GetModelName() ~= "" then
            print("Next Peer:" .. model:GetModelName())
        end
    end
    print("------------------------")
end

function UnequipWeapon( event )
    local hero = event.caster
    local originalWeaponModel = hero.originalWeaponModel
    local currentWeapon = hero.weapon

    local model = hero:FirstMoveChild()
    while model ~= nil do
        if model:GetClassname() ~= "" and model:GetClassname() == "dota_item_wearable" then
            local modelName = model:GetModelName()
            -- Set the weapon model back to the original
            if modelName == currentWeapon then
                hero.weapon = originalWeaponModel
                model:SetModel(originalWeaponModel)
            end
        end
        model = model:NextMovePeer()
        if model ~= nil and model:GetModelName() ~= "" then
            print("Next Peer:" .. model:GetModelName())
        end
    end

    print("------------------------")
end
