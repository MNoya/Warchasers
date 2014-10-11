function hint_test(trigger)
	print("Start")
	--GameRules:SendCustomMessage("<font color='#2EFE2E'>HINT</font> Kappa", 0, 0)
	--EmitGlobalSound("valve_dota_001.stinger.respawn")
end

function hint_key1(trigger)
	EmitGlobalSound("General.PingRune")
	GameRules:SendCustomMessage("<font color='#2EFE2E'>HINT</font> - You need the key to open this door.", 0, 0) 
end
function hint_key2(trigger)
	EmitGlobalSound("General.PingRune")
	GameRules:SendCustomMessage("<font color='#2EFE2E'>HINT</font> - You need the key to open this door.", 0, 0) 
end
function hint_key3(trigger)
	EmitGlobalSound("General.PingRune") 
	GameRules:SendCustomMessage("<font color='#2EFE2E'>HINT</font> - You need the key to open this door.", 0, 0) 
end

function hint_keydrop(trigger)
	Timers:CreateTimer({
    endTime = 3,
    callback = function()
      	EmitGlobalSound("General.PingRune")
		GameRules:SendCustomMessage("<font color='#2EFE2E'>HINT</font> - A key has been dropped!", 0, 0) 
    end
  	})
	
end

function announce_open_doors(trigger)
  	Timers:CreateTimer({
    endTime = 2,
    callback = function()
      	EmitGlobalSound("ui.crafting_slotslide") --Minor Door open
		GameRules:SendCustomMessage("The doors have been opened.", 0, 0)
    end
  	})
end
 
function announce_level2(trigger) 
	GameRules:SendCustomMessage("Level <font color='#2E64FE'>2</font> has been opened. Fools enter at its own peril.", 0, 0) 
	EmitGlobalSound("DOTAMusic_Stinger.007")
end

function miniboss2_engage(trigger)
	GameRules:SendCustomMessage("<font color='#DBA901'>Ra'ADoom:</font> COME, HEROES!<br>COME AND CLAIM THE REWARD FOR YOUR SO CALLED HONOR!", 0,0)
	GameRules:GetGameModeEntity():SetCameraDistanceOverride( 1200 )
	EmitGlobalSound("DOTAMusic.Tutorial_Ducker")
	local statue_origin = Vector(-1408, -5780, 256)
	local dummy_statue = CreateUnitByName("vision_dummy_hall", statue_origin, true, nil, nil, DOTA_TEAM_GOODGUYS)
end

function miniboss2_dead(trigger)
	GameRules:SendCustomMessage("<font color='#DBA901'>Ra'ADoom:</font> UNTIL NEXT TIME...HEROES...", 0,0)
	--StopSound("DOTAMusic.Tutorial_Ducker")
	GameRules:GetGameModeEntity():SetCameraDistanceOverride( 1000 )
	local statue_origin = Vector(-1408, -5780, 256)
	local allNPCNear = Entities:FindAllByClassnameWithin("npc_dota_creature", statue_origin, 500)
		for i = 1, #allNPCNear, 1 do
                local creep = allNPCNear[i]
                local name = creep:GetUnitName()
                if name == "vision_dummy_hall" then
                        creep:ForceKill(true)
                        print(name .. " killed")
                end
        end
end

function spiderhall_warning(trigger)
	GameRules:SendCustomMessage("BEHOLD THE HALL OF SPIDERS! If you have the courage, your salvation lies at the end.",0,0)
		Timers:CreateTimer({ useGameTime = false, endTime = 2,
            callback = function() EmitGlobalSound("BARNDOORS_OPEN") end
        })
        Timers:CreateTimer({ useGameTime = false, endTime = 3,
            callback = function() EmitGlobalSound("ui.crafting_slotslide") end
        })
end

function spiderhall_hint(trigger) 
	EmitGlobalSound("General.PingRune")
	GameRules:SendCustomMessage("<font color='#2EFE2E'>HINT</font> - If you can reach the magic circle at the end of the hall, all the spiders are killed.", 0, 0) 
end

function spiderhall_kill(trigger)
	GameRules:SendCustomMessage("All Spiders were destroyed.", 0,0)
	EmitGlobalSound("Hero_Omniknight.GuardianAngel.Cast")
	local allCreepsNear = Entities:FindAllByClassnameWithin("npc_dota_creature", trigger.activator:GetAbsOrigin(), 3000)
	print("Creeps Found")
	 for i = 1, #allCreepsNear, 1 do
	 	local creep = allCreepsNear[i]
        local name = creep:GetUnitName()
        if name == "npc_hell_spider" then
        	creep:ForceKill(true)
        end
    end
end


function soulkeeper_warning0(trigger) 
	local position = Vector(-1625,-3072,129)
    local necro = CreateUnitByName("npc_soul_keeper", position, true, nil, nil, DOTA_TEAM_BADGUYS)
	local rotation = Vector(-7936,-3072,498)
	necro:SetForwardVector(rotation)
	--EmitGlobalSound("DOTAMusic_Stinger.005")
	EmitSoundOn("Hero_Necrolyte.ReapersScythe.Cast",trigger.activator) --Necro Spawn
  	EmitSoundOn("Hero_Necrolyte.ReapersScythe.Target",trigger.activator) --Necro Spawn

  	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_necrolyte/necrolyte_scythe.vpcf", PATTACH_ABSORIGIN_FOLLOW, necro)
  	local necroGlow = ParticleManager:CreateParticle("particles/units/heroes/hero_necrolyte/necrolyte_scythe_orig.vpcf", PATTACH_ABSORIGIN_FOLLOW, necro)
  	ParticleManager:SetParticleControl(necroGlow, 1, necro:GetAbsOrigin())
  	GameRules:SendCustomMessage("<font color='#DBA901'>Soul Keeper:</font> You come again so soon? HAHAHA! Will your souls finally tire of this endless quest of redemption?!", 0,0 )
	GameRules:SendCustomMessage("Still, you are entitled to your price. Step on a platform and let your hearts determine your prize...", 0,0)
end

function soulkeeper_warning1(trigger)
	GameRules:SendCustomMessage("<font color='#DBA901'>Soul Keeper:</font> Have you forgotten your previous deeds among the living?!", 0,0)
	GameRules:SendCustomMessage("Your hearts have been weighed, and only Hell waits for you now!", 0,0)
end 

function soulkeeper_warning2(trigger) 
	local position = Vector(3449,6687,521)
    local necro = CreateUnitByName("npc_soul_keeper", position, true, trigger.caster, trigger.caster, DOTA_TEAM_BADGUYS)
	EmitSoundOn("Hero_Necrolyte.ReapersScythe.Cast",trigger.activator) --Necro Spawn
  	EmitSoundOn("Hero_Necrolyte.ReapersScythe.Target",trigger.activator) --Necro Spawn
  	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_necrolyte/necrolyte_scythe.vpcf", PATTACH_ABSORIGIN_FOLLOW, necro)
  	local necroGlow = ParticleManager:CreateParticle("particles/units/heroes/hero_necrolyte/necrolyte_scythe_orig.vpcf", PATTACH_ABSORIGIN_FOLLOW, necro)
  	ParticleManager:SetParticleControl(necroGlow, 1, necro:GetAbsOrigin())
	GameRules:SendCustomMessage("<font color='#DBA901'>Soul Keeper:</font> HOLD! I can't believe such fools and cowards have made it this far!",0,0)
	GameRules:SendCustomMessage("However...<br>There are two platforms that must be activated before this magical barrier is dispelled.",0,0)
end

function circle_zapsappers(trigger)
	GameRules:SendCustomMessage("The Magic of the circle destroyed nearby sappers.",0,0)
	--kill sappers
	EmitGlobalSound("Axe_axe_death_05")
	
	local allCreepsNear = Entities:FindAllByClassnameWithin("npc_dota_creature", trigger.activator:GetAbsOrigin(), 1000)
	print("Creeps Found")
	 for i = 1, #allCreepsNear, 1 do
	 	local creep = allCreepsNear[i]
        local name = creep:GetUnitName()
        if name == "npc_sapper" then
        	creep:ForceKill(true)
        end
    end


	Timers:CreateTimer({ useGameTime = false, endTime = 2,
        callback = function() 	EmitGlobalSound("BARNDOORS_OPEN") end
    })

    Timers:CreateTimer({ useGameTime = false, endTime = 3,
        callback = function() EmitGlobalSound("ui.crafting_slotslide") end
    })
end 

function soulkeeper_warning3(trigger)
	local position = Vector(2183,-1489,265)
    local necro = CreateUnitByName("npc_soul_keeper", position, true, trigger.caster, trigger.caster, DOTA_TEAM_BADGUYS)
	local rotation = Vector(2517,6680,512)
	necro:SetForwardVector(rotation)
	EmitSoundOn("Hero_Necrolyte.ReapersScythe.Cast",trigger.activator) --Necro Spawn
  	EmitSoundOn("Hero_Necrolyte.ReapersScythe.Target",trigger.activator) --Necro Spawn
  	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_necrolyte/necrolyte_scythe.vpcf", PATTACH_ABSORIGIN_FOLLOW, necro)
  	local necroGlow = ParticleManager:CreateParticle("particles/units/heroes/hero_necrolyte/necrolyte_scythe_orig.vpcf", PATTACH_ABSORIGIN_FOLLOW, necro)
  	ParticleManager:SetParticleControl(necroGlow, 1, necro:GetAbsOrigin())
	GameRules:SendCustomMessage("<font color='#DBA901'>Soul Keeper:</font> CURSE YOU!<br>Your determination for redeption grows tiresome.<br>No matter, you have reached the sacred halls of the Shadow Lord.<br>Your quest ends here!!!",0,0)
end

function soulkeeper_warning_tanks(trigger)
	local position = Vector(4050,-1026,409)
    local necro = CreateUnitByName("npc_soul_keeper", position, true, trigger.caster, trigger.caster, DOTA_TEAM_BADGUYS)
    local dummy =  CreateUnitByName("vision_dummy_tiny", position, true, trigger.caster, trigger.caster, DOTA_TEAM_GOODGUYS)
	local rotation = Vector(-5746.03 -713.903,416)
	necro:SetForwardVector(rotation)
	EmitSoundOn("Hero_Necrolyte.ReapersScythe.Cast",trigger.activator) --Necro Spawn
  	EmitSoundOn("Hero_Necrolyte.ReapersScythe.Target",trigger.activator) --Necro Spawn
  	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_necrolyte/necrolyte_scythe.vpcf", PATTACH_ABSORIGIN_FOLLOW, necro)
  	local necroGlow = ParticleManager:CreateParticle("particles/units/heroes/hero_necrolyte/necrolyte_scythe_orig.vpcf", PATTACH_ABSORIGIN_FOLLOW, necro)
  	ParticleManager:SetParticleControl(necroGlow, 1, necro:GetAbsOrigin())
	GameRules:SendCustomMessage("<font color='#DBA901'>Soul Keeper:</font> CURSE YOU!<br>Your determination for redemption grows tiresome...<br> we'll see how you fare in these Dwarven contraptions!<br>Step on the magic circle to begin your journey.",0,0)
end

function hint_tanks(trigger)
	EmitGlobalSound("General.PingRune")
	GameRules:SendCustomMessage("<font color='#2EFE2E'>HINT</font> - You get no experience for killing monsters while in a tank.", 0, 0) 
	GameRules:SendCustomMessage("Avoid the monsters you can avoid, and kill the ones you have to.", 0, 0)
	GameRules:SendCustomMessage("Find and kill the enemy steam tanks to open the end door.", 0, 0)
	Timers:CreateTimer({
    endTime = 10,
    callback = function()
      	EmitGlobalSound("General.PingWarning")
		GameRules:SendCustomMessage("<font color='#B40404'>BEWARE</font> - Being slain in this mode is permanent, despite whatever items your Hero carries!", 0, 0)
    end
  	})
	
end

function hint_tanks_end(trigger) 
	GameRules:SendCustomMessage("You have vanquished the enemies. The gate has opened...", 0, 0)

	--find and kill dummy
	local allCreepsNear = Entities:FindAllByClassnameWithin("npc_dota_creature", trigger.activator:GetAbsOrigin(), 1000)
	print("Creeps Found")
	 for i = 1, #allCreepsNear, 1 do
	 	local creep = allCreepsNear[i]
        local name = creep:GetUnitName()
        if name == "vision_dummy_tiny" then
        	creep:ForceKill(true)
        end
    end

end

function boss_engage(trigger)
	GameRules:SendCustomMessage("<font color='#DBA901'>Soul Keeper:</font>  So you dare to challenge the Shadow Lord? <br>I will feast on your lost souls and show you no mercy!!<br>Come and accept your fate!",0,0)
	local ShakeOn = Vector(3558, -7210, 160)
	ScreenShake(ShakeOn, 10.0, 10.0, 7.0, 99999, 0, true)
	EmitGlobalSound("DOTAMusic_Diretide_Finale")
	--[[vecCenter, flAmplitude, flFrequency, flDuration, flRadius, eCommand( SHAKE_START = 0, SHAKE_STOP = 1 ), bAirShake ]]
end

function boss_dead(trigger)
	GameRules:SendCustomMessage("BEHOLD WARRIORS!!<br>You have succeeded in defeating the Shadow Lord!!<br>After an eternity, your quest to redeem your lost souls is over.<br>Indeed you truely are Heroes!<br>Your souls might now move on and finally give you peace.",0,0)
end

--custom hints for teleporters and spawners













