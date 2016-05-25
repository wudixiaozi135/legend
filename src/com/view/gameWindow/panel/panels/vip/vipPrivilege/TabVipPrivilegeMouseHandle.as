package com.view.gameWindow.panel.panels.vip.vipPrivilege
{
	import flash.events.MouseEvent;

	internal class TabVipPrivilegeMouseHandle
	{
		private var _tab:TabVipPrivilege;
		private var _mc:McVipPrivilege;
		
		public function TabVipPrivilegeMouseHandle(tab:TabVipPrivilege)
		{
			_tab = tab;
			_mc = _tab.skin as McVipPrivilege;
			init();
		}
		
		private function init():void
		{
			_mc.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			switch(event.target)
			{
				default:
					break;
			}
		}
		
		internal function destroy():void
		{
			if(_mc)
			{
				_mc.removeEventListener(MouseEvent.CLICK,onClick);
				_mc = null;
			}
			_tab = null;
		}
	}
}