package
{
	import Box2D.Collision.Shapes.b2PolygonDef;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2PrismaticJoint;
	import Box2D.Dynamics.Joints.b2PrismaticJointDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	public class FloatingPlatformWithSwitch extends Actor implements SwitchControlledObject
	{
		
		private static const TO_START:int = 0;
		private static const STATIC:int = 1;
		private static const TO_END:int = 2;
		
		private var _state:int = TO_END; // 0 = destination: start, 1 = not moving, 2 = destination: end
									//this state is used to logically determine speeds and velocities
		private var _switch:Switch;
		

		private var _maxMotorSpeed:int = 5;
		private var _platformJoint:b2PrismaticJoint; //we need to access the joint to change the motor force
		private var _cooldown:int = 0;
		private var _stage:Stage;
		private var _timer:Timer;
		private var _elevatorPath:b2Vec2;
		private var _listOfPassengers:Array = new Array;
		
		
		public function FloatingPlatformWithSwitch(canvas:DisplayObjectContainer, stage:Stage, platform_width:int, platform_height:int, start:Point, end:Point, switch_position:b2Vec2)
		{
			var platformSprite:Sprite = new FloatingPlatformSprite();
			platformSprite.scaleX = platform_width / platformSprite.width;
			platformSprite.scaleY = platform_height / platformSprite.height;
			canvas.addChild(platformSprite);
			
			//define shape
			var platformShapeDef:b2PolygonDef = new b2PolygonDef();
			platformShapeDef.SetAsBox(PhysiVals.meters(platformSprite.width/2), PhysiVals.meters(platformSprite.height/2));
			platformShapeDef.friction = 1;
			platformShapeDef.restitution = 0.0;
			platformShapeDef.density = 4.0;
			platformShapeDef.userData = this;
			
			//define body
			var platformBodyDef:b2BodyDef = new b2BodyDef();
			platformBodyDef.position.Set(PhysiVals.meters(start.x), PhysiVals.meters(start.y + platformSprite.height/2));
			platformBodyDef.fixedRotation = true;
			
			//create body
			var platformBody:b2Body = PhysiVals.world.CreateBody(platformBodyDef);
			platformBody.CreateShape(platformShapeDef);
			platformBody.SetMassFromShapes();
			
			//build the prismatic joint
			
			var platformJoint:b2PrismaticJointDef = new b2PrismaticJointDef();
			
			_elevatorPath = new b2Vec2(PhysiVals.meters(end.x - start.x), PhysiVals.meters(end.y - start.y));
			
			//create temporary unit vector for the elevator path
			var elevatorPathInUnitVector:b2Vec2 = _elevatorPath.Copy();
			elevatorPathInUnitVector.Multiply(1/elevatorPathInUnitVector.Length());
			
			platformJoint.Initialize(PhysiVals.world.GetGroundBody(), platformBody, platformBody.GetPosition(), elevatorPathInUnitVector); //possible source of bug: change the order of start and ends
			platformJoint.enableLimit = true;
			platformJoint.lowerTranslation = 0;
			platformJoint.upperTranslation = _elevatorPath.Length();
			platformJoint.maxMotorForce = 1000;
			platformJoint.motorSpeed = 0.0;
			platformJoint.enableMotor=true;
			_platformJoint = PhysiVals.world.CreateJoint(platformJoint) as b2PrismaticJoint;
			_stage = stage;
			
			//instantiate the switch!
			_switch = new Switch(canvas, stage, this as SwitchControlledObject, new b2Vec2(switch_position.x, switch_position.y));
			
			super(platformBody, platformSprite, false);
		
		}
		
		private function movePlatformToEnd():void {
			_state = TO_END;
			_body.WakeUp();
			_platformJoint.SetMotorSpeed(_maxMotorSpeed);
		}
		
		private function movePlatformToStart():void {
			_state = TO_START;
			_body.WakeUp();
			_platformJoint.SetMotorSpeed(-1 * _maxMotorSpeed);
		}
		
		public function addPassenger(passenger:PlayerActor) {
			_listOfPassengers.push(passenger);
		}
		
		public function removePassenger(passenger:PlayerActor) {
			var _newListOfPassengers:Array = new Array;
			
			passenger.INHERIT_VX = 0;
			passenger.ridingMovingObject = false;
			
			for each (var currentPassenger:PlayerActor in _listOfPassengers)
			{
				if(currentPassenger.body!=passenger.body)
				{
					_newListOfPassengers.push(currentPassenger);
				}
			}
			
			_listOfPassengers = [];
			
			for each (var element:PlayerActor in _newListOfPassengers)
			{
				_listOfPassengers.push(element);
			}
			
			//_listOfPassengers = _newListOfPassengers.splice();
		}
		
		public function switchOnAction():void {
			movePlatformToEnd();
		}
		
		public function switchOffAction():void {
			movePlatformToStart();
		}
		
		public function get controller():Switch { return _switch; }
		
		override protected function updateOtherThings():void
		{	
			var passenger:PlayerActor;
			//use the current speed of the body and the state of the platform to predict its next state
			
			if(Math.abs(_body.GetLinearVelocity().x) < 0.1 && Math.abs(_body.GetLinearVelocity().y) < 0.1)
			{
				
				for each (passenger in _listOfPassengers)
				{
					passenger.INHERIT_VX = 0;
					passenger.ridingMovingObject = false;
				}
				
				/*
				if(_state != STATIC)
				{ //if it was moving to the starting position, then we set it to move to the end position within the cooldown time
					_timer = new Timer(_cooldown * 1000, 1);
					if(_state == TO_START)
					{
						_timer.addEventListener(TimerEvent.TIMER, movePlatformToEnd);
						_timer.start();
						_state = STATIC;
						//trace("Going to make it move to the end");
					}
					
					if (_state == TO_END) {
						_timer.addEventListener(TimerEvent.TIMER, movePlatformToStart);
						_timer.start();
						_state = STATIC;
						//trace("Going to make it move to the start");
					}
					
					
				}*/
			} else {
				for each (passenger in _listOfPassengers)
				{
					
					//passenger.body.SetLinearVelocity(_body.GetLinearVelocity());
					passenger.INHERIT_VX = _body.GetLinearVelocity().x;
					passenger.ridingMovingObject = true;
				}
			}
			
		}
		
		
	}
}
 