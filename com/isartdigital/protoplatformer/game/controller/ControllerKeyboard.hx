package com.isartdigital.protoplatformer.game.controller;
import com.isartdigital.utils.events.KeyboardEventType;
import com.isartdigital.utils.ui.Keyboard;
import js.Browser;
import js.html.KeyboardEvent;
import js.html.MapElement;

	
/**
 * ...
 * @author 
 */
class ControllerKeyboard extends Controller 
{
	
	/**
	 * instance unique de la classe ControllerKeyboard
	 */
	private static var instance: ControllerKeyboard;
	
	private var keyMap : Map<Int,Bool> = new Map<Int,Bool>();	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): ControllerKeyboard {
		if (instance == null) instance = new ControllerKeyboard();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		super();
		Browser.window.addEventListener(KeyboardEventType.KEY_DOWN, onKeyDown);
		Browser.window.addEventListener(KeyboardEventType.KEY_UP, onKeyUp);
		keyMap.arrayWrite(Keyboard.LEFT, false);
		keyMap.arrayWrite(Keyboard.RIGHT, false);
		keyMap.arrayWrite(Keyboard.UP, false);
		keyMap.arrayWrite(Keyboard.SPACE, false);
		keyMap.arrayWrite(Keyboard.G, false);
		keyMap.arrayWrite(Keyboard.P, false);
		
	}
	
	/**
	 * Function attribute value of keyMap at keyCode to true
	 */
	private function onKeyDown(pEvent:KeyboardEvent):Void
	{
		keyMap[pEvent.keyCode] = true;
	}
	
	/**
	 * Function attribute value of keyMap at keyCode to false
	 */
	private function onKeyUp(pEvent:KeyboardEvent):Void
	{
		keyMap[pEvent.keyCode] = false;
	}
	
	/**
	 * Getter of left
	 * @return value of left
	 */
	override private function get_left():Bool 
	{
		return keyMap[Keyboard.LEFT];
	}
	
	/**
	 * Getter of right
	 * @return value of right
	 */
	override private function get_right():Bool 
	{
		return keyMap[Keyboard.RIGHT];
	}
	
	/**
	 * Getter of jump
	 * @return value of jump
	 */
	override private function get_jump():Bool 
	{
		return keyMap[Keyboard.UP];
	}
	
	/**
	 * Getter of godMode
	 * @return value of godMode
	 */
	override private function get_godMode():Bool 
	{
		return keyMap[Keyboard.G];
	}
	
	/**
	 * Getter of pause
	 * @return value of pause
	 */
	override private function get_pause():Bool 
	{
		return keyMap[Keyboard.P];
	}
	
	/**
	 * Getter of shoot
	 * @return value of shoot
	 */
	override private function get_shoot():Bool 
	{
		return keyMap[Keyboard.SPACE];
	}
	
	/**
	 * destroy unique instance and put ref at null
	 */
	override public function destroy (): Void {
		Browser.window.removeEventListener(KeyboardEventType.KEY_DOWN, onKeyDown);
		Browser.window.removeEventListener(KeyboardEventType.KEY_UP, onKeyUp);
		instance = null;
		super.destroy();
	}

}