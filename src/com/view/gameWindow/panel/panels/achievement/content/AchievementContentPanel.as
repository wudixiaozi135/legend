package com.view.gameWindow.panel.panels.achievement.content
{
	import com.model.configData.cfgdata.AchievementCfgData;
	import com.view.gameWindow.panel.panels.achievement.common.IScrollItem;
	import com.view.gameWindow.panel.panels.achievement.common.ScrollContentBase;
	
	public class AchievementContentPanel extends ScrollContentBase
	{
		private const scrollRectH:int=395;
		public function AchievementContentPanel()
		{
			super();
		}
		
		public function initView(cfgArr:Vector.<AchievementCfgData>):void
		{
			removeAllItem();
			for each(var cfg:AchievementCfgData in cfgArr)
			{
				var item:AchievementContentItem=new AchievementContentItem();
				additem(item);
				item.initView(cfg);
			}
		}
		
		public function updateView():void
		{
			for each(var item:AchievementContentItem in items)
			{
				item.updateView();
			}
		}
		
		override public function get scrollRectHeight():int
		{
			return scrollRectH;
		}
		
		override public function setItemSelect(item:IScrollItem):void
		{
			
		}
	}
}