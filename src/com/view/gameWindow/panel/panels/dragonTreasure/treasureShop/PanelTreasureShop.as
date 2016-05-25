package com.view.gameWindow.panel.panels.dragonTreasure.treasureShop
{
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panelbase.IPanelTab;
	import com.view.gameWindow.panel.panelbase.PanelBase;

	/**
	 * Created by Administrator on 2014/12/2.
	 */
	public class PanelTreasureShop extends PanelBase implements IPanelTab
	{
		private var _viewHandler:TreasureShopViewHandler;
		private var _mouseHandler:TreasureShopMouseHandler;
		private var _callBackHandler:TreasureShopCallBack;
		
		public function getTabIndex():int
		{
			return TreasureShopManager.selectIndex;
		}
		
		public function setTabIndex(index:int):void
		{
			TreasureShopManager.selectIndex = index;
			mouseHandler.switchRefresh();
		}
		
		
		public function PanelTreasureShop()
		{
			super();
		}

		override protected function initSkin():void
		{
			_skin = new McTreasureShop();
			addChild(_skin);
			setTitleBar(_skin.dragBox);
		}

		override protected function initData():void
		{
			_viewHandler = new TreasureShopViewHandler(this);
			_mouseHandler = new TreasureShopMouseHandler(this);
		}

		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			_callBackHandler = new TreasureShopCallBack(this, rsrLoader);
		}

		public function get viewHandler():TreasureShopViewHandler
		{
			return _viewHandler;
		}

		public function get mouseHandler():TreasureShopMouseHandler
		{
			return _mouseHandler;
		}

		public function get callBackHandler():TreasureShopCallBack
		{
			return _callBackHandler;
		}

		override public function destroy():void
		{
			TreasureShopManager.selectIndex = 0;
			TreasureShopManager.lastMc = null;
			TreasureShopManager.currentPage = 1;

			if (_mouseHandler)
			{
				_mouseHandler.destroy();
				_mouseHandler = null;
			}
			if (_viewHandler)
			{
				_viewHandler.destroy();
				_viewHandler = null;
			}
			if (_callBackHandler)
			{
				_callBackHandler.destory();
				_callBackHandler = null;
			}
			super.destroy();
		}

	}
}
