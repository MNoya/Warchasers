--development functions
print("developer loading")



function table_printer( event )
	DeepPrintTable(event, nil, false)
end


function test_ability_func( player, ability_name )
	local hero = player:GetAssignedHero() 
	local ability = hero:GetAbilityByIndex(0)
	hero:RemoveAbility(ability:GetAbilityName())
	hero:AddAbility(ability_name)
	hero:FindAbilityByName(ability_name):SetLevel(1)
end


function test_maxms_func(player)
	local hero = player:GetAssignedHero() 
	hero:SetBaseMoveSpeed(700)
end


function test_fly_func(player)
	local hero = player:GetAssignedHero() 
	hero:SetMoveCapability(DOTA_UNIT_CAP_MOVE_FLY)
end

function override_affix_func(affix_name)
	for key, value in pairs(affix_table) do
		value[1] = affix_name
	end
end

function affix_print_func()
	DeepPrintTable(affix_table)
end


Convars:RegisterCommand( "test_fly", function( not_needed) local cmdPlayer = Convars:GetCommandClient() test_fly_func(cmdPlayer) end, "Send hero flying for testing", FCVAR_DEVELOPMENTONLY )
Convars:RegisterCommand( "test_ability", function( not_needed, ability_name) local cmdPlayer = Convars:GetCommandClient() test_ability_func(cmdPlayer, ability_name) end, "Adds ability to your hero for testing", FCVAR_DEVELOPMENTONLY )
Convars:RegisterCommand( "test_maxms", function( not_needed) local cmdPlayer = Convars:GetCommandClient() test_maxms_func(cmdPlayer) end, "Set hero max ms for testing", FCVAR_DEVELOPMENTONLY )
Convars:RegisterCommand( "affix_override", function( not_needed, affix_name) override_affix_func(affix_name) end, "Overrides affix table for testing", FCVAR_DEVELOPMENTONLY )
Convars:RegisterCommand( "affix_print", affix_print_func, "Prints current affix table", FCVAR_DEVELOPMENTONLY )



