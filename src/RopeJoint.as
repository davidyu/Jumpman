package
{
	import Box2D.Dynamics.*;
	import Box2D.Common.Math.*;
	import Box2D.Collision.Shapes.*;
	import flash.display.*;
	
	
	public class RopeJointActor extends Actor
	{
		private var _ropeBody:b2Body;
		private var _antiGravity:b2Vec2;
		
		public function RopeJoint(anchor:b2Vec2, i:int) {
			
			var ropeSprite:Sprite = new Sprite();
			var ropeShapeDef:b2CircleDef = new b2CircleDef();
			
			var ropeBodyDef:b2BodyDef = new b2BodyDef();
			ropeBodyDef.position = anchor.Copy();
			ropeBodyDef.position.Add(new b2Vec2(PhysiVals.meters(i * 10), 0));
			
			_ropeBody = PhysiVals.world.CreateBody(ropeBodyDef);
			
			ropeShapeDef.radius = PhysiVals.meters(2.5);
			ropeShapeDef.density = 4.0;
			ropeShapeDef.filter.categoryBits = 0x0002;
			ropeShapeDef.filter.maskBits = ~0x0004;

			_ropeBody.CreateShape(ropeShapeDef);
			_ropeBody.SetMassFromShapes();
			
			super(_ropeBody, ropeSprite, true);
			
			_antiGravity = new b2Vec2(0.0,(-0.9) * PhysiVals.gravity.y * _ropeBody.GetMass());
			//trace(_antiGravity);
		}
		
		public function get ropeBody():b2Body {return _ropeBody;}
		
		override protected function updateOtherThings():void
		{
			_antiGravity = new b2Vec2(0.0,(-1) * PhysiVals.gravity.y * _ropeBody.GetMass());
			//constantly negate maybe, 98% of gravity.
			//trace(new b2Vec2(0.0,(-0.9) * PhysiVals.gravity.y * _ropeBody.GetMass()));
			_ropeBody.ApplyForce(_antiGravity, _ropeBody.GetPosition());
		}
	}	
}