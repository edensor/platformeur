package com.isartdigital.protoplatformer.game.abstrait;

import com.isartdigital.protoplatformer.game.abstrait.Mobile;
import com.isartdigital.protoplatformer.game.level.Camera;
import com.isartdigital.protoplatformer.game.level.spawn.Spawn;
import com.isartdigital.protoplatformer.game.planes.GamePlane;
import com.isartdigital.protoplatformer.game.sprites.Player;
import com.isartdigital.utils.game.BoxType;
import com.isartdigital.utils.game.CollisionManager;

/**
 * ...
 * @author Dt.Fab
 */
class Shoot extends Mobile
{
	
	public static inline var PLAYER_SHOOT_NORMAL:String = "ShootPlayer";
	public static inline var PLAYER_SHOOT_POWER:String = "ShootShargePlayer";
	public static inline var ENEMY_SHOOTER_SHOOT:String = "ShootEnemy";
	public static inline var ENEMY_TOURRET_SHOOT:String = "ShootTurret";
	public static inline var ENEMY_BOMBER_SHOOT:String = "ShootBomber";
	
	public static var list:Array<Shoot> = new Array<Shoot>();
	
	public var side(get, null):Int;
	public var lvlShoot(get, null):Int;
	public var canThroWall(get, null):Bool;
	public var isActive:Bool = true;
	

	public function new(pAssetName:String) 
	{
		super(pAssetName);
		boxType = BoxType.SELF;
		
	}
	
	/**
	 * Initialisation
	 * @param	pSpawner
	 */
	override public function init(pSpawner:Spawn):Void
	{
		list.push(this);
		super.init(pSpawner);
	}
	
	/**
	 * Initialisation of Shoot
	 * @param	pSide, Int, side of shoot
	 * @param	pSpeedShot, Float, speed of shoot
	 * @param	pLvlShoot, Int, Shoot or ShargeShoot
	 * @param	pCanTW, Bool, If can go thro Wall
	 * @param	pAngle, Float, angle of shoot
	 * @param	pScale, Int, Scale of shoot
	 */
	public function initShoot(pSide:Int, pSpeedShot:Float, pLvlShoot:Int, pCanTW:Bool,pAngle:Float, pScale:Int):Void
	{
		side = pSide;
		lvlShoot = pLvlShoot;
		canThroWall = pCanTW;
		velocity.x = pSpeedShot * Math.cos(pAngle)*pScale;
		velocity.y = pSpeedShot * Math.sin(pAngle);
		MaxHSpeed = pSpeedShot;
		scale.x = pScale;
		rotation = pAngle;
		friction.set(1, 1);
		start();
		isActive = true;
	}
	
	override function setModeNormal():Void 
	{
		setState("begin");
		super.setModeNormal();
	}
	
	override function doActionNormal():Void 
	{
		super.doActionNormal();
		move();
		if ( Main.getInstance().frames % 60 == 0 && Camera.getInstance().isOut(getBounds())) 
		{
			disactivate();
			return;
		}
		
		if (!canThroWall) 
		{
			for (lWall in Wall.list) 
		{
			if (CollisionManager.hasCollision(hitBox,lWall.hitBox))
			{
				setModeEnd();
				if (lvlShoot == 2 && lWall.assetName == "Destructible")
				{
					lWall.setModeEnd();
				}
				return;
			}
		}
		for (lPlat in PlateForm.list) 
		{
			if (CollisionManager.hasCollision(hitBox,lPlat.hitBox))
			{
				setModeEnd();
				return;
			}
		}
		}
		
	}
	
	public function setModeEnd():Void
	{
		setState("end");
		doAction =  doActionEnd;
		isActive = false;
	}
	
	private function doActionEnd():Void
	{
		if (isAnimEnd) 
		{
			disactivate();
		}
	}
	
	
	/**
	 * Getter of Side
	 * @return value of side
	 */
	private function get_side():Int 
	{
		return side;
	}
	
	/**
	 * Getter of lvlShoot
	 * @return value of lvlShoot
	 */
	private function get_lvlShoot():Int 
	{
		return lvlShoot;
	}
	
	/**
	 * Getter of canThroWall
	 * @return value of canThroWall
	 */
	private function get_canThroWall():Bool 
	{
		return canThroWall;
	}
	
	/**
	 * Function which inverts the scale and velocity
	 * 
	 */
	public function flip():Void
	{
		side = -1;
		scale.x *= -1;
		velocity.x *= -1;
	}
	
	/**
	 * Function  that disables this object
	 * @param	pDefinitiv, Bool if perma
	 */
	override function disactivate(?pDefinitiv:Bool = false):Void {  
		list.remove(this);  
		super.disactivate(pDefinitiv); 
	}
	
	public static function destroyAll()
	{
		var lLength:Int = list.length;
		for (i in 0...lLength) 
		{
			list[lLength - 1 - i].disactivate();
		}
	}
	
}