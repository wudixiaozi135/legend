package com.view.gameWindow.panel.panels.keySell
{
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	
	import flash.events.MouseEvent;

	/**
	 * 点击处理类
	 * @author Administrator
	 */	
	internal class PanelKeySellMouseHandle
	{
		private var _panel:PanelKeySell;
		private var _mc:McKeySell;
		
		public function PanelKeySellMouseHandle(panel:PanelKeySell)
		{
			_panel = panel;
			_mc = _panel.skin as McKeySell;
			init();
		}
		
		private function init():void
		{
			_panel.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			switch(event.target)
			{
				default:
					break;
				case _mc.btnSure:
					dealSure();
					break;
				case _mc.btnClose:
					dealClose();
					break;
			}
		}
		
		private function dealSure():void
		{
			KeySellDataManager.instance.dealSell();
			dealClose();
		}
		
		private function dealClose():void
		{
			PanelMediator.instance.switchPanel(PanelConst.TYPE_KEY_SELL);
		}
		
		internal function destroy():void
		{
			if(_mc)
			{
				_mc.removeEventListener(MouseEvent.CLICK,onClick);
				_mc = null;
			}
			_panel = null;
		}
	}
}