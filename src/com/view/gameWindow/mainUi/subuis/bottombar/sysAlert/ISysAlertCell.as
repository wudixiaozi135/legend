package com.view.gameWindow.mainUi.subuis.bottombar.sysAlert
{
	public interface ISysAlertCell
	{
		function set x(value:Number):void;
		function set y(value:Number):void;
		function get id():int;
		function get type():int;
		function show():void;
		function destroy():void;
	}
}