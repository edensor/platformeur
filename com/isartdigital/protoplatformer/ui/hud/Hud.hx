package com.isartdigital.protoplatformer.ui.hud;

import com.isartdigital.protoplatformer.game.GameManager;
import com.isartdigital.protoplatformer.ui.MyButton;
import com.isartdigital.protoplatformer.ui.UIGraphics;
import com.isartdigital.utils.Config;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.system.DeviceCapabilities;
import com.isartdigital.utils.ui.Screen;
import com.isartdigital.utils.ui.UIPosition;
import js.html.TouchEvent;
import pixi.core.display.Container;
import pixi.core.sprites.Sprite;
import pixi.core.text.Text;
import pixi.core.textures.Texture;
import pixi.interaction.EventTarget;

/**
 * Classe en charge de gérer les informations du Hud
 * @author Mathieu ANTHOINE
 */
class Hud extends Screen 
{
	
	/*
	 * instance unique de la classe Hud
	 */
	private static var instance: Hud;
	
	public var hudTopLeft:Container;
	public var hudBottomLeft:Container;
	public var hudBottomRight:Container;
	public var hudTopRight:Container;
	
	public var Touch_Left :  MyButton;
	public var Touch_Right :  MyButton;
	public var Touch_Jump :  MyButton;
	public var Touch_Shoot :  MyButton;
	public var pause :  MyButton;
	public var collectable:UIGraphics;
	public var txtScore:Text;
	

	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): Hud {
		if (instance == null) instance = new Hud();
		return instance;
	}	
	
	public function new() 
	{
		super();
		_modal = false;
		txtScore = new Text(": 0", { font: "100px RoundedElegance", fill: "#551D1D", align: "left" } );
		
		
		collectable = new UIGraphics("Collectable");
		collectable.mySetState("");
		collectable.x = collectable.width *2;
		collectable.y = collectable.height/2;
		txtScore.x = collectable.x + collectable.width;
		
		hudBottomLeft = new Container();
		hudBottomRight = new Container();
		hudTopRight = new Container();
		hudTopLeft = new Container();
			
		// affichage de textes utilisant des polices de caractères chargées	
		
		pause = new MyButton("Btn_II");
		pause.position.set(-pause.width, pause.height-pause.height/2);

		hudTopRight.addChild(pause);
		hudTopLeft.addChild(collectable);
		hudTopLeft.addChild(txtScore);
		
		addChild(hudTopLeft);
		addChild(hudBottomLeft);
		addChild(hudTopRight);
		addChild(hudBottomRight);

		positionables.push({ item:hudTopLeft, align:UIPosition.TOP_LEFT, offsetX:0, offsetY:50});
		positionables.push({ item:hudBottomLeft, align:UIPosition.BOTTOM_LEFT, offsetX:0, offsetY:50});
		positionables.push({ item:hudTopRight, align:UIPosition.TOP_RIGHT, offsetX:200, offsetY:200});
		positionables.push({ item:hudBottomRight, align:UIPosition.BOTTOM_RIGHT, offsetX:200, offsetY:0});
		
		//if (DeviceCapabilities.system != DeviceCapabilities.SYSTEM_DESKTOP) initTouchButton();
		pause.on("click", function(){
			GameManager.getInstance().setPause();
		});
		pause.on(TouchEventType.TAP, function(){
			GameManager.getInstance().setPause();
		});

	}
	
	public function initTouchButton():Void {
	//trace("initbutton");	
		Touch_Left = new MyButton("Touch_Left");
		Touch_Left.x = Touch_Left.width*1.5;
		Touch_Left.y = -Touch_Left.height;
		
		Touch_Right = new MyButton("Touch_Right");
		Touch_Right.x = Touch_Left.x + Touch_Right.width*2;
		Touch_Right.y = -Touch_Right.height;
		
		Touch_Jump = new MyButton("Touch_Jump");
		Touch_Jump.x = -Touch_Left.x + Touch_Jump.width;
		Touch_Jump.y = -Touch_Jump.height -Touch_Jump.height/2;
		
		Touch_Shoot = new MyButton("Touch_Shoot");
		Touch_Shoot.x = -Touch_Right.x + Touch_Jump.width;
		Touch_Shoot.y = -Touch_Shoot.height -Touch_Shoot.height/2;
		
		hudBottomLeft.addChild(Touch_Left);
		hudBottomLeft.addChild(Touch_Right);
		
		hudBottomRight.addChild(Touch_Jump);
		hudBottomRight.addChild(Touch_Shoot);
		
		/* Peut être que ControllerTouch peut gérer */
		/*Touch_Jump.on(TouchEventType.TAP, onTouchJump);
		Touch_Shoot.on(TouchEventType.TAP, onTouchShoot);
		Touch_Left.on(TouchEventType.TAP, onTouchLeft);
		Touch_Right.on(TouchEventType.TAP, onTouchJump);*/
	}
	
	/*private function onTouchJump(pEvent:EventTarget):Void{
		//trace("jump");
	}
	
	private function onTouchShoot(pEvent:EventTarget):Void{
		//trace("shoot");
	}
	
	private function onTouchLeft(pEvent:EventTarget):Void{
		//trace("left");
	}
	
	private function onTouchRight(pEvent:EventTarget):Void{
		//trace("right");
	}*/
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		if (parent != null) parent.removeChild(this);
		removeChildren();
		//super.destroy();
		removeAllListeners();
		instance = null;
		hudTopLeft = null;
		hudBottomLeft = null;
		hudTopRight = null;
		hudBottomRight = null;
	}

}