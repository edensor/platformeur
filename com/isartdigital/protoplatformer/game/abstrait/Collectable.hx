package com.isartdigital.protoplatformer.game.abstrait;

import com.isartdigital.protoplatformer.game.level.PoolObject;
import com.isartdigital.protoplatformer.game.level.spawn.Spawn;
import com.isartdigital.utils.game.BoxType;
import com.isartdigital.utils.game.StateGraphic;

/**
 * ...
 * @author 
 */
class Collectable extends PoolObject
{

	public static var list:Array<Collectable> = new Array<Collectable>();
	private var RANGE_FOLLOW(default, never):Int = 300;
	private var AMPLITTUDE(default, never):Int = 40;
	
	private var y0:Float = 0;
	
	public static var target:StateGraphic;
	
	private var count :Int = 0;
	private var speed : Float = 1;
	
	public function new(pAsset:String) 
	{
		super(pAsset);
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
		y0 = y;
	}
	
	override private function setModeNormal():Void 
	{
		setState(DEFAULT_STATE);
		super.setModeNormal();
	}
	override private function doActionNormal():Void 
	{
		count++;
		y = y0 + AMPLITTUDE * Math.sin(count/(4*Math.PI));
		if (isInShootRange(target)) setModeFollow();
	}
	
	public function setModeFollow():Void
	{
		doAction = doActionFollow;
	}
	
	private function doActionFollow():Void
	{
		x += (target.x- x) / 10;
		y += (target.y-target.height/2 - y) / 10;
	}
	
	/**
	 * Test if we are in range
	 * @return	Bool : True if in, false if not
	 */
	private function isInShootRange(pElem:StateGraphic):Bool
	{
		return ((x-(pElem.x+pElem.width/2))*(x-(pElem.x+pElem.width/2))+(y-(pElem.y-height))*(y-(pElem.y-height))<RANGE_FOLLOW*RANGE_FOLLOW);
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