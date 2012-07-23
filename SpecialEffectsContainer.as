package
{
	import com.flashdynamix.motion.TweensyGroup;
	import com.flashdynamix.motion.TweensyTimeline;
	import com.flashdynamix.motion.effects.core.ColorEffect;
	import com.flashdynamix.motion.effects.core.FilterEffect;
	import com.flashdynamix.motion.extras.Emitter;
	import com.flashdynamix.motion.guides.Orbit2D;
	import com.flashdynamix.motion.layers.BitmapLayer;
	
	import fl.motion.easing.Linear;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;
	
	
	public class SpecialEffectsContainer extends Sprite
	{
		private var _playerSprite:Sprite;
		private var _canvas:DisplayObjectContainer;
		private var _container:DisplayObjectContainer; //the master container of all the special effects. When it comes down to visibility and position, we refer to this
		
		private static const MOVEMENT_TRAIL_LAYER_WIDTH = 1600;
		private static const MOVEMENT_TRAIL_LAYER_HEIGHT = 800;
		
		private static const DEATH_SPARK_LAYER_WIDTH = 400;
		private static const DEATH_SPARK_LAYER_HEIGHT = 400;
		
		private static const SPAWNING_MAGIC_LAYER_WIDTH = 400;
		private static const SPAWNING_MAGIC_LAYER_HEIGHT = 400;
		
		//individual SFX layers
		private var _movementTrailLayer:BitmapLayer;
		private var _playerSpriteCopy:Sprite;
		
		private var _deathParticleLayer:BitmapLayer;
		private var _deathParticleEmittor:Emitter;
		
		private var _spawningMagicLayer:BitmapLayer;
		private var _spawningMagicEmittor:Emitter;
		private var _spawningMagicOrb:Orbit2D;
		
		public function SpecialEffectsContainer(playerSprite:Sprite, canvas:DisplayObjectContainer)
		{
			_canvas = canvas;
			_playerSprite = playerSprite;
			
			
			//create master sprite
			_container = new Sprite();
			_canvas.addChild(_container);
			_canvas.swapChildren(_container, _playerSprite);
			
			//movement trail
			_movementTrailLayer = new BitmapLayer(MOVEMENT_TRAIL_LAYER_WIDTH, MOVEMENT_TRAIL_LAYER_HEIGHT, 1.5);
			_movementTrailLayer.add(new ColorEffect(new ColorTransform(0, 210/255, 1, 0.85)));
			//_movementTrailLayer.add(new FilterEffect(new BlurFilter(3, 3, 1)));
			
			var playerSpriteCopy:Sprite = new CharacterSprite();
			playerSpriteCopy.scaleX = _playerSprite.scaleX;
			playerSpriteCopy.scaleY = _playerSprite.scaleY;
			_playerSpriteCopy = playerSpriteCopy;
			playerSpriteCopy.alpha = 0.4;
			
			var mtHolder = new Sprite();
			mtHolder.addChild(playerSpriteCopy);
			
			_movementTrailLayer.draw(mtHolder);
			_container.addChild(_movementTrailLayer);
			
			
			//death sparks
			_deathParticleLayer = new BitmapLayer(DEATH_SPARK_LAYER_WIDTH, DEATH_SPARK_LAYER_HEIGHT, 1.5);
			
			_deathParticleLayer.add(new ColorEffect(new ColorTransform(1, 1, 1, 0.9)));
			_deathParticleLayer.add(new FilterEffect(new BlurFilter(10, 10, 2)));
			
			var Box:Class = getDefinitionByName("Box") as Class;
			_deathParticleEmittor = new Emitter(Box, null, 40, 1, "0, 360", "1, 110", 0.5, BlendMode.ADD);
			_deathParticleEmittor.transform.colorTransform = new ColorTransform(1, 1, 1, 1, -115, -30, 70);
			_deathParticleEmittor.endColor = new ColorTransform(0.84, 1, 0.156, 1, 0, 0, 0, -255);
			_deathParticleEmittor.ease = Strong.easeOut;
			
			_deathParticleLayer.draw(_deathParticleEmittor.holder);
			_container.addChild(_deathParticleLayer);
			_deathParticleEmittor.stop();
			
			//NEW IDEA: NO ORBIT, just little "pixie stardust" effect above the player's head
			//Save the orbit for later
			
			//spawning magic
			
			var tween:TweensyGroup = new TweensyGroup(false, true);
			_spawningMagicLayer = new BitmapLayer(SPAWNING_MAGIC_LAYER_WIDTH, SPAWNING_MAGIC_LAYER_HEIGHT, 1.5);
			_spawningMagicLayer.add(new ColorEffect(new ColorTransform(1, 1, 1, 0.9)));
			_spawningMagicLayer.add(new FilterEffect(new BlurFilter(20, 20, 1)));
			
			var Magic: Class = getDefinitionByName("Magic") as Class;
			
			_spawningMagicEmittor = new Emitter(Magic, {scaleX:0.1, scaleY:0.1}, 1, 0.5, 270, "30, 90", 0.7, BlendMode.ADD);
			

			_spawningMagicEmittor.delay = .2;
			_spawningMagicEmittor.transform.colorTransform = new ColorTransform(0.15, 1, 1, 1, 13, -115, -255, 0);
			_spawningMagicEmittor.endColor = new ColorTransform(1, 1, -0.375, 1, 255, -198, -255, -50);
			
			
			//the circular orb is for another time and place
			
			//_spawningMagicOrb = new Orbit2D(_spawningMagicEmittor, 40, 60, 0, 0);
			
			//tween.to(_spawningMagicOrb, {degree:360}, 1, Linear.easeNone).repeatType = TweensyTimeline.REPLAY;
			//tween.to(orb, {radiusX:'50'}, 2, Linear.easeNone).repeatType = TweensyTimeline.YOYO;
			//tween.to(orb, {radiusY:'50'}, 4, Linear.easeNone).repeatType = TweensyTimeline.YOYO;
			
			_spawningMagicLayer.draw(_spawningMagicEmittor.holder);
			_container.addChild(_spawningMagicLayer);
			
			_spawningMagicEmittor.stop();
			_spawningMagicLayer.visible = false;
			//_container.visible = false;
			
			addEventListener(Event.ENTER_FRAME, update);
		}
		
		public function updatePlayerSpriteReference(playerSprite:Sprite):void {
			_playerSprite = playerSprite;
		}
		
		private function translateLocation(location:Point):Point { //assumes everything is relative to "canvas"
			var loc2 = _canvas.localToGlobal(location);
			return _container.globalToLocal(loc2);
		}
		
		private function lockLayerPosition(location:Point):void {
			_container.x = location.x;
			_container.y = location.y;
		}
		
		public function enableMovementTrail(direction:int):void {
			
			clearAllEffects();
			
			var newX;
			
			if(direction > 0) newX = _playerSprite.x - MOVEMENT_TRAIL_LAYER_WIDTH * 0.2;
			else newX = _playerSprite.x - MOVEMENT_TRAIL_LAYER_WIDTH * 0.8;
			
			var newY = _playerSprite.y - MOVEMENT_TRAIL_LAYER_HEIGHT + _playerSprite.height * 3;
			var position = new Point(newX, newY);
			
			lockLayerPosition(position);
			
			var tempTimer:Timer = new Timer(50, 1);
			tempTimer.addEventListener(TimerEvent.TIMER, makePlayerSpriteCopyVisible);
			tempTimer.start();
			
		}
		
		private function makePlayerSpriteCopyVisible(ev:TimerEvent):void {
			_playerSpriteCopy.visible = true;
		}
		
		public function disableMovementTrail():void {
			_playerSpriteCopy.visible = false;
		}
		
		public function sparksOfDeath():void
		{
			clearAllEffects();
			
			var newX = _playerSprite.x - DEATH_SPARK_LAYER_WIDTH/2 + _playerSprite.width/2;
			var newY = _playerSprite.y - DEATH_SPARK_LAYER_HEIGHT/2 + _playerSprite.height/2;
			
			var position = new Point(newX, newY);
			
			lockLayerPosition(position);
			
			var pos:Point = translateLocation(new Point(_playerSprite.x, _playerSprite.y));
			
			_deathParticleEmittor.x = pos.x;
			_deathParticleEmittor.y = pos.y;
			
			_deathParticleEmittor.start();
		}
		
		public function clearSparksOfDeath():void
		{
			_deathParticleEmittor.stop();
			//_particleLayer.visible = false;	
		}
		
		public function beautifulShinySpawningMagicEffect():void {
			clearAllEffects();
			
			_canvas.swapChildren(_container, _playerSprite);
			
			var newX = _playerSprite.x - SPAWNING_MAGIC_LAYER_WIDTH/2 + _playerSprite.width/2;
			var newY = _playerSprite.y - SPAWNING_MAGIC_LAYER_HEIGHT/2 + _playerSprite.height/2;
			
			var position = new Point(newX, newY);
			
			lockLayerPosition(position);
			
			var pos:Point = translateLocation(new Point(_playerSprite.x, _playerSprite.y));
			
			//_spawningMagicOrb.centerX = pos.x;
			//_spawningMagicOrb.centerY = pos.y;
			
			_spawningMagicEmittor.x = pos.x;
			_spawningMagicEmittor.y = pos.y - _playerSprite.height;
			
			_spawningMagicEmittor.start();
			_spawningMagicLayer.visible = true;
		}
		
		public function clearBeautifulShinySpawningMagicEffect():void {
			_canvas.swapChildren(_container, _playerSprite);
			_spawningMagicEmittor.stop();
			//_spawningMagicLayer.visible = false;
		}
		
		private function clearAllEffects():void {
			_playerSpriteCopy.visible = false;
			_deathParticleEmittor.stop();
		}
		
		private function update(ev:Event):void {
			var pos:Point = translateLocation(new Point(_playerSprite.x, _playerSprite.y));
			_playerSpriteCopy.x = pos.x;
			_playerSpriteCopy.y = pos.y;
			
//			//_deathParticleEmittor.rotation += 20;
		}
		
	}
}