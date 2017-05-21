package com.isartdigital.protoplatformer.ui.screens;

import com.greensock.TweenMax;
import com.greensock.easing.Power1;
import com.isartdigital.protoplatformer.game.abstrait.LocalizationManager;
import com.isartdigital.protoplatformer.ui.MyButton;
import com.isartdigital.protoplatformer.ui.UIGraphics;
import com.isartdigital.protoplatformer.ui.popin.Confirm;
import com.isartdigital.protoplatformer.ui.screens.Credits;
import com.isartdigital.protoplatformer.ui.screens.WinScreen;
import com.isartdigital.utils.Config;
import com.isartdigital.utils.events.EventType;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.loader.GameLoader;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.ui.Screen;
import pixi.core.display.Container;
import pixi.core.sprites.Sprite;
import pixi.core.text.Text;
import pixi.core.textures.Texture;
import pixi.interaction.EventTarget;

	
/**
 * Exemple de classe héritant de Screen
 * @author 
 */
class TitleCard extends Screen 
{	
	private var btnWin:MyButton; 
	private var btnCredits:MyButton; 
	private var btnLevel:MyButton; 
	private var btnLang:MyButton; 
	private var background:UIGraphics;
	private var title:UIGraphics;
	private var sun:UIGraphics;
	private var txt:Text;
	private var container:Container;
	
	private var backgroundMobile : Array <UIGraphics>= new Array<UIGraphics>();
	
	/**
	 * instance unique de la classe TitleCard
	 */
	private static var instance: TitleCard;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): TitleCard {
		if (instance == null) instance = new TitleCard();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	public function new() 
	{
		
		super(); 		
		container = new Container();
		title = new UIGraphics("TitleCard_title");
		title.mySetState("");
		for (i in 0...7)
		{
			background = new UIGraphics ("TitleCard_bg_" + i);
			background.mySetState("");
			if (i < 4){
				background.alpha = 0;
				TweenMax.to(background, 1, {alpha:1});
			}
			if (i == 4){
				sun = new UIGraphics("Sun");
				sun.mySetState("");
				container.addChild(sun);
			}
			addChild(background);
			backgroundMobile.push(background);
			if (i == 5) untyped background.anim.animationSpeed = 0.5;
		}
		
		sun.x = -width / 2 -sun.width/4;
		sun.y = -height / 2;
		sun.scale.set(2, 2);
		addChild(container);
		container.addChild(title);
		btnMenu();
		container.alpha = 0;
		TweenMax.to(container, 2, {delay:0.5, alpha:1});
		
		var lTweenBackground : TweenMax;
		for (i in 1...4)
		{
			TweenMax.to(backgroundMobile[i], 5, {delay:0.3 * i, repeat: -1, x:-150,y:(i%2 == 0?30*-1:30*1), yoyo:true, ease:Power1.easeInOut});
		}
		
		title.scale.set(0.8, 0.8);
	}
	
	private function btnMenu():Void
	{
		btnLevel = new MyButton("BtnVoid","Play"); 
		btnLevel.y = 100; 
		btnLevel.x = x;
		btnLevel.scale.x = 1.8;
		btnLevel.scale.y = 1.8;
		btnLevel.once(MouseEventType.CLICK,onLevel);
		btnLevel.once(TouchEventType.TAP, onLevel);
		btnLevel.setText(LocalizationManager.stringListMap["Play"]);
		container.addChild(btnLevel);
		
		btnCredits = new MyButton("BtnVoid","Credits"); 
		btnCredits.y = y + (height * 0.25); 
		btnCredits.x = x - (width * ( -0.30)); 
		btnCredits.scale.x = 0.8;
		btnCredits.scale.y = 0.8;
		btnCredits.once(MouseEventType.CLICK,onCredits);
		btnCredits.once(TouchEventType.TAP, onCredits);
		btnCredits.setText(LocalizationManager.stringListMap["Credits"]);
		container.addChild(btnCredits); 
		
		btnLang = new MyButton("BtnVoid","Language"); 
		btnLang.y = y +(height * 0.25); 
		btnLang.x = x + (width * ( -0.32));
		btnLang.scale.x = 0.8;
		btnLang.scale.y = 0.8;
		btnLang.on(MouseEventType.CLICK,LocalizationManager.changeLang);
		btnLang.on(TouchEventType.TAP,LocalizationManager.changeLang);
		btnLang.setText(LocalizationManager.stringListMap["Language"]);
		container.addChild(btnLang);
	}
	
	private function onClick (pEvent:EventTarget): Void {
		TweenMax.killAll();
		UIManager.getInstance().openScreen(WinScreen.getInstance());
	}
	
	private function onCredits (pEvent:EventTarget): Void {
		TweenMax.to(container, 0.8, {alpha:0,onComplete:gotToCreditsScreen});
	}
	private function gotToCreditsScreen() {
		TweenMax.killAll();
		UIManager.getInstance().openScreen(Credits.getInstance());
	}
	
	private function onLevel (pEvent:EventTarget): Void {
		for (i in 0...4)
		{
			if (i == 0) TweenMax.to(backgroundMobile[i], 1, {alpha:0, onComplete:gotToLevelScreen});
			else TweenMax.to(backgroundMobile[i], 1, {alpha:0});
			
		}
		TweenMax.to(container, 1, {alpha:0});
	}
	
	private function gotToLevelScreen() {	
		TweenMax.killAll();
		UIManager.getInstance().openScreen(LevelSelecter.getInstance());
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		removeChild(background);
		removeChild(btnLevel);
		removeChild(btnCredits);
		removeChild(btnWin);
		removeChildren();
		btnLang.off(MouseEventType.CLICK,LocalizationManager.changeLang);
		for (lBackground in backgroundMobile) lBackground.destroy();
		instance = null;
		super.destroy();
	}

}