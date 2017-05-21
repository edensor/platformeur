package com.isartdigital.protoplatformer.game.controller;

/**
 * ...
 * @author 
 */
class Controller
{
	public var left(get, null) : Bool;
	public var right(get, null) : Bool;
	public var jump(get, null) : Bool;
	public var shoot(get, null) : Bool;
	public var pause(get, null) : Bool;
	public var godMode(get, null) : Bool;


	public function new() 
	{
		
	}
	
	/**
	 * Getter of left
	 * @return value of left
	 */
	private function get_left() : Bool{
		return left;
	}
	
	/**
	 * Getter of right
	 * @return value of right
	 */
	private function get_right() : Bool{
		return right;
	}
	
	/**
	 * Getter of jump
	 * @return value of jump
	 */
	private function get_jump() : Bool{
		return jump;
	}
	
	/**
	 * Getter of shoot
	 * @return value of shoot
	 */
	private function get_shoot() : Bool{
		return shoot;
	}
	
	/**
	 * Getter of pause
	 * @return value of pause
	 */
	private function get_pause() : Bool{
		return pause;
	}
	
	/**
	 * Getter of godMode
	 * @return value of godMode
	 */
	private function get_godMode() : Bool{
		return godMode;
	}
	
	/**
	 * destroy unique instance and put ref at null
	 */
	public function destroy ():Void {
		
	}
	
}