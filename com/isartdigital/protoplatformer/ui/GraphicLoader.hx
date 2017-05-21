package com.isartdigital.protoplatformer.ui;

import com.greensock.TweenMax;
import com.isartdigital.utils.Config;
import com.isartdigital.utils.ui.Screen;
import pixi.core.graphics.Graphics;
import pixi.core.sprites.Sprite;
import pixi.core.text.Text;
import pixi.core.textures.Texture;

/**
 * Preloader Graphique principal
 * @author Mathieu ANTHOINE
 */
class GraphicLoader extends Screen 
{
	
	/**
	 * instance unique de la classe GraphicLoader
	 */
	private static var instance: GraphicLoader;

	private var loaderTxt:Text;
	private var loaderTest:Sprite;

	public function new() 
	{
		super();
		loaderTxt = new Text("0%", { font: "100px RoundedElegance", fill:"#FFFFFF", align:"center"});
		addChild(loaderTxt);
		loaderTxt.anchor.set(0.5, 0.5);
		loaderTest = new Sprite();
		var lCircle : Graphics = new Graphics();
		lCircle.beginFill(0xFFFFFF);
		lCircle.drawCircle(0, 300, 50);
		lCircle.endFill();
		loaderTest.addChild(lCircle);
		loaderTest.anchor.set(300, 0);
		addChild(loaderTest);
		
		var lTween : TweenMax = new TweenMax(loaderTest, 2, {rotation:6.28319,repeat:-1});
	}
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): GraphicLoader {
		if (instance == null) instance = new GraphicLoader();
		return instance;
	}
	
	/**
	 * mise à jour de la barre de chargement
	 * @param	pProgress
	 */
	public function update (pProgress:Float): Void {
		loaderTxt.text = Math.floor(pProgress*100)+"%";
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
		super.destroy();
	}

}