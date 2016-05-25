package com.view.gameWindow.panel.panels.boss
{
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.boss.canKill.TabCanKillBoss;
	import com.view.gameWindow.panel.panels.boss.classic.TabClassicBoss;
	import com.view.gameWindow.panel.panels.boss.individual.TabIndividualBoss;
	import com.view.gameWindow.panel.panels.boss.outside.TabOutsideBoss;
	import com.view.gameWindow.panel.panels.boss.vip.TabVipBoss;
	import com.view.gameWindow.util.tabsSwitch.TabsSwitch;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class PanelBossMouseHandle
	{
		public function PanelBossMouseHandle(panel:PanelBoss)
		{
			_panel = panel;
			_skin = _panel.skin as MCPanelBoss;
			init();
		}
		internal var lastBtn:MovieClip;
		private var _panel:PanelBoss;
		private var _skin:MCPanelBoss;
		private var _tabsSwitch:TabsSwitch;

		/**切换选项
		 * index 0，1，2
		 * */
		public function switchTabByIndex(index:int):void
		{
			dealBtnTab(index, _skin["btnTab" + index]);
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

		private function init():void
		{
			_skin.addEventListener(MouseEvent.CLICK, onClick);
			_tabsSwitch = new TabsSwitch(_skin.mcTabLayer, Vector.<Class>([TabCanKillBoss, TabOutsideBoss, TabIndividualBoss]));
			_tabsSwitch.onClick(0, false);
		}

		private function dealFirstBtn(index:int,nowBtn:MovieClip):void
		{

			nowBtn.selected = true;
			nowBtn.mouseEnabled = false;
			lastBtn = nowBtn;
		}

		private function dealBtnTab(index:int, nowBtn:MovieClip):void
		{
			BossDataManager.instance.selectTab = index;
			_tabsSwitch.onClick(index,true);
			if(!lastBtn)
				return;
			lastBtn.selected = false;
			lastBtn.mouseEnabled = true;
			(lastBtn.txt as TextField).textColor = 0xd4a460;
			nowBtn.selected = true;
			nowBtn.mouseEnabled = false;
			(nowBtn.txt as TextField).textColor = 0xffe1aa;
			lastBtn = nowBtn;
		}

		private function onClick(e:MouseEvent):void
		{
			switch (e.target)
			{
				case _skin.btnClose:
					PanelMediator.instance.closePanel(PanelConst.TYPE_BOSS);
					break;

				case _skin.btnTab0:
					dealBtnTab(0, _skin.btnTab0);
					break;
				case _skin.btnTab1:
					dealBtnTab(1, _skin.btnTab1);
					break;
				case _skin.btnTab2:
					dealBtnTab(2, _skin.btnTab2);
					break;
				/*case _skin.btnTab3:
					dealBtnTab(3, _skin.btnTab3);
					break;*/
				/*case _skin.btnTab4:
					dealBtnTab(4, _skin.btnTab4);
					break;*/


			}
		}
	}
}