package com.view.gameWindow.panel.panels.achievement.title
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.AchievementGroupCfgData;
	import com.view.gameWindow.panel.panels.achievement.common.IScrollItem;
	import com.view.gameWindow.panel.panels.achievement.common.ScrollContentBase;
	
	import flash.utils.Dictionary;
	
	public class AchievementTitlePanel extends ScrollContentBase
	{
		private const scrollRectH:int=395;
		public function AchievementTitlePanel()
		{
			super();
		}
		
		public function initView():void
		{
			removeAllItem();
			var cfgDic:Dictionary=ConfigDataManager.instance.achievementGroupCfgData();
			for each(var cfg:AchievementGroupCfgData in cfgDic)
			{
				var item:AchievementTitleItem=new AchievementTitleItem();
				item.initView(cfg);
				additem(item);
			}
		}
		
		public function updateView():void
		{
			for each(var item:IScrollItem in items)
			{
				item.updateView();
			}
		}
		
		override public function get scrollRectHeight():int
		{
			// TODO Auto Generated method stub
			return scrollRectH;
		}
	}
}