package
{
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;

	public class lineOf
	{
		public function lineOf(collectible:Class, startPoint:Point, endPoint:Point, gapVector:Point, canvas:DisplayObjectContainer)
		{
			//weakness of this approach is we have to start from left to right, from bottom to top
			
			var currentPoint:Point = startPoint;
			while((endPoint.x >= currentPoint.x) && (endPoint.y >= currentPoint.y))
			{
				new collectible(currentPoint, canvas);
				
				currentPoint = currentPoint.add(gapVector);
			}
			
		}
	}
}