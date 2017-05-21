package com.isartdigital.utils.ui;


/**
 * Classe de base des Ecrans
 * Tous les écrans d'interface héritent de cette classe
 * @author Mathieu ANTHOINE
 */
class Screen extends UIComponent 
{
	public static inline var WIDTH:Int = 2048;
	public static inline var HEIGHT:Int = 1366;
	public function new() 
	{
		super();
		modalImage = "assets/black_bg.png";
		
	}
	
}