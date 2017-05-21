package com.isartdigital.protoplatformer.game.abstrait;

import com.isartdigital.protoplatformer.game.level.PoolObject;
import com.isartdigital.utils.game.BoxType;
import pixi.core.math.Point;

/**
 * ...
 * @author 
 */
class Mobile extends PoolObject
{
	
	public var velocity: Point = new Point(0,0);
	private var acceleration: Point= new Point(0,0);
	private var friction:Point = new Point(0, 0);
	private var MaxHSpeed:Float = 10;
	private var MaxVSpeed:Float = 10;

	public function new(pAsset:String) 
	{
		super(pAsset);
		boxType = BoxType.SIMPLE;
	}

	override public function start():Void 
	{
		super.start();
		anim.animationSpeed = 0.5;
	}
	
	/**
	 * Function that allows movement of mobile objects
	 * 
	 */
	private function move():Void
	{
		velocity.x += acceleration.x;
		velocity.x = (velocity.x < 0 ? -1: 1) * Math.min(Math.abs(velocity.x), MaxHSpeed);
		x += velocity.x;
		velocity.x *= friction.x;
		
		velocity.y += acceleration.y;
		velocity.y = (velocity.y < 0 ? -1: 1) * Math.min(Math.abs(velocity.y), MaxVSpeed);
		y += velocity.y;
		velocity.y *= friction.y;
		
		acceleration.set(0, 0);
	}
	
}