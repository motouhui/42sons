package Person
{
	import flash.geom.Point;
	
	public class Step
	{
		private var _left:int = 1;
		private var _right:int = 1;
		private var _up:int = 1;
		private var _down:int = 1;
		
		public function direction():Point
		{
			var total:int = _left + _right + _up + _down;
			var left:Number = 1.0 * _left / total * 1;
			var right:Number = left + 1.0 * _right / total * 1;
			var up:Number = right + 1.0 * _up / total * 1;
			var down:Number = up + 1.0 * _down / total * 1; 
			
			var t:Number = Math.random();
			if (t <= left) {
				_left = (_left + 1) % 100 + 1;
				return new Point(-1, 0);
			} else if (t <= right) {
				_right = (_right + 1) % 100 + 1;
				return new Point(1, 0);
			} else if (t <= up) {
				_up = (_up + 1) % 100 + 1;
				return new Point(0, 1);
			}
			_down = (_down + 1) % 100 + 1;
			return new Point(0, -1);
		}
		
		public function knockLeftWallDirection():Point
		{
			_left = 0;
			var p:Point = direction();
			if (p.x >= 0) {
				return p;
			}
			_left = 0;
			var t:Number = Math.random();
			if (t < 1.0 / 3) {
				_right = (_right + 1) % 100 + 1;
				return new Point(1, 0);
			} else if (t < 2.0 / 3) {
				_down = (_down + 1) % 100 + 1;
				return new Point(0, 1);
			} 
			_up = (_up + 1) % 100 + 1
			return new Point(0, -1);
		}
		
		public function knockRightWallDirection():Point
		{
			_right = 0;
			var p:Point = direction();
			if (p.x <= 0) {
				return p;
			}
			_right = 0;
			var t:Number = Math.random();
			if (t < 1.0 / 3) {
				_left = (_left + 1) % 100 + 1;
				return new Point(-1, 0);
			} else if (t < 2.0 / 3) {
				_down = (_down + 1) % 100 + 1;
				return new Point(0, 1);
			}
			_up = (_up + 1) % 100 + 1;
			return new Point(0, -1);
		}
		
		public function knockUpWallDirection():Point
		{
			_up = 0;
			var p:Point = direction();
			if (p.y >= 0) {
				return p;
			}
			_up = 0;
			var t:Number = Math.random();
			if (t < 1.0 / 3) {
				_left = (_left + 1) % 100 + 1;
				return new Point(-1, 0);
			} else if (t < 2.0 / 3) {
				_right = (_right + 1) % 100 + 1;
				return new Point(1, 0);
			}
			_down = (_down + 1) % 100 + 1;
			return new Point(0, 1);
		}
		
		public function knockDownWallDirection():Point
		{
			_down = 0;
			var p:Point = direction();
			if (p.y <= 0) {
				return p;
			}
			_down = 0;
			var t:Number = Math.random();
			if (t < 1.0 / 3) {
				_left = (_left + 1) % 100 + 1;
				return new Point(-1, 0);
			} else if (t < 2.0 / 3) {
				_right = (_right + 1) % 100 + 1;
				return new Point(1, 0);
			}
			_up = (_up + 1) % 100 + 1;
			return new Point(0, -1);
		}
		
		public function knockLeftUpCornerDirection():Point
		{
			_left = 0;
			_up = 0;
			var p:Point = direction();
			if (p.y >= 0 && p.x >= 0) {
				return p;
			}
			_left = 0;
			_up = 0;
			var t:Number = Math.random();
			if (t < 0.5) {
				_right = (_right + 1) % 100 + 1;
				return new Point(1, 0);
			}
			_down = (_down + 1) % 100 + 1;
			return new Point(0, 1);
		}
		
		public function knockRightUpCornerDirection():Point
		{
			_right = 0;
			_up = 0;
			var p:Point = direction();
			if (p.y >= 0 && p.x <= 0) {
				return p;
			}
			_right = 0;
			_up = 0;
			var t:Number = Math.random();
			if (t < 0.5) {
				_left = (_left + 1) % 100 + 1;
				return new Point(-1, 0);
			}
			_down = (_down + 1) % 100 + 1;
			return new Point(0, 1);
		}
		
		public function knockLeftDownCornerDirection():Point
		{
			_left = 0;
			_down = 0;
			var p:Point = direction();
			if (p.y <= 0 && p.x >= 0) {
				return p;
			}
			_left = 0;
			_up = 0;
			var t:Number = Math.random();
			if (t < 0.5) {
				_right = (_right + 1) % 100 + 1;
				return new Point(1, 0);
			}
			_up = (_up + 1) % 100 + 1;
			return new Point(0, -1);
		}
		
		public function knockRightDownCornerDirection():Point
		{
			_right = 0;
			_down = 0;
			var p:Point = direction();
			if (p.y <= 0 && p.x <= 0) {
				return p;
			}
			_right = 0;
			_down = 0;
			var t:Number = Math.random();
			if (t < 0.5) {
				_left = (_left + 1) % 100 + 1;
				return new Point(-1, 0);
			}
			_up = (_up + 1) % 100 + 1;
			return new Point(0, -1);
		}
	}
}
