package com.isartdigital.protoplatformer.game.level.spawn;
import com.isartdigital.protoplatformer.game.level.PoolManager;
import com.isartdigital.protoplatformer.game.level.PoolObject;
import pixi.core.display.Container;
import pixi.core.math.Point;
import pixi.core.math.shapes.Rectangle;

/**
 * ...
 * @author 
 */
class Spawn
{
	
	private static var spawnToDestroy:Array<Spawn> = new Array<Spawn>();

	private var myRect:Rectangle;
	public var type:String;
	private var myContainer:Container;
	public var myPosition:Point = new Point();
	private var isPatrol:Bool;
	public var myName:String;
	public var myBaby:PoolObject;
	public var myArrayCell:Array<Cell> =  new Array<Cell>();
	public var activate:Bool = true;
	
	
	public function new(pType:String,pRect:Rectangle,pContainer:Container,pName:String) 
	{
		type = pType;
		myRect = pRect.clone();
		myContainer = pContainer;
		myPosition.set(pRect.x, pRect.y);
		myName =  pName;
	}
	
	/**
	 * Function which Spawn element from Spawner
	 */
	public function doSpawn():Void
	{
		if (activate && myBaby == null) 
		{
			var lInstance:PoolObject = PoolManager.getFromPool(type);
			lInstance.position.set(myPosition.x, myPosition.y);
			myContainer.addChild(lInstance);
			lInstance.init(this);
			myBaby = lInstance;
		}
		
	}
	
	/**
	 * Function which disable element from Spawner
	 */
	public function deSpawn():Void
	{
		////trace("despawn");
		if (myBaby != null) {
			myBaby.disactivate();
			myBaby = null;
		}
	}
	
	/**
	 * Function which disable spawner
	 */
	public function disactivate():Void
	{
		activate = false;
		spawnToDestroy.push(this);
	}
	
	/**
	 * Function which destroy spawner
	 */
	public function destroy():Void
	{
		myBaby = null;
		myPosition = null;
		myContainer = null;
		var lLength = myArrayCell.length;
		for (i in 0...lLength) 
		{
			myArrayCell.pop().list.remove(this);
		}
		myArrayCell = null;
	}
	
	/**
	 * Function which destroy spawner out of clipping
	 */
	public static function destroyNeededSpawn():Void 
	{
		var lLength:Int = spawnToDestroy.length;
		for (i in 0...lLength) 
		{
			spawnToDestroy.pop().destroy();
		}
	}
	
	/**
	 * Function which restore spawner in clipping
	 */
	public static function restaureNeededSpawn()
	{
		var lLength:Int = spawnToDestroy.length;
		for (i in 0...lLength) 
		{
			spawnToDestroy.pop().activate = true;
		}
	}
	
}