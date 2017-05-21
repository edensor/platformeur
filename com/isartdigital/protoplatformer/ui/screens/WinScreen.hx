package com.isartdigital.protoplatformer.ui.screens;

import com.greensock.TweenMax;
import com.isartdigital.protoplatformer.game.abstrait.LocalizationManager;
import com.isartdigital.protoplatformer.ui.UIGraphics;
import com.isartdigital.protoplatformer.ui.popin.Confirm;
import com.isartdigital.utils.Config;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.ui.Screen;
import pixi.core.sprites.Sprite;
import pixi.core.text.Text;
import pixi.core.textures.Texture;
import pixi.interaction.EventTarget;

	
/**
 * ...
 * @author Dt.Fab
 */
class WinScreen extends Screen 
{
	public static inline var btnH:Float = 0.30;
	public static inline var btnW:Float = (-0.35);
	
	private var btnTiltleCard:MyButton;
	private var background:UIGraphics;
	private var winscreen:UIGraphics;
	private var title:UIGraphics;
	private var sun:UIGraphics;
	private var txt:Text;
	
	/**
	 * instance unique de la classe WinScreen
	 */
	private static var instance: WinScreen;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): WinScreen {
		if (instance == null) instance = new WinScreen();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		super();
		for (i in 0...7)
		{
			background = new UIGraphics ("TitleCard_bg_" + i);
			background.mySetState("");
			if (i == 4) {
				sun = new UIGraphics("Sun");
				sun.mySetState("");
				addChild(sun);
				winscreen = new UIGraphics("WinScreen");
				winscreen.mySetState("");
				winscreen.alpha = 0;
				addChild(winscreen);
				TweenMax.to(winscreen, 2, {alpha:1});
			}
			addChild(background);
			if (i == 5) untyped background.anim.animationSpeed = 0.5;
		}
		
		txt = new Text(LocalizationManager.stringListMap["Win"], { font: "60px RoundedElegance", fill:"#0E2A38", wordWrap:true, wordWrapWidth:background.width});
		txt.anchor.set(0.5, 0.5);
		addChild(txt);
		
		
		sun.x = -width / 2 -sun.width/4;
		sun.y = -height / 2;
		sun.scale.set(2, 2);
		
		title = new UIGraphics("TitleCard_title");
		title.mySetState("");
		addChild(title);
		
		btnMenu(); 
	}
	
	private function btnMenu():Void
	{
		btnTiltleCard = new MyButton("Btn_Back"); 
		btnTiltleCard.y = width/4.5;
		btnTiltleCard.x = height/2.5;
		btnTiltleCard.scale.x = 1.5;
		btnTiltleCard.scale.y = 1.5;
		btnTiltleCard.once(MouseEventType.CLICK,onMenu);
		btnTiltleCard.once(TouchEventType.TAP, onMenu);
		addChild(btnTiltleCard);
	}
	
	private function onMenu (pEvent:EventTarget): Void {
		UIManager.getInstance().openScreen(TitleCard.getInstance());
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		
		instance = null;
		removeChild(btnTiltleCard);
		removeChild(background);
		super.destroy(); 
	}

}