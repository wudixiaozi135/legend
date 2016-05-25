package com.view.gameWindow.panel.panels.stall.log
{
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.panel.panelbase.PanelBase;
    import com.view.gameWindow.panel.panels.McStallLog;

    import flash.display.MovieClip;

    /**
     * Created by Administrator on 2015/1/19.
     */
    public class PanelStallLog extends PanelBase
    {
        private var _viewHandler:StallLogViewHandler;
        private var _mouseHandler:StallLogMouseHandler;

        public function PanelStallLog()
        {
            super();
        }

        override protected function initSkin():void
        {
            _skin = new McStallLog();
            addChild(_skin);
            setTitleBar(_skin.dragBox);
        }

        override protected function initData():void
        {
            _viewHandler = new StallLogViewHandler(this);
            _mouseHandler = new StallLogMouseHandler(this);
        }

        override protected function addCallBack(rsrLoader:RsrLoader):void
        {
            var skin:McStallLog = _skin as McStallLog;
            rsrLoader.addCallBack(skin.mcScrollBar, function (mc:MovieClip):void
            {
                if (_viewHandler)
                {
                    _viewHandler.initScroll(mc);
                }
            });
        }

        override public function destroy():void
        {
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
