package com.isartdigital.protoplatformer.game.abstrait;
import com.isartdigital.protoplatformer.game.level.PoolManager;
import com.isartdigital.protoplatformer.game.planes.GamePlane;
import com.isartdigital.protoplatformer.ui.UIGraphics;
import com.isartdigital.utils.sounds.SoundManager;
import pixi.core.display.Container;
import pixi.core.math.Point;

/**
 * ...
 * @author ...
 */
class ShargeGun extends Gun
{
	private var CHARGE_RATE(default, never):Int = 60;
	
	private var fxSharge:UIGraphics = null;
	private var chargeCount:Int = 0;
	private var isChild:Bool = false;
	
	public function new(pAssetShoot:String, pSideShoot:Int, pSpeedShot:Float, pCanTW:Bool) 
	{
		super(pAssetShoot, pSideShoot, pSpeedShot, 2, pCanTW);
		fxSharge = new UIGraphics("FXSharge");
	}
	
	/**
	 * Function create one shoot, and positions
	 * @param	pPos, Position of shoot
	 * @param	pAngle, Angle of shoot
	 * @return Bool, True
	 */
	override public function doShoot(pPos:Point, pAngle:Float):Bool 
	{		
		var lShoot:Shoot = null;
		if (chargeCount > CHARGE_RATE) {
			SoundManager.getSound("charge_gun").play();	
			lShoot = cast(PoolManager.getFromPool(assetShoot), Shoot);
			lShoot.initShoot(sideShoot, speedShoot, lvlShoot, shootCanThroWall, pAngle, scale);
		}
		else 
		{
			lShoot = cast(PoolManager.getFromPool(Shoot.PLAYER_SHOOT_NORMAL), Shoot);
			lShoot.initShoot(sideShoot, speedShoot, 1, shootCanThroWall, pAngle, scale);
		}
		chargeCount = 0;
		lShoot.init(null);
		lShoot.position.set(pPos.x, pPos.y);
		GamePlane.getInstance().addChild(lShoot);
		if (isChild) 
		{
			fxSharge.parent.removeChild(fxSharge);
			fxSharge.mySetState("Complete");
			isChild = false;
		}
		return true;
	}
	
	/**
	 * Function add fxSharge
	 * @param	pPos, Position of fx
	 * @param	containe, container where it will be added
	 */
	public function charge(pPos:Point,containe:Container):Void
	{
		if (!isChild) 
		{
			containe.addChild(fxSharge);
			isChild = true;
			fxSharge.mySetState("Load",false);
		}
		fxSharge.position = pPos;
		chargeCount++;
		if (chargeCount > CHARGE_RATE) 
		{
			fxSharge.mySetState("Complete");
		}
	}
	
}