package com.view.gameWindow.panel.panels.taskBoss
{
	import com.model.configData.cfgdata.TaskWantedDailyRewardCfgData;
	
	
	/**
	 * @author wqhk
	 * 2014-8-21
	 */
	public class TaskBossRewardData extends TaskWantedDailyRewardCfgData
	{
		public function TaskBossRewardData()
		{
			super();
		}
		public var cfgData:TaskWantedDailyRewardCfgData;
		public var isRewarded:int = 0;//是否已领取 1已领取
		public var canRewarded:int = 0;
	}
}