package com.view.gameWindow.panel.panels.achievement.title
{
	import flash.events.MouseEvent;

	public class AchiTitleMouseHandler
	{
		private var _titlePanel:AchievementTitlePanel;
		public function AchiTitleMouseHandler(panel:AchievementTitlePanel)
		{
			_titlePanel=panel;
			_titlePanel.addEventListener(MouseEvent.CLICK,onMouseFunc);
		}
		
		private function onMouseFunc(e:MouseEvent):void
		{
			var title:AchievementTitleItem=e.target.parent as AchievementTitleItem;
			if(title!=null)
			{
				_titlePanel.setItemSelect(title);
			}
		}
		
		public function destroy():void
		{
			_titlePanel.removeEventListener(MouseEvent.CLICK,onMouseFunc);
		}
		
	}
}