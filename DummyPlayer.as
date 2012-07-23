package
{
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Dynamics.b2Body;
	
	import flash.display.Sprite;
	
	public class DummyPlayer extends Actor
	{
		public function DummyPlayer(myBody:b2Body, myCostume:Sprite, bodyShape:b2Shape, springShape:b2Shape)
		{
			bodyShape.SetUserData(this);
			springShape.SetUserData(this);
			
			super(myBody, myCostume, false);
		}
		
//		public function get body():b2Body { return _body; }
	}
}