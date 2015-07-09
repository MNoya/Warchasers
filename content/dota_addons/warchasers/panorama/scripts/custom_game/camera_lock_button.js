"use strict";

var locked = true;

function OnButtonPressed( data ) {
	var iPlayerID = Players.GetLocalPlayer();
	if (locked){
		$.Msg('Player '+iPlayerID+' Unlocked Camera');
		GameEvents.SendCustomGameEventToServer( "player_toggle_camera_lock", { pID: iPlayerID, locked: 0 })
		$("#Label").text = "Camera Lock OFF";
		locked = false
	}
	else{
		$.Msg('Player '+iPlayerID+' Locked Camera');
		GameEvents.SendCustomGameEventToServer( "player_toggle_camera_lock", { pID: iPlayerID, locked: 1 })
		$("#Label").text = "Camera Lock ON";
		locked = true
	}
}