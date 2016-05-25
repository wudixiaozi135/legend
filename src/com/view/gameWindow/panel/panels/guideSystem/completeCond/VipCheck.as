package com.view.gameWindow.panel.panels.guideSystem.completeCond
{
	import com.view.gameWindow.panel.panels.vip.VipDataManager;

	public class VipCheck implements ICheckCondition
	{
		private var _vip:int;
		
		public function VipCheck(vip:int)
		{
			_vip = vip
		}
		
		public function isDoing():Boolean
		{
			return VipDataManager.instance.lv < _vip;
		}
		
		public function isComplete():Boolean
		{
			return false;
		}
		
		public function toDo():void
		{
		}
	}
}