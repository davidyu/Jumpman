package
{
	
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import Box2D.Dynamics.Joints.*;
	
	/*----
	
	@author: Lewen Yu
	
	---*/
	
	public class Connector {
		
		private var count:int = 20;
		//private var strong:Boolean = true;
		private var anchor:b2Vec2;
		private var _ropeJoints:Array = [];
		private var _ropeJointActors:Array = [];
		
		public function Connector(actorA:PlayerActor, actorB:PlayerActor)
		{
			//we make a number of assumptions here:
			//there are only two actors, actorA and actorB
			//actorA is on the left of actorB
			//the distance between them is a perfect multiple of 10
			//they have the same Y position, that is, they are horizontally aligned
			
			anchor = actorA.GetPosition();
			count = Math.abs(PhysiVals.pixels(actorA.body.GetPosition().x - actorB.body.GetPosition().x)) / 10;
			var ropeJoint:b2Body;
			var ropeJointActor:RopeJointActor;
			
			for (var i:int = 1; i <= count; i++) {
				if (i != count) {
//					var ropeJoint = 
					ropeJointActor = new RopeJointActor(anchor, i);
					_ropeJointActors.push(ropeJointActor)
					
					ropeJoint = ropeJointActor.ropeBody;
					_ropeJoints.push(ropeJoint);
					
				} else {
					// attach playerB body to ropeJoints
					var bodyDef:b2BodyDef = new b2BodyDef();
					bodyDef.position = anchor.Copy();
					bodyDef.position.Add(new b2Vec2(PhysiVals.meters(i * 10), 0));
					ropeJoint = PhysiVals.world.CreateBody(bodyDef);
					_ropeJoints.push(actorB.body);
				}
			}
			
			// Connects ropeJoints together. First ropeJoint is connected directly to the "ceiling".
			var lastRopeJoint:b2Body = null;
			for each (ropeJoint in _ropeJoints) {
				var distanceJointDef:b2DistanceJointDef = new b2DistanceJointDef();
				if (lastRopeJoint == null) {
					distanceJointDef.Initialize(ropeJoint, actorA.body, ropeJoint.GetPosition(), actorA.body.GetPosition());
				} else {
					distanceJointDef.Initialize(ropeJoint, lastRopeJoint, ropeJoint.GetPosition(), lastRopeJoint.GetPosition());
				}
				PhysiVals.world.CreateJoint(distanceJointDef);
				lastRopeJoint = ropeJoint;
			}
			
			//now tighten the ropes
			
			for each (ropeJoint in _ropeJoints) {
				if (ropeJoint != actorB.body) {
					bodyDef = new b2BodyDef();
		        	bodyDef.position = anchor;
		        	var attachement:b2Body = PhysiVals.world.CreateBody(bodyDef);

		        	var massData:b2MassData = new b2MassData();
		        	massData.mass = ropeJoint.GetMass();
		        	massData.I = ropeJoint.GetInertia();
		        	attachement.SetMass(massData);

		        	var revoluteJointDef:b2RevoluteJointDef = new b2RevoluteJointDef();
		        	revoluteJointDef.Initialize(attachement, actorA.body, attachement.GetPosition());
		        	PhysiVals.world.CreateJoint(revoluteJointDef);

		        	var prismaticJointDef:b2PrismaticJointDef = new b2PrismaticJointDef();
		        	prismaticJointDef.Initialize(attachement, ropeJoint, ropeJoint.GetPosition(), new b2Vec2(1, 0));
		        	prismaticJointDef.enableLimit = true;
		        	prismaticJointDef.lowerTranslation = - (ropeJoint.GetPosition().x - actorA.body.GetPosition().x);
		        	prismaticJointDef.upperTranslation = (ropeJoint.GetPosition().x - actorA.body.GetPosition().x);
		        	PhysiVals.world.CreateJoint(prismaticJointDef);
				}
		
			}
			
			//finally, update each body with a reference to the body it's connected to
			//actorA.partner = actorB;
			//actorB.partner = actorA;
			
		}
		
		public function get ropeJoints():Array { return _ropeJoints; }
		
		public function get ropeJointActors():Array { return _ropeJointActors; }
		
		public function Disconnect()
		{
			
		}
		
		public function Reconnect()
		{
			//when it disconnects, an instance of Connector still exists. So we should
			//allow the possibility of a re-connection, right?
		}
		
	}
	
}