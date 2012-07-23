package
{
	
	import Box2D.Collision.Shapes.b2PolygonDef;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.Joints.b2Joint;
	import Box2D.Dynamics.Joints.b2PrismaticJoint;
	import Box2D.Dynamics.Joints.b2PrismaticJointDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	
	import flash.display.*;

	public class Elevator extends Actor implements SwitchControlledObject
	{
		
		//TODO: make a function that calculates the position of the elevator automatically.
		
		private static const HEIGHT:int = 20; 
		
		private var _state:String; //top, bottom or moving
		private var _switch:Switch;
		private var _elevatorJoint:b2PrismaticJoint; //we'll only use the joint for its motor force
		
		
		public function Elevator(canvas:DisplayObjectContainer, stage:Stage, platform_width:int, platform_height:int, location:b2Vec2, vec_elevator_path:b2Vec2, switch_position:b2Vec2)
		{
			
			var platformSprite:Sprite = new PlatformSprite();
			
			platformSprite.scaleX = platform_width / platformSprite.width;
			//platformSprite.scaleY = platform_height / platformSprite.height;
			
			canvas.addChild(platformSprite);
			
			//platformSprite.x = 0;
			//platformSprite.y = 0;
			
			//define shape
			var platformShapeDef:b2PolygonDef = new b2PolygonDef();
			platformShapeDef.SetAsBox(PhysiVals.meters(platform_width / 2), PhysiVals.meters(platform_height / 2));
			platformShapeDef.friction = 1;
			platformShapeDef.restitution = 0.0;
			platformShapeDef.filter.categoryBits = 0x0004;
			platformShapeDef.filter.maskBits = ~0x1;
			platformShapeDef.density = 4.0;
			platformShapeDef.userData = this;
			
			//define body
			var platformBodyDef:b2BodyDef = new b2BodyDef();
			platformBodyDef.position.Set(PhysiVals.meters(location.x), PhysiVals.meters(location.y - (vec_elevator_path.y) + HEIGHT/2));
			platformBodyDef.fixedRotation = true;
			
			//create body
			var platformBody:b2Body = PhysiVals.world.CreateBody(platformBodyDef);
			platformBody.CreateShape(platformShapeDef);
			platformBody.SetMassFromShapes();
			
			//take the vector and build the prismatic joint
			
			var elevatorJoint:b2PrismaticJointDef= new b2PrismaticJointDef();
			//var anchor:b2Vec2 = new b2Vec2(PhysiVals.meters(location.x + vec_elevator_path.x), PhysiVals.meters(location.y - (vec_elevator_path.y) / 2));
			
			elevatorJoint.Initialize(PhysiVals.world.GetGroundBody(), platformBody, platformBody.GetPosition(), new b2Vec2(0,1));
			elevatorJoint.enableLimit = true;
			elevatorJoint.lowerTranslation = 0;
			elevatorJoint.upperTranslation = PhysiVals.meters(vec_elevator_path.y);
			elevatorJoint.maxMotorForce = 1000;
			elevatorJoint.motorSpeed = 5.0;
			elevatorJoint.enableMotor=true;
			_elevatorJoint = PhysiVals.world.CreateJoint(elevatorJoint) as b2PrismaticJoint;
			
			//take the starting position and "reposition" the 
			
			_switch = new Switch(canvas, stage, this as SwitchControlledObject, new b2Vec2(switch_position.x, switch_position.y)); //initialize the switch!
			
			super(platformBody, platformSprite, false);
			
			//trace(platformBody.GetMass());
			
		}
		
		public function moveUp():void
		{
			_body.WakeUp();
			_elevatorJoint.SetMotorSpeed(-6.0);
			//trace("DIFFERENCE BETWEEEN SPRITE AND BODY: " + (_costume.x -_body.GetPosition().x * PhysiVals.RATIO));
			//trace("SPRITE HEIGHT: " + _costume.y);
		}
		
		public function moveDown():void 
		{
			_body.WakeUp();
			_elevatorJoint.SetMotorSpeed(6.0);
			//trace("DIFFERENCE BETWEEN SPRITE AND BODY: " + (_costume.x - _body.GetPosition().x * PhysiVals.RATIO));
			//trace("SPRITE HEIGHT: " + _costume.y);
		}
		
		public function halt():void {
			_elevatorJoint.SetMotorSpeed(0);
		}
		
		public function switchOnAction():void {
			moveUp();
		}
		
		public function switchOffAction():void {
			moveDown();
		}
		
		public function get controller():Switch { return _switch; }
		
		
	}

}