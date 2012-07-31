package
{
	import Box2D.Collision.Shapes.b2PolygonDef;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	
	public class Door extends Actor implements TouchSensitiveObject
	{
		private const WIDTH:int = 75;
		private const HEIGHT:int = 100;
		private var _activated:Boolean = false;
		private var _canvas:DisplayObjectContainer;
		private var _world:BoxWorld;
		private var _playersInDoor:Array = new Array;
		
		public function Door(canvas:DisplayObjectContainer, stage:Stage, world:BoxWorld, location:b2Vec2)
		{
			var doorSprite:Sprite = new DoorSprite();
			
//			var doorSpriteBitmapData:BitmapData = new BitmapData(doorSpriteVector.width, doorSpriteVector.height+20, false, 0x000000);
			
//			doorSpriteVector.x += doorSpriteVector.width/2;
//			doorSpriteVector.y += doorSpriteVector.height/2;
//			doorSpriteBitmapData.draw(doorSpriteVector);
			
//			var doorSpriteBitmap:Bitmap = new Bitmap(doorSpriteBitmapData);
			
//			var doorSprite:Sprite = new Sprite();
//			doorSprite.addChild(doorSpriteBitmap);
			canvas.addChild(doorSprite);
			
			
			
			var doorShapeDef:b2PolygonDef = new b2PolygonDef();
			doorShapeDef.SetAsBox(PhysiVals.meters(WIDTH/2), PhysiVals.meters(HEIGHT/2));
			doorShapeDef.isSensor = true;
			doorShapeDef.userData = this;
			
			var doorBodyDef:b2BodyDef = new b2BodyDef();
			doorBodyDef.position.Set(PhysiVals.meters(location.x), PhysiVals.meters(location.y - HEIGHT/2));
			
			var doorBody:b2Body = PhysiVals.world.CreateBody(doorBodyDef);
			doorBody.CreateShape(doorShapeDef);
			doorBody.SetMassFromShapes();
			
			_canvas = canvas;
			_world = world;
			
			super(doorBody, doorSprite, false);
		}
		
		public function doSomething():void
		{
			if(!_activated && _playersInDoor.length >= 2)
			{
				_world.celebrate(_body);
				
				playShortBGM("Level Complete 2.mp3");
				
				_activated = true;
			}
			//code to load new level goes here
		}
		
		public function addPlayer(player:PlayerActor) {
			if(_playersInDoor.indexOf(player)==-1) _playersInDoor.push(player);
		}
		
		public function removePlayer(player:PlayerActor) {
			var _newPlayersInDoor:Array = new Array;
			
			for each (var cur:PlayerActor in _playersInDoor)
			{
				if(cur.body!=player.body)
				{
					_newPlayersInDoor.push(cur);
				}
			}
			
			_playersInDoor = [];
			
			for each (cur in _newPlayersInDoor)
			{
				_playersInDoor.push(cur);
			}
			
			
		}
		
		override public function handleContact(otherObj):void
		{
			if(otherObj is PlayerActor) addPlayer(otherObj);
			
			doSomething();
		}
	}
}