package com.isartdigital.protoplatformer.game;


import com.greensock.TweenMax;
import com.isartdigital.protoplatformer.game.abstrait.PlateForm;
import com.isartdigital.protoplatformer.game.abstrait.Wall;
import com.isartdigital.protoplatformer.game.level.Camera;
import com.isartdigital.protoplatformer.game.abstrait.Enemy;
import com.isartdigital.protoplatformer.game.level.DataManager;
import com.isartdigital.protoplatformer.game.level.LevelManager;
import com.isartdigital.protoplatformer.game.abstrait.Shoot;
import com.isartdigital.protoplatformer.game.level.spawn.SpawnCollectible;
import com.isartdigital.protoplatformer.game.planes.GamePlane;
import com.isartdigital.protoplatformer.game.planes.ScrollingPlanes;
import com.isartdigital.protoplatformer.game.sprites.CheckPoint;
import com.isartdigital.protoplatformer.game.sprites.Player;
import com.isartdigital.protoplatformer.game.abstrait.Collectable;
import com.isartdigital.protoplatformer.game.sprites.Destructible;
import com.isartdigital.protoplatformer.game.sprites.EnemyBomb;
import com.isartdigital.protoplatformer.game.sprites.EnemyFire;
import com.isartdigital.protoplatformer.game.sprites.EnemySpeed;
import com.isartdigital.protoplatformer.game.sprites.EnemyTurret;
import com.isartdigital.protoplatformer.game.sprites.KillZoneStatic;
import com.isartdigital.protoplatformer.game.sprites.KillZoneDynamic;
import com.isartdigital.protoplatformer.ui.CheatPanel;
import com.isartdigital.protoplatformer.ui.hud.Hud;
import com.isartdigital.protoplatformer.ui.popin.Confirm;
import com.isartdigital.protoplatformer.ui.popin.EnteringLevel;
import com.isartdigital.protoplatformer.ui.popin.Pause;
import com.isartdigital.protoplatformer.ui.popin.WinLevel;
import com.isartdigital.protoplatformer.ui.screens.TitleCard;
import com.isartdigital.protoplatformer.ui.UIManager;
import com.isartdigital.utils.events.EventType;
import com.isartdigital.utils.game.CollisionManager;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.game.StateGraphic;
import com.isartdigital.utils.loader.GameLoader;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.system.DeviceCapabilities;
import haxe.Json;
import js.Browser;
import js.html.KeyboardEvent;
import pixi.interaction.EventTarget;
import pixi.interaction.InteractionManager;

/**
 * Manager (Singleton) en charge de gérer le déroulement d'une partie
 * @author Mathieu ANTHOINE
 */

 
class GameManager
{
	
	/**
	 * instance unique de la classe GameManager
	 */
	private static var instance: GameManager;
	public var win :Bool = false;
	public var currentLvl:Int = 0;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): GameManager {
		if (instance == null) instance = new GameManager();
		return instance;
	}
	
	private function new() 
	{
		
	}
	
	/**
	 * Function which start level
	 * @param lvlId, number of Level
	 */
	public function start (lvlId:Int): Void {
		//Shoot.list.length,
		//Enemy.list.length,
		//Collectable.list.length,
		//KillZoneDynamic.list.length,
		//PlateForm.list.length,
		//CheckPoint.list.length,
		//KillZoneStatic.list.length
		//);
		currentLvl = lvlId;
		// demande au Manager d'interface de se mettre en mode "jeu"
		UIManager.getInstance().startGame();
		GameStage.getInstance().getGameContainer().addChild(GamePlane.getInstance());
		
		// début de l'initialisation du jeu
		
		GamePlane.getInstance().start();
		
		LevelManager.getInstance().createLevel(lvlId);
		
		Camera.getInstance().setTarget(GamePlane.getInstance());
		Camera.getInstance().setPosition();
		CheatPanel.getInstance().ingame();	
		CheatPanel.getInstance().setCamera();
		
		Collectable.target =  Player.getInstance();
		
		Camera.getInstance().setOn();
		
		// enregistre le GameManager en tant qu'écouteur de la gameloop principale
		Main.getInstance().on(EventType.GAME_LOOP, gameLoop);
	}
	
	/**
	 * boucle de jeu (répétée à la cadence du jeu en fps)
	 */
	public function gameLoop (pEvent:EventTarget): Void {
		// le renderer possède une propriété plugins qui contient une propriété interaction de type InteractionManager
		// les instances d'InteractionManager fournissent un certain nombre d'informations comme les coordonnées globales de la souris
		//if (DeviceCapabilities.system==DeviceCapabilities.SYSTEM_DESKTOP) trace (CollisionManager.hitTestPoint(Template.getInstance().hitBox, cast(Main.getInstance().renderer.plugins.interaction,InteractionManager).mouse.global));
		Player.getInstance().doAction();
		for (lShoot in Shoot.list) 
		{
			lShoot.doAction();
		}
		for (lEnemy in Enemy.list) 
		{
			lEnemy.doAction();
		}
		for (lCollectable in Collectable.list) 
		{
			lCollectable.doAction();
		}
		
		for (lKillZoneD in KillZoneDynamic.list) 
		{
			lKillZoneD.doAction();
		}
		
		for (lPlanes in ScrollingPlanes.planes) 
		{
			lPlanes.doAction();
		}
		
		for (lCheckPont in CheckPoint.list) 
		{
			lCheckPont.doAction();
		}
		
		for (lWall in Wall.list) 
		{
			lWall.doAction();
		}
		
		Camera.getInstance().move();
		if (win) checkWin();
	}
	
	
	/**
	 * Function which set Pause
	 */
	public function setPause(){
		Main.getInstance().off(EventType.GAME_LOOP, gameLoop);
		SoundManager.getSound("lvl" + currentLvl).loop(false);
		SoundManager.getSound("lvl" + currentLvl).stop();
		UIManager.getInstance().openPopin(Pause.getInstance());
	}
	
	public function cutGameLoop():Void{
		Main.getInstance().off(EventType.GAME_LOOP, gameLoop);
	}
	
	/**
	 * Function which resume game
	 */
	public function resume() {
		Main.getInstance().on(EventType.GAME_LOOP, gameLoop);
		
		SoundManager.getSound("lvl" + currentLvl).loop(true);
		SoundManager.getSound("lvl" + currentLvl).play();
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void {
		
		SoundManager.getSound("lvl" + currentLvl).loop(false);
		SoundManager.getSound("lvl" + currentLvl).stop();
		
		Main.getInstance().off(EventType.GAME_LOOP, gameLoop);
		Shoot.destroyAll();
		Enemy.destroyAll();
		Collectable.destroyAll();
		KillZoneDynamic.destroyAll();
		ScrollingPlanes.destroyAll();
		CheckPoint.destroyAll();
		Wall.destroyAll();
		KillZoneStatic.destroyAll();
		PlateForm.destroyAll();
		Hud.getInstance().destroy();
		instance = null;
		CheatPanel.getInstance().destroy();
		Camera.getInstance().destroy();
		LevelManager.getInstance().destroy();
	}
	
	/**
	 * Function which start winLevel
	 */
	public function checkWin () : Void {
		
		SoundManager.getSound("lvl" + currentLvl).loop(false);
		SoundManager.getSound("lvl" + currentLvl).stop();
		
		UIManager.getInstance().openPopin(WinLevel.getInstance());
		DataManager.updateMap(currentLvl-1,SpawnCollectible.lisToSave);
		DataManager.saveGame();
		SpawnCollectible.lisToSave = new Array<String>();
		win = false;
	}

}