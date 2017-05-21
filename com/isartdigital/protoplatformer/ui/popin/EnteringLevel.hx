package com.isartdigital.protoplatformer.ui.popin;

import com.greensock.TweenMax;
import com.isartdigital.protoplatformer.game.sprites.Player;
import com.isartdigital.utils.Config;
import com.isartdigital.utils.ui.Popin;
import pixi.core.sprites.Sprite;
import pixi.core.textures.Texture;

	
/**
 * ...
 * @author ...
 */
class EnteringLevel extends Popin 
{
	
	/**
	 * instance unique de la classe EnteringLevel
	 */
	private static var instance: EnteringLevel;
	private var backgroundUp:Sprite;
	private var backgroundDown:Sprite;
	private var backgroundLeft:Sprite;
	private var backgroundRight:Sprite;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): EnteringLevel {
		if (instance == null) instance = new EnteringLevel();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{		
		super();
		Player.getInstance().setModeRestart();
		backgroundUp = new Sprite(Texture.fromImage(Config.url(Config.assetsPath + "black_bg.png")));
		backgroundUp.anchor.set(0.5, 1);
		backgroundUp.scale.set(200, 100);

		
		backgroundDown = new Sprite(Texture.fromImage(Config.url(Config.assetsPath + "black_bg.png")));
		backgroundDown.anchor.set(0.5, 0);
		backgroundDown.scale.set(200, 100);

		
		backgroundLeft = new Sprite(Texture.fromImage(Config.url(Config.assetsPath + "black_bg.png")));
		backgroundLeft.anchor.set(0, 0.5);
		backgroundLeft.scale.set(200, 100);
		
	
		backgroundRight = new Sprite(Texture.fromImage(Config.url(Config.assetsPath + "black_bg.png")));
		backgroundRight.anchor.set(1, 0.5);
		backgroundRight.scale.set(200, 100);

		
		addChild(backgroundUp);
		addChild(backgroundDown);
		addChild(backgroundLeft);
		addChild(backgroundRight);
		var lTween0 : TweenMax = new TweenMax(backgroundUp, 0.5, {y: -1300, onComplete:Player.getInstance().restart});
		var lTween1 : TweenMax = new TweenMax(backgroundDown,0.5, {y:1300});
		var lTween2 : TweenMax = new TweenMax(backgroundLeft, 0.5, {x:1300});
		var lTween3 : TweenMax = new TweenMax(backgroundRight, 0.5, {x: -1300});
	}
	
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
	}

}