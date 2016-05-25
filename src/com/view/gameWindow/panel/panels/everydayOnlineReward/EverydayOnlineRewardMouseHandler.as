package com.view.gameWindow.panel.panels.everydayOnlineReward
{
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.onlineTime.McOnlineTimeReward;
	
	import flash.events.MouseEvent;

	public class EverydayOnlineRewardMouseHandler
	{
		private var _panel:PanelEverydayOnlineReward;
		private var _skin:McOnlineTimeReward;
		public function EverydayOnlineRewardMouseHandler(p:PanelEverydayOnlineReward)
		{
			_panel = p;
			_skin = _panel.skin  as McOnlineTimeReward;
			_skin.addEventListener(MouseEvent.CLICK,onclick);
		}
		
		protected function onclick(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			if(event.target == _skin.closeBtn)
			{
				PanelMediator.instance.closePanel(PanelConst.TYPE_EVERYDAY_ONLINE_REWARD);
			}
		}
		
		public function destroy():void
		{
			_skin.removeEventListener(MouseEvent.CLICK,onclick);
		}
	}
}