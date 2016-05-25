package com.view.gameWindow.panel.panels.guideSystem.trigger
{
	public interface IGuideTrigger
	{
		function updateLoginState():void; //caused by login
		function updateTaskState(tid:int, tstate:int):void; //caused by task
		function updateEnterSceneState(mid:int):void;//caused by enterscene
		function updateGuideState(gid:int):void; //caused by guide finish
		/**
		 * @param isFirst 是否是第一次进入该等级
		 */
		function updateLevelState(roleType:int,roleLevel:int,roleRe:int = 0,isFirst:Boolean = true):void; //caused by level change
		
		/**
		 * @param type 1 玩家 2英雄
		 */
		function updateFirstDead(type:int):void;
		
		/**
		 * 合击引导
		 */
		function updateJointAttack():void;
		
		/**
		 * 经验玉 
		 */
		function updateExpStone(times:int):void;
		
		/**
		 * 英雄需要进入抗怪模式
		 */
		function updateHeroHoldMode():void;
	}
}