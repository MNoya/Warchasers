"use strict";
function OnPlayerDied( args ) {
	$.GetContextPanel().RemoveClass('Hidden');
}

function OnYesButton( args ){
	var iPlayerID = Players.GetLocalPlayer();
	$.Msg('Player '+iPlayerID+' keeps playing');
	GameEvents.SendCustomGameEventToServer( "player_respawn", { pID: iPlayerID })
	$.GetContextPanel().AddClass('Hidden');
}

function OnNoButton( args ){
	var iPlayerID = Players.GetLocalPlayer();
	$.Msg('Player '+iPlayerID+' gives up');
	GameEvents.SendCustomGameEventToServer( "player_give_up", { pID: iPlayerID })
	$.GetContextPanel().AddClass('Hidden');
}

(function () {
	GameEvents.Subscribe( "player_died", OnPlayerDied );
})();