﻿package
{
	import Box2D.Collision.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	import flash.geom.Point;

	public class BoxWorldContactListener extends b2ContactListener
	{
		
		//collision types
		
		private const OBJECT_AND_OBJECT = 0;
		private const PLAYER_AND_OBJECT = 1;
		private const PLAYER_AND_PLAYER = 2;
		
		private var _world:BoxWorld;
		
		public function BoxWorldContactListener(world:BoxWorld)
		{
			_world = world;
		}
		
		
		private function determineParticipants(obj1, obj2)
		{
			
			if(obj1.canHandleContact && obj2.canHandleContact) {
				
				var result = 0;
				
				if (obj1 is PlayerActor) result++;
				
				if (obj2 is PlayerActor) result++;
				
				return result;
				
			}
			
			return -1;
			
		}
		
		private function collisionIsLethal(player, object, angle)
		{
			if(object is Hazard)
			{
				if(object.withinEffectiveNormalRange(angle))
				{
					return true;
				}
			}
			
			return false;
		}
		
		private function collisionIsHorizontal(normal)
		{
			if(Math.abs(normal.y) >= 0.95) return true;
			return false;
		}
		
		
		override public function Persist(point:b2ContactPoint):void
		{
			
			
			//slowly phase out code below this
			
			if (Math.abs(point.normal.y) >= 0.95) { //check the normal to ensure that the contact is definitely with something horizontal.
				if (point.shape2.GetUserData() is PlayerActor) {
					if (!(point.shape1.GetUserData() is Elevator)) {
						point.shape2.GetUserData()._inAir = false;
					}
				}
				
				if (point.shape1.GetUserData() is PlayerActor) {
					if (!(point.shape2.GetUserData() is Elevator)) {
						point.shape1.GetUserData()._inAir = false;
					}
				}
			}
			
			if (point.shape2.GetUserData() is PlayerActor && point.shape1.GetUserData() is Switch) {
				point.shape2.GetUserData().hasThePower = true;
				point.shape2.GetUserData().nearestSwitch = point.shape1.GetUserData();
			}
			
			if (point.shape1.GetUserData() is PlayerActor && point.shape2.GetUserData() is Switch) {
				point.shape1.GetUserData().hasThePower = true;
				point.shape1.GetUserData().nearestSwitch = point.shape2.GetUserData();
			}
			
			if (point.shape2.GetUserData() is PlayerActor && point.shape1.GetUserData() is Prop) {
				point.shape2.GetUserData().onGround = true;
			}
			
			if (point.shape1.GetUserData() is PlayerActor && point.shape2.GetUserData() is Prop) {
				point.shape1.GetUserData().onGround = true;
			}
			
			if (point.shape1.GetUserData() is PlayerActor && point.shape2.GetUserData() is Pool) {
				if(point.shape1.GetUserData().body.GetLinearVelocity().x > 0)
				{
					point.shape2.GetUserData().Splash(point.shape1.GetUserData().body.GetLinearVelocity().x * 0.05, PhysiVals.pixels(point.shape1.GetUserData().body.GetPosition().x));
				}
			}
			
			if (point.shape2.GetUserData() is PlayerActor && point.shape1.GetUserData() is Pool) {
				if(point.shape2.GetUserData().body.GetLinearVelocity().x > 0)
				{
					point.shape1.GetUserData().Splash(point.shape2.GetUserData().body.GetLinearVelocity().x * 0.05, PhysiVals.pixels(point.shape2.GetUserData().body.GetPosition().x));
				}
			}
			
			
			super.Persist(point);
		}
		
		override public function Add(point:b2ContactPoint):void
		{
			
			
			var obj1 = point.shape1.GetUserData();
			var obj2 = point.shape2.GetUserData();
			
			if (obj1 == null || obj2 == null) return;
			
			var add_type = determineParticipants(obj1, obj2);

			//No matter what, if possible, both objects' handleContact method MUST be called
			//Sometimes an object doesn't have the handleContact method, then add_type should be -1 and we won't run any of the code below
			
			var player;
			var object;
			var angle;
			
			if (add_type == PLAYER_AND_PLAYER)
			{
				
			}
			else if (add_type == PLAYER_AND_OBJECT) //THIS IS THE IMPORTANT ONE
			{
				
				if (obj1 is PlayerActor)
				{
					player = obj1;
					object = obj2;
					angle  = PhysiVals.playerNormalToCollidedNormal(Math.atan2(point.normal.y, point.normal.x)/(Math.PI/180));
				}
				else
				{
					player = obj2;
					object = obj1;
					angle  = Math.atan2(point.normal.y, point.normal.x)/(Math.PI/180);
				}
				
				if(collisionIsLethal(player, object, angle))
				{
					player.handleLethalContact(object);
					object.handleContact(player);
				}
				else
				{
					if(collisionIsHorizontal(point.normal))
					{
						player.landOn(object); //in land on, implement a check that the player's y velocity isn't pointed upwards.
						object.handleContact(player);
					}
					else
					{
						player.handleContact(object);
						object.handleContact(player);
					}
				}
			}
			else if (add_type == OBJECT_AND_OBJECT)
			{
				
				//special case: the spring on top of the player touches a lethal object; in this case player should die
				
				if(obj1 is VirtualSpring || obj2 is VirtualSpring) {
					
					var pseudoplayer;
					
					if(obj1 is VirtualSpring) {
						pseudoplayer = obj1;
						object = obj2;
						angle  = PhysiVals.playerNormalToCollidedNormal(Math.atan2(point.normal.y, point.normal.x)/(Math.PI/180));
					}
					
					if(obj2 is VirtualSpring) {
						pseudoplayer = obj2;
						object = obj1;
						angle  = Math.atan2(point.normal.y, point.normal.x)/(Math.PI/180);
					}
					
					if(collisionIsLethal(pseudoplayer, object, angle))
					{
						pseudoplayer.handleLethalContact(object);
					}
					
				}
				
				obj1.handleContact(obj2);
				obj2.handleContact(obj1);
				
				//do NOT cast obj1 and obj2 as Actors, because sometimes they aren't (EG: VirtualSpring isn't an Actor, but it can handleContacts well)
			}
			
		}

		override public function Remove(point:b2ContactPoint):void
		{
			
			var obj1 = point.shape1.GetUserData();
			var obj2 = point.shape2.GetUserData();
			
			if (obj1 == null || obj2 == null) return;
			
			var remove_type = determineParticipants(obj1, obj2);
			
			if (remove_type == PLAYER_AND_PLAYER)
			{
				
			}
			else if (remove_type == PLAYER_AND_OBJECT)
			{
				var player:PlayerActor;
				var object;
				var angle;
				
				if (obj1 is PlayerActor)
				{
					player = (obj1 as PlayerActor);
					object = obj2;
					angle  = PhysiVals.playerNormalToCollidedNormal(Math.atan2(point.normal.y, point.normal.x)/(Math.PI/180));
				}
				else
				{
					player = (obj2 as PlayerActor); 
					object = obj1;
					angle  = Math.atan2(point.normal.y, point.normal.x)/(Math.PI/180);
				}
				
				if(collisionIsHorizontal(point.normal))
				{
					if(player.body.GetLinearVelocity().y < 0) //check if player moving upwards
					{
						player._inAir = true;
						player.onGround = false;
					}
				}
				
				if(object is Fluid)
				{
					if(player.body.GetPosition().y < -(object.offset)) {
						object.RemoveBody(player.body);
						player.inWater = false;
					}
				}
				else if(object is Hazard)
				{
					player.nearHazard = false;
				}
				else if(object is Switch)
				{
					player.nearestSwitch = null;
					player.hasThePower = false;
				}
				else if(object is FloatingPlatform)
				{
					(object as FloatingPlatform).removePassenger(player);
				}
				else if(object is Door)
				{
					(object as Door).removePlayer(player);
				}
			
				
			}
			else if (remove_type == OBJECT_AND_OBJECT)
			{
				if(obj1 is Pool && obj2 is Actor && obj2.body.GetPosition().y < -(obj1.offset))
				{
					obj1.RemoveBody(obj2.body);
				}
				
				if(obj2 is Pool && obj1 is Actor)
				{
					obj2.RemoveBody(obj1.body);
				}
				
			}
			
			
			
			if (Math.abs(point.normal.y) >= 0.95) { //check the normal to ensure that the contact is definitely with something horizontal.
				if(point.shape2.GetUserData() is PlayerActor) {
					point.shape2.GetUserData()._inAir = true;
					if(point.shape1.GetUserData() is Spring || point.shape1.GetUserData() is VirtualSpring) {
						point.shape2.GetUserData().bouncedOffASpring = true;
					} else {
						point.shape2.GetUserData().bouncedOffASpring = false;
					}
					
					if (point.shape1.GetUserData() is FloatingPlatform || point.shape1.GetUserData() is FloatingPlatformWithSwitch || point.shape1.GetUserData() is SmartPlatform) {
						//point.shape2.GetUserData().ridingMovingObject = false;
						point.shape1.GetUserData().removePassenger(point.shape2.GetUserData());
					}
				}
				
				if (point.shape1.GetUserData() is PlayerActor) {
					point.shape1.GetUserData()._inAir = true;
					if(point.shape2.GetUserData() is Spring || point.shape2.GetUserData() is VirtualSpring) {
						point.shape1.GetUserData().bouncedOffASpring = true;
					}
					else
					{
						point.shape1.GetUserData().bouncedOffASpring = false;
					}
					
					if (point.shape2.GetUserData() is FloatingPlatform || point.shape2.GetUserData() is FloatingPlatformWithSwitch || point.shape2.GetUserData() is SmartPlatform) {
						//point.shape1.GetUserData().ridingMovingObject = false;
						point.shape2.GetUserData().removePassenger(point.shape1.GetUserData());
					}
				}
			}			
			super.Remove(point);
		}
		
	}

}
