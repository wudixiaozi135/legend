package com.view.gameWindow.panel.panels.stall.stallBuy
{
    import com.model.consts.StringConst;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panels.McStallBuy;
    import com.view.gameWindow.panel.panels.bag.BagDataManager;
    import com.view.gameWindow.panel.panels.stall.StallDataManager;
    import com.view.gameWindow.panel.panels.stall.data.StallDataInfo;
    import com.view.gameWindow.tips.rollTip.RollTipMediator;
    import com.view.gameWindow.tips.rollTip.RollTipType;

    import flash.events.MouseEvent;

    /**
     * Created by Administrator on 2015/1/19.
     */
    public class StallBuyMouseHandler
    {

        private var _panel:PanelStallBuy;
        private var _skin:McStallBuy;

        public function StallBuyMouseHandler(panel:PanelStallBuy)
        {
            _panel = panel;
            _skin = _panel.skin as McStallBuy;
            _skin.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        }

        private function onClick(event:MouseEvent):void
        {
            switch (event.target)
            {
                case _skin.btnBuy:
                    buyHandler();
                    break;
                case _skin.btnCancel:
                    cancelHandler();
                    break;
                default :
                    break;
            }
        }

        private function cancelHandler():void
        {
            PanelMediator.instance.closePanel(PanelConst.TYPE_STALL_BUY);
        }

        private function buyHandler():void
        {
            var data:StallDataInfo = StallBuyDataManager.bagData;
            if (data)
            {
                if (data.cost_type == StallDataManager.COST_GOLD_TYPE)
                {
                    if (BagDataManager.instance.goldUnBind < data.cost)
                    {
                        RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.TIP_GOLD_NOT_ENOUGH);
                        return;
                    }
                } else
                {
                    if (BagDataManager.instance.coinUnBind < data.cost)
                    {
                        RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.TIP_COIN_NOT_ENOUGH);
                        return;
                    }
                }
                var cid:int = StallDataManager.instance.other_Cid;
                var sid:int = StallDataManager.instance.other_Sid;
                StallDataManager.instance.sendBuyData(cid, sid, data.item_id, data.born_sid, data.item_type, data.item_count, data.cost_type, data.cost);
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
