package com.view.gameWindow.panel.panels.guideSystem.completeCond
{
	import com.view.gameWindow.panel.panels.position.PositionDataManager;
	
	/**
	 * @author wqhk
	 * 2015-2-15
	 */
	public class PositionCheck implements ICheckCondition
	{
		private var _position:int;
		
		public function PositionCheck(position:int)
		{
			_position = position;
		}
		
		public function toDo():void
		{
			
		}
		
		public function isDoing():Boolean
		{
			var pos:int = PositionDataManager.instance.position;
			var ready:Boolean = (pos + 1 == _position);
			return !ready;
		}
		
		public function isComplete():Boolean
		{
			var pos:int = PositionDataManager.instance.position;
			return pos >= _position;
		}
	}
}