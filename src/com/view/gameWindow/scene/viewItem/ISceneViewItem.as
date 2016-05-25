package com.view.gameWindow.scene.viewItem
{
	public interface ISceneViewItem
	{
		function get entityId():int;
		function set entityId(value:int):void;
		function get entityType():int;
		function set entityType(value:int):void;
			
		function updateFrame(timeDiff:int):void;
		
		function destory():void;
	}
}