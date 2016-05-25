package com.view.gameWindow.panel.panels.specialRing
{
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.guideSystem.GuideSystem;
	import com.view.gameWindow.panel.panels.guideSystem.unlock.UnlockFuncId;
	import com.view.gameWindow.panel.panels.guideSystem.unlock.UnlockObserver;
	import com.view.gameWindow.panel.panels.specialRing.dungeon.TabSpecialRingDungeon;
	import com.view.gameWindow.panel.panels.specialRing.upgrade.TabSpecialRingUpgrade;
	import com.view.gameWindow.util.tabsSwitch.TabBase;
	import com.view.gameWindow.util.tabsSwitch.TabsSwitch;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * 特戒面板鼠标相关处理类
	 * @author Administrator
	 */	
	internal class PanelSpecialRingMouseHandle
	{
		private var _panel:PanelSpecialRing;
		private var _skin:McSpecialRing;
		internal var lastBtn:MovieClip;
		private var _tabsSwitch:TabsSwitch;
		private var _guide:GuideSystem;
		private var _unlockObserver:UnlockObserver;
		
		public function PanelSpecialRingMouseHandle(panel:PanelSpecialRing)
		{
			_panel = panel;
			_skin = _panel.skin as McSpecialRing;
			init();
		}
		
		private function checkTabBtnVisible(id:int):void
		{
			if(id == UnlockFuncId.SPECIAL_RING_DGN)
			{
				_skin.btnDungeon.visible = _guide.isUnlock(UnlockFuncId.SPECIAL_RING_DGN);
			}
		}
		
		private function init():void
		{
			//_skin.addEventListener(MouseEvent.CLICK,onClick);
			//新手引导改成这样 关闭事件后触发
			_panel.addEventListener(MouseEvent.CLICK,onClick);
			var selectTab:int = SpecialRingDataManager.instance.selectTab;
			_tabsSwitch = new TabsSwitch(_skin.mcLayer,Vector.<Class>([TabSpecialRingUpgrade,TabSpecialRingDungeon]),selectTab);
			
			
			//开启状态
			_guide = GuideSystem.instance;
			_unlockObserver = new UnlockObserver();
			_unlockObserver.setCallback(checkTabBtnVisible);
			GuideSystem.instance.unlockStateNotice.attach(_unlockObserver);
			checkTabBtnVisible(UnlockFuncId.SPECIAL_RING_DGN);
		}
		
		private function onClick(event:MouseEvent):void
		{
			if(!_skin)
			{
				return;
			}
			switch(event.target)
			{
				case _skin.btnClose:
					dealClose();
					break;
				case _skin.btnUpgrade:
					dealUpgrade();
					break;
				case _skin.btnDungeon:
					dealDungeon();
					break;
				default:
					break;
			}
		}
		
		private function dealClose():void
		{
			PanelMediator.instance.closePanel(PanelConst.TYPE_SPECIAL_RING);
		}
		
		private function dealUpgrade():void
		{
			_tabsSwitch.onClick(0);
			setBtnState(_skin.btnUpgrade);
		}
		
		private function dealDungeon():void
		{
			_tabsSwitch.onClick(1);
			setBtnState(_skin.btnDungeon);
		}
		
		private function setBtnState(nowBtn:MovieClip):void
		{
			lastBtn.selected = false;
			lastBtn.mouseEnabled = true;
			(lastBtn.txt as TextField).textColor = 0xd4a460;
			nowBtn.selected = true;
			nowBtn.mouseEnabled = false;
			(nowBtn.txt as TextField).textColor = 0xffe1aa;
			lastBtn = nowBtn;
		}
		/**
		 * 获取当前标签页
		 * @return 
		 */
		public function get tab():TabBase
		{
			return _tabsSwitch.tab;
		}
		
		public function get tabIndex():int
		{
			return _tabsSwitch.index;
		}
		
		public function set tabIndex(value:int):void
		{
			if(value == 1)
			{
				dealUpgrade();
			}
			else
			{
				dealDungeon();
			}
		}
		
		internal function destroy():void
		{
			if(_unlockObserver)
			{
				GuideSystem.instance.unlockStateNotice.attach(_unlockObserver);
				_unlockObserver.destroy();
				_unlockObserver = null;
			}
			
			if(_tabsSwitch)
			{
				_tabsSwitch.destroy();
				_tabsSwitch = null;
			}
			if(_skin)
			{
//				_skin.removeEventListener(MouseEvent.CLICK,onClick);
				_skin = null;
			}
			
			if(_panel)
			{
				_panel.removeEventListener(MouseEvent.CLICK,onClick);
				_panel = null;
			}
		}
	}
}