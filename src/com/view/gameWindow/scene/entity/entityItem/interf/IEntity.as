package com.view.gameWindow.scene.entity.entityItem.interf
{
	import com.view.gameWindow.scene.viewItem.ISceneViewItem;

	public interface IEntity extends ISceneViewItem
	{
		
		function get entityName():String;
		function set entityName(value:String):void;
		
		function get alpha():Number;
		function set alpha(value:Number):void;
		
		function show():void;
		function hide():void;
		
		function get pixelX():Number;
		function get pixelY():Number;
		function set pixelX(value:Number):void;
		function set pixelY(value:Number):void;
		
		function get tileX():int;
		function get tileY():int;
		function set tileX(value:int):void;
		function set tileY(value:int):void;
		
		/**计算距离目标点的格子距离*/
		function tileDistance(xTile:int, yTile:int):int;
		/**计算距离目标点的像素距离*/
		function pixelDistance(pixelX:Number,pixelY:Number):Number;
		
		function isMouseOn():Boolean;
		function get isShow():Boolean;
		function get viewBitmapExist():Boolean;
		
		function get selectable():Boolean;
		function setSelected(value:Boolean):void;
		function setOver(value:Boolean):void;
		
		/**获取采集时间*/
		function get totalTime():int;
		
		function get tileDistToReach():int;
	}
}