package com.isartdigital.protoplatformer.game.level;
import haxe.Json;
import js.Browser;

/**
 * ...
 * @author Alexandre Le Merrer
 */
class DataManager
{
	public static inline var MAXLVL:Int = 3;
	public static var upgradeDoubleJump : Bool = false;
	public static var upgradeCharge : Bool = false;
	public static var upgradeShield : Bool = false;
	public static var upgradeMagnet : Bool = true;
	public static var currentLevel : Int = -1;
	
	public static var collectibleTotal : Array<Int> = [106, 124, 108];
	
	public static var levelArray: Array<Array <String>> = [for (i in 0...MAXLVL)(new Array<String>())];
	
	private static var save : String ;

	public function new() 
	{
		
	}
	
	/**
	 * Function which update collectable from map of level
	 * @param pLevel, Map<String,Bool>, map collectable taken
	 * @param pArray,Array<Dynamic>, array of taken element
	 */
	public static function updateMap (lvlID : Int, pArray:Array<String>) {
	////trace(lvlID);	
		for (id in pArray){
			if (levelArray[lvlID].indexOf(id) == -1) 
			{
				//trace(id);
				levelArray[lvlID].push(id);
			}
		}
		////trace(pLevel);
	}
	
	/**
	 * Function which save data to Local Storage
	 */
	public static function saveGame(){
		var arrayForJson : Array<Dynamic> = new Array<Dynamic>();
		arrayForJson.push(upgradeDoubleJump);
		arrayForJson.push(upgradeCharge);
		arrayForJson.push(upgradeShield);
		arrayForJson.push(upgradeMagnet);
		for (i in 0...MAXLVL) 
		{
			arrayForJson.push(levelArray[i]);
			////trace(levelArray[i]);
		}
		
		save = Json.stringify(arrayForJson);
		////trace("array",arrayForJson);
		////trace("save",save);
		Browser.getLocalStorage().setItem('save', save);
		Browser.getLocalStorage().getItem('save') != null ;
		
	}
	
	/**
	 * Function which get data from Local Storage
	 */
	public static function getSave():Bool{
		var getSave : Array<Dynamic> = Json.parse(Browser.getLocalStorage().getItem('save'));
		//trace(getSave);
		if (getSave == null) return false;
		upgradeDoubleJump = cast (getSave[0], Bool);
		upgradeCharge = cast (getSave[1], Bool);
		upgradeShield = cast (getSave[2], Bool);
		upgradeMagnet = cast (getSave[3], Bool);
		////trace(upgradeDoubleJump, upgradeCharge, upgradeShield, upgradeMagnet);
		for (i in 0...MAXLVL) 
		{
			levelArray[i] = getSave[4 + i];
			////trace(levelArray[i]);
		}
		return true;
	}
	
}