package {
	import flash.display.MovieClip;

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
			
			//this is not needed, but it shows you your UI has loaded (needs 'scaleform_spew 1' in console)
			trace("Custom UI loaded!");
		}
		
		//this handles the resizes - credits to Nullscope
		public function onResize(re:ResizeManager) : * {
			var rm = Globals.instance.resizeManager;
            var currentRatio:Number =  re.ScreenWidth / re.ScreenHeight;
            var divided:Number;

            // Set this to your stage height, however, if your assets are too big/small for 1024x768, you can change it
			// Your original stage height
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
                    
            //You will probably want to scale your elements by here, they keep the same width and height by default.
            
            //The engine keeps elements at the same X and Y coordinates even after resizing, you will probably want to adjust that here.
		}
	}
}