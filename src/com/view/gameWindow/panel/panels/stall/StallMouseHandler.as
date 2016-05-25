package com.view.gameWindow.panel.panels.stall
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.consts.StringConst;
    import com.pattern.Observer.IObserver;
    import com.view.gameWindow.common.Alert;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panels.McStallPanel;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
    import com.view.gameWindow.tips.rollTip.RollTipMediator;
    import com.view.gameWindow.tips.rollTip.RollTipType;

    import flash.events.MouseEvent;

    /**
     * Created by Administrator on 2015/1/19.
     */
    public class StallMouseHandler implements IObserver
    {
        private var _panel:PanelStall;
        private var _skin:McStallPanel;

        public function StallMouseHandler(panel:PanelStall)
        {
            _panel = panel;
            _skin = _panel.skin as McStallPanel;
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
                case _skin.btnStall:
                    handlerStall();
                    break;
                case _skin.btnLog:
                    viewLog();
                    break;
                default :
                    break;
            }
        }

        /**查看日志*/
        private function viewLog():void
        {
            StallDataManager.instance.sendQueryLog();
            PanelMediator.instance.switchPanel(PanelConst.TYPE_STALL_LOG);
        }

        /**开始摆摊*/
        private function handlerStall():void
        {
            if (_skin.txtStall.text == StringConst.STALL_PANEL_0004)
            {
                if (StallDataManager.instance.selfInfos.length > 0)
                {
                    StallDataManager.instance.startStall();
                } else
                {
                    RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.STALL_PANEL_0026);
                }
            } else
            {
                closeHandler();
            }
        }

        /*关闭界面*/
        private function closeHandler():void
        {
            if (RoleDataManager.instance.stallStatue)
            {
                if (StallDataManager.instance.selfInfos.length > 0)
                {
                    Alert.show2(StringConst.STALL_PANEL_0024, function ():void
                    {
                        StallDataManager.instance.stopStall();
                    }, null, StringConst.PROMPT_PANEL_0012, StringConst.PROMPT_PANEL_0013);
                } else
                {
                    PanelMediator.instance.closePanel(PanelConst.TYPE_STALL_PANEL);
                }
            } else
            {
                StallDataManager.instance.stopStall();
            }
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
            StallDataManager.instance.detach(this);
            if (_skin)
            {
                _skin.removeEventListener(MouseEvent.CLICK, onClick);
            }
        }

    }
}
