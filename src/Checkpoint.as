package
{
	import Box2D.Collision.Shapes.b2PolygonDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;

	public class Checkpoint extends Actor implements TouchSensitiveObject
	{
		private var _position:Point;
		private var _ID:int;
		private var _world:BoxWorld
		private static const HEIGHT = 100;
		private static const WIDTH = 50;
		
		
		public function Checkpoint(canvas:DisplayObjectContainer, world:BoxWorld, position:Point, ID:int)
		{
			_position = position;
			_ID = ID;
			_world = world;
			
			var flagSprite = new FlagSprite();
			canvas.addChild(flagSprite);
			
			//create shape def
			var flagShapeDef:b2PolygonDef = new b2PolygonDef();
			flagShapeDef.SetAsBox(PhysiVals.meters(WIDTH/2), PhysiVals.meters(HEIGHT/2));
			flagShapeDef.friction = 0;
			flagShapeDef.density = 0;
			flagShapeDef.restitution = 0;
			flagShapeDef.isSensor = true;
			flagShapeDef.userData = this;
			
			//create body def
			var flagBodyDef:b2BodyDef = new b2BodyDef();
			flagBodyDef.position.Set(new b2Vec2(PhysiVals.meters(position.x), PhysiVals.meters(position.y)));
			flagBodyDef.fixedRotation = true;
			
			//create body
			var flagBody:b2Body = PhysiVals.world.CreateBody(flagBodyDef);
			flagBody.CreateShape(flagShapeDef);
			flagBody.SetMassFromShapes();
			
			super(flagBody, flagSprite, false);
			
		}
		
		private static function addCheckpoint(ID:int):void
		{
			//_world.
		}
		
		public function doSomething():void
		{
			addCheckpoint(ID);
		}
	}
}