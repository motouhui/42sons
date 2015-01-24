package Util
{
	import flash.geom.Point;

	public class Util
	{
		public static function Distance(x1:int, y1:int, x2:int, y2:int):Number 
		{
			return Math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2));
		}
		
		public static function inView(x1:int, y1:int, x2:int, y2:int, radius:int):Boolean 
		{
			return Distance(x1, y1, x2, y2) <= radius;
		}
		
		public static function cross(x1:int, y1:int, radius1:int, x2:int, y2:int, radius2:int):Boolean
		{
			var dist:Number = Distance(x1, y1, x2, y2);
			return dist <= radius1 + radius2;
		}
		
		public static function place(x1:int, y1:int, x2:int, y2:int, speed:int):Point
		{
			var p:Number = 1.0 * (x2 - x1) / (y2 - y1);
			var z:Number = speed / Math.sqrt(p * p + 1);
			var x:int = 0;
			var y:int = 0;
			if (x2 >= x1) {
				x = (int)(x1 + p * z);
			} else {
				x = (int)(x1 - p * z);
			}
			if (y2 >= y1) {
				y = (int)(y1 + z);
			} else {
				y = (int)(y1 - z);
			}
			
			return new Point(x, y);
		}
	}
}