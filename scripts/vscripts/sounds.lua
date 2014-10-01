--EmitSound(string soundName) --[[Returns:void ]]
--EmitGlobalSound(string a) --[[Returns:void Play named sound for all players]]


--EmitGlobalSound("DOTA_Item.DustOfAppearance.Activate") --Discovery
--EmitGlobalSound("Hero_Chen.HolyPersuasionEnemy") --Dominated, need to precache Chen

function DoorOpenSound()
	EmitGlobalSound("ui.crafting_slotslide")
end

function BigDoorOpenSound()
    EmitGlobalSound("BARNDOORS_OPEN")
    Timers:CreateTimer({ useGameTime = false, endTime = 1,
        callback = function() EmitGlobalSound("ui.crafting_slotslide") end
    })
end

function ActivationSound()
	EmitGlobalSound("Loot_Drop_Stinger_Short")
end

function Discovery()
	EmitGlobalSound("DOTAMusic_Stinger.007")
end

function FemaleChrorus()
	EmitGlobalSound("General.FemaleLevelUp")
end
