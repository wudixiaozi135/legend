package com.view.gameWindow.panel.panels.guideSystem.action
{
	import com.view.gameWindow.panel.panels.guideSystem.GuideDataManager;
	
	/**
	 * @author wqhk
	 * 2015-1-23
	 */
	public class SendFamilyMailAction extends GuideAction
	{
		public function SendFamilyMailAction()
		{
			super();
		}
		
		override public function act():void
		{
			GuideDataManager.instance.sendGetFamilyGuideMail();
			
			super.act();
			
			_isComplete = true;
		}
	}
}