package com.view.gameWindow.scene.entity.entityItem.interf
{
	public interface ITrailer extends ILivingUnit
	{
		function get trailerId():int;
		function set trailerId(value:int):void;
		function get ownerCid():int;
		function set ownerCid(value:int):void;
		function get ownerSid():int;
		function set ownerSid(value:int):void;
		function get ownerName():String;
		function set ownerName(value:String):void;
	}
}