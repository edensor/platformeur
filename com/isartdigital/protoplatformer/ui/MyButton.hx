package com.isartdigital.protoplatformer.ui;

import com.isartdigital.protoplatformer.game.abstrait.LocalizationManager;
import com.isartdigital.utils.ui.Button;
import pixi.core.text.Text;
import pixi.core.math.Point;
import pixi.interaction.EventTarget;

/**
 * ...
 * @author 
 */
class MyButton extends Button
{

	
	public function new(?pAssetName:String,?pRef:String) 
	{
		assetName = pAssetName;
		super();
		LocalizationManager.textListMap.set(pRef, this.txt);
	}
	
	public function setPosText(pX:Float, pY:Float,?pText:Text):Void{
		if (pText == null) pText = txt;
		pText.x = pX;
		pText.y = pY;
	}
	
	public function setAnchorText(pX:Float, pY:Float,?pText:Text):Void{
		if (pText == null) pText = txt;
		pText.anchor.set(pX, pY);
	}
	
	public function addText(pText:String, pX:Float, pY:Float,?pRef:String,?pFill:String):Void{
		txt = new Text("",upStyle);
		txt.anchor.set(0.5, 0.5);
		txt.text=pText; 
		txt.x = pX;
		txt.y = pY;
		txt.style = { font: "50px RoundedElegance", fill: ((pFill != null)?pFill :"#FFFFFF"), align:"center"};
		if(pRef != null)LocalizationManager.textListMap.set(pRef, this.txt);
		addChild(txt);
	}
	
	public function setFont(pFont:String,?pFill:String):Void{
		txt.style = { font: pFont, fill: ((pFill!=null)?pFill :"#FFFFFF"), align:"left"};
		upStyle={ font: pFont, fill: ((pFill!=null)?pFill :"#FFFFFF"), align:"left"};
		overStyle={ font: pFont, fill: ((pFill!=null)?pFill :"#AAAAAA"), align:"left"};
		downStyle = { font: pFont, fill: ((pFill!=null)?pFill :"#AAAAAA"), align:"left" };
	}
	

	
}