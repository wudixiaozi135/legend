package com.view.gameWindow.panel.panels.taskBoss
{
	import com.model.configData.cfgdata.TaskWantCfgData;
	import com.view.gameWindow.panel.panels.task.linkText.LinkText;
	
	/**
	 * @author wqhk
	 * 2014-8-20
	 */
	public class TaskBossData
	{
		public var id:int;
		public var level:int;
		
		/**
		 * 	未领取的任务，满足领取等级显示：“可领取”
				未领取的任务，不满足领取等级显示：“等级不足”
				已完成任务，已领取奖励显示：“已击杀”
				已完成任务，未领取奖励显示：”完成任务“按钮
				已领取任务显示：“立即完成”按钮
		 */
		public var state:int;
		public var progress:int;
		
		public var monsterId:int;
		public var monsterNum:int;
		public var monsterName:String;
		public var costCfgData:TaskWantCfgData;
		public var preHint:String;
		public var link:LinkText;
		public var iconId:int;
		public function TaskBossData()
		{
		}
	}
}