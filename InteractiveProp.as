package
{
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	import flash.events.*;
	import flash.display.*;
	import flash.geom.*;
	
	/*---
	
	@author: Lewen Yu
	
	---*/
	
	public class InteractiveProp extends Prop
	{
		public function InteractiveProp(parent:DisplayObjectContainer, location:Point, arrayOfCoords:Array, textureLoc = "none", density:Number = 1.00)
		{
			super(parent, location, arrayOfCoords, textureLoc, density);
		}
	}
}