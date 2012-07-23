package
{
	import Box2D.Dynamics.b2Body;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class Hazard extends Actor
	{
		
		private var _minEffectiveNormalRange:Number;
		private var _maxEffectiveNormalRange:Number;
		
		public function Hazard(myBody:b2Body, myCostume:Sprite, allowRotation:Boolean, minEffectiveNormalRange:Number, maxEffectiveNormalRange:Number)
		{
			_minEffectiveNormalRange = minEffectiveNormalRange; 
			_maxEffectiveNormalRange = maxEffectiveNormalRange;
				
			super(myBody, myCostume, allowRotation);
		}
		
		public function get minEffectiveNormalRange():Number { return _minEffectiveNormalRange; }
		public function get maxEffectiveNormalRange():Number { return _maxEffectiveNormalRange; }
		public function withinEffectiveNormalRange(angle:Number):Boolean
		{
			if(angle>=_minEffectiveNormalRange && angle<= _maxEffectiveNormalRange) { 
				return true;
			} else {
				return false;
			}
		}
		
	}
}