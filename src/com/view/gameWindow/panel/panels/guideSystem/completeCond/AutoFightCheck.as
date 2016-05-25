package com.view.gameWindow.panel.panels.guideSystem.completeCond
{
	import com.view.gameWindow.panel.panels.onhook.AutoSystem;
	
	/**
	 * @author wqhk
	 * 2015-1-19
	 */
	public class AutoFightCheck implements ICheckCondition
	{
		public function AutoFightCheck()
		{
		}
		
		public function toDo():void
		{
			
		}
		
		public function isDoing():Boolean
		{
			return AutoSystem.instance.isAutoFight();
		}
		
		private var _isComplete:Boolean = false;
		public function isComplete():Boolean
		{
			if(isDoing())
			{
				_isComplete = true;
			}
			return _isComplete;
		}
	}
}