package com.isartdigital.protoplatformer.game.sprites;

import com.isartdigital.protoplatformer.game.abstrait.Gun;
import com.isartdigital.protoplatformer.game.abstrait.Patrol;
import com.isartdigital.protoplatformer.game.abstrait.Shoot;
import com.isartdigital.protoplatformer.game.level.spawn.Spawn;
import com.isartdigital.protoplatformer.game.planes.GamePlane;
import com.isartdigital.utils.game.StateGraphic;
import com.isartdigital.utils.sounds.SoundManager;
import pixi.core.math.Point;
import pixi.core.math.shapes.Rectangle;

/**
 * ...
 * @author 
 */
class EnemyFire extends Patrol
{
	
	private var rangeGun:Rectangle;
	private var myGun:Gun;
	private var speedShoot(default, never):Float = 30;
	private var fireRate(default, never):Int = 35;
	private var myCount:Int = 0;

	public function new() 
	{
		super("EnemyFire");
		type = 1;
		speedEnemy = 10;
		myGun =  new Gun(Shoot.ENEMY_SHOOTER_SHOOT, -1, speedShoot, 1, false);
	}
	
	/**
	 * Function init range of enemy
	 * @param	pRangeRun, Rectangle of Range
	 * @param	pVelocityX, Velocity of enemy
	 */
	override public function init(pSpawner:Spawn):Void 
	{
		super.init(pSpawner);
		HP = 3;
	}
	 
	override public function initRange(pRangeRun:Rectangle, ?pVelocityX:Float = 0):Void 
	{
		super.initRange(pRangeRun, pVelocityX);
		rangeGun = pRangeRun.clone();
		rangeGun.width =  width * 3;
		rangeGun.x  = x;
		rangeGun.y  = y;
		myCount = fireRate;
		setModePatrol();
		myGun.scale = scale.x>0 ? 1:-1;
	}
	
	override function doActionPatrol() :Void
	{
		super.doActionPatrol();
		rangeGun.x = x - rangeGun.width * (-scale.x + 1) / 2;
		if (myCount > fireRate) 
		{
			
			myCount = 0;
			if (Player.getInstance().x >= rangeGun.x && Player.getInstance().x <= rangeGun.x + rangeGun.width && Player.getInstance().y <= rangeGun.y +rangeGun.height/2 && Player.getInstance().y >= rangeGun.y - rangeGun.height/2 ) 
			{
				myGun.doShoot(GamePlane.getInstance().toLocal(get_ShootPoint()), 0);
				SoundManager.getSound("enemy_shot").play();
			}
		}
		myCount++;
	}
	
	/**
	 * Function which inverts the scale and velocity
	 * 
	 */
	override function flip():Void 
	{
		super.flip();
		myGun.flip();
	}
	
	/**
	 * Getter of Shoot Point
	 * @return Value of ShootPoint
	 */
	private function get_ShootPoint():Point
	{
		return box.toGlobal(box.getChildByName("mcShoot").position);
	}
	
}