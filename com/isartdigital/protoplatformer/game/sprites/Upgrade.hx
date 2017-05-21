package com.isartdigital.protoplatformer.game.sprites;

import com.isartdigital.protoplatformer.game.abstrait.Collectable; 
import com.isartdigital.utils.game.BoxType;

/**
 * ...
 * @author Dt.Fab
 */
class Upgrade extends Collectable
{

	public function new(pAsset:String) 
	{
		super(pAsset);
		boxType = BoxType.SELF;
	}
	
}