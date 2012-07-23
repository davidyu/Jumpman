package
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class Menu
	{
		private var _world:BoxWorld;
		private var _overlay:Sprite;
		private var _mainMenu:MovieClip;
		
		public function Menu(overlay:Sprite, world:BoxWorld)
		{
			_overlay = overlay;
			_world = world;
			
			_mainMenu = new MenuScreen();
			_overlay.addChild(_mainMenu);
			
			_mainMenu.getChildByName("btn_start").addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			
		}
		
		private function mouseDownHandler(event:MouseEvent):void {
			
			_overlay.removeChild(_mainMenu);
			
			_world.initiate();
		}
	}
}