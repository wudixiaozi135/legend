package com.view.gameWindow.panel.panels.guideSystem.unlock
{
	public interface IUnlockTrigger
	{
		function updateTaskState(tid:int, tstate:int):void; //caused by task
		/**
		 * @param isFirst 是否是第一次进入该等级
		 */
		function updateLevelState(roleType:int,roleLevel:int,roleRe:int = 0,isFirst:Boolean = true):void; //caused by level change
		
		function updateUserUnlockOperation(func_id:int):void;//用户的解锁操作
		
		/**
		 * @param type 装备类型 EquipCfg.type
		 */
		function updateEquipType(type:int,isOnFirstInit:Boolean = false):void
	}
}