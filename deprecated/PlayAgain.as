//=====================================================================================================
// PlayAgain.as
//=====================================================================================================
package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.*;
	
	//import some stuff from the valve lib
	import ValveLib.Globals;
	import ValveLib.ResizeManager;

	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.display.Sprite;
	
	//copied from VotingPanel.as source
	import flash.display.*;
    import flash.filters.*;
    import flash.text.*;
    import scaleform.clik.events.*;
    import vcomponents.*;
	
	public class PlayAgain extends MovieClip {
		
		public var gameAPI:Object;
		public var globals:Object;
		
		private var _btnYes:VButton;
        private var _btnNo:VButton;
		
		private var _loc_2:VComponent;
		private var _loc_3:VComponent;
          		   
		public function PlayAgain() {
		}
		
		//set initialise this instance's gameAPI
		public function setup(api:Object, globals:Object) {
			this.gameAPI = api;
			this.globals = globals;
			this.visible = true;
			
			//Event Listeners
			this.gameAPI.SubscribeToGameEvent("warchasers_player_died", this.OnHeroDied);
			
			trace("##Module Setup!");
		}
		
		public function OnHeroDied(args:Object) : void {			
			trace("##Hero Died Detected");
			
			//Only show this in the corresponding player UI
			var pID:int = globals.Players.GetLocalPlayer();
			if (args.player_ID == pID) {
				//Credits to Ractis for this
				trace("Play again?")
				this.visible = true
				_loc_2 = new VComponent("bg_overlayBox");
				_loc_2.width = 500;
				_loc_2.height = 160;
				addChild(_loc_2);
				
				var _loc_3:* = Utils.CreateLabel("#warchasers_play_again", FontType.TextFont);
				var _loc_4:* = new TextFormat();
				_loc_4.size = 24;
				_loc_4.align = TextFormatAlign.CENTER;
				_loc_4.color = 0xFFFFFF;
				_loc_4.font = FontType.TextFont;
				_loc_3.setTextFormat(_loc_4);
				_loc_3.y = 30;
				_loc_3.width = 500;
				_loc_3.alpha = 0.9;
				_loc_3.filters = [new GlowFilter()];
				addChild(_loc_3);
				
				this._btnYes = new VButton("chrome_button_primary", "YES");
				this._btnYes.x = 50;
				this._btnYes.y = 95;
				addChild(this._btnYes);
				
				this._btnNo = new VButton("chrome_button_normal", "NO, GG");
				this._btnNo.x = 300;
				this._btnNo.y = 95;
				addChild(this._btnNo);
				
				this._btnYes.addEventListener(ButtonEvent.CLICK, this._onClickYes);
				this._btnNo.addEventListener(ButtonEvent.CLICK, this._onClickNo);
			}
         		
		}
		
		private function _onClickYes(event:ButtonEvent) : void
        {
            this.gameAPI.SendServerCommand("RespawnAsGhost");
			trace("##Respawn");
			this._close();
            return;
        }// end function

        private function _onClickNo(event:ButtonEvent) : void
        {
            this.gameAPI.SendServerCommand("GG"); //Your soul is lost forever...
			trace("##GG");
            this._close();
            return;
        }// end function

        private function _close() : void
        {
            visible = false;
            return;
        }
		
		public function screenResize(stageW:int, stageH:int, xScale:Number, yScale:Number, wide:Boolean){
			this.x = stageW/2;
			this.y = stageH/2; //A bit on top of the middle to show the chat
					 
			//Now we just set the scale of this element, because these parameters are already the inverse ratios
			this.scaleX = xScale;
			this.scaleY = yScale;
		}
	}	
}