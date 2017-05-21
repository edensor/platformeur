package com.isartdigital.protoplatformer.game.level.spawn;

import com.isartdigital.protoplatformer.game.abstrait.Mobile;
import com.isartdigital.protoplatformer.game.abstrait.Patrol;
import com.isartdigital.protoplatformer.game.level.PoolManager;
import com.isartdigital.protoplatformer.game.level.PoolObject;
import pixi.core.display.Container;
import pixi.core.math.shapes.Rectangle;

/**
 * ...
 * @author 
 */
class SpawnPatrol extends Spawn
{
	
	public var myVelocity:Float = 0;
	public var HP:Int = -1;

	public function new(pType:String, pRect:Rectangle, pContainer:Container,pName:String) 
	{
		super(pType, pRect, pContainer,pName);
		myRect.x -= myRect.width / 2;
	}
	
	/**
	 * Function which Spawn element from Spawner
	 */
	override public function doSpawn():Void 
	{
		if (activate && myBaby == null) 
		{
			var lInstance:PoolObject = PoolManager.getFromPool(type);
			lInstance.init(this);
			lInstance.position.set(myPosition.x, myPosition.y);
			myContainer.addChild(lInstance);
			cast(lInstance, Patrol).initRange(myRect, myVelocity);
			if(HP >0 )cast(lInstance, Patrol).HP = HP;
			myBaby = lInstance;
		}
	}
	
	/**
	 * Function which disable element from Spawner
	 */
	override public function deSpawn() 
	{
		if (myBaby != null) {
			myPosition.x = myBaby.x;
			myPosition.y = myBaby.y;
			myVelocity = cast(myBaby, Mobile).velocity.x;
			//HP = cast(myBaby, Patrol).HP;
			super.deSpawn();
		}
	}
	
}