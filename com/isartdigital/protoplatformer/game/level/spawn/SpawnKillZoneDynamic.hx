package com.isartdigital.protoplatformer.game.level.spawn;

import com.isartdigital.protoplatformer.game.level.PoolManager;
import com.isartdigital.protoplatformer.game.level.PoolObject;
import com.isartdigital.protoplatformer.game.sprites.KillZoneDynamic;
import pixi.core.display.Container;
import pixi.core.math.shapes.Rectangle;

/**
 * ...
 * @author 
 */
class SpawnKillZoneDynamic extends Spawn
{
	
	private var typeKillZone:Int;
	
	public function new(pType:String, pRect:Rectangle, pContainer:Container,pName:String) 
	{
		super(pType, pRect, pContainer,pName);
	}
	
	/**
	 * Function which init killZone
	 */
	public function init(pType:Int):Void
	{
		typeKillZone =  pType;
	}
	
	/**
	 * Function which Spawn element from Spawner
	 */
	override public function doSpawn():Void 
	{
		if (myBaby == null) 
		{
			var lInstance:PoolObject = PoolManager.getFromPool(type);
			myContainer.addChild(lInstance);
			lInstance.position.set(myPosition.x, myPosition.y);
			lInstance.init(this);
			cast(lInstance, KillZoneDynamic).initKillZone(typeKillZone, myRect);
			myBaby = lInstance;
		}
	}
	
}