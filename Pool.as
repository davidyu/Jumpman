package
{
	import Box2D.Collision.Shapes.b2PolygonDef;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Collision.Shapes.b2ShapeDef;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	
	import com.boristhebrave.Box2D.Controllers.b2BuoyancyController;
	import com.electrotank.water.Water;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.filters.DisplacementMapFilter;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	public class Pool extends Actor implements Fluid
	{
		
		private var _density:Number = 0.0;
		private var _friction:Number = 0.0;
		private var _restitution:Number = 0.0;
		private var _waterColor:Number = 0x45B5C4;
		private var _waterBuoyancyController:b2BuoyancyController = new b2BuoyancyController();
		private var _waterSprite:Water;
		
		private var _restrictSplashBodies:Array = new Array();
		
		
		public function Pool(canvas:DisplayObjectContainer, location:Point, arrayOfCoords:Array, linearDrag:Number)
		{
			var waterBody:b2Body = createBodyFromCoords(arrayOfCoords, location);
			var waterBaseSprite:Sprite = createSpriteFromCoords(arrayOfCoords, location, canvas);
			_waterBuoyancyController.offset = PhysiVals.meters(-(location.y + arrayOfCoords[0][0].y));
			_waterBuoyancyController.normal.Set(0,-1);
			_waterBuoyancyController.density = 5;
			_waterBuoyancyController.linearDrag = linearDrag;
			_waterBuoyancyController.angularDrag = 2;
			

			super(waterBody, waterBaseSprite, false);
		}
		
		public function AddBody(body:b2Body):void
		{
			//trace("adding them bodies");
			_waterBuoyancyController.AddBody(body);

			playSplashSFX(body);
			
			//swap sprite depths if necessary
			if (body.GetUserData() is Actor)
			{
				var submergedSprite = (body.GetUserData() as Actor).sprite;
				var parent:DisplayObjectContainer = _costume.parent as DisplayObjectContainer;
				
				if (parent.getChildIndex(_costume) < parent.getChildIndex(submergedSprite)) parent.swapChildren(submergedSprite, _costume);
				
			}
		}
		
		private function removeSplashRestrictionOn(e:TimerEvent):void
		{
			var tmr:DataTimer = e.currentTarget as DataTimer;
			var body = tmr.data.body;
			
			_restrictSplashBodies.splice(_restrictSplashBodies.indexOf(body), 1);
		}
		
		private function playSplashSFX(body:b2Body):void
		{
			if (_restrictSplashBodies.indexOf(body) < 0)
			{
				_restrictSplashBodies.push(body);
				playSFX("splash_big.mp3");
			}
			
			//set timer function to prevent this sound from repeating multiple times in a row
			var removeTimer:DataTimer = new DataTimer(1000, 1);
			removeTimer.data.body = body;
			removeTimer.addEventListener(TimerEvent.TIMER, removeSplashRestrictionOn);
			removeTimer.start();
		}
		
		public function RemoveBody(body:b2Body):void
		{
			_waterBuoyancyController.RemoveBody(body);
		}
		
		public function Splash(intensity:Number, globalX:Number):void
		{
//			_waterSprite.injectWave(intensity, globalX - _waterSprite.x);		
		}
		
		public function get offset():Number { return _waterBuoyancyController.offset; }
		
		public function GetBodies():Array { return _waterBuoyancyController.GetBodies(); }
		
		private function createSpriteFromCoords(arrayOfCoords:Array, location:Point, canvas:DisplayObjectContainer):Sprite
		{
			
			var newSprite:Sprite = new Sprite();
			newSprite.graphics.lineStyle(2, 0x5D7E62);
			for each (var listOfPoints:Array in arrayOfCoords) {
				var firstPoint:Point = listOfPoints[0];
				newSprite.graphics.moveTo(firstPoint.x, firstPoint.y);
				newSprite.graphics.beginFill(_waterColor);
				
				for each (var newPoint:Point in listOfPoints) {
					newSprite.graphics.lineTo(newPoint.x, newPoint.y);
				}
				
				newSprite.graphics.lineTo(firstPoint.x, firstPoint.y);
			}
			
			newSprite.x = location.x;
			newSprite.y = location.y;
			newSprite.alpha = 0.5;
			
			canvas.addChild(newSprite);
			
			//trying out this cool wave thing
			
//			var waterSprite:Water = new Water((arrayOfCoords[0][1].x - arrayOfCoords[0][0].x), (arrayOfCoords[0][1].y - arrayOfCoords[0][2].y));
//			waterSprite.y = location.y + arrayOfCoords[0][0].y;
//			waterSprite.x = location.x + arrayOfCoords[0][0].x;
//			waterSprite.alpha = 0.5;
//			canvas.addChild(waterSprite);
//			
//			_waterSprite = waterSprite;
			
			//return waterSprite;
			return newSprite;
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
					b2Vec2(newShapeDef.vertices[i]).Set(PhysiVals.meters(nextPoint.x), PhysiVals.meters(nextPoint.y)); 
				}
				newShapeDef.density = _density;
				newShapeDef.friction = _friction;
				newShapeDef.restitution = _restitution;
				newShapeDef.isSensor = true;
				newShapeDef.userData = this;
				
				allShapeDefs.push(newShapeDef);
			}
			
			//define body
			var propBodyDef:b2BodyDef = new b2BodyDef();
			propBodyDef.position.Set(PhysiVals.meters(location.x), PhysiVals.meters(location.y));
			
			//create body
			var propBody:b2Body = PhysiVals.world.CreateBody(propBodyDef);
			
			//create shapes
			for each (var newShapeDefToAdd:b2ShapeDef in allShapeDefs) {
				propBody.CreateShape(newShapeDefToAdd);
			}
			
			propBody.SetMassFromShapes();
			
			return propBody;
		}
		
		override protected function updateOtherThings():void
		{
			_waterBuoyancyController.Step(1/30);
		}
		
		override public function handleContact(otherObj):void
		{
			if(otherObj is PlayerActor)
			{
				var player:PlayerActor = (otherObj as PlayerActor);
				AddBody(player.body);
				Splash(player.body.GetLinearVelocity().y * 0.1, PhysiVals.pixels(player.body.GetPosition().x)); 
			}
		}
	}
}