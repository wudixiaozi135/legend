package com.view.gameWindow.panel.panels.stall.stallBuy
{
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.panel.panelbase.PanelBase;
    import com.view.gameWindow.panel.panels.McStallBuy;

    /**
     * Created by Administrator on 2015/1/19.
     */
    public class PanelStallBuy extends PanelBase
    {
        private var _mouseHandler:StallBuyMouseHandler;
        private var _viewHandler:StallBuyViewHandler;

        public function PanelStallBuy()
        {
            super();
        }


        override protected function initSkin():void
        {
            _skin = new McStallBuy();
            addChild(_skin);
        }


        override protected function initData():void
        {
            _mouseHandler = new StallBuyMouseHandler(this);
            _viewHandler = new StallBuyViewHandler(this);
        }


        override protected function addCallBack(rsrLoader:RsrLoader):void
        {
            super.addCallBack(rsrLoader);
        }


        override public function destroy():void
        {
            StallBuyDataManager.bagData = null;
            if (_viewHandler)
            {
                _viewHandler.destroy();
                _viewHandler = null;
            }
            if (_mouseHandler)
            {
                _mouseHandler.destroy();
                _mouseHandler = null;
            }
            super.destroy();
        }
    }
}
