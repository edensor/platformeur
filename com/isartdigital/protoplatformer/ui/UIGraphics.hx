package com.isartdigital.protoplatformer.ui;

import com.isartdigital.utils.game.StateGraphic;

/**
 * ...
 * @author Alexandre Le Merrer
 */
class UIGraphics extends StateGraphic
{

	
	public var lastState : Void -> Void;
	public function new(pAsset:String) 
	{
		super();
		assetName = pAsset;
	}
	
	override function setModeNormal():Void 
	{
		lastState = setModeNormal;
		setState(DEFAULT_STATE,true);
		super.setModeNormal();
	}
	
	public function setModeWait():Void{
		setState("wait", true);
		anim.animationSpeed = 0.5;
		lastState = setModeWait;
	}
	
	public function setModeJump():Void{
		setState("jump", false);
		lastState = setModeJump;
	}
	
	public function setModeWalk():Void{
		setState("walk", true);
		lastState = setModeWalk;
	}
	
	public function setModeFall():Void{
		setState("fall", false);
		lastState = setModeFall;
	}
	
	public function setModeReception():Void{
		setState("reception", false);
		lastState = setModeReception;
	}
	
	public function setModeShoot():Void{
		setState("shoot",false);
	}
	
	public function mySetState(pstate:String,?pBool:Bool=true):Void
	{
		setState(pstate,pBool);
	}
	
}