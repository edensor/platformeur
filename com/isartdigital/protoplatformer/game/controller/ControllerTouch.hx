package com.isartdigital.protoplatformer.game.controller;
import com.isartdigital.protoplatformer.ui.hud.Hud;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.game.StateGraphic;
import haxe.Constraints.Function;
import js.Browser;
import js.html.TouchEvent;
import js.html.TouchList;

	
/**
 * ...
 * @author 
 */
class ControllerTouch extends Controller 
{
	
	/**
	 * instance unique de la classe ControllerTouch
	 */
	private static var instance: ControllerTouch;
	

	private var touchMap : Map<String,Int> = new Map<String,Int>();
	public var ButtonRight : StateGraphic ;
	public var ButtonLeft : StateGraphic ;
	public var ButtonGodMode : StateGraphic ;
	public var ButtonPause : StateGraphic ;
	public var ButtonJump : StateGraphic ;
	public var ButtonShoot : StateGraphic ;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): ControllerTouch {
		if (instance == null) instance = new ControllerTouch();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		super();
		touchMap.arrayWrite("jump",0);
		touchMap.arrayWrite("left",0);
		touchMap.arrayWrite("right",0);
		touchMap.arrayWrite("shoot",0);
		touchMap.arrayWrite("godMode",0);
		//getButton();
		//
		//ButtonJump.addListener(TouchEventType.TOUCH_START, onTouchStartPerso("jump"));
		//ButtonJump.addListener(TouchEventType.TOUCH_END, onTouchEndPerso("jump"));
		//
		//ButtonRight.addListener(TouchEventType.TOUCH_START, onTouchStartPerso("right"));
		//ButtonRight.addListener(TouchEventType.TOUCH_END, onTouchEndPerso("right"));
		//
		//ButtonLeft.addListener(TouchEventType.TOUCH_START, onTouchStartPerso("left"));
		//ButtonLeft.addListener(TouchEventType.TOUCH_END, onTouchEndPerso("left"));
		//
		//ButtonPause.addListener(TouchEventType.TOUCH_START, onTouchStartPerso("pause"));
		//ButtonPause.addListener(TouchEventType.TOUCH_END, onTouchEndPerso("pause"));
		//
		////ButtonGodMode.addListener(TouchEventType.TOUCH_START, onTouchStartPerso("godMode"));
		////ButtonGodMode.addListener(TouchEventType.TOUCH_END_OUTSIDE, onTouchEndPerso("godMode"));
		//
		//ButtonShoot.addListener(TouchEventType.TOUCH_START, onTouchStartPerso("shoot"));
		//ButtonShoot.addListener(TouchEventType.TOUCH_END, onTouchEndPerso("shoot"));
	}
	
	private function getButton():Void
	{
		Hud.getInstance().initTouchButton();
		ButtonRight = 	Hud.getInstance().Touch_Right ;
		ButtonLeft 	= 	Hud.getInstance().Touch_Left ;
		ButtonPause = 	Hud.getInstance().pause ;
		ButtonJump 	= 	Hud.getInstance().Touch_Jump ;
		ButtonShoot = 	Hud.getInstance().Touch_Shoot ;
	}
	
	public function refreshButton():Void
	{
		if(ButtonJump != null) ButtonJump.removeAllListeners();
		if(ButtonRight != null) ButtonRight.removeAllListeners();
		if(ButtonLeft != null) ButtonLeft.removeAllListeners();
		if(ButtonShoot != null) ButtonShoot.removeAllListeners();
		
		getButton();
		ButtonJump.addListener(TouchEventType.TOUCH_START, onTouchStartPerso("jump"));
		ButtonJump.addListener(TouchEventType.TOUCH_END, onTouchEndPerso("jump"));
		
		ButtonRight.addListener(TouchEventType.TOUCH_START, onTouchStartPerso("right"));
		ButtonRight.addListener(TouchEventType.TOUCH_END, onTouchEndPerso("right"));
		
		ButtonLeft.addListener(TouchEventType.TOUCH_START, onTouchStartPerso("left"));
		ButtonLeft.addListener(TouchEventType.TOUCH_END, onTouchEndPerso("left"));
		
		ButtonShoot.addListener(TouchEventType.TOUCH_START, onTouchStartPerso("shoot"));
		ButtonShoot.addListener(TouchEventType.TOUCH_END, onTouchEndPerso("shoot"));
		
	}
	

	
	private function onTouchStartPerso(pString:String):Dynamic->Void
	{
		return function (pEvent:Dynamic):Void
		{
			touchMap[pString] += 1;
		}
	}
	
	private function onTouchEndPerso(pString:String):Dynamic->Void
	{
		return function (pEvent:Dynamic):Void
		{
			if(touchMap[pString] >0)touchMap[pString] -= 1;
		}
	}
	
	
	
	override private function get_left():Bool 
	{
		return touchMap["left"] > 0;
	}
	
	/**
	 * Getter of right
	 * @return value of right
	 */
	override private function get_right():Bool 
	{
		return touchMap["right"] > 0;
	}
	
	/**
	 * Getter of jump
	 * @return value of jump
	 */
	override private function get_jump():Bool 
	{
		return touchMap["jump"] > 0;
	}
	
	/**
	 * Getter of godMode
	 * @return value of godMode
	 */
	override private function get_godMode():Bool 
	{
		return touchMap["god"] > 0;
	}
	
	/**
	 * Getter of pause
	 * @return value of pause
	 */
	override private function get_pause():Bool 
	{
		return false;
	}
	
	/**
	 * Getter of shoot
	 * @return value of shoot
	 */
	override private function get_shoot():Bool 
	{
		return touchMap["shoot"] > 0;
	}
	
	/**
	 * destroy unique instance and put ref at null
	 */
	override public function destroy (): Void {
		Browser.window.removeEventListener(TouchEventType.TOUCH_START, onTouchStartPerso);
		Browser.window.removeEventListener(TouchEventType.TOUCH_END, onTouchEndPerso);
		instance = null;
		super.destroy();
	}

}