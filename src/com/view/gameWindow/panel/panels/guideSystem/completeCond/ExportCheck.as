package com.view.gameWindow.panel.panels.guideSystem.completeCond
{
	
	/**
	 * @author wqhk
	 * 2015-1-29
	 */
	public class ExportCheck implements ICheckCondition
	{
		private var callback:Function;
		
		public function toDo():void
		{
			
		}
		
		public function ExportCheck(doingCallback:Function)
		{
			this.callback = doingCallback;
		}
		
		public function isDoing():Boolean
		{
			if(callback != null)
			{
				return callback();
			}
			
			return false;
		}
		
		public function isComplete():Boolean
		{
			return false;
		}
	}
}