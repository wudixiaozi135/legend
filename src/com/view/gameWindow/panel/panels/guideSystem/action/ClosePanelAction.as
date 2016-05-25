package com.view.gameWindow.panel.panels.guideSystem.action
{
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.guideSystem.UICenter;
	
	/**
	 * @author wqhk
	 * 2014-10-24
	 */
	public class ClosePanelAction extends GuideAction
	{
		public var panelName:String;
		protected var uiCenter:UICenter;
		public function ClosePanelAction(panelName:String)
		{
			super();
			this.panelName = panelName;
			uiCenter = new UICenter();
		}
		
		override public function act():void
		{
			uiCenter.closeUI(panelName);
			
			super.act();
			
			_isComplete = true;
		}
	}
}