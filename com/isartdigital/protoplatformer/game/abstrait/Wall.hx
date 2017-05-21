package com.isartdigital.protoplatformer.game.abstrait;

import com.isartdigital.protoplatformer.game.level.PoolObject;
import com.isartdigital.protoplatformer.game.level.spawn.Spawn;
import com.isartdigital.utils.game.BoxType;
import com.isartdigital.utils.game.StateGraphic;
import com.isartdigital.utils.sounds.SoundManager;

/**
 * ...
 * @author 
 */
class Wall extends PoolObject
{
	public static var list:Array<Wall> = new Array<Wall>();
	
	private var type:Int;

	public function new(pAssetName:String) 
	{
		super(pAssetName);
		boxType = BoxType.SIMPLE;
	}
	
	/**
	 * Initialisation
	 * @param	pSpawner
	 */
	override public function init(pSpawner:Spawn):Void
	{
		super.init(pSpawner);
		list.push(this);
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
	
	public function setModeEnd():Void
	{
		setState("end");
		doAction =  doActionEnd;
		SoundManager.getSound("destructible").play();
	}
	
	private function doActionEnd():Void
	{
		if (isAnimEnd) 
		{
			disactivate(true);
		}
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