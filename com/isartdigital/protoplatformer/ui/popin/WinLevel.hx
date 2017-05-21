package com.isartdigital.protoplatformer.ui.popin;

import com.greensock.TweenMax;
import com.isartdigital.protoplatformer.game.GameManager;
import com.isartdigital.protoplatformer.game.abstrait.LocalizationManager;
import com.isartdigital.protoplatformer.game.level.DataManager;
import com.isartdigital.protoplatformer.game.level.LevelManager;
import com.isartdigital.protoplatformer.ui.UIGraphics;
import com.isartdigital.protoplatformer.ui.screens.LevelSelecter;
import com.isartdigital.protoplatformer.ui.screens.WinScreen;
import com.isartdigital.utils.Config;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.ui.Popin;
import pixi.core.sprites.Sprite;
import pixi.core.text.Text;
import pixi.core.textures.Texture;
import pixi.interaction.EventTarget;

	
/**
 * ...
 * @author Alexandre Le Merrer
 */
class WinLevel extends Popin 
{
	
	private var background:UIGraphics;
	private var upgradeText:Text;
	private var upgradeExplainText:Text;
	public static var lastUpgrade : String = "DoubleJump";
	
	private var backgroundUp:Sprite;
	private var backgroundDown:Sprite;
	private var backgroundLeft:Sprite;
	private var backgroundRight:Sprite;
	
	/**
	 * instance unique de la classe WinLevel
	 */
	private static var instance: WinLevel;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): WinLevel {
		if (instance == null) instance = new WinLevel();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new(?pUpgrade:String) 
	{
		super();
		SoundManager.getSound("victory").play();
		
		alpha = 0;
		background = new UIGraphics("Cadre_Victory");
		background.mySetState("");
		addChild(background);
		
		upgradeText = new Text(LocalizationManager.stringListMap[lastUpgrade],{ font: "50px RoundedElegance", fill:"#FFFFFF"});
		LocalizationManager.textListMap.set(lastUpgrade, upgradeText);
		upgradeText.anchor.set(0.5, 0.5);
		upgradeText.y = -height / 4;
		addChild(upgradeText);
		
		upgradeExplainText = new Text(LocalizationManager.stringListMap[lastUpgrade+"_Explain"],{ font: "50px RoundedElegance", fill:"#FFFFFF",wordWrap:true, wordWrapWidth:background.width*3/4});
		LocalizationManager.textListMap.set(lastUpgrade+"_Explain", upgradeExplainText);
		upgradeExplainText.anchor.set(0.5, 0.5);
		addChild(upgradeExplainText);
		
		interactive = true;
		
		once(MouseEventType.CLICK,onClick);
		once(TouchEventType.TAP, onClick);
		TweenMax.to(this, 1, {alpha:1});
		
		backgroundUp = new Sprite(Texture.fromImage(Config.url(Config.assetsPath + "black_bg.png")));
		backgroundUp.anchor.set(0.5, 1);
		backgroundUp.scale.set(0, 0);
		
		backgroundDown = new Sprite(Texture.fromImage(Config.url(Config.assetsPath + "black_bg.png")));
		backgroundDown.anchor.set(0.5, 0);
		backgroundDown.scale.set(0, 0);
		
		backgroundLeft = new Sprite(Texture.fromImage(Config.url(Config.assetsPath + "black_bg.png")));
		backgroundLeft.anchor.set(0, 0.5);
		backgroundLeft.scale.set(0, 0);
	
		backgroundRight = new Sprite(Texture.fromImage(Config.url(Config.assetsPath + "black_bg.png")));
		backgroundRight.anchor.set(1, 0.5);
		backgroundRight.scale.set(0, 0);
		
		addChild(backgroundUp);
		addChild(backgroundDown);
		addChild(backgroundLeft);
		addChild(backgroundRight);
		
		GameManager.getInstance().cutGameLoop();
	}
	
	private function onClick (pEvent:EventTarget): Void {
		var lTween0 : TweenMax = new TweenMax(backgroundUp.scale, 0.8, {x:200,y: 100, onComplete:goToLevel});
		var lTween1 : TweenMax = new TweenMax(backgroundDown.scale,0.8, {x:200,y: 100,});
		var lTween2 : TweenMax = new TweenMax(backgroundLeft.scale, 0.8, {x:200,y: 100,});
		var lTween3 : TweenMax = new TweenMax(backgroundRight.scale, 0.8, {x:200,y: 100,});
	}
	
	private function goToLevel():Void {
		SoundManager.getSound("victory").stop();
		TweenMax.killAll();
		UIManager.getInstance().closeCurrentPopin();
		GameManager.getInstance().destroy();
		
		SoundManager.getSound("titlecard").loop(true);
		SoundManager.getSound("titlecard").play();
		if(DataManager.collectibleTotal[0] == DataManager.levelArray[0].length && DataManager.collectibleTotal[1] == DataManager.levelArray[1].length && DataManager.collectibleTotal[2] == DataManager.levelArray[2].length)UIManager.getInstance().openScreen(WinScreen.getInstance());
		else UIManager.getInstance().openScreen(LevelSelecter.getInstance());
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
	}

}