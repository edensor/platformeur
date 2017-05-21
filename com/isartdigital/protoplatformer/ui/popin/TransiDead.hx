package com.isartdigital.protoplatformer.ui.popin;

import com.greensock.TweenMax;
import com.isartdigital.protoplatformer.game.sprites.Player;
import com.isartdigital.utils.Config;
import com.isartdigital.utils.ui.Popin;
import pixi.core.sprites.Sprite;
import pixi.core.textures.Texture;

	
/**
 * ...
 * @author Alexandre Le Merrer
 */
class TransiDead extends Popin 
{
	
	/**
	 * instance unique de la classe TransiDead
	 */
	private static var instance: TransiDead;
	private var backgroundUp:Sprite;
	private var backgroundDown:Sprite;
	private var backgroundLeft:Sprite;
	private var backgroundRight:Sprite;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): TransiDead {
		if (instance == null) instance = new TransiDead();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		super();
		backgroundUp = new Sprite(Texture.fromImage(Config.url(Config.assetsPath + "black_bg.png")));
		backgroundUp.anchor.set(0.5, 1);

		
		backgroundDown = new Sprite(Texture.fromImage(Config.url(Config.assetsPath + "black_bg.png")));
		backgroundDown.anchor.set(0.5, 0);

		
		backgroundLeft = new Sprite(Texture.fromImage(Config.url(Config.assetsPath + "black_bg.png")));
		backgroundLeft.anchor.set(0, 0.5);
	
		backgroundRight = new Sprite(Texture.fromImage(Config.url(Config.assetsPath + "black_bg.png")));
		backgroundRight.anchor.set(1, 0.5);

		
		addChild(backgroundUp);
		addChild(backgroundDown);
		addChild(backgroundLeft);
		addChild(backgroundRight);
		var lTween0 : TweenMax = new TweenMax(backgroundUp.scale, 1, {x:200, y:100,onComplete:Player.getInstance().doTp});
		var lTween1 : TweenMax = new TweenMax(backgroundDown.scale, 1, {x:200, y:100});
		var lTween2 : TweenMax = new TweenMax(backgroundLeft.scale, 1, {x:100, y:200});
		var lTween3 : TweenMax = new TweenMax(backgroundRight.scale, 1, {x:100, y:200});
	}
	
	public function callbackTp():Void{
		var lTween0 : TweenMax = new TweenMax(backgroundUp, 1, {y: -1300, onComplete:Player.getInstance().restart});
		var lTween1 : TweenMax = new TweenMax(backgroundDown,1, {y:1300});
		var lTween2 : TweenMax = new TweenMax(backgroundLeft, 1, {x:1300});
		var lTween3 : TweenMax = new TweenMax(backgroundRight, 1, {x: -1300});
		
		//var lTween : TweenMax = new TweenMax(this, 2, {alpha:0});
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		TweenMax.killAll();
		instance = null;
	}

}