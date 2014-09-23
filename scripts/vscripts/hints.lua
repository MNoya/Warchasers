function hint1(trigger)
	GameRules:SendCustomMessage("<font color='#2EFE2E'>HINT</font> Kappa", 0, 0)
end

function hint_key1(trigger) 
	GameRules:SendCustomMessage("<font color='#2EFE2E'>HINT</font> - You need the key to open this door.", 0, 0) 
end
function hint_key2(trigger) 
	GameRules:SendCustomMessage("<font color='#2EFE2E'>HINT</font> - You need the key to open this door.", 0, 0) 
end
function hint_key3(trigger) 
	GameRules:SendCustomMessage("<font color='#2EFE2E'>HINT</font> - You need the key to open this door.", 0, 0) 
end

function hint_keydrop(trigger) 
	GameRules:SendCustomMessage("<font color='#2EFE2E'>HINT</font> - A key has been dropped!", 0, 0) 
end

function announce_open_doors(trigger) 
	GameRules:SendCustomMessage("The doors have been opened.", 0, 0) 
end
 
function announce_level2(trigger) 
	GameRules:SendCustomMessage("Level <font color='#2E64FE'>2</font> has been opened. Fools enter at its own peril.", 0, 0) 
end

function miniboss2_engage(trigger)
	GameRules:SendCustomMessage("<font color='#DBA901'>Ra'ADoom:</font> COME, HEROES!<br>COME AND CLAIM THE REWARD FOR YOUR SO CALLED HONOR!", 0,0)
end

function miniboss2_dead(trigger)
	GameRules:SendCustomMessage("<font color='#DBA901'>Ra'ADoom:</font> UNTIL NEXT TIME...HEROES...", 0,0)
end

function spiderhall_warning(trigger)
	GameRules:SendCustomMessage("BEHOLD THE HALL OF SPIDERS! If you have the courage, your salvation lies at the end.",0,0)
end

function spiderhall_hint(trigger) 
	GameRules:SendCustomMessage("<font color='#2EFE2E'>HINT</font> - If you can reach the magic circle at the end of the hall, all the spiders are killed.", 0, 0) 
end

function spiderhall_kill(trigger)
	GameRules:SendCustomMessage("All Spiders were destroyed.", 0,0)
end


function soulkeeper_warning0(trigger) 
	local position = Vector(-1625,-3072,129)
    local necro = CreateUnitByName("npc_soul_keeper", position, true, nil, nil, DOTA_TEAM_BADGUYS)
	local rotation = Vector(-7936,-3072,498)
	necro:SetForwardVector(rotation)
	EmitGlobalSound("DOTAMusic_Stinger.005")
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
	EmitGlobalSound("DOTAMusic_Stinger.005")
	GameRules:SendCustomMessage("<font color='#DBA901'>Soul Keeper:</font> HOLD! I can't believe such fools and cowards have made it this far!",0,0)
	GameRules:SendCustomMessage("However...<br>There are two platforms that must be activated before this magical barrier is dispelled.",0,0)
end

function circle_zapsappers(trigger)
	GameRules:SendCustomMessage("The Magic of the circle finds no sappers to destroy.",0,0)
end 

function soulkeeper_warning3(trigger)
	local position = Vector(2183,-1489,265)
    local necro = CreateUnitByName("npc_soul_keeper", position, true, trigger.caster, trigger.caster, DOTA_TEAM_BADGUYS)
	local rotation = Vector(2517,6680,512)
	necro:SetForwardVector(rotation)
	EmitGlobalSound("DOTAMusic_Stinger.007")
	GameRules:SendCustomMessage("<font color='#DBA901'>Soul Keeper:</font> CURSE YOU!<br>Your determination for redeption grows tiresome.<br>No matter, you have reached the sacred halls of the Shadow Lord.<br>Your quest ends here!!!",0,0)
end

function boss_engage(trigger)
	GameRules:SendCustomMessage("<font color='#DBA901'>Soul Keeper:</font>  So you dare to challenge the Shadow Lord? <br>I will feast on your lost souls and show you no mercy!!<br>Come and accept your fate!",0,0)
end

function boss_dead(trigger)
	GameRules:SendCustomMessage("BEHOLD WARRIORS!!<br>You have succeeded in defeating the Shadow Lord!!<br>After an eternity, your quest to redeem your lost souls is over.<br>Indeed you truely are Heroes!<br>Your souls might now move on and finally give you peace.",0,0)
end

--custom hints for teleporters and spawners













