package com.view.gameWindow.panel.panels.exchangeShop
{
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.VipCfgData;
    import com.model.consts.StringConst;
    import com.model.consts.ToolTipConst;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panels.bag.BagDataManager;
    import com.view.gameWindow.panel.panels.exchangeShop.data.ExchangeCostType;
    import com.view.gameWindow.panel.panels.vip.VipDataManager;
    import com.view.gameWindow.tips.rollTip.RollTipMediator;
    import com.view.gameWindow.tips.rollTip.RollTipType;
    import com.view.gameWindow.tips.toolTip.TipVO;
    import com.view.gameWindow.tips.toolTip.ToolTipManager;
    import com.view.gameWindow.util.HtmlUtils;

    import flash.events.MouseEvent;

    import mx.utils.StringUtil;

    /**
     * Created by Administrator on 2015/3/12.
     */
    public class ExchangeShopMouseHandler
    {

        private var _panel:PanelExchangeShop;
        private var _skin:McExchangeShopPanel;
        private var _tipVo:TipVO;

        public function ExchangeShopMouseHandler(panel:PanelExchangeShop)
        {
            _panel = panel;
            _skin = _panel.skin as McExchangeShopPanel;
            _skin.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);

            _tipVo = new TipVO();
            _tipVo.tipType = ToolTipConst.TEXT_TIP;
            _tipVo.tipData = getTipVo();
            ToolTipManager.getInstance().hashTipInfo(_skin.txtVip, _tipVo);
            ToolTipManager.getInstance().attach(_skin.txtVip);

            ToolTipManager.getInstance().attachByTipVO(_skin.mcGold, ToolTipConst.TEXT_TIP, HtmlUtils.createHtmlStr(0xffcc00, StringConst.MALL_COST_TYPE_1));
        }

        private function onClick(event:MouseEvent):void
        {
            switch (event.target)
            {
                case _skin.btnClose:
                    closeHandler();
                    break;
                case _skin.btnRefresh:
                    handlerRefresh();
                    break;
                default :
                    break;
            }
        }

        private function handlerRefresh():void
        {
            var mgt:ExchangeShopDataManager = ExchangeShopDataManager.instance;
            var isTodayFree:Boolean = mgt.checkHasFreeRefreshCount();
            if (isTodayFree)
            {
                var gold:int = 0;
                var costType:int = mgt.stoneExchangeShop.cost_type;
                if (costType == ExchangeCostType.COST_GOLD)
                {
                    gold = BagDataManager.instance.coinUnBind;
                } else if (costType == ExchangeCostType.COST_MEDAL)
                {
                    gold = BagDataManager.instance.goldUnBind;
                } else if (costType == ExchangeCostType.COST_TICKET)
                {
                    gold = BagDataManager.instance.goldBind;
                }
                if (gold < mgt.stoneExchangeShop.cost)
                {
                    RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringUtil.substitute(StringConst.EXCHANGE_SHOP_0018, mgt.getCostStr(mgt.stoneExchangeShop.cost_type)));
                    return;
                }
                ExchangeShopDataManager.instance.sendRefresh();
            } else
            {
                RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.EXCHANGE_SHOP_0014);
            }
        }

        private function closeHandler():void
        {
            PanelMediator.instance.closePanel(PanelConst.TYPE_EXCHANGE_SHOP);
        }

        private function getTipVo():String
        {
            var cfg:VipCfgData, mgt:VipDataManager = VipDataManager.instance, mgt2:ConfigDataManager = ConfigDataManager.instance;
            var tip:String = HtmlUtils.createHtmlStr(0xd4a460, StringUtil.substitute(StringConst.PRAY_TIP_1, mgt.lv)) + "<br>";
            tip += HtmlUtils.createHtmlStr(0xd4a460, StringConst.PRAY_TIP_2) + "<br>";
            for (var i:int = 1; i <= VipDataManager.MAX_LV; i++)
            {
                cfg = mgt2.vipCfgData(i);
                tip += HtmlUtils.createHtmlStr(0xffffff, StringUtil.substitute(StringConst.EXCHANGE_SHOP_007, i, cfg.add_refresh_num));
                tip += "<br>";
            }
            return tip;
        }

        public function destroy():void
        {
            if (_tipVo)
            {
                _tipVo = null;
            }
            if (_skin)
            {
                ToolTipManager.getInstance().detach(_skin.txtVip);
                ToolTipManager.getInstance().detach(_skin.mcGold);
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
