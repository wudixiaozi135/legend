package com.view.gameWindow.panel.panels.loginReward
{
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;

    import flash.events.MouseEvent;

    /**
     * Created by Administrator on 2015/2/26.
     */
    public class LoginRewardMouseHandler
    {
        private var _panel:PanelLoginReward;
        private var _skin:McLoginReward;

        public function LoginRewardMouseHandler(panel:PanelLoginReward)
        {
            _panel = panel;
            _skin = _panel.skin as McLoginReward;
            _skin.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        }

        private function onClick(event:MouseEvent):void
        {
            switch (event.target)
            {
                case _skin.btnClose:
                    closeHandler();
                    break;
                case _skin.btnLeft:
                    turnLeft();
                    break;
                case _skin.btnRight:
                    turnRight();
                    break;
                case _skin.btnGet:
                    handlerGet();
                    break;
                default :
                    break;
            }
        }

        private function turnRight():void
        {
            var page:int = LoginRewardDataManager.currentPage;
            var total:int = LoginRewardDataManager.totalPage;
            if (page == total)
                return;
            if (page < total)
            {
                page++;
            }

            LoginRewardDataManager.currentPage = page;
            if (_panel.viewHandler)
            {
                _panel.viewHandler.updatePageBtns();
            }
        }

        private function turnLeft():void
        {
            var page:int = LoginRewardDataManager.currentPage;
            var total:int = LoginRewardDataManager.totalPage;
            if (page <= 1)
                return;

            if (page > 1)
            {
                page--;
            }
            LoginRewardDataManager.currentPage = page;
            if (_panel.viewHandler)
            {
                _panel.viewHandler.updatePageBtns();
            }
        }

        private function handlerGet():void
        {
            if (_panel.viewHandler)
            {
                _panel.viewHandler.storeBitmaps();
            }
            var selectDay:int = LoginRewardDataManager.selectDay;
            LoginRewardDataManager.instance.sendCM_FIFTEEN_REWARD_GET(selectDay);
        }

        private function closeHandler():void
        {
            PanelMediator.instance.closePanel(PanelConst.TYPE_LOGIN_REWARD_PANEL);
        }

        public function destroy():void
        {
            if (_skin)
            {
                _skin.removeEventListener(MouseEvent.CLICK, onClick);
                _skin = null;
            }
            if (_panel)
            {
                _panel = null;
            }
        }
    }
}
