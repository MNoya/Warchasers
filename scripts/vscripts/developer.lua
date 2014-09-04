--development functions
print("developer loading")

function log_npc( event )
	local index = event.entindex
	local unit = EntIndexToHScript(index)
	print("Index: "..index.." Name: "..unit:GetName().." Created time: "..GetSystemTime())
end



ListenToGameEvent( "npc_spawned", log_npc, nil )
