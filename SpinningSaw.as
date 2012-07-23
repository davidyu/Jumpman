package
{
	import Box2D.Collision.Shapes.b2CircleDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	
	public class SpinningSaw extends Hazard
	{
		
		//private static var saw_diameter = 150;
		
		
		public function SpinningSaw(canvas:DisplayObjectContainer, location:Point, saw_diameter:Number = 150)
		{
			//create the sprite
			var sawSprite:Sprite = new SawSprite();
			sawSprite.scaleX = saw_diameter / sawSprite.width;
			sawSprite.scaleY = saw_diameter / sawSprite.height;
			canvas.addChild(sawSprite);
			
			//create the shape definition
			var sawShapeDef:b2CircleDef = new b2CircleDef();
			sawShapeDef.radius = PhysiVals.meters(saw_diameter / 2);
			sawShapeDef.density = 0.0;
			sawShapeDef.friction = 0.0;
			sawShapeDef.restitution = 0.1;
			sawShapeDef.userData = this;
			
			//create the body definition
			var sawBodyDef:b2BodyDef = new b2BodyDef();
			sawBodyDef.position.Set(PhysiVals.meters(location.x), PhysiVals.meters(location.y));
			
			//create the body
			var sawBody:b2Body = PhysiVals.world.CreateBody(sawBodyDef);
			
			//create the shape
			sawBody.CreateShape(sawShapeDef);
			sawBody.SetMassFromShapes();
			
			super(sawBody, sawSprite, false, -180, 180);
		}
		
		
		
		
	}
}