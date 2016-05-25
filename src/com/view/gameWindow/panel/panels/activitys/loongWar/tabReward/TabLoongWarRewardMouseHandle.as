package com.view.gameWindow.panel.panels.activitys.loongWar.tabReward
{
	import com.view.gameWindow.mainUi.subuis.activityTrace.ActivityDataManager;
	
	import flash.events.MouseEvent;

	internal class TabLoongWarRewardMouseHandle
	{
		private var _tab:TabLoongWarReward;
		private var _skin:McLoongWarReward;
		
		public function TabLoongWarRewardMouseHandle(tab:TabLoongWarReward)
		{
			_tab = tab;
			_skin = tab.skin as McLoongWarReward;
			initialize();
		}
		
		private function initialize():void
		{
			_skin.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			if(event.target == _skin.btnGet)
			{
				ActivityDataManager.instance.loongWarDataManager.cmLongchengAwardReceive();
				ActivityDataManager.instance.loongWarDataManager.cmLongchengChestReceive();
			}
		}
		
		public function destroy():void
		{
			if(_skin)
			{
				_skin.removeEventListener(MouseEvent.CLICK,onClick);
				_skin = null;
			}
			_tab = null;
		}
	}
}