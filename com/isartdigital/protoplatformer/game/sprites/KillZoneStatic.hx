package com.isartdigital.protoplatformer.game.sprites;

import com.isartdigital.protoplatformer.game.level.PoolObject;
import com.isartdigital.protoplatformer.game.level.spawn.Spawn;
import com.isartdigital.utils.game.BoxType;

/**
 * ...
 * @author 
 */
class KillZoneStatic extends PoolObject
{
	
	public static var list:Array<KillZoneStatic> = new Array<KillZoneStatic>();

	public function new() 
	{
		super("KillZoneStatic");
		boxType = BoxType.SIMPLE;
	}
	
	/**
	 * Initialisation
	 * @param	pSpawner
	 */
	override public function init(pSpawner:Spawn)
	{
		list.push(this);
		super.init(pSpawner);
	}
	
	override private function setModeNormal():Void 
	{
		setState(DEFAULT_STATE);
		super.setModeNormal();
	}
	
	/**
	 * Function  that disables this object
	 * @param	pDefinitiv, Bool if perma
	 */
	override function disactivate(?pDefinitiv:Bool = false) {  
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