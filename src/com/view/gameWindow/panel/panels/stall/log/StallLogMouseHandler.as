package com.view.gameWindow.panel.panels.stall.log
{
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panels.McStallLog;

    import flash.events.MouseEvent;

    /**
     * Created by Administrator on 2015/1/19.
     */
    public class StallLogMouseHandler
    {
        private var _panel:PanelStallLog;
        private var _skin:McStallLog;

        public function StallLogMouseHandler(panel:PanelStallLog)
        {
            _panel = panel;
            _skin = _panel.skin as McStallLog;
            _skin.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        }

        private function onClick(event:MouseEvent):void
        {
            switch (event.target)
            {
                case _skin.btnClose:
                    closeHandler();
                    break;
                default :
                    break;
            }
        }

        private function closeHandler():void
        {
            PanelMediator.instance.closePanel(PanelConst.TYPE_STALL_LOG);
        }

        public function destroy():void
        {
            if (_skin)
            {
                _skin.removeEventListener(MouseEvent.CLICK, onClick);
            }
        }
    }
}
