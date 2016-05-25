package com.view.gameWindow.panel.panels.guideSystem.completeCond
{
	import com.view.gameWindow.panel.panels.bag.BagData;
	import com.view.gameWindow.panel.panels.equipRecycle.EquipRecycleDataManager;

	public class EquipRecycleNumCheck implements ICheckCondition
	{
		public function EquipRecycleNumCheck()
		{
		}
		
		public function isDoing():Boolean
		{
			var realEquipRecycleDatas:Vector.<BagData> = EquipRecycleDataManager.instance.realEquipRecycleDatas;
			return realEquipRecycleDatas.length == 0;
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