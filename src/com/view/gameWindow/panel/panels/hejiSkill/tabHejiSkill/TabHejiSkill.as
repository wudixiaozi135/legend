package com.view.gameWindow.panel.panels.hejiSkill.tabHejiSkill
{
	import com.view.gameWindow.panel.panels.hejiSkill.McTabPanelHejiSkill;
	import com.view.gameWindow.util.tabsSwitch.TabBase;
	
	public class TabHejiSkill extends TabBase
	{
		public function TabHejiSkill()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			var skin:McTabPanelHejiSkill = new McTabPanelHejiSkill();
			_skin = skin;
			addChild(_skin);
		}
		
		
	}
}