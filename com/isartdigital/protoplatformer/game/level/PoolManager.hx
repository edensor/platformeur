package com.isartdigital.protoplatformer.game.level;
import com.isartdigital.protoplatformer.game.abstrait.PlateForm;
import com.isartdigital.protoplatformer.game.abstrait.Shoot;
import com.isartdigital.protoplatformer.game.abstrait.Wall;
import com.isartdigital.protoplatformer.game.level.PoolObject;
import com.isartdigital.protoplatformer.game.sprites.CheckPoint;
import com.isartdigital.protoplatformer.game.sprites.Coin;
import com.isartdigital.protoplatformer.game.sprites.EnemyBomb;
import com.isartdigital.protoplatformer.game.sprites.EnemyFire;
import com.isartdigital.protoplatformer.game.sprites.EnemySpeed;
import com.isartdigital.protoplatformer.game.sprites.EnemyTurret;
import com.isartdigital.protoplatformer.game.sprites.KillZoneDynamic;
import com.isartdigital.protoplatformer.game.sprites.KillZoneStatic;
import com.isartdigital.protoplatformer.game.sprites.Player;
import com.isartdigital.protoplatformer.game.sprites.Upgrade;

/**
 * ...
 * @author 
 */
class PoolManager
{
	private static var pool:Map<String,Array<PoolObject>>=[
		"Player" => new Array<PoolObject>(),
		"Wall0" => new Array<PoolObject>(),
		"Wall1" => new Array<PoolObject>(),
		"Wall2" => new Array<PoolObject>(),
		"Wall3" => new Array<PoolObject>(),
		"LimitLeft" => new Array<PoolObject>(),
		"LimitRight" => new Array<PoolObject>(),
		"Ground" => new Array<PoolObject>(),
		"Destructible" => new Array<PoolObject>(),
		"Collectable" => new Array<PoolObject>(),
		"CheckPoint" => new Array<PoolObject>(),
		"KillZoneStatic" => new Array<PoolObject>(),
		"KillZoneDynamic" => new Array<PoolObject>(),
		"Platform0" => new Array<PoolObject>(),
		"Platform1" => new Array<PoolObject>(),
		"BridgeLeft" => new Array<PoolObject>(),
		"BridgeRight" => new Array<PoolObject>(),
		"EnemyBomb" => new Array<PoolObject>(),
		"EnemyFire" => new Array<PoolObject>(),
		"EnemySpeed" => new Array<PoolObject>(),
		"EnemyTurret" => new Array<PoolObject>(),
		"Upgrade_doubleJump" => new Array<PoolObject>(),
		"Upgrade_shield" => new Array<PoolObject>(),
		"Upgrade_sharge" => new Array<PoolObject>(),
		"ShootPlayer" => new Array<PoolObject>(),
		"ShootTurret" => new Array<PoolObject>(),
		"ShootEnemy" => new Array<PoolObject>(),
		"ShootShargePlayer" => new Array<PoolObject>()
	];

	public function new() 
	{
		
	}
	
	/**
	 * Function which add element to pool
	 */
	public static function addToPool(pType:String, pInstance:PoolObject):Void {
		pool[pType].push(pInstance);
	}

	/**
	 * Function which get element from pool
	 */
	public static function getFromPool(pType:String):PoolObject {
		////trace(pool[pType].length);
		if (pool[pType].length == 0) 
		{
			switch (pType) 
			{
				case "Player":  Player.getInstance();
				case "Wall0":  new Wall("Wall0");
				case "Wall1":  new Wall("Wall1");
				case "Wall2":  new Wall("Wall2");
				case "Wall3":  new Wall("Wall3");
				case "LimitLeft":  new Wall("LimitLeft");
				case "LimitRight":  new Wall("LimitRight");
				case "Ground":  new Wall("Ground");
				case "Destructible":  new Wall("Destructible");
				case "KillZoneDynamic":  new KillZoneDynamic();
				case "Collectable":  new Coin("Collectable");
				case "CheckPoint":  new CheckPoint();
				case "KillZoneStatic":  new KillZoneStatic();
				case "Platform0":  new PlateForm("Platform0");
				case "Platform1":  new PlateForm("Platform1");
				case "BridgeLeft":  new PlateForm("BridgeLeft");
				case "BridgeRight":  new PlateForm("BridgeRight");
				case "EnemyBomb":  new EnemyBomb();
				case "EnemyFire":  new EnemyFire();
				case "EnemySpeed":  new EnemySpeed();
				case "EnemyTurret":  new EnemyTurret();
				case "Upgrade_doubleJump":  new Upgrade("Upgrade_doubleJump");
				case "Upgrade_shield":  new Upgrade("Upgrade_shield");
				case "Upgrade_sharge":  new Upgrade("Upgrade_sharge");
				case "ShootPlayer":  new Shoot("ShootPlayer");
				case "ShootEnemy":  new Shoot("ShootEnemy");
				case "ShootTurret":  new Shoot("ShootTurret");
				case "ShootBomber":  new Shoot("ShootBomber");
				case "ShootShargePlayer":  new Shoot("ShootShargePlayer");
					
				default: return null;
					
			}
		}
		return pool[pType].pop();
	}

	/**
	 * Function which clear element to pool
	 */
	public static function clear(?pType:String = null):Void {
		var lLength = pool[pType].length;
		for (i in 0...lLength) 
		{
			pool[pType][lLength - i - 1].destroy();
			pool[pType].splice(lLength - i - 1,1);
		}
	}
	
	/**
	 * Function which clear element witch graphics depends on level to pool
	 */
	public static function clearNeeded():Void
	{
		clear("Wall0");
		clear("Wall1");
		clear("Wall2");
		clear("Wall3");
		clear("LimitLeft");
		clear("LimitRight");
		clear("Ground");
		clear("Destructible");
		clear("KillZoneDynamic");
		clear("KillZoneStatic");
		clear("Platform0");
		clear("Platform1");
		clear("BridgeRight");
	}
	
	
}