package com.isartdigital.protoplatformer.game.abstrait;

import com.isartdigital.protoplatformer.game.level.PoolObject;
import com.isartdigital.protoplatformer.game.level.spawn.Spawn;
import com.isartdigital.utils.game.BoxType;
import com.isartdigital.utils.game.StateGraphic;

/**
 * ...
 * @author 
 */
class PlateForm extends PoolObject
{
	public 	static var  list:Array<PlateForm> = new Array<PlateForm>();

	public function new(pAssetName:String) 
	{
		super(pAssetName);
		assetName = pAssetName;
		boxType = BoxType.SIMPLE;
	
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
	
	override private function setModeNormal():Void 
	{
		setState(DEFAULT_STATE);
		super.setModeNormal();
	}
	override private function doActionNormal():Void 
	{
		doAction = doActionNormal;
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