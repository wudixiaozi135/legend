package com.view.gameWindow.panel.panels.guideSystem.action
{
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.IPanelPage;
	import com.view.gameWindow.panel.panelbase.IPanelTab;
	import com.view.gameWindow.panel.panels.guideSystem.UICenter;
	
	/**
	 * @author wqhk
	 * 2014-10-24
	 */
	public class OpenPanelAction extends GuideAction
	{
		public var panelName:String = "";
		public var tabIndex:int = -1;
		public var pageIndex:int = -1;
		protected var uiCenter:UICenter;
		
		public function OpenPanelAction(panelName:String = "",tabIndex:int = -1,pageIndex:int = -1)
		{
			this.panelName = panelName;
			this.tabIndex = tabIndex;
			this.pageIndex = pageIndex;
			uiCenter = new UICenter();
			super();
		}
		
		override public function act():void
		{
			if(panelName)
			{
				uiCenter.openUI(panelName);
				
				if(tabIndex>=0)
				{
					var tab:IPanelTab = UICenter.getUI(panelName) as IPanelTab;
					if(tab)
					{
						tab.setTabIndex(tabIndex);
					}
				}
				
				if(pageIndex >= 0)
				{
					var page:IPanelPage = UICenter.getUI(panelName) as IPanelPage;
					if(page)
					{
						page.setPageIndex(pageIndex);
					}
				}
			}
			
			super.act();
			
			_isComplete = true;
		}
	}
}