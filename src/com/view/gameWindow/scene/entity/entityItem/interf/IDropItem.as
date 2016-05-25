package com.view.gameWindow.scene.entity.entityItem.interf
{
	public interface IDropItem extends IEntity
	{
		function get itemId():int;
		function set itemId(value:int):void;
		function get itemType():int;
		function set itemType(value:int):void;
		function get itemCount():int;
		function set itemCount(value:int):void;
		function get ownerTeamId():int;
		function set ownerTeamId(value:int):void;
		function get ownerCid():int;
		function set ownerCid(value:int):void;
		function get ownerSid():int;
		function set ownerSid(value:int):void;
	}
}