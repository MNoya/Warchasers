"use strict";

function OnDifficultyPick( data ) {
	$.Msg("DEBUG - Clicked on diff: ", data);

	//handle the text
	$('#Diff_Text').AddClass('Hidden');
	$('#Diff_Text0').AddClass('Hidden');
	$('#Diff_Text1').AddClass('Hidden');
	$('#Diff_Text2').AddClass('Hidden');
	$('#Diff_Text3').AddClass('Hidden');
	$('#Diff_Text4').AddClass('Hidden');
	if( data==0 ) $('#Diff_Text0').RemoveClass('Hidden');
	if( data==1 ) $('#Diff_Text1').RemoveClass('Hidden');
	if( data==2 ) $('#Diff_Text2').RemoveClass('Hidden');
	if( data==3 ) $('#Diff_Text3').RemoveClass('Hidden');
	if( data==4 ) $('#Diff_Text4').RemoveClass('Hidden');

	//handle the titles
	$('#Diff_Title').AddClass('Hidden');
	$('#Diff_Title0').AddClass('Hidden');
	$('#Diff_Title1').AddClass('Hidden');
	$('#Diff_Title2').AddClass('Hidden');
	$('#Diff_Title3').AddClass('Hidden');
	$('#Diff_Title4').AddClass('Hidden');
	if( data==0 ) $('#Diff_Title0').RemoveClass('Hidden');
	if( data==1 ) $('#Diff_Title1').RemoveClass('Hidden');
	if( data==2 ) $('#Diff_Title2').RemoveClass('Hidden');
	if( data==3 ) $('#Diff_Title3').RemoveClass('Hidden');
	if( data==4 ) $('#Diff_Title4').RemoveClass('Hidden');
}

function OnDifficultyChosen() {
	$.Msg("DEBUG - Voted");

	// Default difficulty in case they dont bother selecting
	var diff = 1;

	//check which diff is chosen
	if( $('#Diff0').checked ) diff = 0;
	else if( $('#Diff1').checked ) diff = 1;
	else if( $('#Diff2').checked ) diff = 2;
	else if( $('#Diff3').checked ) diff = 3;
	else if( $('#Diff4').checked ) diff = 4;

	$.Msg('DEBUG - Difficulty ', diff);
	var iPlayerID = Players.GetLocalPlayer();
	GameEvents.SendCustomGameEventToServer( "player_voted_difficulty", { pID: iPlayerID, difficulty: diff })
	$.GetContextPanel().visible = false;
}

function OnFinishedVoting (args) {
	$.GetContextPanel().visible = false;
}

(function () {
	GameEvents.Subscribe( "finished_voting", OnFinishedVoting );
})();
