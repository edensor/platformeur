package com.isartdigital.protoplatformer.game.level.spawn;

import com.isartdigital.protoplatformer.game.sprites.CheckPoint;
import pixi.core.display.Container;
import pixi.core.math.shapes.Rectangle;

/**
 * ...
 * @author 
 */
class SpawnCheckPoint extends Spawn
{
	
	private var isActive:Bool = false;
	
	public function new(pType:String, pRect:Rectangle, pContainer:Container, pName:String) 
	{
		super(pType, pRect, pContainer, pName);
		
	}
	
	/**
	 * Function which Spawn element from Spawner
	 */
	override public function doSpawn():Void 
	{
		super.doSpawn();
		if (isActive) 
		{
			cast(myBaby, CheckPoint).isActive = true;
			cast(myBaby, CheckPoint).setModeWait();
		}
	}
	
	/**
	 * Function which disable element from Spawner
	 */
	override public function deSpawn():Void 
	{
		if(myBaby != null)isActive = cast(myBaby, CheckPoint).isActive;
		super.deSpawn();
	}
	
}