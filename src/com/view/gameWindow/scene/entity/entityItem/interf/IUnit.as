package com.view.gameWindow.scene.entity.entityItem.interf
{
	import com.view.gameWindow.scene.entity.effect.interf.IEntityUnPermEffect;

	public interface IUnit extends IEntity
	{
		function get level():int;
		function set level(value:int):void;
		function say(value:String):void;
		
		function get modelHeight():int;
		
		function addUnPermTopEffect(path:String,isTween:Boolean = false):IEntityUnPermEffect;
		
		function get currentAcionId():int;

		function addHideForMonster():void;//为怪物添加虚方法
		function addHideForPlayer():void;//为角色添加虚方法

	}
}