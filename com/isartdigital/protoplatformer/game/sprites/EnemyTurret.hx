package com.isartdigital.protoplatformer.game.sprites;

import com.isartdigital.protoplatformer.game.abstrait.Enemy;
import com.isartdigital.protoplatformer.game.abstrait.Gun;
import com.isartdigital.protoplatformer.game.abstrait.Shoot;
import com.isartdigital.protoplatformer.game.level.spawn.Spawn;
import com.isartdigital.protoplatformer.game.planes.GamePlane;
import com.isartdigital.protoplatformer.ui.UIGraphics;
import com.isartdigital.utils.game.StateGraphic;
import com.isartdigital.utils.sounds.SoundManager;
import pixi.core.math.Point;

/**
 * ...
 * @author 
 */
class EnemyTurret extends Enemy
{
	private var RANGE_SHOOT(default, never):Int = 1200;
	private var myGun:Gun;
	private var speedShoot(default, never):Float = 20;
	private var fireRate(default, never):Int = 90;
	private var myCount:Int = 0;
	private var myFx:UIGraphics;
	private var targetAngle:Float = 0;

	public function new() 
	{
		super("EnemyTurret");
		type = 3;
		myGun =  new Gun(Shoot.PLAYER_SHOOT_NORMAL, -1, speedShoot, 1, true);
		myFx = new UIGraphics("FXRosace");
		
	}
	
	override public function init(pSpawner:Spawn):Void 
	{
		super.init(pSpawner);
		myFx.mySetState("wait");
		addChild(myFx);
		myFx.y = -height / 2;
		HP = 1;
	}
	
	override function doActionNormal():Void 
	{
		super.doActionNormal();
		if (myCount > fireRate && isInShootRange(Player.getInstance())) 
		{
			myCount = 0;
			setModeShoot();
			targetAngle = Math.atan2(Player.getInstance().y+Player.getInstance().height/2 - y-height/2, Player.getInstance().x - x);
		}
		myCount++;
		myFx.rotation = myCount / fireRate * 3 * 2 * Math.PI;
	}
	
	public function setModeShoot()
	{
		doAction = doActionShoot;
	}
	
	private function doActionShoot()
	{
		getShot();
		myFx.rotation = targetAngle;
		if (myCount > fireRate/2) 
		{
			myGun.doShoot(GamePlane.getInstance().toLocal(get_ShootPoint()), targetAngle);
			SoundManager.getSound("enemy_shot").play();
			setModeNormal();
			myCount = 0;
		}
		myCount++;
	}
	
	/**
	 * Function  which test if we are in range of shoot
	 * @param	pElem, state graphic of element in range
	 */
	private function isInShootRange(pElem:StateGraphic):Bool
	{
		return (((x-width/2)-(pElem.x-pElem.width/2))*((x-width/2)-(pElem.x-pElem.width/2))+((y-height/2)-(pElem.y-height/2))*((y-height/2)-(pElem.y-height/2))<RANGE_SHOOT*RANGE_SHOOT);
	}
	
	override public function setModeHurt():Void 
	{
		myFx.mySetState("hurt",false);
		doAction = doActionHurt;
	}
	
	override function doActionHurt():Void 
	{
		if (myFx.isAnimEnd) 
		{
			if (HP <= 0) disactivate(true);
			else {
				setModeNormal();
				hurtable = true;
			}
		}
	}
	
	/**
	 * Getter of Shoot Point
	 * @return Value of ShootPoint
	 */
	private function get_ShootPoint():Point
	{
		return box.toGlobal(box.getChildByName("mcShoot").position);
	}
	
	override function disactivate(?pDefinitiv:Bool = false):Void 
	{
		removeChild(myFx);
		super.disactivate(pDefinitiv);
	}
	
}