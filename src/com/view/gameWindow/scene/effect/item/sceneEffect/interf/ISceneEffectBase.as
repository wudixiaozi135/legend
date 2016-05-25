package com.view.gameWindow.scene.effect.item.sceneEffect.interf
{
	import com.view.gameWindow.scene.effect.item.interf.IEffectBase;
	
	public interface ISceneEffectBase extends IEffectBase
	{
		function get pixelX():Number;
		function get pixelY():Number;
		function set pixelX(value:Number):void;
		function set pixelY(value:Number):void;
		
		function get tileX():int;
		function get tileY():int;
		function set tileX(value:int):void;
		function set tileY(value:int):void;
	}
}