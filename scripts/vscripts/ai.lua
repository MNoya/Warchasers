print("AI is loading")

function final_boss_think( event )
	local boss = event.caster
end

function final_boss_defeat( event )
	GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
end