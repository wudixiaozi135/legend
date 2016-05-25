package com.view.gameWindow.panel.panels.guideSystem.completeCond
{
	import com.model.consts.ConstHeroMode;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	
	/**
	 * @author wqhk
	 * 2015-2-28
	 */
	public class HeroFightModeCheck implements ICheckCondition
	{
		private var _mode:int;
		public function HeroFightModeCheck(mode:int)
		{
			_mode = mode;
		}
		
		public function isDoing():Boolean
		{
			if(HeroDataManager.instance.attrHp == 0)
			{
				return true;
			}
			
			var mode:int = HeroDataManager.instance.mode;
			
			if(mode == ConstHeroMode.HM_HIDE_HOLD 
				|| mode == ConstHeroMode.HM_HIDE_IDLE
				|| mode == ConstHeroMode.HM_HIDE_ACTIVE)
			{
				return true; //隐藏
			}
			
			return mode == _mode;
		}
		
		public function isComplete():Boolean
		{
			return HeroDataManager.instance.mode == _mode;
		}
		
		public function toDo():void
		{
		}
	}
}