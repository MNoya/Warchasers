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



ListenToGameEvent( "npc_spawned", log_npc, nil )
