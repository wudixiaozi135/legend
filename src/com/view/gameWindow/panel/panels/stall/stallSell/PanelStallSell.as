package com.view.gameWindow.panel.panels.stall.stallSell
{
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.panel.panelbase.PanelBase;
    import com.view.gameWindow.panel.panels.McStallSell;
    import com.view.gameWindow.util.LoaderCallBackAdapter;

    /**
     * Created by Administrator on 2015/1/19.
     */
    public class PanelStallSell extends PanelBase
    {
        private var _viewHandler:StallSellViewHandler;
        private var _mouseHandler:StallSellMouseHandler;

        public function PanelStallSell()
        {
            super();

        }

        override protected function initSkin():void
        {
            _skin = new McStallSell();
            addChild(_skin);
            setTitleBar(_skin.mcTitleBar);
        }

        override protected function initData():void
        {
            _viewHandler = new StallSellViewHandler(this);
            _mouseHandler = new StallSellMouseHandler(this);
        }


        override protected function addCallBack(rsrLoader:RsrLoader):void
        {
            var skin:McStallSell = _skin as McStallSell;
            var loaderBack:LoaderCallBackAdapter = new LoaderCallBackAdapter();
            loaderBack.addCallBack(rsrLoader, function ():void
            {
                loaderBack = null;
                if (_mouseHandler)
                {
                    _mouseHandler.setSelect(skin.radioBtn1, skin.radioBtn1Txt, 1);
                }
            }, skin.radioBtn1, skin.radioBtn2);
        }

        override public function destroy():void
        {
            StallSellDataManager.bagData = null;
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
