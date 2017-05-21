package com.isartdigital.protoplatformer.ui.screens;

import com.greensock.TweenMax;
import com.isartdigital.protoplatformer.game.GameManager;
import com.isartdigital.protoplatformer.game.abstrait.LocalizationManager;
import com.isartdigital.protoplatformer.game.level.DataManager;
import com.isartdigital.protoplatformer.game.level.spawn.Spawn;
import com.isartdigital.protoplatformer.ui.MyButton;
import com.isartdigital.protoplatformer.ui.UIGraphics;
import com.isartdigital.protoplatformer.ui.popin.EnteringLevel;
import com.isartdigital.utils.events.LoadEventType;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.game.StateGraphic;
import com.isartdigital.utils.loader.GameLoader;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.system.DeviceCapabilities;
import com.isartdigital.utils.ui.Button;
import com.isartdigital.utils.ui.Screen;
import pixi.core.display.Container;
import pixi.core.display.DisplayObject;
import pixi.core.sprites.Sprite;
import pixi.core.textures.Texture;
import pixi.interaction.EventTarget;

	
/**
 * ...
 * @author 
 */
class LevelSelecter extends Screen 
{
	private var btnTiltleCard:MyButton;
	
	private static inline var NMB_LEVEL:Int = 3;
	
	private var levelArray:Array<MyButton>;
	private var container:DisplayObject = new DisplayObject();
	private var lastLevelSelect : Int;
	private var fond : UIGraphics;
	private var background : UIGraphics;
	private var collectible : UIGraphics;
	private var backgroundTab : Array<UIGraphics> = new Array<UIGraphics>();
	
	/**
	 * instance unique de la classe LevelSelecter
	 */
	private static var instance: LevelSelecter;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): LevelSelecter {
		if (instance == null) instance = new LevelSelecter();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		super();
		
		fond = new UIGraphics("Background_LevelSelection");
		fond.mySetState("");
		addChild(fond);
		
		levelArray = new Array<MyButton>();
		for (i in 0 ... NMB_LEVEL) 
		{
			levelArray.push(new MyButton("BandeLevel"+(i+1),"Level"+(i+1)));
		}
		var tab:Array<Int> = [for (j in 0...NMB_LEVEL) j];
		var id:Int;
		var screenWidth:Float = GameStage.getInstance().getScreensContainer().width;
		var screenHeigth:Float = GameStage.getInstance().getScreensContainer().height;
		var lButton:MyButton;
		for (i in 0 ... NMB_LEVEL) 
		{
			id = tab.splice(Math.floor(Math.random() * tab.length), 1)[0];
			lButton = levelArray[id];
			lButton.width = Screen.WIDTH / NMB_LEVEL;
			lButton.height = Screen.HEIGHT;
			lButton.x = (i) * Screen.WIDTH / NMB_LEVEL - Screen.WIDTH/2;
			lButton.y =  -Screen.HEIGHT*2;
			lButton.setPosText(Screen.WIDTH / NMB_LEVEL / 2, Screen.HEIGHT / 5);
			lButton.setFont("50px RoundedElegance", "#666666");
			lButton.setText(LocalizationManager.stringListMap["Level" + (id + 1)],{ font: "bold 60px RoundedElegance", fill:"#666666", align:"center"});
			
			lButton.addText(DataManager.levelArray[id].length+"/"+DataManager.collectibleTotal[id], lButton.width / 2, lButton.height /2,null,"#666666");
			if (id == 2){
				if (DataManager.upgradeDoubleJump) lButton.addText(LocalizationManager.stringListMap["UpgradeUnlock"], lButton.width / 2.5, lButton.height / 3.5, "UpgradeUnlock","#666666");
				else lButton.addText(LocalizationManager.stringListMap["UpgradeLock"], lButton.width / 2, lButton.height / 3.5 ,"UpgradeLock","#666666");
				
			}
			else if (id == 1 ){
				if (DataManager.upgradeCharge) lButton.addText(LocalizationManager.stringListMap["UpgradeUnlock"], lButton.width / 2, lButton.height / 3.5 ,"UpgradeUnlock","#666666");
				else lButton.addText(LocalizationManager.stringListMap["UpgradeLock"], lButton.width / 2, lButton.height / 3.5 ,"UpgradeLock","#666666");
			}
			else if (id == 0){
				if (DataManager.upgradeShield) lButton.addText(LocalizationManager.stringListMap["UpgradeUnlock"], lButton.width / 2, lButton.height / 3.5 ,"UpgradeUnlock","#666666");
				else lButton.addText(LocalizationManager.stringListMap["UpgradeLock"], lButton.width / 2, lButton.height / 3.5 ,"UpgradeLock","#666666");
			}
			
			collectible = new UIGraphics("Collectable");
			collectible.position.set(lButton.width / 2, lButton.height / 2.5);
			collectible.mySetState("");
			lButton.addChild(collectible);
			addChild(lButton);
			
			if (i != NMB_LEVEL-1) TweenMax.to(levelArray[id], 1, { delay:i * 0.2, y: -Screen.HEIGHT / 2 } );
			else TweenMax.to(levelArray[id], 1, { delay:i * 0.2, y: -Screen.HEIGHT / 2 , onComplete: activeBtn});
			
			////trace(lButton.x, lButton.y,lButton.width, lButton.height);
		}
		
		
		for (i in 4...7)
		{
			background = new UIGraphics("TitleCard_bg_" + i);
			background.mySetState("");
			addChild(background);
			backgroundTab.push(background);
			if (i == 5) untyped background.anim.animationSpeed = 0.5;
			TweenMax.to(background, 1, {y:height / 20});
		}
		btnMenu();
	}
	
	private function activeBtn():Void
	{
		btnTiltleCard.once(MouseEventType.CLICK,onMenu);
		btnTiltleCard.once(TouchEventType.TAP, onMenu);
		var lButton:MyButton;
		for (i in 0...NMB_LEVEL) 
		{
			lButton = levelArray[i];
			
			lButton.on(MouseEventType.CLICK, function(levelId:Int) {
				return function() {
					preloadAssets(levelId); 
				}
			}(i + 1));
			lButton.on(TouchEventType.TAP, function(levelId:Int) {
				return function() {
					preloadAssets(levelId);
				}
			}(i + 1));
		}
	}
	
	private function btnMenu():Void
	{
		btnTiltleCard = new MyButton("Btn_Back"); 
		btnTiltleCard.y = width/4.2; 
		btnTiltleCard.x = height/4;
		btnTiltleCard.scale.x = 1.5;
		btnTiltleCard.scale.y = 1.5;
		addChild(btnTiltleCard);
	}
	
	private function onMenu (pEvent:EventTarget): Void {
		var lButton:MyButton;
		for (i in 0...NMB_LEVEL) 
		{
			lButton = levelArray[i];
			
			lButton.removeAllListeners();
		}
		btnTiltleCard.removeAllListeners();
		for (i in 0...3){
			if(i<2)TweenMax.to(levelArray[i], 1, {delay:i*0.2,y: -Screen.HEIGHT * 2});
			else TweenMax.to(levelArray[i], 1, {delay:i * 0.2, y: -Screen.HEIGHT * 2, onComplete:goToTitleScreen});
			TweenMax.to(backgroundTab[i], 1, {y:0});
		}
	}
	
	private function goToTitleScreen():Void {	
		TweenMax.killAll();
		UIManager.getInstance().openScreen(TitleCard.getInstance());
	}

	private function preloadAssets(levelId:Int):Void {
		lastLevelSelect = levelId;
		var lLoader:GameLoader = new GameLoader();
			lLoader.addAssetFile("black_bg.png");
			lLoader.addAssetFile("preload.png");
			lLoader.addAssetFile("preload_bg.png");
			
			lLoader.once(LoadEventType.COMPLETE, loadAssets);
			lLoader.load();		
	}
	
	private function loadAssets (): Void {

		var lLoader:GameLoader = new GameLoader();
		lLoader.addTxtFile("boxes.json");
		lLoader.addTxtFile("Level" + lastLevelSelect + ".json");
		
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/enemy_fire.json");
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/enemy.json");
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/fx.json");
		
		if (lastLevelSelect <= 2) {
			
			lLoader.addAssetFile(DeviceCapabilities.textureType+"/World1.json");
			lLoader.addAssetFile(DeviceCapabilities.textureType+"/BackgroundOpaque1.json");
			lLoader.addAssetFile(DeviceCapabilities.textureType+"/BackgroundTransparent1.json");
		}
		else {
			
			lLoader.addAssetFile(DeviceCapabilities.textureType+"/World2.json");
			lLoader.addAssetFile(DeviceCapabilities.textureType+"/BackgroundOpaque2.json");
			lLoader.addAssetFile(DeviceCapabilities.textureType+"/BackgroundTransparent2.json");
		}
		
		SoundManager.getSound("titlecard").loop(false);
		SoundManager.getSound("titlecard").stop();
		
		lLoader.on(LoadEventType.PROGRESS, onLoadProgress);
		lLoader.once(LoadEventType.COMPLETE, onLoadComplete);
		// affiche l'écran de préchargement
		UIManager.getInstance().openScreen(LevelLoad.getInstance());
		
		lLoader.load();
		
	}
	
	
	private function onLoadProgress (pLoader:GameLoader): Void {
		LevelLoad.getInstance().update(pLoader.progress/100);
	}
	
	private function onLoadComplete (pLoader:GameLoader): Void {
		pLoader.off(LoadEventType.PROGRESS, onLoadProgress);
		
		StateGraphic.addBoxes(GameLoader.getContent("boxes.json"));
		if (DataManager.currentLevel >=0) 
		{
			if (lastLevelSelect > 2 && DataManager.currentLevel <= 2){
				StateGraphic.clearTextures(GameLoader.getContent(DeviceCapabilities.textureType+"/World2.json"));
				StateGraphic.clearTextures(GameLoader.getContent(DeviceCapabilities.textureType+"/BackgroundOpaque2.json"));
				StateGraphic.clearTextures(GameLoader.getContent(DeviceCapabilities.textureType+"/BackgroundTransparent2.json"));
				StateGraphic.addTextures(GameLoader.getContent(DeviceCapabilities.textureType+"/World1.json"));
				StateGraphic.addTextures(GameLoader.getContent(DeviceCapabilities.textureType+"/BackgroundOpaque1.json"));
				StateGraphic.addTextures(GameLoader.getContent(DeviceCapabilities.textureType+"/BackgroundTransparent1.json"));
			}
			if (lastLevelSelect <= 2 && DataManager.currentLevel > 2){	
				StateGraphic.clearTextures(GameLoader.getContent(DeviceCapabilities.textureType+"/World1.json"));
				StateGraphic.clearTextures(GameLoader.getContent(DeviceCapabilities.textureType+"/BackgroundOpaque1.json"));
				StateGraphic.clearTextures(GameLoader.getContent(DeviceCapabilities.textureType+"/BackgroundTransparent1.json"));
				StateGraphic.addTextures(GameLoader.getContent(DeviceCapabilities.textureType+"/World2.json"));
				StateGraphic.addTextures(GameLoader.getContent(DeviceCapabilities.textureType+"/BackgroundOpaque2.json"));
				StateGraphic.addTextures(GameLoader.getContent(DeviceCapabilities.textureType+"/BackgroundTransparent2.json"));
			}
		}
		else 
		{
			if (lastLevelSelect <= 2  ){
				StateGraphic.addTextures(GameLoader.getContent(DeviceCapabilities.textureType+"/World1.json"));
				StateGraphic.addTextures(GameLoader.getContent(DeviceCapabilities.textureType+"/BackgroundOpaque1.json"));
				StateGraphic.addTextures(GameLoader.getContent(DeviceCapabilities.textureType+"/BackgroundTransparent1.json"));
			}
			if (lastLevelSelect > 2){
				StateGraphic.addTextures(GameLoader.getContent(DeviceCapabilities.textureType+"/World2.json"));
				StateGraphic.addTextures(GameLoader.getContent(DeviceCapabilities.textureType+"/BackgroundOpaque2.json"));
				StateGraphic.addTextures(GameLoader.getContent(DeviceCapabilities.textureType+"/BackgroundTransparent2.json"));
			}
		}
		
		StateGraphic.addTextures(GameLoader.getContent(DeviceCapabilities.textureType+"/enemy.json"));
		StateGraphic.addTextures(GameLoader.getContent(DeviceCapabilities.textureType+"/enemy_fire.json"));
		StateGraphic.addTextures(GameLoader.getContent(DeviceCapabilities.textureType+"/fx.json"));
		
		UIManager.getInstance().closeScreens();
		UIManager.getInstance().openPopin(EnteringLevel.getInstance());
		
		SoundManager.getSound("lvl"+lastLevelSelect).loop(true);
		SoundManager.getSound("lvl"+lastLevelSelect).play();
		
		GameManager.getInstance().start(lastLevelSelect);
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
		//removeChild(btnTiltleCard);
		super.destroy();
		for (i in 0 ... NMB_LEVEL) 
		{
			levelArray.splice(0, 1);
		}
		levelArray = null;
	}

}