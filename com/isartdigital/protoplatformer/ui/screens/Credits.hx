package com.isartdigital.protoplatformer.ui.screens;

import com.greensock.TweenMax;
import com.isartdigital.protoplatformer.ui.MyButton;
import com.isartdigital.protoplatformer.ui.UIGraphics;
import com.isartdigital.protoplatformer.ui.screens.TitleCard;
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
class Credits extends Screen 
{
	public static inline var BTNH:Float = 0.30;
	public static inline var BTNW:Float = -0.35;
	
	private var background:UIGraphics;
	private var credits:UIGraphics;
	private var title:UIGraphics;
	private var btnTiltleCard:MyButton; 
	private var sun:UIGraphics;
	private var titleDev:Text; 
	private var titleDa:Text; 
	private var txtDev:Text; 
	private var txtDa:Text;
	
	private var backgroundMobile : Array <UIGraphics>= new Array<UIGraphics>();
	/**
	 * instance unique de la classe WinScreen
	 */
	private static var instance: Credits;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): Credits {
		if (instance == null) instance = new Credits();
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
				credits = new UIGraphics("Credits");
				credits.mySetState("");
				credits.alpha = 0;
				addChild(credits);
				TweenMax.to(credits, 2, {alpha:1});
			}
			addChild(background);
			backgroundMobile.push(background);
			if (i == 5) untyped background.anim.animationSpeed = 0.5;
		}
		
		
		sun.x = -width / 2 -sun.width/4;
		sun.y = -height / 2;
		sun.scale.set(2, 2);
		
		title = new UIGraphics("TitleCard_title");
		title.mySetState("");
		addChild(title);
		titleDev = new Text( "Programmers", { font: "80px RoundedElegance", fill:"#0E2A38", align:"center"});
		titleDa = new Text( "Digital Art", { font: "80px RoundedElegance", fill:"#0E2A38", align:"center"});
		
		txtDev = new Text( "DORMANT Fabien \n LE MERRER Alexandre \n MARTELLA Marco", { font: "50px RoundedElegance", fill:"#0E2A38", align:"center"});
		txtDa = new Text( "BRUSCHI Yan\n MARAMOTTI Ophélie\n RUIZ Mehdi\n SOUBRIER Romain", { font: "50px RoundedElegance", fill:"#0E2A38", align:"center"});
		
		titleDev.anchor.set(0.5, 0.5);
		titleDev.x = -width/5.5;
		titleDev.y = -height/15;
		
		titleDa.anchor.set(0.5, 0.5);
		titleDa.x = width/5.5;
		titleDa.y = -height / 15;
		
		txtDev.anchor.set(0.5, 0.5);
		txtDev.x = -width/5.5;
		txtDev.y = height / 50;
		
		txtDa.anchor.set(0.5, 0.5);
		txtDa.x = width/5.5;
		txtDa.y =  height / 50;
		
		addChild(txtDev);
		addChild(txtDa);
		
		addChild(titleDev);
		addChild(titleDa);
		
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
		//removeChild(btnTiltleCard);
		//removeChild(background);
		super.destroy(); 
	}

}