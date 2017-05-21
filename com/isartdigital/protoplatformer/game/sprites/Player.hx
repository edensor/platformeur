package com.isartdigital.protoplatformer.game.sprites;

import com.isartdigital.protoplatformer.game.abstrait.Collectable;
import com.isartdigital.protoplatformer.game.controller.ControllerTouch;
import com.isartdigital.protoplatformer.game.level.DataManager;
import com.isartdigital.protoplatformer.game.level.PoolObject;
import com.isartdigital.protoplatformer.game.level.Camera;
import com.isartdigital.protoplatformer.game.abstrait.Enemy;
import com.isartdigital.protoplatformer.game.abstrait.Gun;
import com.isartdigital.protoplatformer.game.abstrait.Mobile;
import com.isartdigital.protoplatformer.game.abstrait.PlateForm;
import com.isartdigital.protoplatformer.game.abstrait.ShargeGun;
import com.isartdigital.protoplatformer.game.abstrait.Shoot;
import com.isartdigital.protoplatformer.game.abstrait.Wall;
import com.isartdigital.protoplatformer.game.controller.Controller;
import com.isartdigital.protoplatformer.game.controller.ControllerKeyboard;
import com.isartdigital.protoplatformer.game.level.spawn.Spawn;
import com.isartdigital.protoplatformer.game.planes.GamePlane;
import com.isartdigital.protoplatformer.ui.UIGraphics;
import com.isartdigital.protoplatformer.ui.UIManager;
import com.isartdigital.protoplatformer.ui.hud.Hud;
import com.isartdigital.protoplatformer.ui.popin.TransiDead;
import com.isartdigital.protoplatformer.ui.popin.WinLevel;
import com.isartdigital.utils.game.CollisionManager;
import com.isartdigital.utils.game.StateGraphic;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.system.DeviceCapabilities;
import com.isartdigital.utils.ui.Keyboard;
import haxe.ds.Vector;
import js.Browser;
import js.html.KeyboardEvent;
import pixi.core.display.Container;
import pixi.core.math.Point;
import pixi.core.math.shapes.Rectangle;
import pixi.core.sprites.Sprite;
import pixi.extras.MovieClip;

	
/**
 * ...
 * @author 
 */
class Player extends Mobile 
{
	
	/**
	 * instance unique de la classe Player
	 */
	private static var instance: Player;
	private var controller : Controller;
	
	private var WAIT_STATE(default, never):String = "wait";
	private var JUMP_STATE(default, never):String = "jump";
	private var FALL_STATE(default, never):String = "fall";
	private var RECEPTION_STATE(default, never):String = "reception";
	private var WALK_STATE(default, never):String = "walk";
	private var HURT_STATE(default, never):String = "hurt";
	
	private var POINT_BOTTOM(default, never):String = "mcBottom";
	private var POINT_TOP(default, never):String = "mcTop";
	private var POINT_FRONT(default, never):String = "mcFront";
	private var POINT_BACK(default, never):String = "mcBack";
	private var POINT_SHOOT(default, never):String = "mcShoot";
	private var POINT_CAMERA(default, never):String = "mcCamera";
	private var FRAME_INVINCIBLITY(default, never):Int = 60;
	private var STEPY(default, never):Int = 280;
	
	private var frictionGround (default, never):Float = 0.75;
	private var accelerationGround (default, never):Float = 8;
	private var frictionAir (default, never):Float = 0.95;
	private var gravity (default, never):Float = 4.6;
	private var accelerationAir (default, never):Float = 1.2;
	private var impulse (default, never):Float = 11;
	private var impulseDuration (default, never):UInt = 7;
	private var impulseConter:UInt = 0;
	
	private var doubleJump :Bool = false;
	private var isInDoubleJump:Int = 0;
	
	private var chargeShoot :Bool = false;
	private var hasSheildPower :Bool = false;
	
	private var shield : Bool = false;
	private var shieldObject : Shield ;
	private var countShield : Int = 0;
	
	public var godMode : Bool = false;
	
	private var floor:Array<StateGraphic>;
	private var wall:Array<StateGraphic>;
	
	private var ActionShoot:Void->Void;
	private var speedShoot(default, never):Float = 75;
	private var fireRate(default, never):Int = 20;
	private var myGun:Gun;
	private var myCount:Int = 0;
	private var myCountInvincibility:Int = 0;
	private var myState:String;
	
	private var score : Int = 0;
	private var safeScore : Int = 0;
	
	private var lastY:Array<Float> = [0,0];
	public var startPoint:Point = new Point();
	public var iPressShoot:Bool = false;
	
	private var lastTimeIJump:Int = 0;
	private var boolFollow:Bool = false;
	private var iJustJump:Bool = false;
	
	private var arm : UIGraphics ;
	
	private var arrayArticulation:Map<String,Array<Array<Float>>> = new Map<String,Array<Array<Float>>>();
	
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): Player {
		if (instance == null) instance = new Player();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		super("Player");
		if (DeviceCapabilities.system != DeviceCapabilities.SYSTEM_DESKTOP) controller = cast(ControllerTouch.getInstance(), Controller);
		else controller = cast(ControllerKeyboard.getInstance(), Controller);
		start();
		MaxHSpeed = 20;
		MaxVSpeed = 44;
		shieldObject = new Shield("FXShield");
		shieldObject.start();
		arrayArticulation[WAIT_STATE] =  [[ -15, -169.2], [ -15, -169.2], [ -15, -169.4], [ -15, -169.6], [ -15, -169.85], [ -15, -170.05], [ -15, -170.25], [ -15, -170.45], [ -15, -170.65], [ -15, -170.9], [ -15, -171.1], [ -15, -171.3], [ -15, -171.5], [ -15, -171.7], [ -15, -171.9], [ -15, -172.15], [ -15, -172.35], [ -15, -172.55], [ -15, -172.75], [ -15, -172.95], [ -15, -173.2], [ -15, -173.4], [ -15, -173.6], [ -15, -173.35], [ -15, -173.15], [ -15, -172.9], [ -15, -172.65], [ -15, -172.45], [ -15, -172.2], [ -15.0, -172], [ -15, -171.75], [ -15, -171.5], [ -15, -171.3], [ -15, -171.05], [ -15, -170.8], [ -15, -170.6], [ -15, -170.35], [ -15, -170.15], [ -15, -169.9], [ -15, -169.65], [ -15, -169.45]];
		arrayArticulation[JUMP_STATE] =  [[3.5, -202.7], [3.5, -202.7], [3.5, -202.7], [3.5, -202.7]];
		arrayArticulation[WALK_STATE] =  [[ -20.6, -162], [ -20.6, -162], [ -20.6, -162], [ -20.05, -161.95], [ -20.05, -161.95], [ -9.55, -160.25], [ -9.55, -160.25], [ -9.55, -160.25], [ -9.55, -160.25], [2.5, -173.85], [2.5, -173.85], [2, -174.4], [2, -174.4], [11.05, -183.15], [11.05, -183.15], [10.55, -181.6], [10.55, -181.6], [2.85, -188.05], [2.85, -188.05], [2.3, -188], [2.3, -188], [ -15.1, -164.2], [ -15.1, -164.2], [ -15.1, -164.75], [ -15.1, -164.75], [4.7, -162.05], [4.7, -162.05], [4.7, -162], [4.7, -162], [15.55, -171.45], [15.55, -171.45], [16.55, -170.95], [16.55, -170.95], [18.15, -189.2], [18.15, -189.2], [18.15, -189.7], [18.15, -189.7], [10.9, -190.2], [10.9, -190.2], [11.4, -190.2]];
		arrayArticulation[RECEPTION_STATE] =  [[ -31.3, -125.9], [ -31.3, -125.9], [ -31.3, -125.9], [ -31.3, -125.9], [ -31.3, -125.9]];
		arrayArticulation[FALL_STATE] = [[ -29.45, -206.7], [ -29.45, -206.7], [ -29.45, -206.7], [ -29.45, -206.7], [ -29.45, -206.7], [ -29.45, -206.7]];
		arm = new UIGraphics("PlayerArm");
		addChild(arm);
		doubleJump =  DataManager.upgradeDoubleJump;
		hasSheildPower = DataManager.upgradeShield;
		chargeShoot = DataManager.upgradeCharge;
	}
	/**
	 * Initialisation
	 * @param	pSpawner
	 */
	override public function init(pSpawner:Spawn):Void 
	{
		super.init(null);
		if (DeviceCapabilities.system != DeviceCapabilities.SYSTEM_DESKTOP) cast(ControllerTouch.getInstance(), ControllerTouch).refreshButton();
		myGun =  new Gun(Shoot.PLAYER_SHOOT_NORMAL, 1, speedShoot, 1, false);
		ShootGestion = chargeShoot ? manageChargeGun : manageNormalGun;
		upgradeShoot();
		floor = [null,null];
		wall = [null, null];
		arm.setModeWait();
		CheckPoint.lastCheckPointActivate.set(0, 0);
		myCountInvincibility = FRAME_INVINCIBLITY;
	}
	
	override public function start():Void 
	{
		super.start();
		Camera.getInstance().setFocus(box.getChildByName(POINT_CAMERA));
		lastY[0] = y;
		startPoint.set(x, y - 20);
		anim.animationSpeed = 1;
	}
	
	override private function setModeNormal():Void 
	{
		Camera.getInstance().resetX();
		setState(WAIT_STATE, true);
		super.setModeNormal();
		velocity.set(0, 0);
		Camera.getInstance().canMoveV = true;
		//Camera.getInstance().canMoveH = true;
	}
	
	private function setModeWait():Void
	{
		setState(WAIT_STATE, true);
		velocity.set(0, 0);
		arm.setModeWait();
		super.setModeNormal();
		Camera.getInstance().canMoveV = true;
	}
	
	override private function doActionNormal():Void 
	{
		if ((controller.left && (scale.x == 1 || canWalk(POINT_FRONT))) || (controller.right && (scale.x == -1 || canWalk(POINT_FRONT))))
		{
			setModeWalk();
		}
		if (iUseJump() && canJump()) 
		{
			setModeJump();
		}
		if (canFall()) 
		{
			isInDoubleJump == 1;
			setModeFall();
		}
		
		ShootGestion();
		myCount++;
		collisionCoin();
		getHurt();
		
	}
	
	private function setModeWalk ():Void {
		doAction = doActionWalk;
		setState(WALK_STATE, true);
		friction.set(frictionGround, 0);
		if (controller.left) flipLeft();
		if (controller.right) flipRight();
		arm.setModeWalk();
		
	}
	
	private function doActionWalk():Void {
		if (controller.left) 
		{
			acceleration.x =  -accelerationGround;
			flipLeft();
		}
		else if (controller.right) 
		{
			acceleration.x = accelerationGround;
			flipRight();
		}
		
		if (Math.abs(velocity.x) <= 1) 
		{
			setModeWait();
		}
		
		if (iUseJump() && canJump()) 
		{
			setModeJump();
		}
		
		if (canFall()) 
		{
			setModeFall();
		}
		
		ShootGestion();
		myCount++;
		collisionCoin();
		move();
	}
	
	private function setModeJump (): Void {
		SoundManager.getSound("jump").play();
		doAction = doActionJump;
		setState(JUMP_STATE, false);
		friction.set(frictionAir, frictionAir);
		impulseConter = 0;
		isInDoubleJump = 0;
		velocity.y = -impulse * 2;
		var currentFrame = Main.getInstance().frames;
		boolFollow = (lastY[0] < lastY[1] && currentFrame - lastTimeIJump < 60);
		lastTimeIJump = currentFrame;
		Camera.getInstance().canMoveV = false;
		arm.setModeJump();
	}
	
	private function setModeDoubleJump (): Void {
		SoundManager.getSound("jump").play();
		doAction = doActionJump;
		friction.set(frictionAir, frictionAir);
		impulseConter = 0;
		isInDoubleJump = -1;
		velocity.y = -impulse * 2;
		arm.setModeJump();
	}
	
	private function doActionJump():Void {
		if (controller.jump) 
		{
			
			impulseConter ++;
			if (impulseConter < impulseDuration) 
			{
				acceleration.y = -impulse;
			}
			
			if (doubleJump && isInDoubleJump == 1) 
			{
				setModeDoubleJump();
			}
			if (isInDoubleJump ==  -1 || boolFollow) 
			{
				Camera.getInstance().canMoveV = true;
			}
			else 
			{
				Camera.getInstance().canMoveV = false;
			}
		}
		else 
		{
			impulseConter = impulseDuration;
			if (isInDoubleJump == 0) 
			{
				isInDoubleJump = 1;
			}
		}
		
		if (velocity.y > 0) 
		{
			setModeFall();
		}
		else {
			var lCeil:StateGraphic = testPoint(Wall.list, get_Point(POINT_TOP));
			if (lCeil != null) 
				{
					velocity.y = 0;
					acceleration.y = 0;
					//y = lCeil.hitBox.height + hitBox.height;
					setModeFall();
				}
		}
		airControl();
	}
	
	private function setModeFall ():Void {
		setState(FALL_STATE, false);
		doAction = doActionFall;
		friction.set(frictionAir, frictionAir);
		Camera.getInstance().canMoveV = false;
		Camera.getInstance().resetY();
		arm.setModeFall();
	}
	
	private function doActionFall():Void {
		airControl();
		
		var other:String = "";
		for (i in 0...floor.length) 
		{
			if (i == 1) other = "Over";
			if (hitFLoor(i,get_Point(POINT_BOTTOM + other))) 
			{
				setModeReception();
				
				break;
			}
		}
		if (doubleJump && controller.jump) {
			if (isInDoubleJump == 1) 
			{
				setModeDoubleJump();
			}
		}
		else 
		{
			if (isInDoubleJump == 0) 
			{
				isInDoubleJump = 1;
			}
		}
		
		if (y > lastY[0]+ STEPY) 
		{
			Camera.getInstance().modeDown =  true;
			Camera.getInstance().canMoveV = true;
		}
	}
	
	private function setModeReception():Void {
		setState(RECEPTION_STATE, false);
		doAction = doActionReception;
		velocity.y = 0;
		isInDoubleJump = 0;
		lastY[1] = lastY[0];
		lastY[0] = y + 50;
		Camera.getInstance().modeDown =  false;
		Camera.getInstance().resetY();
		arm.setModeReception();
	}
	
	private function doActionReception ():Void {
		doActionNormal();
		Camera.getInstance().canMoveV = true;
		if (isAnimEnd) {
			setModeWait();
		}
	}
	
	private function setModeShoot():Void
	{
		if (doAction != doActionShoot) 
		{
			myState = state;
			ActionShoot = doAction;
		}
		
		doAction = doActionShoot;
		setState(myState);
		arm.setModeShoot();
		myGun.doShoot(GamePlane.getInstance().toLocal(get_Point(POINT_SHOOT)), 0);
		
		var random:Float = Math.random(); 
		
		if (random >= 0 && random < 0.33)
		{
			SoundManager.getSound("player_shoot1").play();
		}
		else if (random >= 0.33 && random < 0.66)
		{
			SoundManager.getSound("player_shoot2").play();
		}
		else if (random >= 0.66 && random < 1.0)
		{
			SoundManager.getSound("player_shoot3").play();
		}
	}
	
	private function doActionShoot():Void
	{
		ActionShoot();
		if (arm.isAnimEnd) 
		{
			arm.lastState();
		}
	}
	
	/**
	 * Function which give control in fallState and JumpState
	 */
	private function airControl():Void
	{
		acceleration.y += gravity;
		if (controller.left)
		{
			acceleration.x = -accelerationAir;
			flipLeft();
		}
		else if (controller.right)
		{
			acceleration.x = accelerationAir;
			flipRight();
		}
		ShootGestion();
		myCount++;
		collisionCoin();
		move();
	}
	
	public function setModeHurt():Void
	{
		
		if (shield){
			shield = false;
			SoundManager.getSound("shield_hurt").play();
			shieldObject.setModeEnd();
			myCountInvincibility = 0;
		}
		else {
			setState(HURT_STATE);
			doAction = doActionHurt;
			SoundManager.getSound("gameover").play();
			arm.visible = false;
		}
		countShield = 0;
	}
	
	private function doActionHurt():Void
	{
		if (isAnimEnd) {
			Shoot.destroyAll();
			UIManager.getInstance().openPopin(TransiDead.getInstance());
		}
	}
	
	public function doTp():Void{
		
		setModeRestart();
		var lCheckPoint:Point = CheckPoint.lastCheckPointActivate;
		if (lCheckPoint.x !=0 && lCheckPoint.y !=0) 
		{
			x =  CheckPoint.lastCheckPointActivate.x;
			y =  CheckPoint.lastCheckPointActivate.y;
		}
		else 
		{
			x =  startPoint.x;
			y =  startPoint.y;
		}
		score = safeScore;
		var newScore : String = "Score : " + score;
		Hud.getInstance().txtScore.text = newScore;
		Spawn.restaureNeededSpawn();
		Camera.getInstance().setOff();
		Camera.getInstance().setOn();
		TransiDead.getInstance().callbackTp();
	}
	
	public function setModeRestart():Void{
		setState(WAIT_STATE);
		if (arm != null){
			arm.setModeWait();
			arm.visible = true;
		}
		doAction = doActionVoid;
	}
	
	public function restart():Void{
		UIManager.getInstance().closeCurrentPopin();
		setModeWait();
	}
	
	
	/**
	 * Function which test collision with all element can hurt player
	 */
	private function getHurt():Void
	{
		updatePosArm();
		shieldObject.doAction();
		if(!godMode && myCountInvincibility > FRAME_INVINCIBLITY){
			for (lShoot in Shoot.list) 
			{
				if (lShoot.side == -1 && CollisionManager.hasCollision(lShoot.hitBox,hitBox)) 
				{
					setModeHurt();
					break;
				}
			}
			
			for (lEnemy in Enemy.list) 
			{
				if (lEnemy.hurtable && CollisionManager.hasCollision(lEnemy.hitBox,hitBox)) 
				{
					setModeHurt();
					break;
				}
			}
			
			for (lKillZoneDynamic in KillZoneDynamic.list) 
			{
				if (CollisionManager.hasCollision(lKillZoneDynamic.hitBox,hitBox)) 
				{
					setModeHurt();
					break;
				}
			}
			
			for (lKillZoneStatic in KillZoneStatic.list) 
			{
				if (CollisionManager.hasCollision(lKillZoneStatic.hitBox,hitBox)) 
				{
					setModeHurt();
					break;
				}
			}
		}
		myCountInvincibility++;
		
		for (lCheckPoint in CheckPoint.list) 
			{
				if (CollisionManager.hasCollision(lCheckPoint.hitBox,hitBox)) 
				{
					lCheckPoint.setModeActivate();
					safeScore = score;
					break;
				}
			}
		if (myCountInvincibility<FRAME_INVINCIBLITY)alpha = Math.abs(Math.sin(FRAME_INVINCIBLITY/(FRAME_INVINCIBLITY-myCountInvincibility+1)));
		else alpha = 1;
	}
	
	/**
	 * Function which up Shoot to ShargeShoot
	 * @param	pSpawner
	 */
	private function upgradeShoot():Void{
		myGun = new ShargeGun(Shoot.PLAYER_SHOOT_POWER, 1, speedShoot, false);
	}
	
	/**
	 * Function which set velocity and acceleration of Player
	 * @param	pSpawner
	 */
	override function move()
	{
		if ((velocity.x * scale.x > 0||(velocity.x == 0  && acceleration.x * scale.x > 0)) && !canWalk(POINT_FRONT)) 
		{
			velocity.x = 0;
			acceleration.x = 0;
		}
		else if((velocity.x * scale.x < 0||(velocity.x == 0  && acceleration.x * scale.x < 0)) && !canWalk(POINT_BACK))
		{
			velocity.x = 0;
			acceleration.x = 0;
		}
		super.move();
		getHurt();
	}
	
	/**
	 * Function which change scale to left
	 */
	private function flipLeft():Void
	{
		if (scale.x == 1) 
		{
			Camera.getInstance().resetX();
			scale.x = -1;
			myGun.flipLeft();
		}
	}
	
	/**
	 * Function which change scale to right
	 */
	private function flipRight():Void
	{
		if (scale.x == -1) 
		{
			Camera.getInstance().resetX();
			scale.x = 1;
			myGun.flipRight();
		}
	}
	
	/**
	 * Function which test if we are not in Wall/Platform
	 * @return Bool
	 */
	private function canFall():Bool
	{
		var lFloor:StateGraphic;
		var other:String = "";
		var result:Array<Bool> = [false, false];
		for (i in 0...2) 
		{
			if (i == 1) other = "Over";
			lFloor = floor[i];
			if (lFloor != null && testPoint([lFloor], get_Point(POINT_BOTTOM+other+"Check")) == lFloor) 
			{
				result[i] = false;
			}
			else{
				result[i] =  !hitFLoor(i , get_Point(POINT_BOTTOM + other));
			}
		}
		
		return result[0] && result[1];
	}
	
	/**
	 * Function which test if we are able to shoot
	 * @return Bool
	 */
	private function canShoot():Bool
	{
		if (myCount > fireRate) 
		{
			myCount = 0;
			return true;
		}
		else 
		{
			return false;
		}
	}
	
	/**
	 * Function which returns Bool if we hit a Wall/Platform
	 * @param index, index of floor
	 * @param pHit, Point of hitFloor
	 * @return Bool
	 */
	private function hitFLoor(index:Int, ?pHit:Point = null):Bool
	{
		if (pHit == null) 
		{
			pHit = get_Point(POINT_BOTTOM);
		}
		var lCollision:StateGraphic =  testPoint(Wall.list, pHit);
		if (lCollision == null)
		{
			lCollision = testPoint(PlateForm.list, pHit);
		}
		if (lCollision != null) 
		{
			floor[index] = lCollision;
			y = floor[index].y;
			return true;
		}
		
		floor[index] = null;
		return false;
	}
	
	/**
	 * Function which test if he can walk
	 * @param pDirection,String, Direction of Player
	 * @return Bool,
	 */
	private function canWalk(pDirection:String):Bool
	{
		var lWall:StateGraphic;
		var other:String = "";
		var result:Array<Bool> = [false, false];
		for (i in 0...2) 
		{
			if (i == 1) other = "Over";
			lWall = wall[i];
			if (lWall != null && testPoint([lWall], get_Point(pDirection+other+"Check")) == lWall) 
			{
				result[i] = false;
			}
			else 
			{
				result[i] = !hitWall(get_Point(pDirection+other),i);
			}
		}
		
		return result[0] && result[1];
	}
	
	/**
	 * Function which returns Bool if we hit a Wall/Platform
	 * @param pHit, Point of Wall
	 * @param index, index of Wall
	 * @return Bool
	 */
	private function hitWall(pHit:Point,index:Int):Bool
	{
		var lCollision:StateGraphic =  testPoint(Wall.list, pHit);
		if (lCollision != null) 
		{
			wall[index] = lCollision;
			return true;
		}
		
		wall[index] = null;
		return false;
	}
	
	/**
	 * Function which returns the object with which it has collided
	 * @param pList, Array of Element to test
	 * @param pGlobalPoint, GlobalPoint of Player
	 * @return StateGraphic if collided, null if not
	 */
	private function testPoint(pList:Array<Dynamic>,pGlobalPoint:Point):StateGraphic
	{
		for (lObject in pList) 
		{
			if (CollisionManager.hitTestPoint(cast(lObject,StateGraphic).hitBox, pGlobalPoint)) 
			{
				return cast(lObject,StateGraphic);
			}
		}
		return null;
	}
	
	/**
	 * Getter of HitBox
	 * @return Value of hitBox
	 */
	override function get_hitBox():Container 
	{
		return cast(box.getChildByName("mcGlobalBox"), Container);
	}
	
	/**
	 * Getter of Point
	 * @return Value of Point
	 */
	private function get_Point(pPoint:String):Point
	{
		var lPoint:Point = box.toGlobal(box.getChildByName(pPoint).position);
		if (lPoint == null) 
		{
			//trace("le point"+pPoint+"est null");
		}
		return box.toGlobal(box.getChildByName(pPoint).position);
	}
	
	/**
	 * Function which returns Bool if we can jump
	 * @return Bool
	 */
	private function canJump():Bool
	{
		return (testPoint(Wall.list, get_Point(POINT_TOP+"Check")) == null && testPoint(Wall.list, get_Point(POINT_TOP+"Over"+"Check")) == null);
	}
	
	private function collisionCoin(){
		for (lObject in Collectable.list) 
		{
			if (CollisionManager.hitTestObject(lObject.hitBox, hitBox)) 
			{
				
				if (StringTools.startsWith(lObject.assetName, "Upgrade")) {
				
					
					if (StringTools.endsWith(lObject.assetName, "doubleJump")) {
						SoundManager.getSound("upgrade").play();
						DataManager.upgradeDoubleJump = true;
						doubleJump = true;
						WinLevel.lastUpgrade = "DoubleJump";
					}
					else if (StringTools.endsWith(lObject.assetName, "sharge")) {
					SoundManager.getSound("upgrade").play();	
						DataManager.upgradeCharge = true;
						chargeShoot = true;
						WinLevel.lastUpgrade = "ChargeGun";
					}
					else if (StringTools.endsWith(lObject.assetName, "shield")) {
					SoundManager.getSound("upgrade").play();	
						DataManager.upgradeShield = true;
						hasSheildPower = true;
						WinLevel.lastUpgrade = "Shield";
					}
					GameManager.getInstance().win = true;					
					Spawn.destroyNeededSpawn();
				}	
				else {
					SoundManager.getSound("collectible").play();
					score++;
					var newScore : String = ": " + score;
					Hud.getInstance().txtScore.text = newScore;
				}
				lObject.disactivate(true);
				
				if (!shield && hasSheildPower) 
				{
					countShield++;	
				}
				if (countShield == 10 && !shield) 
				{
					shield = true;
					addChild(shieldObject);
					SoundManager.getSound("shield_wait").play();
					shieldObject.setModeNormal();
					countShield = 0;
				}
				break;
			}
		}
	}
	
	private var ShootGestion:Void->Void;
	
	/**
	 * Function which manage normal Shoot
	 */
	private function manageNormalGun():Void
	{
		if (controller.shoot && canShoot()) 
		{
			setModeShoot();
		}
	}
	
	/**
	 * Function which manage Charge Shoot
	 */
	private function manageChargeGun():Void
	{
		if (myCount > fireRate) 
		{
			if (controller.shoot) 
			{
				iPressShoot = true;
				cast(myGun, ShargeGun).charge(new Point(0, 0), arm);
				arm.setModeShoot();
				arm.anim.gotoAndStop(0);
			}
			else if (iPressShoot) 
			{
				iPressShoot = false;
				myCount = 0;
				setModeShoot();
				arm.anim.play();
			}
		}
	}
	
	/**
	 * Function which use jump just once
	 * @return Bool
	 */
	private function iUseJump():Bool
	{
		if (!iJustJump && controller.jump) 
		{
			iJustJump = true;
			return true;
		}
		else if (iJustJump && controller.jump) 
		{
			return false;
		}
		else if(!controller.jump)
		{
			iJustJump = false;
		}
		return iJustJump;
	}
	
	private function updatePosArm():Void{
		arm.x = arrayArticulation[state][anim.currentFrame][0];
		arm.y = arrayArticulation[state][anim.currentFrame][1];
		////trace(anim.currentFrame,arrayArticulation[state].length);
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
		super.destroy();
	}
}