function to_try ( kappa, test)
	SetAbilityIndex(int a) --[[Returns:void
	No Description Set
	]]
	MakeAbilityButtonDirty()
	CreateVisibilityNode(Vector a, float b, float c) --[[Returns:void
	No Description Set
	]]
	GetCursorTarget() --[[Returns:handle
	No Description Set
	]]
	SetHidden(bool a) --[[Returns:void
	No Description Set
	]]
end

function swap_aura2( event )
	local hero = event.caster
	if hero.currentAura == nil or hero.currentAura == 1 then
		hero.currentAura = 2
	end
	hero:SwapAbilities("warchasers_aura1", "warchasers_aura2", false, true) --[[Returns:void
	Swaps the slots of the two passed abilities and sets them enabled/disabled: 
	const char* AbilityName1, const char* AbilityName2, ''bool'' bEnable1, ''bool'' bEnable2. 
	The boolean controls which ability is active. 
	The ability order is never swapped when swapping abilities, only the boolean statements are flipped.
	]]
end

function swap_aura3( event )
	local hero = event.caster
	if hero.currentAura == nil or hero.currentAura == 2 then
		hero.currentAura = 3
	end
	hero:SwapAbilities("warchasers_aura2", "warchasers_aura3", false, true)
end

function swap_aura1( event )
	local hero = event.caster
	if hero.currentAura == nil or hero.currentAura == 3 then
		hero.currentAura = 1
	end
	hero:SwapAbilities("warchasers_aura3", "warchasers_aura1", false, true)
end