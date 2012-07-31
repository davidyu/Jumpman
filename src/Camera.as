package
{
	import Box2D.Collision.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	import com.freeactionscript.ParallaxField;
	
	public class Camera
	{
		
		private static const BUFFER_X:Number = 5;
		private static const BUFFER_Y:Number = 0.5;
		private static var _target:CameraTarget;
		private static var _subject:b2Body;
		private static var _trackingTarget:Boolean = false;
		private static var _position:b2Vec2 = new b2Vec2(0, 0);
		private static var _halting:Boolean = false;
		private static var _parallaxBG:ParallaxField = null;
		
		public function Camera()
		{
			//_target = target;
			//updatePosition();
		}
		
		//to do: make FocusOn function
		//		 store 2 variables x and y.
		//		 link it up with BoxWorld.as
		
		static public function updatePosition():void
		{
			//trace(_target);
			//in order to add inertia, we use 85% of the old camera position and 15% of the new camera position.
			//idea from gosu (http://www.libgosu.org/cgi-bin/mwf/topic_show.pl?tid=376).
			
			if (!_halting)
			{
				if (_trackingTarget)
				{
					if (_parallaxBG) moveParallax(_target.GetPosition(), _position);
					
					
					_position = new b2Vec2(_position.x * 0.85 + _target.GetPosition().x * 0.15,
											_position.y * 0.85 + _target.GetPosition().y * 0.15);
					
				}
				else
				{
					if (_parallaxBG) moveParallax(_subject.GetPosition(), _position);
					
					_position = new b2Vec2(_position.x * 0.85 + _subject.GetPosition().x * 0.15,
											_position.y * 0.85 + _subject.GetPosition().y * 0.15);
				}
			}
		}
		
		static public function moveParallax(destination:b2Vec2, original:b2Vec2):void
		{
			
//			trace("destination : (" +  destination.x + ", " + destination.y + ")" +
//				  "\noriginal : (" + original.x + ", " + original.y + ")");
			
			if (destination.x > original.x + PhysiVals.meters(BUFFER_X))
			{
				_parallaxBG.rightPressed = true;
				_parallaxBG.leftPressed = false;
			}
			else if (destination.x < original.x - PhysiVals.meters(BUFFER_X))
			{
				_parallaxBG.leftPressed = true;
				_parallaxBG.rightPressed = false;
			}
			else
			{
				_parallaxBG.leftPressed = false;
				_parallaxBG.rightPressed = false;
			}
			
			if (destination.y > original.y + PhysiVals.meters(BUFFER_Y))
			{
				_parallaxBG.downPressed = true;
				_parallaxBG.upPressed = false;
			}
			else if (destination.y < original.y - PhysiVals.meters(BUFFER_Y))
			{
				_parallaxBG.upPressed = true;
				_parallaxBG.downPressed = false;
			}
			else
			{
				_parallaxBG.upPressed = false;
				_parallaxBG.downPressed = false;
			}
		}
		
		static public function stop():void
		{
			_halting = true;
		}
		
		static public function start():void
		{
			_halting = false;
		}
		
		static public function clearALlReferences():void
		{
			_subject = null;
			_target = null;
		}
		
		static public function set target(value:CameraTarget):void { _target = value; _trackingTarget = true;} //fancy animations should go in here
		static public function get subject():b2Body { return _subject; }
		static public function set subject(value:b2Body):void { _subject = value; _trackingTarget = false;} //fancy animations should go in here
		static public function get trackingTarget():Boolean { return _trackingTarget; }
		static public function get position():b2Vec2 { return _position; }
		static public function set parallaxBG(value:ParallaxField):void { _parallaxBG = value } 
	}
	
}