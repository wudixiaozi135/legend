package com.view.gameWindow.scene.entity.entityItem.interf
{
	public interface IHero extends ILivingUnit
	{
		function get ownerId():int;
		function set ownerId(value:int):void;
		function get sid():int;
		function set sid(value:int):void;
	}
}