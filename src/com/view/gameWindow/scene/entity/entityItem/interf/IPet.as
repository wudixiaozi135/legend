package com.view.gameWindow.scene.entity.entityItem.interf
{
	public interface IPet extends ILivingUnit
	{
		function get ownId():int;
		function set ownId(value:int):void;
		function get sid():int;
		function set sid(value:int):void;
	}
}