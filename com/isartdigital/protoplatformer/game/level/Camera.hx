package com.isartdigital.protoplatformer.game.level;
import com.isartdigital.protoplatformer.game.level.spawn.Spawn;
import com.isartdigital.protoplatformer.game.planes.GamePlane;
import com.isartdigital.protoplatformer.game.planes.WallContainer;
import com.isartdigital.protoplatformer.game.sprites.Player;
import com.isartdigital.utils.game.CollisionManager;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.system.DeviceCapabilities;
import haxe.ds.Vector;
import pixi.core.display.Container;
import pixi.core.display.DisplayObject;
import pixi.core.math.Point;
import pixi.core.math.shapes.Rectangle;


/**
 * Classe Camera
 * @author Mathieu ANTHOINE
 */
class Camera
{
	
	private var target:DisplayObject;
	private var focus:DisplayObject;
	private var easeMax:Point = new Point(40, 20);
	private var easeMin:Point = new Point(2, 8);
	private var countH:UInt = 0;
	private var delayH:UInt = 120;
	private var countV:UInt = 0;
	private var delayV:UInt = 60;
	
	/**
	 * instance unique de la classe GamePlane
	 */
	private static var instance: Camera;
	
	public var center:Rectangle;
	private var percentX:Float = 0.28;
	private var percentY:Float = 0.25;
	private var percentDeltaX:Float = 0.1;
	private var percentDeltaY:Float = 0.35;
	
	private var modeRight:Bool =  true;
	public var modeDown:Bool =  false;
	
	public var canMoveH = true;
	public var canMoveV = true;
	
	public var power:Bool = false;
	
	public var cellX:Int = 0;
	public var cellY:Int = 0;
	public var cellWidth:Int = 0;
	public var cellHeight:Int = 0;
	private var marginX:Int = 1;
	private var marginY:Int = 1;
	
	
	private var SpawnToRemove:Array<Spawn> = new Array<Spawn>();
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): Camera {
		if (instance == null) instance = new Camera();
		return instance;
	}	
	
	private function new() 
	{
		
	}
	
	/**
	 * Défini la cible de la caméra
	 * @param	pTarget cible
	 */
	public function setTarget (pTarget:DisplayObject):Void {
		target = pTarget;
	}
	
	/**
	 * Défini l'élement à repositionner au centre de l'écran
	 * @param	pFocus focus
	 */
	public function setFocus(pFocus:DisplayObject):Void {
		focus = pFocus;
	}
	
	/**
	 * recadre la caméra
	 * @param	pDelay si false, la caméra est recadrée instantannément
	 */
	private function changePosition (?pDelay:Bool=true) :Void {
		
		countH++;
		countV++;
		
		center = DeviceCapabilities.getScreenRect(target.parent);				
		var lFocus:Point = target.toLocal(focus.position, focus.parent);
		var lEaseX:Float = pDelay ? getEaseX() : 1;
		var lEaseY:Float = pDelay ? getEaseY() : 1;
		
		var lmodeH:Int = modeRight ? -1: 1;
		var lmodeV:Int = modeDown ? -1: 0;
		
		var wallContainer = WallContainer.getInstance();
		
		if (canMoveH){
			var lDeltaX:Float = (center.x + (1 / 2 + lmodeH * percentDeltaX) * center.width - lFocus.x - target.x) / lEaseX;
			target.x+= lDeltaX;
		}
		if (canMoveV) 
		{
			var lDeltaY:Float = (center.y + (1 / 2 + lmodeV * percentDeltaY) * center.height - lFocus.y - target.y) / lEaseY;
			target.y += lDeltaY;
		}
		if (target.x > 0) target.x = 0;
		if (target.x < -(LevelManager.getInstance().width - center.width)) target.x = -(LevelManager.getInstance().width - center.width);
		if (target.y < -(LevelManager.getInstance().height - center.height -180)) target.y = -(LevelManager.getInstance().height - center.height-180);
		if (target.y > 0) target.y = 0;
	}
	
	/**
	 * Function which search all element in cells put them into remove or spawn, Clipping
	 */
	private function manageCells():Void
	{
		var x:Int = Math.floor(-target.x / LevelManager.STEP)-marginX;
		var y:Int = Math.floor(-target.y / LevelManager.STEP)-marginY;
		var width:Int = Math.floor((-target.x + center.width) / LevelManager.STEP)+marginX;
		var height:Int = Math.floor(( -target.y + center.height) / LevelManager.STEP) + marginY;
		if (x < 0) x = 0;
		if (y < 0) y = 0;
		var arrayClipping:Array<Array<Int>> = [[cellX, cellY, cellWidth, cellHeight], [x, y, width, height]];
		
		//for (n in 0...4 ) 
		//{
			//if (arrayClipping[1][n] != arrayClipping[0][n]) {
				//var delta:Int = arrayClipping[1][n] - arrayClipping[0][n];
				//var lmin:Int = Math.floor(Math.min(arrayClipping[1][n], arrayClipping[0][n]));
				//var lmax:Int = Math.floor(Math.max(arrayClipping[1][n], arrayClipping[0][n]));
				//if ((delta)*(n<2 ? 1:-1) < 0) 
				//{
					//
					//for (p in (lmin+((n>2)?1:0))...(lmax+((n>2)?1:0))) 
					//{
						//for (o in arrayClipping[1][(n+1)%2]...arrayClipping[1][(n+1)%2+2]+1) 
						//{
							//var lvlX:Int = (n % 2) * o + (n % 2 + 1) * p;
							//var lvlY:Int = (n % 2 + 1) * o +  (n % 2) * p;
							//var lLength:Int = LevelManager.level[lvlX][lvlY].list.length;
							//for (i in 0...lLength) 
							//{
								//LevelManager.level[lvlX][lvlY].list[i].doSpawn();
							//}
						//}
					//}
				//}
				//else 
				//{
					//for (o in  arrayClipping[1][(n+1)%2]...arrayClipping[1][(n+1)%2+2]+1) 
					//{
						//for (p in (lmin+((n>2)?1:0))...(lmax+((n>2)?1:0))) 
						//{
							//var lvlX:Int = (n % 2) * o + (n % 2 + 1) * p;
							//var lvlY:Int = (n % 2 + 1) * o +  (n % 2) * p;
							//var lLength:Int = LevelManager.level[lvlX][lvlY].list.length;
							//for (i in 0...lLength) 
							//{
								//SpawnToRemove.push(LevelManager.level[lvlX][lvlY].list[i]);
							//}
						//}
					//}
					//for (o in arrayClipping[1][(n+1)%2]...arrayClipping[1][(n+1)%2+2]+1) 
					//{
						//var lvlX:Int = (n % 2) * o + (n % 2 + 1) * lmax;
						//var lvlY:Int = (n % 2 + 1) * o +  (n % 2) * lmax;
						//var lLength:Int = LevelManager.level[lvlX][lvlY].list.length;
						//for (i in 0...lLength) 
						//{
							//while(SpawnToRemove.remove(LevelManager.level[lvlX][lvlY].list[i])){}
						//}
					//}
				//}
			//}
		//}
		
		if (x != cellX) 
		{
			if (x < cellX) 
			{
				for (l in x...cellX) 
				{
					for (k in y...height+1) 
					{
						var lLength = LevelManager.level[l][k].list.length;
						for (i in 0...lLength) 
						{
							LevelManager.level[l][k].list[i].doSpawn();
						}
					}
				}
			}
			else 
			{
				for (k in y...height+1) 
				{
					var lLength:Int;
					for (m in cellX...x) 
					{
						lLength = LevelManager.level[cellX][k].list.length;
						for (i in 0...lLength) 
						{
							SpawnToRemove.push(LevelManager.level[cellX][k].list[i]);
						}
					}
				}
				for (k in y...height+1) 
				{
					var lLength = LevelManager.level[x][k].list.length;
					for (i in 0...lLength) 
					{
						while(SpawnToRemove.remove(LevelManager.level[x][k].list[i])){};
					}
				}
			}
			
		}
		if (y != cellY) 
		{	
			if (y < cellY) 
			{
				for (n in y...cellY) 
				{
					for (k in x...width+1) 
					{
						var lLength = LevelManager.level[k][n].list.length;
						for (i in 0...lLength) 
						{
							LevelManager.level[k][n].list[i].doSpawn();
						}
					}
				}
			}
			else 
			{
				for (k in x...width+1) 
				{
					var lLength = LevelManager.level[k][cellY].list.length;
					for (i in 0...lLength) 
					{
						SpawnToRemove.push(LevelManager.level[k][cellY].list[i]);
					}
				}
				for (k in x...width+1) 
				{
					var lLength = LevelManager.level[k][y].list.length;
					for (i in 0...lLength) 
					{
						while(SpawnToRemove.remove(LevelManager.level[k][y].list[i])){};
					}
				}
			}
			
		}
		if (width != cellWidth) 
		{
			if (width > cellWidth) 
			{
				for (k in y...height+1) 
				{
					var lLength = LevelManager.level[width][k].list.length;
					for (i in 0...lLength) 
					{
						LevelManager.level[width][k].list[i].doSpawn();
					}
				}
			}
			else 
			{
				for (k in y...height+1) 
				{
					var lLength = LevelManager.level[cellWidth][k].list.length;
					for (i in 0...lLength) 
					{
						SpawnToRemove.push(LevelManager.level[cellWidth][k].list[i]);
					}
				}
				for (k in y...height+1) 
				{
					var lLength = LevelManager.level[width][k].list.length;
					for (i in 0...lLength) 
					{
						while(SpawnToRemove.remove(LevelManager.level[width][k].list[i])){};
					}
				}
			}
			
		}
		if (height != cellHeight) 
		{
			if (height > cellHeight) 
			{
				for (k in x...width+1) 
				{
					var lLength = LevelManager.level[k][height].list.length;
					for (i in 0...lLength) 
					{
						LevelManager.level[k][height].list[i].doSpawn();
					}
				}
			}
			else 
			{
				for (k in x...width+1) 
				{
					var lLength = LevelManager.level[k][cellHeight].list.length;
					for (i in 0...lLength) 
					{
						SpawnToRemove.push(LevelManager.level[k][cellHeight].list[i]);
					}
				}
				for (k in x...width+1) 
				{
					var lLength = LevelManager.level[k][height].list.length;
					for (i in 0...lLength) 
					{
						while(SpawnToRemove.remove(LevelManager.level[k][height].list[i])){};
					}
				}
			}
			
		}
		
		//if (Math.abs(cellX - x) > 1)  //trace("clipping Warning");
		//if (Math.abs(cellY - y) > 1)  //trace("clipping Warning");
		//if (Math.abs(cellWidth - width) > 1)  //trace("clipping Warning");
		//if (Math.abs(cellHeight - height) > 1)  //trace("clipping Warning");
		cellX = x;
		cellY = y;
		cellWidth = width;
		cellHeight = height;
		var lLength =  SpawnToRemove.length;
		var lSpawn:Spawn;
		for (j in 0...lLength) 
		{
			lSpawn = SpawnToRemove.pop();
			lSpawn.deSpawn();
		}
	}
	
	/**
	 * retourne une inertie en X variable suivant le temps
	 * @return inertie en X
	 */
	private function getEaseX() : Float {
		if (countH > delayH) return easeMin.x;
		return easeMax.x + (easeMin.x-easeMax.x)*countH/delayH;
	}

	/**
	 * retourne une inertie en Y variable suivant le temps
	 * @return inertie en Y
	 */	
	private function getEaseY() : Float {
		if (countV > delayV) return easeMin.y;
		return easeMax.y + (easeMin.y-easeMax.y)*countV/delayV;
	}
	
	/**
	 * cadre instantannément la caméra sur le focus
	 */
	public function setPosition():Void {
		GameStage.getInstance().render();
		changePosition(false);
	}
	
	/**
	 * cadre la caméra sur le focus avec de l'inertie
	 */
	public function move():Void {
			
			if (power) 
			{
				changePosition();
				manageCells();
				deadZone();
			}
			////trace(modeDown, canMoveV);
	}
	
	/**
	 * remet à zéro le compteur qui fait passer la caméra de l'inertie en X maximum à minimum
	 */
	public function resetX():Void {
		countH = 0;
	}

	/**
	 * remet à zéro le compteur qui fait passer la caméra de l'inertie en Y maximum à minimum
	 */
	public function resetY():Void {
		countV = 0;
	}
	
	
	/**
	 * Function which return if rect is out of camera
	 * @return Bool of intersection of Rect and Camera
	 */
	public function isOut(pRect:Rectangle):Bool
	{
		var lpoint:Point = new Point(pRect.x, pRect.y);
		lpoint = target.parent.toLocal(lpoint);
		pRect.x = lpoint.x;
		pRect.y = lpoint.y;
		return !CollisionManager.getIntersection(pRect, center);
	}
	
	/**
	 * Function which set up deadZone of Camera
	 */
	public function deadZone():Void
	{
		var lRect : Rectangle = new Rectangle(1,1,1,1);
		var lpoint:Point = focus.toGlobal(focus.position);
		lpoint = target.parent.toLocal(lpoint);
		lRect.x = lpoint.x;
		lRect.y = lpoint.y;
		var lDeadZone : Rectangle = center.clone();
		if (modeRight) lDeadZone.x += lDeadZone.width * (1/2 - (percentDeltaX+percentX));
		else lDeadZone.x += lDeadZone.width * (1 / 2 + percentDeltaX);
		
		
		lDeadZone.width *= percentX;
		
		////trace(lRect.x,lDeadZone.x , lDeadZone.x + lDeadZone.width);
		if (lRect.x > lDeadZone.x + lDeadZone.width && !modeRight) 
		{
			modeRight =  true;
			easeMax.x = 9;
			easeMin.x = 3;
			resetX();
		}
		else if (lRect.x < lDeadZone.x && modeRight)
		{
			modeRight =  false;
			easeMax.x = 9;
			easeMin.x = 3;
			resetX();
		}
		
		if (lRect.x < lDeadZone.x || lRect.x > lDeadZone.x + lDeadZone.width) 
		{
			canMoveH = true;
			easeMax.x = 30;
			easeMin.x = 5;
		}
		else canMoveH = false;
		
	}
	
	/**
	 * Function which deSpawn element from clipping
	 */
	public function setOff()
	{
		power = false;
		for (j in cellX...cellWidth+1) 
		{
			for (k in cellY...cellHeight+1) 
			{
				var lLength = LevelManager.level[j][k].list.length;
				for (i in 0...lLength) 
				{
					LevelManager.level[j][k].list[i].deSpawn();
				}
			}
		}
	}
	
	/**
	 * Function which Spawn element from clipping
	 */
	public function setOn()
	{
		power = true;
		canMoveH = true;
		canMoveV = true;
		modeDown = false;
		LevelManager.getInstance().activeContainer.addChild(Player.getInstance());
		setPosition();
		cellX = Math.floor(-target.x / LevelManager.STEP)-marginX;
		cellY = Math.floor(-target.y / LevelManager.STEP)-marginY;
		cellWidth = Math.floor((-target.x + center.width) / LevelManager.STEP)+marginX;
		cellHeight = Math.floor(( -target.y + center.height) / LevelManager.STEP) + marginY;
		if (cellX < 0) cellX = 0;
		if (cellY < 0) cellY = 0;
		for (j in cellX...cellWidth+1) 
		{
			for (k in cellY...cellHeight+1) 
			{
				var lLength = LevelManager.level[j][k].list.length;
				for (i in 0...lLength) 
				{
					LevelManager.level[j][k].list[i].doSpawn();
				}
			}
		}
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void {
		instance = null;
	}
	
}