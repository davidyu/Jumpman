package
{
	import Box2D.Common.Math.*;
	
	/*-----
	
	@author: Lewen Yu
	
	-----*/
	
	public class CameraTarget
	{
		
		protected var _position:b2Vec2; //moving point
		
		public function CenterOfInterest():void
		{
			
		}
		
		public function GetPosition():b2Vec2
		{
			return _position;
		}
		
		public function updateNow():void
		{
			//does nothing
			//I expect it to be called by my children
		}
		//public function set position(value:b2Vec2) { _position = b2Vec2 };
		
	}
}