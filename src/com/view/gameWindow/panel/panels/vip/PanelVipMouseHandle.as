package com.view.gameWindow.panel.panels.vip
{
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.vip.vipOpen.TabVipOpen;
	import com.view.gameWindow.panel.panels.vip.vipPrivilege.TabVipPrivilege;
	import com.view.gameWindow.util.tabsSwitch.TabBase;
	import com.view.gameWindow.util.tabsSwitch.TabsSwitch;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	/**
	 * vip特权面板鼠标相关处理类
	 * @author Administrator
	 */	
	internal class PanelVipMouseHandle
	{
		private var _panel:PanelVip;
		private var _mc:McVip;
		private var _tabsSwitch:TabsSwitch;
		internal var lastClickBtn:MovieClip;
		
		public function PanelVipMouseHandle(panel:PanelVip)
		{
			_panel = panel;
			_mc = _panel.skin as McVip;
			init();
		}
		
		public function setTabIndex(value:int):void
		{
			if(value == 1)
			{
				dealTabSwitch(_mc.btnPrivilege,1);
			}
			else
			{
				dealTabSwitch(_mc.btnOpen,0);
			}
		}
		
		public function getTabIndex():int
		{
			return _tabsSwitch.index;
		}
		
		private function init():void
		{
			var tabs:Vector.<Class> = Vector.<Class>([TabVipOpen,TabVipPrivilege]);
			_tabsSwitch = new TabsSwitch(_mc.mcLayer,tabs);
			lastClickBtn = _mc.btnOpen;
			_mc.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			switch(event.target)
			{
				case _mc.btnClose:
					dealClose();
					break;
				case _mc.btnOpen:
					dealTabSwitch(_mc.btnOpen,0);
					break;
				case _mc.btnPrivilege:
					dealTabSwitch(_mc.btnPrivilege,1);
					break;
			}
		}
		
		private function dealClose():void
		{
			PanelMediator.instance.closePanel(PanelConst.TYPE_VIP);
		}
		
		private function dealTabSwitch(clickBtn:MovieClip,index:int):void
		{
			if(lastClickBtn.hasOwnProperty("txt"))
			{
				lastClickBtn.txt.textColor = 0x675138;
				lastClickBtn.selected = false;
			}
			lastClickBtn.mouseEnabled = true;
			_tabsSwitch.onClick(index);
			lastClickBtn = clickBtn;
			if(lastClickBtn.hasOwnProperty("txt"))
			{
				lastClickBtn.txt.textColor = 0xffe1aa;
				lastClickBtn.selected = true;
			}
			lastClickBtn.mouseEnabled = false;
		}
		
		internal function get tab():TabBase
		{
			if(_tabsSwitch)
			{
				var tab:TabBase = _tabsSwitch.tab;
				return tab;
			}
			return null;
		}
		
		internal function destroy():void
		{
			if(_tabsSwitch)
			{
				_tabsSwitch.destroy();
				_tabsSwitch = null;
			}
			if(_mc)
			{
				_mc.removeEventListener(MouseEvent.CLICK,onClick);
				_mc = null;
			}
			_panel = null;
		}
	}
}