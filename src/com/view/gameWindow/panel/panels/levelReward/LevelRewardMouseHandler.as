package com.view.gameWindow.panel.panels.levelReward
{
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;

    import flash.events.MouseEvent;
    import flash.utils.clearTimeout;
    import flash.utils.setTimeout;

    /**
     * Created by Administrator on 2014/12/8.
     */
    public class LevelRewardMouseHandler
    {
        private var _panel:PanelLevelReward;
        private var _skin:McLevelReward;
        private var _timeId:int = 0;
        private var _delayTime:int = 10000;
        private var _isDoing:Boolean = false;
        public function LevelRewardMouseHandler(panel:PanelLevelReward)
        {
            _panel = panel;
            _skin = _panel.skin as McLevelReward;
            _skin.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
            _timeId = setTimeout(onTimer, _delayTime);
        }

        private function onTimer():void
        {
            if (_isDoing) return;
            clearTimeout(_timeId);
            _isDoing = true;
            handlerClick();
        }
        private function onClick(event:MouseEvent):void
        {
            switch (event.target)
            {
                case _skin.mcBtn:
                    onTimer();
                    break;
                default :
                    break;
            }
        }

        private function handlerClick():void
        {
            var index:int = LevelRewardDataManager.instance.rewardIndex;
            LevelRewardDataManager.instance.sendGetReward(index + 1);
            PanelMediator.instance.closePanel(PanelConst.TYPE_LEVEL_REWARD);
            LevelRewardDataManager.dataIsLoaded = false;
        }

        public function destroy():void
        {
            clearTimeout(_timeId);
            if (_skin)
            {
                _skin.removeEventListener(MouseEvent.CLICK, onClick);
                _skin = null;
            }
        }
    }
}
