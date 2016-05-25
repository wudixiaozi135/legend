package com.view.gameWindow.scene.entity.entityItem.interf
{
	public interface ITrap extends IUnit
	{
		function get trapId():int;
		function set trapId(value:int):void;
		function get state():int;
		function set state(value:int):void;
		
		function get trapType():int;
		function get triggerType():int;
		
		function get isMine():Boolean;
	}
}