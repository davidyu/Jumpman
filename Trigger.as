package
{
	import Box2D.Collision.Shapes.b2PolygonDef;
	import Box2D.Collision.Shapes.b2ShapeDef;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	
	import flash.geom.Point;

	public class Trigger implements TouchSensitiveObject
	{
		private var _function:Function;
		private var _triggered:Boolean = false;
		
		public function Trigger(location:Point, arrayOfCoords:Array, action:Function, world:BoxWorld)
		{
			
			var myBody:b2Body = createBodyFromCoords(arrayOfCoords, location);
			_function = action;
			//_world = world;
		}
		
		private function createBodyFromCoords(arrayOfCoords:Array, location:Point):b2Body
		{
			//define shapes
			var allShapeDefs:Array = [];
			
			for each (var listOfPoints:Array in arrayOfCoords) {
				var newShapeDef:b2PolygonDef = new b2PolygonDef();
				newShapeDef.vertexCount = listOfPoints.length;
				for (var i:int = 0; i < listOfPoints.length; i++) {
					var nextPoint:Point = listOfPoints[i];
					b2Vec2(newShapeDef.vertices[i]).Set(nextPoint.x / PhysiVals.RATIO, nextPoint.y / PhysiVals.RATIO); 
				}
				newShapeDef.density = 0;
				newShapeDef.friction = 0;
				newShapeDef.restitution = 0;
				newShapeDef.userData = this;
				newShapeDef.isSensor = true;
				
				allShapeDefs.push(newShapeDef);
			}
			
			//define body
			var propBodyDef:b2BodyDef = new b2BodyDef();
			propBodyDef.position.Set(location.x / PhysiVals.RATIO, location.y / PhysiVals.RATIO);
			
			//create body
			var propBody:b2Body = PhysiVals.world.CreateBody(propBodyDef);
			
			//create shapes
			for each (var newShapeDefToAdd:b2ShapeDef in allShapeDefs) {
				propBody.CreateShape(newShapeDefToAdd);
			}
			
			propBody.SetMassFromShapes();
			
			return propBody;
		}
		
		public function doSomething():void
		{
			if(!_triggered) {
				_function();
				_triggered = true;
			}
		}
	}
}