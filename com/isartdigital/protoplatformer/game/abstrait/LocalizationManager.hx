package com.isartdigital.protoplatformer.game.abstrait;
import com.isartdigital.utils.Config;
import com.isartdigital.utils.loader.GameLoader;
import pixi.core.text.Text;

/**
 * ...
 * @author ...
 */
class LocalizationManager
{

	
	public static var stringListMap : Map<String,String> = new Map<String,String>();
	public static var textListMap : Map<String,Text> = new Map<String,Text>();
	public static var lCurrentLang : String = "en";
	
	public function new() 
	{
		
	}
	
	public static function changeLang():Void{
		var target:String;
		if (lCurrentLang == "fr"){
			target = "source";
			lCurrentLang = "en";
		}
		else {
			target = "target";
			lCurrentLang = "fr";
		}
		var lUrl:Xml = Xml.parse(cast(GameLoader.getXml("main.xlf", "fr"), String));
		for ( user in lUrl.elementsNamed('xliff').next().elements().next().elementsNamed('body').next().elements() ) 
		{
			var str : String = StringTools.replace(user.elementsNamed(target).next().toString(), "<"+target+">", "");
			str = StringTools.replace(str, "</"+target+">", "");
			stringListMap.set(user.get('id'), str);
			if (textListMap.exists(user.get('id'))){
				textListMap.get(user.get('id')).text = str;
			}
		}
	}
	
}