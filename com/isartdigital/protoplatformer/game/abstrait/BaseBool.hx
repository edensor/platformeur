package com.isartdigital.protoplatformer.game.abstrait;

import com.isartdigital.utils.game.StateGraphic;
import pixi.core.display.Container;

/**
 * ...
 * @author Dt.Fab
 */
class BaseBool extends StateGraphic
{
	
	public var isActive(get, null):Bool;

	public function new() 
	{
		super();
		active();
	}
	
	private function get_isActive():Bool 
	{
		return isActive;
	}
	
	public function disactivate()
	{
		isActive = false;
		if(parent != null) parent.removeChild(this);
		setModeVoid();
	}
	
	public function active()
	{
		isActive = true;
	}
	
}