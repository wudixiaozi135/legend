package com.view.gameWindow.panel.panels.daily
{
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.daily.activity.TabDailyActivity;
	import com.view.gameWindow.panel.panels.daily.pep1.TabDailyPep;
	import com.view.gameWindow.panel.panels.daily.taskdungeon.TabDailyTaskDgn;
	import com.view.gameWindow.panel.panels.guideSystem.unlock.UIUnlockHandler;
	import com.view.gameWindow.util.tabsSwitch.TabsSwitch;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * 日常面板鼠标相关处理类
	 * @author Administrator
	 */
	internal class PanelDailyMouseHandle
	{
		private var _panel:PanelDaily;
		private var _skin:McDaily1;
		internal var lastBtn:MovieClip;
		private var _tabsSwitch:TabsSwitch;
		private var _unlock:UIUnlockHandler;
		
		public function PanelDailyMouseHandle(panel:PanelDaily)
		{
			_panel = panel;
			_skin = _panel.skin as McDaily1;
			initialize();
		}
		
		private function initialize():void
		{
			_skin.addEventListener(MouseEvent.CLICK, onClick);
			var selectTab:int = DailyDataManager.instance.selectTab;
			_tabsSwitch = new TabsSwitch(_skin.mcTabLayer, Vector.<Class>([TabDailyPep, TabDailyActivity, TabDailyTaskDgn, TabDailyTaskDgn]));
		}
		
		private function onClick(event:MouseEvent):void
		{
			var manager:DailyDataManager = DailyDataManager.instance;
			switch (event.target)
			{
				case _skin.btnClose:
					dealClose();
					break;
				case _skin.btnTab0:
					dealBtnTab(manager.tabPep, _skin.btnTab0);
					break;
				case _skin.btnTab1:
					dealBtnTab(manager.tabActivity, _skin.btnTab1);
					break;
				case _skin.btnTab2:
					dealBtnTab(manager.tabTask, _skin.btnTab2);
					break;
				case _skin.btnTab3:
					dealBtnTab(manager.tabDgn, _skin.btnTab3);
					break;
				default:
					break;
			}
		}
		
		private function dealClose():void
		{
			PanelMediator.instance.closePanel(PanelConst.TYPE_DAILY);
		}
		
		private function dealBtnTab(index:int, nowBtn:MovieClip):void
		{
			DailyDataManager.instance.selectTab = index;
			_tabsSwitch.onClick(index);
			//
			lastBtn.selected = false;
			lastBtn.mouseEnabled = true;
			(lastBtn.txt as TextField).textColor = 0xd4a460;
			nowBtn.selected = true;
			nowBtn.mouseEnabled = false;
			(nowBtn.txt as TextField).textColor = 0xffe1aa;
			lastBtn = nowBtn;
		}
		
		public function switchToTab(index:int):void
		{
			var mc:MovieClip = getTab(index);
			dealBtnTab(index, mc);
		}
		
		private function getTab(index:int):MovieClip
		{
			var manager:DailyDataManager = DailyDataManager.instance;
			switch (index)
			{
				case manager.tabPep:
					return _skin.btnTab0;
				case manager.tabActivity:
					return _skin.btnTab1;
				case manager.tabTask:
					return _skin.btnTab2;
				case manager.tabDgn:
					return _skin.btnTab3;
			}
			return _skin.btnTab0;
		}
		
		internal function destroy():void
		{
			if (_tabsSwitch)
			{
				_tabsSwitch.destroy();
				_tabsSwitch = null;
			}
			if (_skin)
			{
				_skin.removeEventListener(MouseEvent.CLICK, onClick);
				_skin = null;
			}
			_panel = null;
		}
	}
}