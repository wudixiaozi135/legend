package com.view.gameWindow.panel.panels.achievement.common
{
	public interface IScrollItem
	{
		function set select(value:Boolean):void;
		function get select():Boolean;
		function getItemHight():Number;
		function destroy():void;
		function initView(value:Object):void;
		function updateView():void;
		function setY(y:Number):void;
	}
}