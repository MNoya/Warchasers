package  {
	
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
        
        //this function is called
        public function onLoaded() : void {            
            //make this UI visible
            visible = true;
            
            //let the client rescale the UI
            Globals.instance.resizeManager.AddListener(this);
            
            //this is not needed, but it shows you your UI has loaded (needs 'scaleform_spew 1' in console)
            trace("Custom UI loaded!");
			
			 Globals.instance.GameInterface.SetConvar("dota_camera_lock", "1");
        }
		
		//this handles the resizes - credits to Nullscope
		public function onScreenSizeChanged():void{
            this.scaleX = (this.globals.resizeManager.ScreenWidth / 1920);
            this.scaleY = (this.globals.resizeManager.ScreenHeight / 1080);
            x = 0;
            y = 0;
            trace(("fofitemdraft::onScreenSizeChanged stageWidth/Height = " + stage.stageWidth), stage.stageHeight);
            trace(("  stage.width/height = " + stage.width), stage.height);
            trace(("  rm.screenWidth/height = " + this.globals.resizeManager.ScreenWidth), this.globals.resizeManager.ScreenHeight);
        }
	}
	
}