package com.isartdigital.protoplatformer.game.sprites;

import com.isartdigital.protoplatformer.game.abstrait.Mobile;
import com.isartdigital.protoplatformer.game.level.spawn.Spawn;
import pixi.core.math.shapes.Rectangle;

/**
 * ...
 * @author 
 */
class KillZoneDynamic extends Mobile
{
	
	public static var list:Array<KillZoneDynamic> = new Array<KillZoneDynamic>();
	
	public static inline var RANGE:Int = 600;
	public static inline var SPEED:Int = 10;

	private var type:Int;
	private var myTimer:Float = 60*1.5;
	private var myCount:Int = 0;
	private var rangeRun:Rectangle;
	

	public function new() 
	{
		super("KillZoneDynamic");
		friction.set(1, 1);
		MaxHSpeed = SPEED;
		MaxVSpeed = SPEED;
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
	
	/**
	 * Initialisation of KillZone
	 * @param	pType, direction of killZone
	 * @param	pRange, Range of killZone
	 */
	public function initKillZone(pType:Int,pRange:Rectangle):Void
	{
		type = pType;
		rangeRun = pRange.clone();
		x += rangeRun.width / 2;
		y += rangeRun.height / 2;
		var lAngle:Float = pType * Math.PI / 4;
		velocity.x = SPEED * Math.cos(lAngle);
		velocity.y = SPEED * Math.sin(lAngle);
		start();
	}
	
	override private function setModeNormal():Void 
	{
		setState(DEFAULT_STATE,true);
		super.setModeNormal();
	}
	
	override function doActionNormal():Void 
	{
		rotation += 1 / Math.PI;
		super.doActionNormal();
		move();
		if (x <= rangeRun.x || x >= rangeRun.x + rangeRun.width || y <= rangeRun.y || y >= rangeRun.y + rangeRun.height) flip();
	}
	
	/**
	 * Function which inverts velocity
	 * 
	 */
	private function flip():Void
	{
		velocity.x *= -1;
		velocity.y *= -1;
		
	}
	
	/**
	 * Function  that disables this object
	 * @param	pDefinitiv, Bool if perma
	 */
	override function disactivate(?pDefinitiv:Bool = false) {  
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