package com.isartdigital.protoplatformer.game.sprites;

import com.isartdigital.protoplatformer.game.abstrait.Patrol;
import com.isartdigital.protoplatformer.game.level.spawn.Spawn;
import com.isartdigital.utils.game.StateGraphic;

/**
 * ...
 * @author 
 */
class EnemySpeed extends Patrol
{

	public function new() 
	{
		super("EnemySpeed");
		speedEnemy = 20;
		type = 2;
	}
	
	override public function init(pSpawner:Spawn):Void 
	{
		super.init(pSpawner);
		HP = 2;
	}
	
}