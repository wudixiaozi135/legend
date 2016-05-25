package com.view.gameWindow.panel.panels.dragonTreasure.treasureShop
{
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panels.dragonTreasure.constant.TreasureShopTabType;
    import com.view.gameWindow.panel.panels.dragonTreasure.treasureShop.tab.TabActivity;
    import com.view.gameWindow.panel.panels.dragonTreasure.treasureShop.tab.TabPosition;
    import com.view.gameWindow.panel.panels.dragonTreasure.treasureShop.tab.TabUsual;
    import com.view.gameWindow.util.tabsSwitch.TabsSwitch;

    import flash.display.MovieClip;
    import flash.events.MouseEvent;

    /**
	 * Created by Administrator on 2014/12/2.
	 */
	public class TreasureShopMouseHandler
	{
		private var _panel:PanelTreasureShop;
		private var _skin:McTreasureShop;
		private var _tabSwitch:TabsSwitch;

		public function TreasureShopMouseHandler(panel:PanelTreasureShop)
		{
			_panel = panel;
			_skin = _panel.skin as McTreasureShop;
			_skin.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
			_tabSwitch = new TabsSwitch(_skin.container, Vector.<Class>([TabUsual, TabPosition, TabActivity]));
            _skin.container.mouseEnabled = false;
		}

		private function onClick(event:MouseEvent):void
		{
			switch (event.target)
			{
				default :
					break;
				case _skin.btnClose:
					closeHandler();
					break;
				case _skin.tab0:
					dealTab(_skin.tab0, TreasureShopTabType.TBA_0);
					break;
				case _skin.tab1:
					dealTab(_skin.tab1, TreasureShopTabType.TBA_1);
					break;
				case _skin.tab2:
					dealTab(_skin.tab2, TreasureShopTabType.TBA_2);
					break;
				case _skin.btnLeft:
					turnLeft();
					break;
				case _skin.btnRight:
					turnRight();
					break;
			}
		}

		private function turnRight():void
		{
			var currentPage:int = TreasureShopManager.currentPage;
			var totalPage:int = TreasureShopManager.totalPage;
			if (currentPage < totalPage)
			{
				currentPage++;
			}
			TreasureShopManager.currentPage = currentPage;
			switchRefresh();
		}

		private function turnLeft():void
		{
			var currentPage:int = TreasureShopManager.currentPage;
			if (currentPage > 1)
			{
				currentPage--;
			}
			TreasureShopManager.currentPage = currentPage;
			switchRefresh();
		}

		public function switchRefresh():void
		{
			var selectIndex:int = TreasureShopManager.selectIndex;
			if (_tabSwitch)
			{
				_tabSwitch.onClick(selectIndex, true);
			}
		}


		private function dealTab(tab:MovieClip, index:int):void
		{
			var lastMc:MovieClip = TreasureShopManager.lastMc;
			if (lastMc)
			{
				lastMc.mouseEnabled = true;
				lastMc.selected = false;
				lastMc.txt.textColor = 0xd4a460;
			}
			tab.selected = true;
			tab.mouseEnabled = false;
			tab.txt.textColor = 0xffe1aa;

			lastMc = tab;
			TreasureShopManager.lastMc = lastMc;
			TreasureShopManager.selectIndex = index;
			TreasureShopManager.currentPage = 1;

			_tabSwitch.onClick(index, true);
		}

		private function closeHandler():void
		{
			PanelMediator.instance.closePanel(PanelConst.TYPE_DRAGON_TREASURE_SHOP);
		}

		public function destroy():void
		{
			if (_skin)
			{
				_skin.removeEventListener(MouseEvent.CLICK, onClick);
				_skin = null;
			}
			if (_tabSwitch)
			{
				_tabSwitch.destroy();
				_tabSwitch = null;
			}
			if (_panel)
			{
				_panel = null;
			}
		}
	}
}
