package com.isartdigital.protoplatformer.ui.screens;

import com.isartdigital.protoplatformer.ui.UIGraphics;
import com.isartdigital.utils.Config;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.ui.Screen;
import pixi.core.sprites.Sprite;
import pixi.core.text.Text;
import pixi.core.textures.Texture;

	
/**
 * ...
 * @author ...
 */
class LevelLoad extends Screen 
{
	
	/**
	 * instance unique de la classe LevelLoad
	 */
	private static var instance: LevelLoad;
	private var loaderBar:UIGraphics;
	private var lBg:UIGraphics ;
	private var text : Text;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): LevelLoad {
		if (instance == null) instance = new LevelLoad();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		SoundManager.getSound("openlvl").play();
		
		super();
		lBg = new UIGraphics("LoadBarre");
		lBg.mySetState("");
		addChild(lBg);
		
		loaderBar = new UIGraphics ("LoadAnim");
		loaderBar.y = -lBg.height;
		loaderBar.x = 2;
		loaderBar.mySetState("");
		addChild(loaderBar);
		
		text = new Text("Loading", { font: "50px MyFontOpNoBold", fill:"#FFFFFF", align:"center"});
		text.anchor.set(0.5, 0.5);
		text.y = height / 4;
		addChild(text);
	}
	
	/**
	 * mise à jour de la barre de chargement
	 * @param	pProgress
	 */
	public function update (pProgress:Float): Void {
		lBg.scale.y = 1 - pProgress;
		loaderBar.y = -lBg.height;
		if (Math.floor(pProgress * 100) < 50) text.text = "Loading Level";
		if (Math.floor(pProgress * 100) > 50 && Math.floor(pProgress * 100) < 80) text.text = "Loading Enemy";
		if (Math.floor(pProgress * 100) > 80 && Math.floor(pProgress * 100) < 90) text.text = "Loading Background";
		if (Math.floor(pProgress * 100) > 90 && Math.floor(pProgress * 100) < 95) text.text = "Loading FX";
		if (Math.floor(pProgress * 100) > 95)text.text = "Have Fun";
		
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
		super.destroy();
	}

}