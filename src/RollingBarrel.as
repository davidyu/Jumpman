package
{
	import Box2D.Collision.Shapes.b2CircleDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class RollingBarrel extends Actor
	{
		
		private static const BARREL_DIAMETER = 100;
		
		public function RollingBarrel(canvas:DisplayObjectContainer, location:Point)
		{
			
			//create the sprite
			var barrelSprite:Sprite = new BarrelSprite();
			barrelSprite.scaleX = BARREL_DIAMETER / barrelSprite.width;
			barrelSprite.scaleY = BARREL_DIAMETER / barrelSprite.height;
			canvas.addChild(barrelSprite);
			
			//create the shape definition
			var barrelShapeDef:b2CircleDef = new b2CircleDef();
			barrelShapeDef.radius = PhysiVals.meters(BARREL_DIAMETER / 2);
			barrelShapeDef.density = 3.0;
			barrelShapeDef.friction = 3.0;
			barrelShapeDef.restitution = 0.1;
			barrelShapeDef.filter.categoryBits = 0x0004;
			barrelShapeDef.userData = this;
			
			//create the body definition
			var barrelBodyDef:b2BodyDef = new b2BodyDef();
			barrelBodyDef.angle = PhysiVals.degrees(Math.random() * Math.PI * 2);
			barrelBodyDef.position.Set(PhysiVals.meters(location.x), PhysiVals.meters(location.y));
			
			//create the body
			var barrelBodyB:b2Body = PhysiVals.world.CreateBody(barrelBodyDef);
			
			trace(barrelSprite);
			trace(barrelShapeDef);
			trace(barrelBodyDef);
			trace(barrelBodyB);
			
			
			//create the shape
			barrelBodyB.CreateShape(barrelShapeDef);
			barrelBodyB.SetMassFromShapes();
			
			super(barrelBodyB, barrelSprite, true);
		}
	}
}