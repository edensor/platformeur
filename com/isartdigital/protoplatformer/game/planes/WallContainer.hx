package com.isartdigital.protoplatformer.game.planes;

import com.isartdigital.utils.game.GameObject;

	
/**
 * ...
 * @author 
 */
class WallContainer extends GameObject 
{
	
	/**
	 * instance unique de la classe WallContainer
	 */
	private static var instance: WallContainer;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): WallContainer {
		if (instance == null) instance = new WallContainer();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		super();
		
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
		super.destroy();
	}

}