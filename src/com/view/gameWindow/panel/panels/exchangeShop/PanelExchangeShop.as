package com.view.gameWindow.panel.panels.exchangeShop
{
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.mainUi.MainUiMediator;
    import com.view.gameWindow.mainUi.subclass.McExchangeShop;
    import com.view.gameWindow.mainUi.subuis.stoneShop.ExchangeShopIcon;
    import com.view.gameWindow.panel.panelbase.PanelBase;

    import flash.display.MovieClip;
    import flash.geom.Point;

    /**
     * Created by Administrator on 2015/3/12.
     */
    public class PanelExchangeShop extends PanelBase
    {
        private var _mouseHandler:ExchangeShopMouseHandler;
        private var _viewHandler:ExchangeShopViewHandler;

        public function PanelExchangeShop()
        {
            super();
        }

        override protected function initSkin():void
        {
            _skin = new McExchangeShopPanel();
            addChild(_skin);
            setTitleBar(_skin.dragBox);
        }

        override public function setPostion():void
        {
            var mc:McExchangeShop = (MainUiMediator.getInstance().exchangeShop as ExchangeShopIcon).skin as McExchangeShop;
            if (mc)
            {
                var popPoint:Point = mc.localToGlobal(new Point(mc.bg.x,mc.bg.y+mc.bg.height*.5));
                isMount(true, popPoint.x, popPoint.y);
            } else
            {
                isMount(true);
            }
        }

        override protected function initData():void
        {
            _mouseHandler = new ExchangeShopMouseHandler(this);
            _viewHandler = new ExchangeShopViewHandler(this);
        }

        override protected function addCallBack(rsrLoader:RsrLoader):void
        {
            var skin:McExchangeShopPanel = _skin as McExchangeShopPanel;
            rsrLoader.addCallBack(skin.btnRefresh, function (mc:MovieClip):void
            {
                if (_viewHandler)
                {
                    _viewHandler.updateTips();
                }
            });
        }

        override public function destroy():void
        {
            ExchangeShopDataManager.buyItemBmp = null;
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
            super.destroy();
        }
    }
}
