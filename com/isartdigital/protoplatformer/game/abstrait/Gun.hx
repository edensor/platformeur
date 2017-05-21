package com.isartdigital.protoplatformer.game.abstrait;
import com.isartdigital.protoplatformer.game.abstrait.Shoot;
import com.isartdigital.protoplatformer.game.level.PoolManager;
import com.isartdigital.protoplatformer.game.planes.GamePlane;
import pixi.core.math.Point;

/**
 * ...
 * @author Dt.Fab
 */
class Gun
{
	private var assetShoot:String;
	private var sideShoot:Int;
	private var speedShoot:Float;
	private var lvlShoot:Int;
	private var shootCanThroWall:Bool;
	public var scale:Int = 1;

	public function new(pAssetShoot:String, pSideShoot:Int, pSpeedShot:Float, pLvlShoot:Int, pCanTW:Bool) 
	{
		assetShoot = pAssetShoot;
		sideShoot = pSideShoot;
		speedShoot = pSpeedShot;
		lvlShoot = pLvlShoot;
		shootCanThroWall = pCanTW;
	}
	
	/**
	 * Function create one shoot, and positions
	 * @param	pPos, Position of shoot
	 * @param	pAngle, Angle of shoot
	 * @return Bool, True
	 */
	public function doShoot(pPos:Point,pAngle:Float):Bool
	{
		var lShoot:Shoot = cast(PoolManager.getFromPool(assetShoot), Shoot); 
		lShoot.initShoot(sideShoot, speedShoot, lvlShoot, shootCanThroWall, pAngle, scale);
		lShoot.init(null);
		lShoot.position.set(pPos.x, pPos.y);
		GamePlane.getInstance().addChild(lShoot);
		return true;
	}
	
	/**
	 * Function change scale to left
	 * 
	 */
	public function flipLeft():Void
	{
		scale = -1;
	}
	
	/**
	 * Function change scale to right
	 * 
	 */
	public function flipRight():Void
	{
		scale = 1;
	}
	
	/**
	 * Function which inverts the scale
	 * 
	 */
	public function flip():Void
	{
		scale *= -1;
	}
	
}