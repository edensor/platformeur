package com.isartdigital.protoplatformer.game.abstrait;
import com.isartdigital.protoplatformer.game.level.spawn.Spawn;
import com.isartdigital.protoplatformer.game.sprites.Player;
import com.isartdigital.utils.game.CollisionManager;
import com.isartdigital.utils.game.StateGraphic;
import pixi.core.math.Point;
import pixi.core.math.shapes.Rectangle;

/**
 * ...
 * @author 
 */
class Patrol extends Enemy
{
	//rectangle whitch define the patrol aera
	private var rangeRun:Rectangle;
	
	private var floor:StateGraphic;
	
	private var speedEnemy:Float = 15;

	public function new(pAsset:String) 
	{
		super(pAsset);
		
	}
	
	
	override public function init(pSpawner:Spawn):Void 
	{
		super.init(pSpawner);
		floor = null;
	}
	
	/**
	 * init the rangeRun propriety and the velocity.
	 * @param	pRangeRun value of the patrol aera
	 * @param	pVelocityX value of the velocity
	 */
	public function initRange(pRangeRun:Rectangle, ?pVelocityX:Float = 0):Void 
	{
		setState(Enemy.WAIT_STATE);
		anim.animationSpeed = 0.5;
		rangeRun = pRangeRun.clone();
		rangeRun.height = height;
		
		
		velocity.x = pVelocityX;
		if (velocity.x == 0) {
			setModeNormal();
		}
		else {
			scale.x = velocity.x < 0 ? -1: 1;
			setModePatrol();
		}
	}
	
	override function setModeNormal():Void 
	{
		super.setModeNormal();
	}
	
	override function doActionNormal():Void 
	{
		super.doActionNormal();
		if (Player.getInstance().x >= rangeRun.x-rangeRun.width && Player.getInstance().x <= rangeRun.x + 2*rangeRun.width && Player.getInstance().y <= rangeRun.y + 2*rangeRun.height && Player.getInstance().y >= rangeRun.y - rangeRun.height ) 
		{
			setModePatrol();
		}
	}
	
	public function setModePatrol():Void
	{
		setState(Enemy.WALK_STATE , true);
		velocity.x = scale.x*speedEnemy;
		doAction = doActionPatrol;
	}
	
	private function doActionPatrol():Void
	{
		////trace(x, rangeRun.x , rangeRun.x + rangeRun.width);
		if (x <= rangeRun.x || x >= rangeRun.x + rangeRun.width || !canWalk()) flip();
		move();
		getShot();
	}
	
	/**
	 * Function which inverts the scale and velocity
	 * 
	 */
	private function flip():Void
	{
		scale.x *= -1;
		velocity.x *= -1;
	}
	
	/**
	 * Function which gets front's point
	 * @return "mcFrontCheck" Point
	 */
	private function getFrontPoint():Point
	{
		return box.toGlobal(box.getChildByName("mcFrontCheck").position);
	}
	
	/**
	 * Function which test if he can walk
	 * @return Bool, if we are on Wall/Platform 
	 */
	private function canWalk():Bool
	{
		if (floor != null && testPoint([floor], getFrontPoint()) == floor) 
		{
			return true;
		}
		return hitFLoor(getFrontPoint());
	}
	
	/**
	 * Function which returns the object with which it has collided
	 * @return StateGraphic if collided, null if not
	 */
	private function testPoint(pList:Array<Dynamic>,pGlobalPoint:Point):StateGraphic
	{
		for (lObject in pList) 
		{
			if (CollisionManager.hitTestPoint(cast(lObject,StateGraphic).hitBox, pGlobalPoint)) 
			{
				return cast(lObject,StateGraphic);
			}
		}
		return null;
	}
	
	/**
	 * Function which returns Bool if we hit a Wall/Platform
	 * @return Bool
	 */
	private function hitFLoor(?pHit:Point):Bool
	{
		var lCollision:StateGraphic =  testPoint(Wall.list, pHit);
		if (lCollision == null)
		{
			lCollision = testPoint(PlateForm.list, pHit);
		}
		if (lCollision != null) 
		{
			floor = lCollision;
			return true;
		}
		
		floor = null;
		return false;
	}
	
}