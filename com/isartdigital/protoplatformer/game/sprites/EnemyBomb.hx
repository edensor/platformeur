package com.isartdigital.protoplatformer.game.sprites;

import com.isartdigital.protoplatformer.game.abstrait.Gun;
import com.isartdigital.protoplatformer.game.abstrait.Patrol;
import com.isartdigital.protoplatformer.game.abstrait.Shoot;
import com.isartdigital.protoplatformer.game.abstrait.Wall;
import com.isartdigital.protoplatformer.game.level.spawn.Spawn;
import com.isartdigital.protoplatformer.ui.UIGraphics;
import com.isartdigital.utils.game.StateGraphic;
import com.isartdigital.utils.sounds.SoundManager;
import pixi.core.math.Point;

/**
 * ...
 * @author 
 */
class EnemyBomb extends Patrol
{
	private var RANGE_EXPLOSION(default, never):Int = 500;
	private var shield : Shield;
	public static inline var EXPLODE_STATE:String = "explode";

	public function new() 
	{
		super("EnemyBomb");
		shield = new Shield("FXEnemyBombShield");
		shield.start();
		addChild(shield);
		speedEnemy = 15;
		type = 0;
	}
	
	override public function init(pSpawner:Spawn):Void 
	{
		super.init(pSpawner);
		HP = 2;
	}

	override function doActionNormal():Void 
	{
		super.doActionNormal();
		shield.doAction();
		if (isInExplosionRange(Player.getInstance())) 
		{
			HP = 0;
			setModeHurt();
		}
	}
	
	override function doActionPatrol():Void 
	{
		super.doActionPatrol();
		shield.doAction();
		if (isInExplosionRange(Player.getInstance())) 
		{
			HP = 0;
			setModeHurt();
		}
	}
	
	override function doActionHurt():Void 
	{
		if (isAnimEnd) 
		{	
			if (HP <= 0) setModeExplode();
			else {
				setModePatrol();
				hurtable = true;
			}
		}
	}
	
	private function setModeExplode():Void{
		setState(EXPLODE_STATE);
		
		SoundManager.getSound("bomber").play();
		
		doAction = doActionExplode;
		
		if (!Player.getInstance().godMode && isInExplosionPlayer(Player.getInstance())) Player.getInstance().setModeHurt();
			var lLength:Int = Wall.list.length;
			for (i in 0...lLength) 
			{
				var lWall = Wall.list[lLength - 1 - i];
				if (lWall.assetName == "Destructible" && isInExplosionRange(lWall)) 
				{
					lWall.setModeEnd();
				}
			}
	}
	
	private function doActionExplode():Void{
		if (isAnimEnd) 
		{
			disactivate(true);
		}
	}
	
	/**
	 * Function  which test if we are in range of explosion
	 * @param	pElem, state graphic of element in range
	 */
	private function isInExplosionRange(pElem:StateGraphic):Bool
	{
		return ((x-(pElem.x+pElem.width/2))*((x)-(pElem.x+pElem.width/2))+((y+height/2)-(pElem.y+pElem.height/2))*((y+height/2)-(pElem.y+pElem.height/2))<RANGE_EXPLOSION*RANGE_EXPLOSION);
	}
	
	private function isInExplosionPlayer(pElem:StateGraphic):Bool
	{
		return ((x-pElem.x)*((x)-pElem.x)+((y-height/2)-(pElem.y-pElem.height))*((y-height/2)-(pElem.y-pElem.height))<RANGE_EXPLOSION*RANGE_EXPLOSION);
	}
	
	/**
	 * Change state of enemi if he got touch
	 * @param	pShoot, Shoot that hit the enemy
	 */
	override function imShot(lShoot:Shoot):Void 
	{
		if (lShoot.lvlShoot == 1){
			lShoot.flip();
			shield.setModeHit();
			shield.scale.x = lShoot.scale.x*scale.x;
		}
		else {
			HP = 0;
			setModeHurt();
			lShoot.setModeEnd();
		}
		
	}
	
}