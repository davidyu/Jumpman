package
{
	import Box2D.Collision.Shapes.b2PolygonDef;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Collision.Shapes.b2ShapeDef;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	
	import com.boristhebrave.Box2D.Controllers.b2BuoyancyController;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.filters.DisplacementMapFilter;
	import flash.geom.Point;
	
	public class Acid extends Hazard implements Fluid
	{
		
		//As with the beginning of all classes, we need to declare some basic variables: 
		private var _density:Number = 0.0;
		private var _friction:Number = 0.0;
		private var _restitution:Number = 0.0;
		private var _acidColor:Number = 0x999900;
		
		//Now we need to instantiate the custom Controller that simulates buoyancy in fluids (thanks to BorisTheBrave):
		private var _acidBuoyancyController:b2BuoyancyController = new b2BuoyancyController();
		
		
		public function Acid(canvas:DisplayObjectContainer, location:Point, arrayOfCoords:Array)
		{
			//We need to create the body and the sprite...
			var acidBody:b2Body = createBodyFromCoords(arrayOfCoords, location);
			var acidBaseSprite:Sprite = createSpriteFromCoords(arrayOfCoords, location, canvas);
			
			_acidBuoyancyController.offset = PhysiVals.meters(-(location.y + arrayOfCoords[0][0].y));
			//And the tweak the buoyancy controller so it feels just right.
			_acidBuoyancyController.normal.Set(0,-1);
			
			_acidBuoyancyController.density = 5; 
			/*the density was originally at 2.0, but this made barrel oscillate up and down through the acid.
			  I changed it to 1.8, and everything worked fine. For future reference, the higher the density,
			  the faster the object in the liquid floats.*/
			
			_acidBuoyancyController.linearDrag = 20; //the higher this is, the slower the item moves through the fluid
			_acidBuoyancyController.angularDrag = 2; //see above
			
			//Call the parent constructor...
			super(acidBody, acidBaseSprite, false, -180, 180);
		}
		
		public function AddBody(body:b2Body):void
		{
			_acidBuoyancyController.AddBody(body);
			
			//swap sprite depths if necessary
			if (body.GetUserData() is Actor)
			{
				var submergedSprite = (body.GetUserData() as Actor).sprite;
				var parent:DisplayObjectContainer = _costume.parent as DisplayObjectContainer;
				
				if (parent.getChildIndex(_costume) < parent.getChildIndex(submergedSprite)) parent.swapChildren(submergedSprite, _costume);
								
			}
		}
		
		public function RemoveBody(body:b2Body):void
		{
			_acidBuoyancyController.RemoveBody(body);
		}
		
		public function get offset():Number { return _acidBuoyancyController.offset; }
		
		public function GetBodies():Array { return _acidBuoyancyController.GetBodies(); }
		
		private function createSpriteFromCoords(arrayOfCoords:Array, location:Point, parent:DisplayObjectContainer):Sprite
		{
			
			//You don't really need to understand this...it basically takes an array of points and
			//connects them to make a sprite.
			var newSprite:Sprite = new Sprite();
			newSprite.graphics.lineStyle(2, 0x5D7E62);
			for each (var listOfPoints:Array in arrayOfCoords) {
				var firstPoint:Point = listOfPoints[0];
				newSprite.graphics.moveTo(firstPoint.x, firstPoint.y);
				newSprite.graphics.beginFill(_acidColor);
				
				for each (var newPoint:Point in listOfPoints) {
					newSprite.graphics.lineTo(newPoint.x, newPoint.y);
				}
				
				newSprite.graphics.lineTo(firstPoint.x, firstPoint.y);
			}
			
			newSprite.x = location.x;
			newSprite.y = location.y;
			newSprite.alpha = 0.5;
			
			parent.addChild(newSprite);
			
			return newSprite;
		}
		
		private function createBodyFromCoords(arrayOfCoords:Array, location:Point):b2Body
		{
			//Same as above. It creates a body by connecting an array of points
			var allShapeDefs:Array = [];
			
			for each (var listOfPoints:Array in arrayOfCoords) {
				var newShapeDef:b2PolygonDef = new b2PolygonDef();
				newShapeDef.vertexCount = listOfPoints.length;
				for (var i:int = 0; i < listOfPoints.length; i++) {
					var nextPoint:Point = listOfPoints[i];
					b2Vec2(newShapeDef.vertices[i]).Set(nextPoint.x / PhysiVals.RATIO, nextPoint.y / PhysiVals.RATIO); 
				}
				newShapeDef.density = _density;
				newShapeDef.friction = _friction;
				newShapeDef.restitution = _restitution;
				newShapeDef.isSensor = true;
				newShapeDef.userData = this;
				
				allShapeDefs.push(newShapeDef);
			}
			
			var propBodyDef:b2BodyDef = new b2BodyDef();
			propBodyDef.position.Set(location.x / PhysiVals.RATIO, location.y / PhysiVals.RATIO);
			
			var propBody:b2Body = PhysiVals.world.CreateBody(propBodyDef);
			
			for each (var newShapeDefToAdd:b2ShapeDef in allShapeDefs) {
				propBody.CreateShape(newShapeDefToAdd);
			}
			
			propBody.SetMassFromShapes();
			
			return propBody;
		}
		
		override protected function updateOtherThings():void
		{
			//the buoyancy controller has its own step function:
			_acidBuoyancyController.Step(1/30);
		}
		
		override public function handleContact(otherObj):void
		{
			if(otherObj is PlayerActor)
			{
				var player:PlayerActor = (otherObj as PlayerActor);
				AddBody(player.body);
			}
			else if(otherObj is DummyPlayer)
			{
				var dummy:DummyPlayer = (otherObj as DummyPlayer);
				AddBody(dummy.body);
			}
		}
	}
}