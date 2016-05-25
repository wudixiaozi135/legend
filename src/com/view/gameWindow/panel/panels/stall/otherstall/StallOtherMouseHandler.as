package com.view.gameWindow.panel.panels.stall.otherstall
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.pattern.Observer.IObserver;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panels.McOtherStall;
    import com.view.gameWindow.panel.panels.stall.*;

    import flash.events.MouseEvent;

    /**
     * Created by Administrator on 2015/1/19.
     */
    public class StallOtherMouseHandler implements IObserver
    {
        private var _panel:PanelOtherStall;
        private var _skin:McOtherStall;

        public function StallOtherMouseHandler(panel:PanelOtherStall)
        {
            _panel = panel;
            _skin = _panel.skin as McOtherStall;
            _skin.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
            StallDataManager.instance.attach(this);
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

        /*关闭界面*/
        private function closeHandler():void
        {
            PanelMediator.instance.closePanel(PanelConst.TYPE_STALL_OTHER);
        }

        public function update(proc:int = 0):void
        {
            if (proc == GameServiceConstants.CM_STOP_SELL)
            {
                PanelMediator.instance.closePanel(PanelConst.TYPE_STALL_PANEL);
            }
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
