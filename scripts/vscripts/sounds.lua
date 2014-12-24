--EmitGlobalSound(string a) --[[Returns:void Play named sound for all players]]

--StartSoundEvent(string a, handle b) --[[Returns:void Start a sound event]]
--StopSoundEvent(string a, handle b) --[[Returns:void Stops a sound event ]]
--Entity:StopSound(string soundName) --[[Returns:void Stops a named sound playing from this entity. ]]
--Entity:EmitSound(string soundName) --[[Returns:void ]]
--EmitSoundOn(string a, handle b) --[[Returns:void Play named sound on Entity ]]
--GetSoundDuration(string soundName, string actormodelname) 
	--[[Returns:float Returns ''float'' duration of the sound. Takes soundname and optional actormodelname.]]

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

function WorldMusic(event)
	EmitGlobalSound("valve_dota_001.music.ui_world_map")
end

function Level1()
	EmitGlobalSound("valve_dota_001.music.battle_01")
end

function Level2()
	EmitGlobalSound("valve_dota_001.music.battle_02")
end

function Level3()
	EmitGlobalSound("valve_dota_001.music.battle_03")
end

function Level4()
	EmitGlobalSound("valve_dota_001.music.battle_01")
end

function Laning1()
	EmitGlobalSound("valve_dota_001.music.laning_01_layer_01")
end

function Laning2()
	EmitGlobalSound("valve_dota_001.music.laning_02_layer_01")
end

function Laning3() --quiet
	EmitGlobalSound("valve_dota_001.music.laning_03_layer_01")
end

function Ganked()
	EmitGlobalSound("valve_dota_001.music.ganked_lg")
end

function AnnouncerChoose()
	local chooseSound = RandomInt(1,3)
	if chooseSound == 1 then 
		EmitGlobalSound("Warchasers.ChooseHero")
	elseif chooseSound == 2 then 
		EmitGlobalSound("Warchasers.ChooseAHero")
	elseif chooseSound == 3 then 
		EmitGlobalSound("Warchasers.ChooseWisely")
	end
end

function AnnouncerBattle()
	print("To Battle")
	local chooseSound = RandomInt(1,2)
	if chooseSound == 1 then 
		EmitGlobalSound("Warchasers.HeroesRodeOut")
	elseif chooseSound == 2 then 
		EmitGlobalSound("Warchasers.GloriousBattle")
	end
end

function AnnouncerProgress()
	local chooseSound = RandomInt(1,5)
	if chooseSound == 1 then 
		EmitGlobalSound("Warchasers.BravelyDone")
	elseif chooseSound == 2 then 
		EmitGlobalSound("Warchasers.Feat")
	elseif chooseSound == 3 then 
		EmitGlobalSound("Warchasers.Impressive")
	elseif chooseSound == 4 then 
		EmitGlobalSound("Warchasers.PressFurther")
	elseif chooseSound == 5 then 
		EmitGlobalSound("Warchasers.TrailOfDestruction")
	end

end