package
{
	import Box2D.Dynamics.b2Body;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class LittleKidNPC extends NPC
	{
		
		private var _hadBeenSpokenTo:Boolean;
		
		public function LittleKidNPC(position:Point)
		{
			
			super(littleKidSprite, position);
		}
		
		override public function speak():void {
			
		}
		
		override public function speakForTheFirstTime():void {
			//var speech_IDSOMETHING = new SpeechBubble(messageSprite, fadeInterval);
			//changeEmotion(emotion);
			
			//if (speech_IDSOMETHING.done) {
				//updateNarrative(message);
			//}
		}
		
				
	}
}