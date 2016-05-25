package com.view.gameWindow.panel.panels.guideSystem.completeCond
{
	import com.view.gameWindow.panel.panels.onhook.AutoSystem;
	
	/**
	 * @author wqhk
	 * 2014-12-13
	 */
	public class RunToMonsterCheck implements ICheckCondition
	{
		private var _mgId:int;
		
		public function RunToMonsterCheck(mgId:int)
		{
			_mgId = mgId;
		}
		
		public function toDo():void
		{
			
		}
		
		public function isDoing():Boolean
		{
			var isRunning:Boolean = AutoSystem.instance.isRunningToMonster(_mgId);
			var isFighting:Boolean = AutoSystem.instance.isFightingAtMonster(_mgId);
			
			return isRunning || isFighting;
		}
		
		public function isComplete():Boolean
		{
			return false;
		}
	}
}