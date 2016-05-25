package com.view.gameWindow.scene.entity.entityItem.interf
{
	import com.model.configData.cfgdata.MonsterCfgData;
	import com.model.configData.cfgdata.MstDigCfgData;

	public interface IMonster extends ILivingUnit
	{
		function set monsterId(value:int):void
		function get monsterId():int;
		function set side(value:int):void;
		function get side():int;
		function get canDig():Boolean;
		function get mstCfgData():MonsterCfgData;
		function get mstDigCfgData():MstDigCfgData;
	}
}