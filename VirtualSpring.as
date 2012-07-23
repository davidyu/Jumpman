package
{
	import Box2D.Dynamics.b2Body;

	public class VirtualSpring
	{
		
		private var _body:b2Body;
		private var _parent:PlayerActor;
		
		public function get canHandleContact():Boolean { return true; }
		
		public function VirtualSpring(realBody:b2Body, parent)
		{
			_body = realBody;
			_parent = parent;
		}
		
		public function get body():b2Body { return _body; } //this actually returns the player body
		
		//remmeber that this isn't an extension of actor, so you have to manually write this part:
		public function handleContact(otherObj) {
			
		}
		
		public function handleLethalContact(otherObj) {
			_parent.handleLethalContact(otherObj);
		}
		
		
		
		
	}
}