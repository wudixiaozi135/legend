package com.view.gameWindow.panel.panels.guideSystem.completeCond
{
	import com.view.gameWindow.panel.PanelMediator;

	public class PanelCloseCheck implements ICheckCondition
	{
		private var _panelName:String;
		public function PanelCloseCheck(name:String)
		{
			_panelName = name;
		}
		
		public function isDoing():Boolean
		{
			if(_panelName)
			{
				return PanelMediator.instance.openedPanel(_panelName) != null;
			}
			else
			{
				return false;
			}
		}
		
		public function isComplete():Boolean
		{
			return true;
		}
		
		public function toDo():void
		{
		}
	}
}