package com.isartdigital.protoplatformer.game.level;
import com.isartdigital.protoplatformer.game.level.spawn.SpawnCheckPoint;
import com.isartdigital.protoplatformer.game.level.spawn.SpawnCollectible;
import com.isartdigital.protoplatformer.game.planes.GamePlane;
import com.isartdigital.protoplatformer.game.planes.ScrollingPlanes;
import com.isartdigital.protoplatformer.game.planes.WallContainer;
import com.isartdigital.protoplatformer.game.level.spawn.Spawn;
import com.isartdigital.protoplatformer.game.level.spawn.SpawnKillZoneDynamic;
import com.isartdigital.protoplatformer.game.level.spawn.SpawnPatrol;
import com.isartdigital.protoplatformer.game.sprites.CheckPoint;
import com.isartdigital.protoplatformer.game.sprites.Coin;
import com.isartdigital.protoplatformer.game.abstrait.Collectable;
import com.isartdigital.protoplatformer.game.sprites.EnemyBomb;
import com.isartdigital.protoplatformer.game.sprites.EnemyFire;
import com.isartdigital.protoplatformer.game.sprites.EnemySpeed;
import com.isartdigital.protoplatformer.game.sprites.EnemyTurret;
import com.isartdigital.protoplatformer.game.sprites.KillZoneDynamic;
import com.isartdigital.protoplatformer.game.sprites.KillZoneStatic;
import com.isartdigital.protoplatformer.game.sprites.Player;
import com.isartdigital.protoplatformer.game.sprites.Upgrade;
import com.isartdigital.protoplatformer.ui.UIGraphics;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.game.StateGraphic;
import com.isartdigital.utils.loader.GameLoader;
import haxe.Timer;
import js.Browser;
import pixi.core.display.Container;
import pixi.core.math.shapes.Rectangle;

	
/**
 * ...
 * @author 
 */

 typedef MyData = {
  var x:Float;
  var y:Float;
  var type:String;
  var scaleY :Int;
  var rotation :Int;
  var scaleX : Int;
  var width : Float;
  var height : Float;
}
 
class LevelManager 
{
	
	/**
	 * instance unique de la classe LevelManager
	 */
	private static var instance: LevelManager;
	public var activeContainer : Container = new Container();
	
	private static var sun : UIGraphics = new UIGraphics("Sun");
	private static var tabToAddChild:Array<String> = ["EnemyBomb", "EnemyFire" , "FXEnemyBombShield"];
	private static var toAdd:Container = new Container();
	public var height : Float = 0;
	public var width : Float = 0;
	
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): LevelManager {
		if (instance == null) instance = new LevelManager();
		return instance;
	}
	
	public static var level:Array<Array<Cell>> = null;
	public static var MAXROW:Int = 500;
	public static var MAXCOL:Int = 500;
	public static var STEP:Int = 280;
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
	}
	
	/**
	 * Function which init cell of Level
	 */
	public function initLevel():Void
	{
		if (DataManager.currentLevel < 0) {
			DataManager.getSave();
		}
		else 
		{
			DataManager.getSave();
		}
		level = new Array<Array<Cell>>();
		for (i in 0...MAXROW) 
		{
			level.push(new Array<Cell>());
			for (j in 0...MAXCOL) 
			{
				level[i].push(new Cell());
			}
		}
	}
	
	/**
	 * Function which create level
	 * @param lvlId, Int, lvlId of level
	 */
	public function createLevel(lvlId:Int) : Void {
		initLevel();
		DataManager.currentLevel = lvlId;
		var LD = GameLoader.getContent("Level" + lvlId +".json");
		var instance :MyData ;
		var lSpawner:Spawn = null;
		var url : String;
		var arrayInstance :Array<MyData> = new Array<MyData>();
		for (i in Reflect.fields(LD)) {
			instance = { x:Reflect.field(LD, i).x, y:Reflect.field(LD, i).y, type:Reflect.field(LD, i).type, scaleY:Reflect.field(LD, i).scaleY, rotation:Reflect.field(LD, i).rotation, scaleX:Reflect.field(LD, i).scaleX, width:Reflect.field(LD, i).width, height:Reflect.field(LD, i).height };
			arrayInstance.push(instance);
			////trace(instance.type);
			var lRect:Rectangle = new Rectangle(instance.x, instance.y, instance.width, instance.height);
			
			if (instance.type == "Player") {
				//activeContainer.addChild(Player.getInstance());
				lSpawner = null;
				Player.getInstance().x = instance.x;
				Player.getInstance().y = instance.y;
				Player.getInstance().init(null);
			}
			else {
				if (StringTools.startsWith(instance.type, "Wall") || StringTools.startsWith(instance.type, "Limit") || StringTools.startsWith(instance.type, "Ground") || StringTools.startsWith(instance.type, "Destructible")) {
					lSpawner = new Spawn(instance.type, lRect, WallContainer.getInstance(), i);
					if (StringTools.startsWith(instance.type, "LimitRight")){
						width = instance.x + instance.width;
					}
					if (StringTools.startsWith(instance.type, "Ground")){
						height = instance.y + instance.height;
					}
				}
				if (StringTools.startsWith(instance.type, "KillZoneDynamic")) {
					var llSpawner:SpawnKillZoneDynamic = new SpawnKillZoneDynamic("KillZoneDynamic", lRect, WallContainer.getInstance(), i);
					var type : Int = Std.parseInt(instance.type.charAt(instance.type.length - 1));
					llSpawner.init(type);
					lSpawner =  cast(llSpawner, Spawn);
				}
				if (StringTools.startsWith(instance.type, "Collectable")) {
					var llSpawner:SpawnCollectible = new SpawnCollectible(instance.type, lRect, activeContainer, i);
					var lGhost:Bool = DataManager.levelArray[lvlId-1].indexOf(i) != -1;
					//trace(lGhost);
					llSpawner.initCollectible(lGhost);
					lSpawner =  cast(llSpawner, Spawn);
				}
				if (StringTools.startsWith(instance.type, "Upgrade")) {
					lSpawner = new Spawn(instance.type, lRect, activeContainer, i);
				}
				if (StringTools.startsWith(instance.type, "CheckPoint")) {
					var llSpawner = new SpawnCheckPoint(instance.type, lRect, activeContainer, i);
					lSpawner =  cast(llSpawner, Spawn);
				}
				if (StringTools.startsWith(instance.type, "KillZoneStatic")) {
					lSpawner = new Spawn(instance.type, lRect, activeContainer, i);
				}
				if (StringTools.startsWith(instance.type, "Platform") || StringTools.startsWith(instance.type, "Bridge")) {
					 lSpawner = new Spawn(instance.type, lRect, WallContainer.getInstance(), i);
				}
				if (StringTools.startsWith(instance.type, "Enemy")) {
					if (StringTools.startsWith(instance.type, "EnemyTurret")) {
						lSpawner = new Spawn(instance.type, lRect, WallContainer.getInstance(), i);
					}
					else 
					{
						var llSpawner:SpawnPatrol = new SpawnPatrol(instance.type, lRect, activeContainer, i);
						lSpawner =  cast(llSpawner, Spawn);
					}
				}
			}
			var x:Int = Math.floor(instance.x / STEP);
			var y:Int = Math.floor(instance.y / STEP);
			var width:Int = Math.floor((instance.x + instance.width) / STEP);
			var height:Int = Math.floor((instance.y + instance.height) / STEP);
			if (lSpawner != null) 
			{
				for (j in x...width+1) 
				{
					for (k in y...height+1) 
					{
						////trace(j,k);
						level[j][k].add(lSpawner);
					}
				}
				//if (StringTools.startsWith(lSpawner.type, "Limit")) 
				//{
					////lSpawner.doSpawn();
				//}
			}
		}
		
		var backgroundOpaque : ScrollingPlanes = new ScrollingPlanes("Opaque");
		var backgroundTransparent : ScrollingPlanes = new ScrollingPlanes("Transparent");
		var backgroundTransparent1 : ScrollingPlanes = new ScrollingPlanes("Transparent1");
		
		backgroundOpaque.start();
		backgroundTransparent.start();
		backgroundTransparent1.start();
		
		sun.mySetState("");
		GamePlane.getInstance().parent.addChildAt(sun, 0);
		
		if (lvlId % 2 == 1){
			sun.y = GameStage.getInstance().safeZone.height / 5;
			sun.x = (lvlId-1)/2*(GameStage.getInstance().safeZone.width-sun.width);
		}
		else {
			sun.x = GameStage.getInstance().safeZone.width / 2 - sun.width / 2;
			sun.y = 0;
		}
		GamePlane.getInstance().parent.addChildAt(backgroundTransparent1,0);
		GamePlane.getInstance().parent.addChildAt(backgroundTransparent,0);
		GamePlane.getInstance().parent.addChildAt(backgroundOpaque,0);
		GamePlane.getInstance().addChild(WallContainer.getInstance());
		GamePlane.getInstance().addChild(activeContainer);
		//trace("levelManager");
		
		for (l in tabToAddChild) 
		{
			var lsprite:UIGraphics = new UIGraphics("EnemyBomb");
			lsprite.mySetState("wait", false);
			toAdd.addChild(lsprite);
			lsprite = new UIGraphics("EnemyFire");
			lsprite.mySetState("wait", false);
			toAdd.addChild(lsprite);
			lsprite = new UIGraphics("FXEnemyBombShield");
			lsprite.mySetState("", false);
			toAdd.addChild(lsprite);
			GamePlane.getInstance().addChild(toAdd);
			Timer.delay(removeNeed, 1);
		}
	}
	
	private function removeNeed():Void
	{
		GamePlane.getInstance().removeChild(toAdd);
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void {
		instance = null;
		GamePlane.getInstance().parent.removeChild(sun);
		Spawn.destroyNeededSpawn();
		for (i in 0...MAXROW) 
		{
			for (j in 0...MAXCOL) 
			{
				level[i][j].destroy();
			}
		}
		PoolManager.clearNeeded();
		
		for (i in 0...ScrollingPlanes.planes.length){
			//GamePlane.getInstance().parent.removeChildAt(0);
			ScrollingPlanes.planes.splice(i, 1);
		}
		level = null;
	}

}