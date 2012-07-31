package
{
	import Box2D.Collision.Shapes.b2PolygonDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	
	import com.neriksworkshop.lib.ASaudio.Track;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	public class GenericCollectible extends Collectible
	{
		
		private var _genericSprite:MovieClip;
		private var _ding:Track = new Track("sfx/coin.mp3");
		
		public function GenericCollectible(location:Point, canvas:DisplayObjectContainer)
		{
			
			//define and create sprite

			var genericSprite:MovieClip = new GenericCoinSprite();
			_genericSprite = genericSprite;
			
			//define shape
			var genericShapeDef:b2PolygonDef = new b2PolygonDef();
			genericShapeDef.SetAsBox(PhysiVals.meters(_genericSprite.width / 2), PhysiVals.meters(_genericSprite.height / 2));
			genericShapeDef.friction = 0.0;
			genericShapeDef.restitution = 0.0;
			genericShapeDef.density = 0.0;
			genericShapeDef.isSensor =true;
			
			genericShapeDef.userData = this;
			
			
			//define body
			var genericBodyDef:b2BodyDef = new b2BodyDef();
			genericBodyDef.position.Set(PhysiVals.meters(location.x), PhysiVals.meters(location.y));
			genericBodyDef.fixedRotation = true;
			
			var genericBody:b2Body = PhysiVals.world.CreateBody(genericBodyDef);
			genericBody.CreateShape(genericShapeDef);
			
			super(genericBody, _genericSprite, canvas);
		}
		
		override protected function PlayGetSound():void
		{
			_ding.loop = false;
			_ding.start();
		}
	}
}