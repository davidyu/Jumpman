package
{
	import Box2D.Dynamics.b2Body;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Point;

	public class NPC
	{
		private var _actor:Actor 
		protected var _sprite:MovieClip; //I know, a little bit counterintuitive...
		protected var _hasBeenSpokenTo:Boolean = false;
		
		public function NPC(World:BoxWorld, NPCSprite:MovieClip, position:Point, bodyWidth:Number = 0, bodyHeight:Number = 0)
		{
			
			if(bodyWidth == 0 && bodyHeight == 0) {
				//inherit width and height from the sprite
				bodyWidth = NPCSprite.width;
				bodyHeight = NPCSprite.height;
			}
			
			//define shape
			
			
			//define body
			
			
			//create body
			
			
			//create shape
			
			
			_actor = new Actor(NPCBody, NPCSprite, false);
		}
		
		protected function activate():void
		{
			if(_hasBeenSpokenTo) {
				speak();
			} else {
				speakForTheFirstTime();
				_hasBeenSpokenTo = true;
			}
			
		}
		
		protected function speakForTheFirstTime():void
		{
			//I expect this to be overriden by my children
		}
		
		protected function speak():void
		{
			speakForTheFirstTime();
			//I expect this to be overriden by my children
		}
		
		protected function updateNarrative(message:String):void
		{
			
		}
	}
}