package com.isartdigital.protoplatformer.ui.popin;

import com.greensock.TweenMax;
import com.isartdigital.protoplatformer.game.GameManager;
import com.isartdigital.protoplatformer.game.abstrait.LocalizationManager;
import com.isartdigital.protoplatformer.game.level.LevelManager;
import com.isartdigital.protoplatformer.ui.MyButton;
import com.isartdigital.protoplatformer.ui.UIGraphics;
import com.isartdigital.protoplatformer.ui.screens.LevelSelecter;
import com.isartdigital.utils.Config;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.game.StateGraphic;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.ui.Popin;
import pixi.core.sprites.Sprite;
import pixi.core.textures.Texture;
import pixi.interaction.EventTarget;

	
/**
 * ...
 * @author Alexandre Le Merrer
 */
class Pause extends Popin 
{
	
	
	private var background:UIGraphics;
	
	/**
	 * instance unique de la classe Pause
	 */
	private static var instance: Pause;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): Pause {
		if (instance == null) instance = new Pause();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		super();
		alpha = 0;
		scale.set(2, 2);
		background = new UIGraphics("ScreenPause");
		background.mySetState("");
		addChild(background);
		
		var lResume : MyButton = new MyButton("BtnVoid","Resume");
		lResume.setText(LocalizationManager.stringListMap["Resume"]);
		lResume.y = 0;
		lResume.setAnchorText(0, 0.5);
		lResume.setPosText( -80, -5);
		lResume.setFont("30px RoundedElegance");
		addChild(lResume);
		
		var lQuit : MyButton = new MyButton("BtnVoid","Quit");
		lQuit.setText(LocalizationManager.stringListMap["Quit"]);
		lQuit.y = 50;
		lQuit.setAnchorText(0, 0.5);
		lQuit.setPosText( -80, -5);
		lQuit.setFont("30px RoundedElegance");
		addChild(lQuit);
		
		lResume.once(MouseEventType.CLICK,onClickResume);
		lResume.once(TouchEventType.TAP, onClickResume);
		
		lQuit.once(MouseEventType.CLICK,onClickQuit);
		lQuit.once(TouchEventType.TAP, onClickQuit);
		
		TweenMax.to(this, 0.5, {alpha:1});
	}
	
	private function onClickResume (pEvent:EventTarget): Void {
		TweenMax.to(this, 0.5, {alpha:0,onComplete:UIManager.getInstance().closeCurrentPopin});
		GameManager.getInstance().resume();
	}
	
	private function onClickQuit (pEvent:EventTarget): Void {
		UIManager.getInstance().closeCurrentPopin();
		GameManager.getInstance().destroy();
		
		SoundManager.getSound("titlecard").loop(true);
		SoundManager.getSound("titlecard").play();
		
		UIManager.getInstance().openScreen(LevelSelecter.getInstance());
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
	}

}