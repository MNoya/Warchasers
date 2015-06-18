package  {
	
	import flash.display.MovieClip;
	import ValveLib.*;
	import scaleform.clik.controls.Button;
	import scaleform.clik.events.ButtonEvent;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class CameraLock extends MovieClip {
		public var gameAPI:Object;
        public var globals:Object;
        public var elementName:String;
		
		public var cameraLockBtn:Button;
		public var cameraLocked:Boolean;
		
		public function CameraLock() {
			
		}
		
		public function onLoaded():void{
			
			trace("On Loaded")
			this.lockCamera()
			this.cameraLockBtn.addEventListener(ButtonEvent.CLICK, this.cameraLockToggle);
			this.gameAPI.SubscribeToGameEvent("hero_picker_hidden", this.OnHeroPickerHidden);
		}
		
		public function cameraLockToggle():void
		{
			if(cameraLocked)
			{
				cameraLocked = false;
				Globals.instance.GameInterface.SetConvar("dota_camera_lock", "0");
				this.cameraLockBtn.label = Globals.instance.GameInterface.Translate("#camera_lock_off");
				trace("Camera Unlocked")
			}else{
				cameraLocked = true;
				Globals.instance.GameInterface.SetConvar("dota_camera_lock", "1");
				this.cameraLockBtn.label = Globals.instance.GameInterface.Translate("#camera_lock_on");
				trace("Camera Locked")
			}
		}
		
		public function lockCamera():void
		{
			cameraLocked = true;
			Globals.instance.GameInterface.SetConvar("dota_camera_lock", "1");
			this.cameraLockBtn.label = Globals.instance.GameInterface.Translate("#camera_lock_on");
			trace("Camera Locked")			
		}
			
		public function OnHeroPickerHidden(keyValues:Object):void
		{
			this.visible = true;
		}
		
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