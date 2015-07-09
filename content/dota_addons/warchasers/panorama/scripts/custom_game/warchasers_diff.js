"use strict";

function OnDifficultyPick( data ) {
	$.Msg("DEBUG - Clicked on diff: ", data);
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
}

function OnDifficultyChosen() {
	$.Msg("DEBUG - Voted");
}