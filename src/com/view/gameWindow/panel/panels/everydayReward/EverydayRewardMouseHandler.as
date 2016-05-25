package com.view.gameWindow.panel.panels.everydayReward
{
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.EveryDayRewardCfgData;
    import com.model.consts.StringConst;
    import com.view.gameWindow.common.Alert;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panels.bag.BagDataManager;
    import com.view.gameWindow.tips.rollTip.RollTipMediator;
    import com.view.gameWindow.tips.rollTip.RollTipType;
    import com.view.gameWindow.util.JsUtils;
    import com.view.gameWindow.util.SimpleStateButton;

    import flash.events.MouseEvent;
    import flash.events.TextEvent;

    /**
     * Created by Administrator on 2015/2/28.
     */
    public class EverydayRewardMouseHandler
    {

        private var _panel:PanelEverydayReward;
        private var _skin:McEveryReward;

        public function EverydayRewardMouseHandler(panel:PanelEverydayReward)
        {
            _panel = panel;
            _skin = _panel.skin as McEveryReward;
            _skin.addEventListener(MouseEvent.CLICK, onClickHandler, false, 0, true);
            SimpleStateButton.addLinkState(_skin.txtExtract, StringConst.MALL_LABEL_7, "extract");
            _skin.txtExtract.addEventListener(TextEvent.LINK, onLinkEvt, false, 0, true);
        }

        private function onLinkEvt(event:TextEvent):void
        {
            if (event.text == "extract")
            {
                var unExtractGold:int = BagDataManager.instance.unExtractGold;
                if (unExtractGold > 0)
                {
                    Alert.show2(StringConst.MALL_GET_GOLD_TIP, function ():void
                    {
                        BagDataManager.instance.sendExtraGold();
                    });
                } else
                {
                    RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.MALL_GET_GOLD_TIP1);
                }
            }
        }

        private function onClickHandler(event:MouseEvent):void
        {
            switch (event.target)
            {
                case _skin.btnClose:
                    closeHandler();
                    break;
                case _skin.btnGet:
                    handlerGet();
                    break;
                case _skin.btnPlay:
                    handlerCharge();
                    break;
                default :
                    break;
            }
        }

        private function handlerGet():void
        {
            var dataManager:EveryDayRewardDataManager = EveryDayRewardDataManager.instance;
            var getCount:int = dataManager.get_count;//领取次数
            var cfg:EveryDayRewardCfgData = ConfigDataManager.instance.everydayRewardCfg(getCount + 1);
            if (cfg)
            {
                var rewardPosition:int = EveryDayRewardDataManager.selectRewardIndex;
                if (rewardPosition > 0)
                {
                    dataManager.sendGetReward(getCount + 1, rewardPosition);
                }
            }
        }

        private function handlerCharge():void
        {
            JsUtils.callRecharge();
        }

        private function closeHandler():void
        {
            PanelMediator.instance.closePanel(PanelConst.TYPE_EVERYDAY_REWARD_PANEL);
        }

        public function destroy():void
        {
            if (_skin)
            {
                SimpleStateButton.removeState(_skin.txtExtract);
                _skin.removeEventListener(MouseEvent.CLICK, onClickHandler);
                _skin.txtExtract.removeEventListener(TextEvent.LINK, onLinkEvt);
                _skin = null;
            }
            if (_panel)
            {
                _panel = null;
            }
        }
    }
}
