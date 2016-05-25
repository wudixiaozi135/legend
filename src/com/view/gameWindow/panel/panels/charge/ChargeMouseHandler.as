package com.view.gameWindow.panel.panels.charge
{
    import com.model.consts.StringConst;
    import com.view.gameWindow.common.Alert;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.util.JsUtils;

    import flash.events.MouseEvent;

    /**
     * Created by Administrator on 2015/2/11.
     */
    public class ChargeMouseHandler
    {
        private var _panel:PanelCharge;
        private var _skin:McCharge;

        public function ChargeMouseHandler(panel:PanelCharge)
        {
            _panel = panel;
            _skin = _panel.skin as McCharge;
            _skin.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        }

        private function onClick(event:MouseEvent):void
        {
            switch (event.target)
            {
                case _skin.closeBtn:
                    closeHandler();
                    break;
                case _skin.btnGet:
                    handlerGet();
                    break;
                case _skin.btnPlay:
                    handlerPlay();
                    break;
                default :
                    break;
            }
        }

        private function handlerGet():void
        {
            var dataManager:ChargeDataManager = ChargeDataManager.instance;
            var alreadyChargeCount:int = dataManager.alreadyChargeCount;
            if (alreadyChargeCount <= 0)
            {
                Alert.show2(StringConst.MALL_GET_GOLD_TIP3, function ():void
                {
                    PanelMediator.instance.openPanel(PanelConst.TYPE_MALL);
                });
            } else
            {
                ChargeDataManager.instance.sendGetReward();
            }
        }

        private function handlerPlay():void
        {
            //打开充值页面
            JsUtils.callRecharge();
        }

        private function closeHandler():void
        {
            PanelMediator.instance.closePanel(PanelConst.TYPE_CHARGE_PANEL);
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
