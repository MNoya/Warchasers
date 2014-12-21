//=====================================================================================================
// ExampleModule.as
//=====================================================================================================
package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.utils.getDefinitionByName;
	import scaleform.clik.events.*;
	
	//import some stuff from the valve lib
	import ValveLib.Globals;
	import ValveLib.ResizeManager;

	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	
	public class ExampleModule extends MovieClip {
		
		public var gameAPI:Object;
		public var globals:Object;
          
		public var difficulty_selected:int;
		   
		public function ExampleModule() {
		}
		
		//set initialise this instance's gameAPI
		public function setup(api:Object, globals:Object) {
			this.gameAPI = api;
			this.globals = globals;
			
			//Event Listeners
			this.gameAPI.SubscribeToGameEvent("hero_picker_hidden", this.OnHeroPicked);
	
			//Button Listeners
			this.lvl0Button.addEventListener(MouseEvent.CLICK, onButton0Clicked);
			this.lvl1Button.addEventListener(MouseEvent.CLICK, onButton1Clicked);
			this.lvl2Button.addEventListener(MouseEvent.CLICK, onButton2Clicked);
			this.lvl3Button.addEventListener(MouseEvent.CLICK, onButton3Clicked);
			this.lvl4Button.addEventListener(MouseEvent.CLICK, onButton4Clicked);
			
			var AcceptButton = replaceWithValveComponent(btn_replace, "button_big");
			AcceptButton.addEventListener(ButtonEvent.CLICK, onAcceptButtonClicked);
			AcceptButton.label = Globals.instance.GameInterface.Translate("#vote_difficulty");
			//AcceptButton.width = 220;
			//AcceptButton.height = 45;
			
			// Text
			this.SelectDifficultyText.text = Globals.instance.GameInterface.Translate("#select_difficulty");
			this.difficultyDescriptionText.text = Globals.instance.GameInterface.Translate("#difficulty_text");
			this.difficultyLevel.text = Globals.instance.GameInterface.Translate("#difficulty_0");
			
			trace("##Module Setup!");
		}
		
		public function onButton0Clicked(event:MouseEvent) {
			trace("Button 0");
			this.difficultyLevel.text = Globals.instance.GameInterface.Translate("#difficulty0");
			this.difficultyDescriptionText.text = Globals.instance.GameInterface.Translate("#difficulty0_text");
			selected0.visible=true;
			selected0.enabled=true;
			
			selected1.visible=false;
			selected1.enabled=false;
			
			selected2.visible=false;
			selected2.enabled=false;
			
			selected3.visible=false;
			selected3.enabled=false;
			
			selected4.visible=false;
			selected4.enabled=false;
			difficulty_selected = 0;
		}
		
		public function onButton1Clicked(event:MouseEvent) {
			trace("Button 1");
			this.difficultyLevel.text = Globals.instance.GameInterface.Translate("#difficulty1");
			this.difficultyDescriptionText.text = Globals.instance.GameInterface.Translate("#difficulty1_text");
			selected0.visible=true;
			selected0.enabled=false;
			
			selected1.visible=true;
			selected1.enabled=true;
			
			selected2.visible=false;
			selected2.enabled=false;
			
			selected3.visible=false;
			selected3.enabled=false;
			
			selected4.visible=false;
			selected4.enabled=false;
			difficulty_selected = 1;
		}
		
		public function onButton2Clicked(event:MouseEvent) {
			trace("Button 2");
			this.difficultyLevel.text = Globals.instance.GameInterface.Translate("#difficulty2");
			this.difficultyDescriptionText.text = Globals.instance.GameInterface.Translate("#difficulty2_text");
			selected0.visible=true;
			selected0.enabled=false;
			
			selected1.visible=true;
			selected1.enabled=false;
			
			selected2.visible=true;
			selected2.enabled=true;
			
			selected3.visible=false;
			selected3.enabled=false;
			
			selected4.visible=false;
			selected4.enabled=false;
			difficulty_selected = 2;
		}
		
		public function onButton3Clicked(event:MouseEvent) {
			trace("Button 3");
			this.difficultyLevel.text = Globals.instance.GameInterface.Translate("#difficulty3");
			this.difficultyDescriptionText.text = Globals.instance.GameInterface.Translate("#difficulty3_text");
			selected0.visible=true;
			selected0.enabled=false;
			
			selected1.visible=true;
			selected1.enabled=false;
			
			selected2.visible=true;
			selected2.enabled=false;
			
			selected3.visible=true;
			selected3.enabled=false;
			
			selected4.visible=false;
			selected4.enabled=false;
			difficulty_selected = 3;
		}
		
		public function onButton4Clicked(event:MouseEvent) {
			trace("Button 4");
			this.difficultyLevel.text = Globals.instance.GameInterface.Translate("#difficulty4");
			this.difficultyDescriptionText.text = Globals.instance.GameInterface.Translate("#difficulty4_text");
			selected0.visible=true;
			selected0.enabled=false;
			
			selected1.visible=true;
			selected1.enabled=false;
			
			selected2.visible=true;
			selected2.enabled=false;
			
			selected3.visible=true;
			selected3.enabled=false;
			
			selected4.visible=true;
			selected4.enabled=true;
			difficulty_selected = 4;
		}
		
		public function onAcceptButtonClicked(event:ButtonEvent) {
			trace("##You have selected level "+difficulty_selected+" difficulty");
			this.visible = false
			switch(difficulty_selected) 
			{ 
				case 0: 
					this.gameAPI.SendServerCommand("PlayerVotedDifficulty 0");
					break; 
				case 1: 
					this.gameAPI.SendServerCommand("PlayerVotedDifficulty 1");
					break; 
				case 2: 
					this.gameAPI.SendServerCommand("PlayerVotedDifficulty 2");
					break; 
				case 3: 
					this.gameAPI.SendServerCommand("PlayerVotedDifficulty 3");
					break; 
				case 4: 
					this.gameAPI.SendServerCommand("PlayerVotedDifficulty 4");
					break; 
				default:
					this.gameAPI.SendServerCommand("PlayerVotedDifficulty 0");
					break; 
			}
			
		}
		
		
		public function OnHeroPicked(args:Object) : void {
			//get the ID of the player this UI belongs to, here we use a scaleform function from globals
			var pID:int = globals.Players.GetLocalPlayer();
			this.visible = true
			trace("##Difficulty Selection Module should be visible now")
		}
    		
		public function screenResize(stageX:int, stageY:int, scaleRatio:Number){
			this.x = stageX/2
			this.y = stageY/2;
		}
		
		//Parameters: 
		//	mc - The movieclip to replace
		//	type - The name of the class you want to replace with
		//	keepDimensions - Resize from default dimensions to the dimensions of mc (optional, false by default)
		public function replaceWithValveComponent(mc:MovieClip, type:String, keepDimensions:Boolean = false) : MovieClip {
			var parent = mc.parent;
			var oldx = mc.x;
			var oldy = mc.y;
			var oldwidth = mc.width;
			var oldheight = mc.height;
			
			var newObjectClass = getDefinitionByName(type);
			var newObject = new newObjectClass();
			newObject.x = oldx;
			newObject.y = oldy;
			if (keepDimensions) {
				newObject.width = oldwidth;
				newObject.height = oldheight;
			}
			
			parent.removeChild(mc);
			parent.addChild(newObject);
			
			return newObject;
		}
	}	
}