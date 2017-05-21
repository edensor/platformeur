package com.isartdigital.protoplatformer.game.abstrait;
import com.isartdigital.protoplatformer.game.level.spawn.Spawn;
import com.isartdigital.protoplatformer.game.sprites.EnemyBomb;
import com.isartdigital.protoplatformer.game.sprites.EnemyFire;
import com.isartdigital.protoplatformer.game.sprites.EnemySpeed;
import com.isartdigital.protoplatformer.game.sprites.EnemyTurret;
import com.isartdigital.protoplatformer.game.sprites.Player;
import com.isartdigital.utils.game.BoxType;
import com.isartdigital.utils.game.CollisionManager;

/**
 * ...
 * @author 
 */
class Enemy extends Mobile
{	
	public static inline var HURT_STATE:String = "hurt";
	public static inline var WALK_STATE:String = "walk";
	public static inline var WAIT_STATE:String = "wait";
	
	
	public static var list:Array<Enemy> = new Array<Enemy>();

	private var type:Int;
	public var HP:Int;
	public var hurtable:Bool = true;
	
	public function new(pAsset:String) 
	{
		super(pAsset);
		boxType = BoxType.SIMPLE;
		friction.set(1, 1);
	}
	
	
	/**
	 * Initialisation
	 * @param	pSpawner
	 */
	override public function init(pSpawner:Spawn):Void 
	{
		super.init(pSpawner);
		hurtable = true;
		list.push(this);
	}
	
	override function doActionNormal():Void 
	{
		super.doActionNormal();
		getShot();
	}
	
	override function setModeNormal():Void 
	{
		super.setModeNormal();
		setState(Enemy.WAIT_STATE,true);
	}
	
	public function setModeHurt():Void
	{
		setState(HURT_STATE);
		doAction = doActionHurt;
		hurtable = false;
	}
	
	private function doActionHurt():Void
	{
		if (isAnimEnd) 
		{
			if (HP <= 0) disactivate(true);
			else {
				setModeNormal();
				hurtable = true;
			}
		}
	}
	
	
	
	
	/**
	 * Test in shoot's list if we got collision with enemy
	 * 
	 */
	private function getShot():Void
	{
		for (lShoot in Shoot.list) 
		{
			if (lShoot.isActive && lShoot.side == 1 && CollisionManager.hasCollision(lShoot.hitBox,hitBox)) 
			{
				imShot(lShoot);
			}
		}
	}
	
	/**
	 * Change state of enemi if he got touch
	 * @param	pShoot, Shoot that hit the enemy
	 */
	private function imShot(lShoot:Shoot):Void
	{
		HP -= lShoot.lvlShoot;
		setModeHurt();
		lShoot.setModeEnd();
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