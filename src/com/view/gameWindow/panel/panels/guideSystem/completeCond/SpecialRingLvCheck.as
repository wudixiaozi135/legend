package com.view.gameWindow.panel.panels.guideSystem.completeCond
{
	import com.view.gameWindow.panel.panels.specialRing.SpecialRingData;
	import com.view.gameWindow.panel.panels.specialRing.SpecialRingDataManager;
	
	/**
	 * @author wqhk
	 * 2014-12-13
	 */
	public class SpecialRingLvCheck implements ICheckCondition
	{
		private var _ringId:int;
		private var _lv:int;
		
		public function SpecialRingLvCheck(ringId:int,lv:int)
		{
			_ringId = ringId;
			_lv = lv;
		}
		
		public function toDo():void
		{
			
		}
		
		public function isDoing():Boolean
		{
			return false;
		}
		
		public function isComplete():Boolean
		{
			var data:SpecialRingData = SpecialRingDataManager.instance.getDataById(_ringId);
			if(data)
			{
				return data.level >= _lv;
			}
			
			return false;
		}
	}
}