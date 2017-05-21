package com.isartdigital.protoplatformer.game.sprites;

import com.isartdigital.protoplatformer.game.abstrait.Wall;
import com.isartdigital.utils.game.StateGraphic;

/**
 * ...
 * @author 
 */
class Destructible extends Wall
{

	public function new(pAssetName:String) 
	{
		super(pAssetName);
		
	}
	override private function setModeNormal():Void 
	{
		setState(DEFAULT_STATE);
		super.setModeNormal();
	}
	override private function doActionNormal():Void 
	{
		
	}
}