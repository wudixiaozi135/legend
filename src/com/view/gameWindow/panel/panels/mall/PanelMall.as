package com.view.gameWindow.panel.panels.mall
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.mainUi.MainUiMediator;
    import com.view.gameWindow.mainUi.subclass.McMainUIBottom;
    import com.view.gameWindow.mainUi.subuis.bottombar.BottomBar;
    import com.view.gameWindow.panel.panelbase.IPanelPage;
    import com.view.gameWindow.panel.panelbase.IPanelTab;
    import com.view.gameWindow.panel.panelbase.PanelBase;
    import com.view.gameWindow.panel.panels.bag.BagDataManager;

    import flash.geom.Point;
    import flash.geom.Rectangle;

    /**
	 * Created by Administrator on 2014/11/19.
	 */
	public class PanelMall extends PanelBase implements IPanelMall,IPanelTab,IPanelPage
	{
		public function PanelMall()
		{
			super();
			BagDataManager.instance.attach(this);
		}
		
		private var _callBackHandler:MallCallBackHandler;

		public function get callBackHandler():MallCallBackHandler
		{
			return _callBackHandler;
		}
		
		private var _mouseHandler:MallMouseHandler;

		public function get mouseHandler():MallMouseHandler
		{
			return _mouseHandler;
		}
		
		private var _viewHandler:MallViewHandler;

		public function get viewHandler():MallViewHandler
		{
			return _viewHandler;
		}

		override public function setPostion():void
		{
            var mc:McMainUIBottom = (MainUiMediator.getInstance().bottomBar as BottomBar).skin as McMainUIBottom;
            if (mc)
            {
                var popPoint:Point = mc.localToGlobal(new Point(mc.shopBtn.x, mc.shopBtn.y));
                isMount(true, popPoint.x, popPoint.y);
            } else
            {
                isMount(true);
            }
		}

		override public function update(proc:int = 0):void
		{
			switch (proc)
			{
				default :
					break;
				case GameServiceConstants.SM_BAG_ITEMS:
					_viewHandler.refresh();
                    _callBackHandler.updateEffect();
					break;
			}
		}

		override public function initView():void
		{
			super.initView();
		}

		override protected function initSkin():void
		{
			_skin = new McMallPanel();
			var mcMall:McMallPanel = _skin as McMallPanel;
			addChild(mcMall);
			setTitleBar(mcMall.dragBox);
		}

		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			_callBackHandler = new MallCallBackHandler(this, rsrLoader);
		}

		override protected function initData():void
		{
			_viewHandler = new MallViewHandler(this);
			_mouseHandler = new MallMouseHandler(this);
		}

		private var _tabIndex:int = -1;
		public function getTabIndex():int
		{
			return _tabIndex;
		}

		/**
		 * index 对应 MallTabType 0-9()
		 * 跳转某个选项
		 * */
		public function setTabIndex(index:int):void
		{
			_tabIndex = index;
            MallDataManager.defaultIndex = _tabIndex;
		}

		override public function setSelectTabShow(tabIndex:int = -1):void
		{
			setTabIndex(tabIndex);
		}
		
		public function getPageIndex():int
		{
			return MallDataManager.currentPage - 1;
		}
		
		public function setPageIndex(page:int):void
		{
			MallDataManager.currentPage = page + 1;
            MallDataManager.defaultPage = page + 1;
		}

        override public function getPanelRect():Rectangle
        {
            return new Rectangle(0, 0, _skin.bg.width, _skin.bg.height);
        }

        override public function destroy():void
		{
			BagDataManager.instance.detach(this);
			MallDataManager.instance.selectIndex = 0;
            MallDataManager.defaultPage = 0;
            MallDataManager.defaultIndex = 0;
			MallDataManager.lastTab = null;
			MallDataManager.currentPage = 1;
			if (_callBackHandler != null)
			{
				_callBackHandler.destroy();
				_callBackHandler = null;
			}
			if (_mouseHandler != null)
			{
				_mouseHandler.destroy();
				_mouseHandler = null;
			}
			if (_viewHandler != null)
			{
				_viewHandler.destroy();
				_viewHandler = null;
			}
			if (_skin != null)
			{
				_skin = null;
			}
			super.destroy();
		}
	}
}
