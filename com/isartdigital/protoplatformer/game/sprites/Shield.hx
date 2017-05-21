package com.isartdigital.protoplatformer.game.sprites;

import com.isartdigital.protoplatformer.ui.UIGraphics;
import com.isartdigital.utils.sounds.SoundManager;

/**
 * ...
 * @author Alexandre Le Merrer
 */
class Shield extends UIGraphics
{
	
	private var HIT_STATE (default, null): String = "hit";
	private var END_STATE (default, null): String = "end";

	public function new(pAsset:String) 
	{
		super(pAsset);
	}
	
	override function setModeNormal():Void 
	{
		setState(DEFAULT_STATE,true);
		super.setModeNormal();
	}
	
	override function doActionNormal():Void 
	{
		super.doActionNormal();
	}
	
	public function setModeHit():Void{
		doAction = doActionHit;
		setState(HIT_STATE);
	}
	
	private function doActionHit():Void{
		if (isAnimEnd) setModeNormal();
	}
	
	public function setModeEnd():Void{
		doAction = doActionEnd;
		setState(END_STATE);
	}
	
	private function doActionEnd():Void{
		if (isAnimEnd) {
			SoundManager.getSound("shield_hurt").play();
			setModeNormal();
			if (parent != null) parent.removeChild(this);
		}
	}
	
	
	
}