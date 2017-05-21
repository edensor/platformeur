package com.isartdigital.protoplatformer.game.level.spawn;

import pixi.core.display.Container;
import pixi.core.math.shapes.Rectangle;

/**
 * ...
 * @author 
 */
class SpawnCollectible extends Spawn
{
	private var ghost:Bool = false;
	public static var lisToSave:Array<String> = new Array<String>();
	
	public function new(pType:String, pRect:Rectangle, pContainer:Container, pName:String) 
	{
		super(pType, pRect, pContainer, pName);
		
	}
	
	public function initCollectible(pGhost:Bool)
	{
		ghost = pGhost;
	}
	
	override public function doSpawn():Void 
	{
		super.doSpawn();
		if (activate) 
		{
			if (ghost) 
			{
				myBaby.alpha = 0.4;
			}
			else 
			{
				myBaby.alpha = 1;
			}
		}
		
	}
	
	override public function destroy():Void 
	{
		lisToSave.push(myName);
		////trace(myName);
		super.destroy();
	}
	
}