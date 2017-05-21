package com.isartdigital.protoplatformer.game.sprites;

import com.isartdigital.protoplatformer.game.planes.GamePlane;
import com.isartdigital.protoplatformer.game.planes.ScrollingPlanes;
import com.isartdigital.protoplatformer.game.planes.ScrollingPlanes;
import com.isartdigital.utils.game.StateGraphic;
import com.isartdigital.utils.system.DeviceCapabilities;

/**
 * ...
 * @author ...
 */
class Background extends StateGraphic
{

	public function new(pAsset:String) 
	{
		super();
		assetName = pAsset;	
		y = 0;
	}
	
	override private function setModeNormal():Void 
	{
		setState(DEFAULT_STATE);
		super.setModeNormal();
	}
	
	override function doActionNormal():Void 
	{
		super.doActionNormal();
		
	}
	
	
	
}