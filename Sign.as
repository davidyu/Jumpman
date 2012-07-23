package
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Point;

	public class Sign
	{
		
		public static const ARROW_RIGHT:Sprite = new rightArrowSignSprite();
		public static const ARROW_LEFT:Sprite = new leftArrowSignSprite();
		public static const ARROW_UP:Sprite = new upArrowSignSprite();
		public static const WARNING_BARREL_ROLLS:Sprite = new WarningBarrelRollsSprite();
		public static const DANGER_ACID:Sprite = new DangerAcidSprite();
		public static const DANGER_SAWBLADES:Sprite = new DangerSawSprite();
		
		public function Sign(canvas:DisplayObjectContainer, position:Point, sprite:Sprite)
		{
			canvas.addChild(sprite);
			sprite.x = position.x;
			sprite.y = position.y;
			
		}
	}
}