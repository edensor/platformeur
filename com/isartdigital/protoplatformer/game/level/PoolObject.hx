package com.isartdigital.protoplatformer.game.level;

import com.isartdigital.protoplatformer.game.level.spawn.Spawn;
import com.isartdigital.utils.game.StateGraphic;
import pixi.core.display.Container;

/**
 * ...
 * @author Dt.Fab
 */
class PoolObject extends StateGraphic
{
	private var mySpawner:Spawn;

	public function new(pAsset:String)
	{
		super();
		assetName = pAsset;
		PoolManager.addToPool(assetName, this);
	}
	
	/**
	 * Initialisation
	 * @param	pSpawner
	 */
	public function init(pSpawner:Spawn):Void
	{
		mySpawner =  pSpawner;
		start();
	}
	
	/**
	 * Function  that disables this object
	 * @param	pDefinitiv, Bool if perma
	 */
	public function disactivate(?pDefinitiv:Bool = false)
	{
		if (parent != null) parent.removeChild(this);
		if (mySpawner != null) 
		{
			if (pDefinitiv) 
			{
				mySpawner.disactivate();
			}
			mySpawner.myBaby = null;
			mySpawner = null;
		}
		setModeVoid();
		PoolManager.addToPool(assetName, this);
	}
	
}