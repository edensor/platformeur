package com.isartdigital.protoplatformer.game.planes;

import com.isartdigital.protoplatformer.game.level.Camera;
import com.isartdigital.protoplatformer.game.level.LevelManager;
import com.isartdigital.protoplatformer.game.sprites.Background;
import com.isartdigital.protoplatformer.game.sprites.Player;
import com.isartdigital.utils.game.GameObject;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.system.DeviceCapabilities;

/**
 * ...
 * @author ...
 */
class ScrollingPlanes extends GameObject
{

	private var backgroundTab:Array<Background> = new Array<Background>();
	public static var planes:Array<ScrollingPlanes> = new Array<ScrollingPlanes>();
	
	public static inline var BASE_OPAC_SPEED:Float = 0.2;
	
	private var baseSpeed : Float = 0;
	private var reference : GameObject;
	private var WIDTH(default, never):Int = 1218;
	
	public function new(pBackGround:String) 
	{
		super();
		planes.push(this);
		reference = GamePlane.getInstance();
		init(pBackGround);
		
	}
	
	override function setModeNormal():Void 
	{
		super.setModeNormal();
	}
	
	override function doActionNormal():Void 
	{
		super.doActionNormal();
		x = baseSpeed * reference.x;
		////trace(backgroundTab[0]);
		
		/* --------- A CHANGER POUR PARALLAX VERTICAL --------- */
		y = -( LevelManager.getInstance().height - Camera.getInstance().center.height + reference.y)  * ( Camera.getInstance().center.height - height)  * (baseSpeed / BASE_OPAC_SPEED) / (LevelManager.getInstance().height - Camera.getInstance().center.height) +Camera.getInstance().center.height - height ;
		/* --------- A CHANGER POUR PARALLAX VERTICAL --------- */
		if (x+backgroundTab[0].x + WIDTH  <= 0) 
		{
			backgroundTab[0].x = backgroundTab[2].x + WIDTH;
			backgroundTab.push(backgroundTab.shift());
		}
		if (x+backgroundTab[2].x  > WIDTH + GameStage.getInstance().safeZone.width/2) 
		{
			backgroundTab[2].x = backgroundTab[0].x - WIDTH;
			backgroundTab.unshift(backgroundTab.pop());
		}
	}
	
	/**
	 * Function which init background
	 * @param pBackGround, String, type of Background
	 */
	public function init(pBackGround:String):Void
	{
		if(pBackGround == "Opaque"){
			createBackground("BackgroundOpaqueLeft", 0, 0);
			createBackground("BackgroundOpaqueMiddle", WIDTH, 0);
			createBackground("BackgroundOpaqueRight", WIDTH*2, 0);
			baseSpeed = BASE_OPAC_SPEED;
		}
		if (pBackGround == "Transparent"){
			createBackground("BackgroundTransparentLeft", 0, 0);
			createBackground("BackgroundTransparentMiddle", WIDTH, 0);
			createBackground("BackgroundTransparentRight", WIDTH*2, 0);
			baseSpeed = 0.5;
		}
		if (pBackGround == "Transparent1"){
			createBackground("BackgroundTransparent1Left", 0, 0);
			createBackground("BackgroundTransparent1Middle", WIDTH, 0);
			createBackground("BackgroundTransparent1Right", WIDTH*2, 0);
			baseSpeed = 0.4;
		}
		setModeNormal();
	}
	
	/**
	 * Function which create part of Background
	 * @param pAsset, String, name of asset
	 * @param pX, position.x
	 * @param pY, position.y
	 */
	private function createBackground(pAsset:String, pX:Float, pY:Float):Void
	{
		var backGround : Background = new Background(pAsset);
		backgroundTab.push(backGround);
		backGround.x = pX;
		backGround.y = pY;
		backGround.start();
		addChild(backGround);
	}
	
	override public function destroy():Void 
	{
		if (parent != null) parent.removeChild(this);
		planes.remove(this);
		super.destroy();
	}
	
	public static function destroyAll()
	{
		var lLength:Int = planes.length;
		for (i in 0...lLength) 
		{
			planes[lLength - 1 - i].destroy();
		}
	}
	
}