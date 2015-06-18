function QuestStart(event)
	entQuest = SpawnEntityFromTableSynchronous( "quest", { name = "Quest", title = "#QuestTimer" } )
	--add 	"QuestTimer"	"Survive for %quest_current_value% seconds" 	in addon_english
	
	questTimeEnd = GameRules:GetGameTime() + 10 --Time to Finish the quest

	--bar system
	entKillCountSubquest = SpawnEntityFromTableSynchronous( "subquest_base", {
		show_progress_bar = true,
		progress_bar_hue_shift = -119
	} )
	entQuest:AddSubquest( entKillCountSubquest )
	entQuest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_TARGET_VALUE, 10 ) --text on the quest timer at start
	entQuest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, 10 ) --text on the quest timer
	entKillCountSubquest:SetTextReplaceValue( SUBQUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, 10 ) --value on the bar at start
	entKillCountSubquest:SetTextReplaceValue( SUBQUEST_TEXT_REPLACE_VALUE_TARGET_VALUE, 10 ) --value on the bar
	
  	Timers:CreateTimer(0.9, function()
      	entQuest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, questTimeEnd - GameRules:GetGameTime() )
      	entKillCountSubquest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, questTimeEnd - GameRules:GetGameTime() ) --update the bar with the time passed      	
      	if (questTimeEnd - GameRules:GetGameTime())<=0 then
      		EmitGlobalSound("Tutorial.Quest.complete_01") --on game_sounds_music_tutorial, check others
      		UTIL_RemoveImmediate( entQuest )
      		entKillCountSubquest = nil
      	end
      	return 1    	
    end
  	)
	
end

