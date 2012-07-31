package
{
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.b2Body;
	
	/*-----
	
	@author: Lewen Yu
	
	-----*/
	
	public class Midpoint extends CameraTarget
	{
		
		private var _targetA:b2Body;
		private var _targetB:b2Body;
		private static var _xDist:Number = 0;
		
		public function Midpoint(targetA:b2Body, targetB:b2Body)
		{
			_targetA = targetA;
			_targetB = targetB;
		}
		
		public function refresh(targetA:b2Body, targetB: b2Body)
		{
			_targetA = targetA;
			_targetB = targetB;
		}
		
		override public function updateNow():void
		{
			_position = new b2Vec2((_targetA.GetPosition().x + _targetB.GetPosition().x)/2, (_targetA.GetPosition().y + _targetB.GetPosition().y)/2);
			_xDist = PhysiVals.pixels(Math.abs((_targetA.GetPosition().x - _targetB.GetPosition().x)));
		}
		
		public function get xDist():Number { return _xDist; }
		
	}
}