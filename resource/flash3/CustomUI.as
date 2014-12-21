//=====================================================================================================
// CustomUI.as
//=====================================================================================================
package {
	import flash.display.MovieClip;
	import flash.text.*;

	//import some stuff from the valve lib
	import ValveLib.Globals;
	import ValveLib.ResizeManager;
	
	public class CustomUI extends MovieClip{
		
		//these three variables are required by the engine
		public var gameAPI:Object;
		public var globals:Object;
		public var elementName:String;
		
		//constructor, you usually will use onLoaded() instead
		public function CustomUI() : void {

		}
			
		//this function is called when the UI is loaded
		public function onLoaded() : void {			
			//make this UI visible
			visible = true;
			
			//let the client rescale the UI
			Globals.instance.resizeManager.AddListener(this);
			
			//pass the gameAPI on to the modules
			this.myModule.setup(this.gameAPI, this.globals);
			
			this.myModule.visible = false
			
			//this is not needed, but it shows you your UI has loaded (needs 'scaleform_spew 1' in console)
			trace("Custom UI loaded!");
		}
		
		//this handles the resizes - credits to Nullscope
		public function onResize(re:ResizeManager) : * {
			var rm = Globals.instance.resizeManager;
			var currentRatio:Number =  re.ScreenWidth / re.ScreenHeight;
			var divided:Number;
		
			// Set this to your stage height, however, if your assets are too big/small for 1024x768, you can change it
			// This is just your original stage height
			var originalHeight:Number = 900;
					
			if(currentRatio < 1.5)
			{
				// 4:3
				divided = currentRatio / 1.333;
			}
			else if(re.Is16by9()){
				// 16:9
				divided = currentRatio / 1.7778;
			} else {
				// 16:10
				divided = currentRatio / 1.6;
			}
							
			 var correctedRatio:Number =  re.ScreenHeight / originalHeight * divided;
			
			//pass the resize event to our module, we pass the width and height of the screen, as well as the correctedRatio.
			//this.myModule.screenResize(re.ScreenWidth, re.ScreenHeight, correctedRatio);
		}
	}
}