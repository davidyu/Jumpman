package
{

	public class Control
	{
		private var _up:int;
		private var _left:int;
		private var _down:int;
		private var _right:int;
		private var _cmdCameraFocus:int;
		private var _cmdActivateMagnet:int;
		
		public function Control(up:int, left:int, down:int, right:int, cmdCameraFocus:int, cmdActivateMagnet:int)
		{
			_up = up;
			_left = left;
			_down = down;
			_right = right;	
			_cmdCameraFocus = cmdCameraFocus;
			_cmdActivateMagnet = cmdActivateMagnet;
		}
		
		public function get Up():int { return _up; }
		public function get Left():int { return _left; }
		public function get Down():int { return _down; }
		public function get Right():int { return _right; }
		public function get cmdCameraFocus():int { return _cmdCameraFocus; }
		public function get cmdActivateMagnet():int { return _cmdActivateMagnet; }

	}
}