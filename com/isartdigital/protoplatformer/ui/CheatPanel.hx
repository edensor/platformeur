package com.isartdigital.protoplatformer.ui;
import com.isartdigital.protoplatformer.game.level.Camera;
import com.isartdigital.protoplatformer.game.GameManager;
import com.isartdigital.protoplatformer.game.sprites.Player;
import com.isartdigital.utils.Config;
import com.isartdigital.utils.effects.Trail;
import com.isartdigital.utils.game.GameStage;
import dat.gui.GUI;

	
/**
 * Classe permettant de manipuler des parametres du projet au runtime
 * Si la propriété Config.debug et à false ou que la propriété Config.data.cheat est à false, aucun code n'est executé.
 * Il n'est pas nécessaire de retirer ou commenter le code du CheatPanel dans la version "release" du jeu
 * @author Mathieu ANTHOINE
 */
class CheatPanel 
{
	
	/**
	 * instance unique de la classe CheatPanel
	 */
	private static var instance: CheatPanel;
	
	/**
	 * instance de dat.GUI composée par le CheatPanel
	 */
	private var gui:GUI;
	
	private var trail:Trail;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): CheatPanel {
		if (instance == null) instance = new CheatPanel();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		init();
	}
	
	private function init():Void {
		if (Config.debug && Config.data.cheat) gui = new GUI();
	}
	
	// exemple de méthode configurant le panneau de cheat suivant le contexte
	public function ingame (): Void {
		// ATTENTION: toujours intégrer cette ligne dans chacune de vos méthodes pour ignorer le reste du code si le CheatPanel doit être désactivé
		if (gui == null) return;
		

		gui.add(Player.getInstance(), "y").listen();
		var lVelocity: GUI = gui.addFolder("velocity");
		lVelocity.open();
		var lAcc: GUI = gui.addFolder("lAcc");
		lAcc.open();
		var lParams: GUI = gui.addFolder("parametre");
		lParams.open();
		
		lVelocity.add(untyped Player.getInstance(), "state").listen();
		lVelocity.add(untyped Player.getInstance().velocity, "x").listen();
		lVelocity.add(untyped Player.getInstance().velocity, "y").listen();
		lAcc.add(untyped Player.getInstance().acceleration, "x").listen();
		lAcc.add(untyped Player.getInstance(), "doubleJump").listen();
		lAcc.add(untyped Player.getInstance(), "godMode").listen();
		lAcc.add(untyped Player.getInstance(), "impulseDuration").min(0).max(50).listen();
		lAcc.add(untyped Player.getInstance(), "impulseConter").min(0).max(50).listen();
		lParams.add(untyped Player.getInstance(), "frictionGround").min(0).max(1).step(0.05).listen();
		lParams.add(untyped Player.getInstance(), "accelerationGround").min(0).max(50).listen();
		lParams.add(untyped Player.getInstance(), "frictionAir").min(0).max(1).step(0.05).listen();
		lParams.add(untyped Player.getInstance(), "gravity").min(0).max(10).step(0.2).listen();
		lParams.add(untyped Player.getInstance(), "impulse").min(0).max(100).step(1).listen();
		lParams.add(untyped Player.getInstance(), "fireRate").min(0).max(100).step(5).listen();
		lParams.add(untyped Player.getInstance(), "speedShoot").min(0).max(100).step(5).listen();
		lVelocity.add(untyped Player.getInstance(), "MaxHSpeed").min(0).max(100).listen();
		lVelocity.add(untyped Player.getInstance(), "MaxVSpeed").min(0).max(100).listen();
		
		//trail =  new Trail(Main.getInstance(),Player.getInstance());
		
	}
	
	public function setCamera () : Void {
			if (gui == null) return;
			
			var lCam : GUI = gui.addFolder("focus Caméra");
			lCam.open();
			
			var lParam : GUI = gui.addFolder("Paramètre Cam");
			lParam.open();
			
			var lMax : GUI = gui.addFolder("Inertie Max");
			lMax.open();
			
			var lMin : GUI = gui.addFolder("Inertie Min");
			lMax.open();
			
			lCam.add(untyped Player.getInstance().box.getChildByName("mcCamera").position, "x").step(5).listen();
			lCam.add(untyped Player.getInstance().box.getChildByName("mcCamera").position, "y").step(5).listen();
			lCam.add(untyped Camera.getInstance(), "percentX").min(0).max(1).step(0.01).listen();
			lCam.add(untyped Camera.getInstance(), "percentY").min(0).max(1).step(0.01).listen();
			lCam.add(untyped Camera.getInstance(), "percentDeltaX").min(0).max(1).step(0.01).listen();
			lCam.add(untyped Camera.getInstance(), "percentDeltaY").min(0).max(1).step(0.01).listen();
			
			lMax.add(untyped Camera.getInstance().easeMax, "x").step(1).listen();
			lMax.add(untyped Camera.getInstance().easeMax, "y").step(1).listen();
			
			lMin.add(untyped Camera.getInstance().easeMin, "x").step(1).listen();
			lMin.add(untyped Camera.getInstance().easeMin, "y").step(1).listen();
			
			//trail = new Trail(Main.getInstance(), Player.getInstance());
	}
	
	/**
	 * vide le CheatPanel
	 */
	public function clear ():Void {
		if (gui == null) return;
		gui.destroy();
		init();
		trail.destroy();
		trail = null;
	}	
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void {
		instance = null;
	}

}