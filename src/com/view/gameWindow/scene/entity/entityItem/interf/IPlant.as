package com.view.gameWindow.scene.entity.entityItem.interf
{
	public interface IPlant extends IUnit
	{
		function get plantId():int;
		function set plantId(value:int):void;
		function get state():int;
		function set state(value:int):void;
	}
}