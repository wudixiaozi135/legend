package com.view.gameWindow.panel.panels.dragonTreasure.treasureRewardAlert
{
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;

    import flash.events.MouseEvent;

    /**
     * Created by Administrator on 2015/1/31.
     */
    public class TreasureRewardAlertMouseHandler
    {
        private var _panel:PanelTreasureRewardAlert;
        private var _skin:McRewardAlert;

        public function TreasureRewardAlertMouseHandler(panel:PanelTreasureRewardAlert)
        {
            _panel = panel;
            _skin = _panel.skin as McRewardAlert;
            _skin.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        }

        private function onClick(event:MouseEvent):void
        {
            switch (event.target)
            {
                case _skin.btnClose:
                case _skin.btnSure:
                    closeHandler();
                    break;
                default :
                    break;
            }
        }

        private function closeHandler():void
        {
            PanelMediator.instance.closePanel(PanelConst.TYPE_TREASURE_REWARD_ALERT);
        }

        public function destroy():void
        {
            if (_skin)
            {
                _skin.removeEventListener(MouseEvent.CLICK, onClick);
            }
            if (_panel)
            {
                _panel = null;
            }
        }
    }
}
