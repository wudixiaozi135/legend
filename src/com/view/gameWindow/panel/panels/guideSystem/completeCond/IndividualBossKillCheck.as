package com.view.gameWindow.panel.panels.guideSystem.completeCond
{
	import com.view.gameWindow.panel.panels.boss.BossDataManager;
	import com.view.gameWindow.panel.panels.daily.DailyDataManager;
	import com.view.gameWindow.panel.panels.dungeon.DgnDataManager;
	
	import flash.utils.getTimer;
	
	/**
	 * @author wqhk
	 * 2015-2-25
	 */
	public class IndividualBossKillCheck implements ICheckCondition
	{
		private var _idList:Array;
		public function IndividualBossKillCheck(idList:Array)
		{
			_idList = [];
			for each(var id:int in idList)
			{
				_idList.push(id);
			}
		}
		
		public function toDo():void
		{
			
		}
		
		public function isDoing():Boolean
		{
			if(!_idList || _idList.length == 0)
			{
				return false;
			}
			
			//代表 getIndividualBossValidIndex 函数中必要的数据没有 . 暂时不显示
			if(DailyDataManager.instance.daily_online_start == 0 || !DgnDataManager.instance.isChrDgnInfoInited)
			{
				return true;
			}
			
			var index:int = BossDataManager.instance.getIndividualBossValidIndex(_idList);
			
			return index == -1;
		}
		
		public function isComplete():Boolean
		{
			return false;
		}
	}
}