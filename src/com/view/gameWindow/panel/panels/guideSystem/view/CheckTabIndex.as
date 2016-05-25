package com.view.gameWindow.panel.panels.guideSystem.view
{
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.IPanelTab;
	import com.view.gameWindow.panel.panels.guideSystem.UICenter;
	
	/**
	 * @author wqhk
	 * 2014-10-24
	 */
	public class CheckTabIndex implements ICheckUIState
	{
		private var panelName:String;
		private var tabIndex:int;
		public function CheckTabIndex(panelName:String,index:int = -1)
		{
			this.panelName = panelName;
			this.tabIndex = index;
		}
		
		public function isChange():Boolean
		{
			if(tabIndex > -1 )
			{
				var panel:* = UICenter.getPanel(panelName); //PanelMediator.instance.openedPanel(panelName);
				if(panel is IPanelTab)
				{
					if(IPanelTab(panel).getTabIndex() != tabIndex)
					{
						return true;
					}
				}
			}
			
			return false;
		}
	}
}