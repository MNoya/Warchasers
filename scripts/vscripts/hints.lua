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
	GameRules:SendCustomMessage(" <font color='#DBA901'>Ra'ADoom:</font> COME, HEROES!<br>COME AND CLAIM THE REWARD FOR YOUR SO CALLED HONOR!")
end

function miniboss2_dead(trigger)
	GameRules:SendCustomMessage(" <font color='#DBA901'>Ra'ADoom:</font> UNTIL NEXT TIME...HEROES...")
end

function endspiderhall_warning(trigger)
	GameRules:SendCustomMessage("BEHOLD THE HALL OF SPIDERS! If you have the courage, your salvation lies at the end.")
end

function spiderhall_hint(trigger) 
	GameRules:SendCustomMessage("<font color='#2EFE2E'>HINT</font> - If you can reach the magic circle at the end of the hall, all the spiders are killed.", 0, 0) 
end

function spiderhall_kill(trigger)
	GameRules:SendCustomMessage("All Spiders were destroyed.")
end


function soulkeeper_warning0(trigger)
	GameRules:SendCustomMessage(" <font color='#DBA901'Soul Keeper:</font> You come again so soon? HAHAHA! Will your souls finally tire of this endless quest of redemption?!<br>Still, you are entitled to your price. Step on a platform and let your hearts determine your prize...")
end

function soulkeeper_warning1(trigger)
	GameRules:SendCustomMessage(" <font color='#DBA901'Soul Keeper:</font> Have you forgotten your previous deeds among the living?!<br>Your hearts have been weighed, and only Hell waits for you now!")
end 

function soulkeeper_warning2(trigger)
	GameRules:SendCustomMessage(" <font color='#DBA901'Soul Keeper:</font> HOLD! I can't believe such fools and cowards have made it this far! However...<br>There are two platforms that must be activated before this magical barrier is dispelled.")
end

function circle_zapsappers(trigger)
	GameRules:SendCustomMessage("The Magic of the circle finds no sappers to destroy.")
end 

function circle_activated(trigger)
	GameRules:SendCustomMessage("The circle has been activated!<br>The magical barrier has been dispelled and now the path is clear")
end  
--Now, find and activate the other magic circle
--SUCESS (blue) [on both]

function soulkeeper_warning3(trigger)
	GameRules:SendCustomMessage("<font color='#DBA901'Soul Keeper:</font> CURSE YOU! Your determination for redeption grows tiresome.<br>No matter, you have reached the sacred halls of the Shadow Lord.
<br>Your quest ends here!!!")
end

function boss_engage(trigger)
	GameRules:SendCustomMessage("<font color='#DBA901'Soul Keeper:</font>  So you dare to challenge the Shadow Lord? I will feast on your lost souls and show you no mercy!! <br>Come and accept your fate!")
end

function boss_dead(trigger)
	GameRules:SendCustomMessage("BEHOLD WARRIORS!! You have succeeded in defeating the Shadow Lord!!<br>
After an eternity, your quest to redeem your lost souls is over. Indeed you truely are Heroes!<br>
Your souls might now move on and finally give you peace.")
end

--custom hints for teleporters and spawners













