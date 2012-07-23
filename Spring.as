package
{
	import Box2D.Collision.Shapes.b2PolygonDef;
	import Box2D.Collision.Shapes.b2ShapeDef;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	
	public class Spring extends Actor
	{
		
		private var _restitution = 0.0;
		private static const ON_GROUND:int = 0;
		private static const FLOAT_LEFT:int = 1;
		private static const FLOAT_RIGHT:int = 2;
		private static const PLAYER_HEAD:int = 3;
		
		public function Spring(canvas:DisplayObjectContainer, spring_type:int, spring_width:int, spring_height:int, location:b2Vec2)
		{
			
			var springSprite:MovieClip;
			
			switch (spring_type)
			{
				case ON_GROUND:
					springSprite = new GroundSpringSprite();
					//springSprite.scaleX = spring_width / springSprite.width;
					break;
				case FLOAT_LEFT:
					springSprite = new LeftFloatingSpringSprite();
					//springSprite.scaleX = spring_width / springSprite.width;
					//springSprite.scaleY = spring_height / springSprite.height;
					break;
				case FLOAT_RIGHT:
					springSprite = new RightFloatingSpringSprite();
					//springSprite.scaleX = spring_width / springSprite.width;
					//springSprite.scaleY = spring_height / springSprite.height;
					break;
				case PLAYER_HEAD:
					//springSprite = new Sprite;
				default:
					trace("the spring type you specified wasn't found. Spring cannot be built.");
			}
			
			canvas.addChild(springSprite);
			
			/*
			if (spring_type == ON_GROUND) {
				var springSprite:MovieClip = new GroundSpringSprite();
				springSprite.scaleX = spring_width / springSprite.width;
			}
			
			if (spring_type == FLOAT_LEFT) {
				var springSprite:MovieClip = new LeftFloatingSpringSprite();
				springSprite.scaleX = spring_width / springSprite.width;
				springSprite.scaleY = spring_height / springSprite.height;
			}
			
			if (spring_type == FLOAT_RIGHT) {
				var springSprite:MovieClip = new RightFloatingSpringSprite();
				springSprite.scaleX = spring_width / springSprite.width;
				springSprite.scaleY = spring_height / springSprite.height;
			}*/
			
			var springShapeDef:b2PolygonDef = new b2PolygonDef();
			springShapeDef.SetAsBox(PhysiVals.meters(spring_width/2), PhysiVals.meters(spring_height/2));
			springShapeDef.friction = 0;
			springShapeDef.restitution = _restitution;
			springShapeDef.density = 0.0;
			springShapeDef.userData = this;
			
			var springBodyDef:b2BodyDef = new b2BodyDef();
			springBodyDef.position.Set(PhysiVals.meters(location.x), PhysiVals.meters(location.y));
			springBodyDef.fixedRotation = true;
			
			var springBody:b2Body = PhysiVals.world.CreateBody(springBodyDef);
			springBody.CreateShape(springShapeDef);
			
			//TODO: implement function
			super(springBody, springSprite, false);
		}
		
		static public function get on_ground():int { return ON_GROUND; }
		
		static public function get float_left():int { return FLOAT_LEFT; }
		
		static public function get float_right():int { return FLOAT_RIGHT; }
		
		override public function handleContact(otherObj):void
		{
			playSFX("boing.mp3");
		}
		
		//public function get body():b2Body { return _body; }
	}
}