package com.isartdigital.protoplatformer.game.sprites;

import com.isartdigital.protoplatformer.game.level.PoolObject;
import com.isartdigital.protoplatformer.game.level.spawn.Spawn;
import com.isartdigital.utils.game.BoxType;
import com.isartdigital.utils.game.CollisionManager;
import com.isartdigital.utils.sounds.SoundManager;
import pixi.core.math.Point;

/**
 * ...
 * @author Dt.Fab
 */
class CheckPoint extends PoolObject
{

	private var WAIT_STATE(default, never):String = "Wait";
	private var ACTIVATE_STATE(default, never):String = "Begin";
	private var DESACTIVE_STATE(default, never):String = "Disactive";
	
	public static var list:Array<CheckPoint> = new Array<CheckPoint>();
	
	public static var lastCheckPointActivate:Point = new Point(0, 0);
	
	public var isActive:Bool = false;
	
	public function new() 
	{
		super("CheckPoint");
		boxType = BoxType.SELF;
	}
	
	/**
	 * Initialisation
	 * @param	pSpawner
	 */
	override public function init(pSpawner:Spawn):Void
	{
		list.push(this);
		super.init(pSpawner);
		isActive =  false;
	}
	
	override public function start():Void 
	{
		super.start();
		setState(DESACTIVE_STATE);
	}
	
	public function setModeActivate(?already:Bool = false):Void
	{
		if (!already && !isActive) {
			setState(ACTIVATE_STATE);
			SoundManager.getSound("check_point").play();
			doAction = doActionActivate;
			isActive = true;
		}
		if (!already) 
		{
			lastCheckPointActivate.set(x, y);
			Spawn.destroyNeededSpawn();
		}
	}
	
	private function doActionActivate():Void
	{
		if (isAnimEnd) 
		{
			setModeWait();
		}
	}
	
	public function setModeWait():Void
	{
		setState(WAIT_STATE, true);
		setModeVoid();
	}
	
	
	/**
	 * Function  that disables this object
	 * @param	pDefinitiv, Bool if perma
	 */
	override function disactivate(?pDefinitiv:Bool = false):Void
	{ 
		isActive = false;
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