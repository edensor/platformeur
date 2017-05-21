package com.isartdigital.protoplatformer.game.level;
import com.isartdigital.protoplatformer.game.level.spawn.Spawn;

/**
 * ...
 * @author 
 */
class Cell
{
	public var list:Array<Spawn> = new Array<Spawn>();
	
	public function new() 
	{
		
	}
	
	/**
	 * Function which add a Spawn to cell
	 * @param pSpawn, Spawn
	 */
	public function add(pSpawn:Spawn)
	{
		list.push(pSpawn);
		pSpawn.myArrayCell.push(this);
	}
	
	public function destroy()
	{
		var lLength = list.length;
		for (i in 0...lLength) 
		{
			list[lLength - i - 1].destroy();
			list.splice(lLength - i - 1,1);
		}
	}
	
}