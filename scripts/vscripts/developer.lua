--development functions
print("developer loading")



function table_printer( event )
	DeepPrintTable(event, nil, false)
end



function log_npc( event )
	local index = event.entindex
	local unit = EntIndexToHScript(index)
	print("Index: "..index.." Name: "..unit:GetName().." Created time: "..GameRules:GetGameTime().." at x= "..unit:GetOrigin().x.." y= "..unit:GetOrigin().y)
end

function test_maxms_func(player)
	local hero = player:GetAssignedHero() 
	hero:SetBaseMoveSpeed(700)
end


function test_fly_func(player)
	local hero = player:GetAssignedHero() 
	hero:SetMoveCapability(DOTA_UNIT_CAP_MOVE_FLY)
end

Convars:RegisterCommand( "test_fly", function( not_needed) local cmdPlayer = Convars:GetCommandClient() test_fly_func(cmdPlayer) end, "Send hero flying for testing", FCVAR_DEVELOPMENTONLY )
Convars:RegisterCommand( "test_maxms", function( not_needed) local cmdPlayer = Convars:GetCommandClient() test_maxms_func(cmdPlayer) end, "Set hero max ms for testing", FCVAR_DEVELOPMENTONLY )

ListenToGameEvent( "npc_spawned", log_npc, nil )
