package com.view.gameWindow.panel.panels.stall.stallSell
{
    import com.model.consts.StringConst;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panelbase.IPanelBase;
    import com.view.gameWindow.panel.panels.McStallSell;
    import com.view.gameWindow.panel.panels.bag.BagData;
    import com.view.gameWindow.panel.panels.mall.constant.ResIconType;
    import com.view.gameWindow.panel.panels.mall.mallItem.CostType;
    import com.view.gameWindow.panel.panels.stall.StallDataManager;
    import com.view.gameWindow.tips.rollTip.RollTipMediator;
    import com.view.gameWindow.tips.rollTip.RollTipType;

    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.text.TextField;

    /**
     * Created by Administrator on 2015/1/19.
     */
    public class StallSellMouseHandler
    {
        private var _panel:PanelStallSell;
        private var _skin:McStallSell;

        private var _lastRadio:MovieClip;
        private var _lastRadioTxt:TextField;
        private var _costType:int;

        public function StallSellMouseHandler(panel:PanelStallSell)
        {
            _panel = panel;
            _skin = _panel.skin as McStallSell;
            _skin.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
            _skin.txtInput.addEventListener(Event.CHANGE, onChange, false, 0, true);
            _skin.addEventListener(Event.ADDED_TO_STAGE, onStageEvt, false, 0, true);
        }

        private function onStageEvt(event:Event):void
        {
            if (_panel.stage)
            {
                _panel.stage.focus != _skin.txtInput;
                _panel.stage.focus = _skin.txtInput;
            }
            _skin.removeEventListener(Event.ADDED_TO_STAGE, onStageEvt);
        }

        private function onChange(event:Event):void
        {
            if (_skin.txtInput.text.length > 9)
            {
                _skin.txtInput.text = _skin.txtInput.text.substring(0, 9);
            }
        }

        private function onClick(event:MouseEvent):void
        {
            switch (event.target)
            {
                case _skin.btnClose:
                    closeHandler();
                    break;
                case _skin.radioBtn1:
                    dealRadio(_skin.radioBtn1, _skin.radioBtn1Txt, 1);
                    break;
                case _skin.radioBtn2:
                    dealRadio(_skin.radioBtn2, _skin.radioBtn2Txt, 2);
                    break;
                case _skin.btnStall:
                    restock();
                    break;
                default :
                    break;
            }
        }

        /**物品上架*/
        private function restock():void
        {
            var bagData:BagData = StallSellDataManager.bagData;
            var costValue:int = parseInt(_skin.txtInput.text);
            if (bagData)
            {
                if (costValue <= 0)
                {
                    RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.STALL_PANEL_0017);
                    return;
                }
                StallDataManager.instance.sendDragItemToStall(bagData.storageType, bagData.slot, bagData.count, _costType, costValue);
            }
        }

        private function dealRadio(mc:MovieClip, txt:TextField, type:int):void
        {
            if (_lastRadio)
            {
                _lastRadio.selected = false;
            }
            if (_lastRadioTxt)
            {
                _lastRadioTxt.textColor = 0xd4a460;
            }

            _lastRadio = mc;
            _lastRadio.selected = true;
            _lastRadioTxt = txt;
            _lastRadioTxt.textColor = 0xffcc00;

            _costType = type;
            updateIcon(_costType);
        }

        private function updateIcon(type:int):void
        {
            var costIcon:CostType = null;
            if (type == 1)
            {//金币
                costIcon = new CostType(ResIconType.TYPE_MONEY);
            } else if (type == 2)
            {//元宝
                costIcon = new CostType(ResIconType.TYPE_GOLD);
            }
            if (costIcon)
            {
                clearIcon();
                _skin.costContainer.addChild(costIcon);
            }
        }

        /**
         * @param type
         * 1 金币
         * 2 元宝
         * */
        public function setSelect(mc:MovieClip, txt:TextField, type:int):void
        {
            _lastRadio = mc;
            _lastRadioTxt = txt;
            dealRadio(_lastRadio, _lastRadioTxt, type);
        }

        private function closeHandler():void
        {
            PanelMediator.instance.closePanel(PanelConst.TYPE_STALL_SELL);
            var bagPanel:IPanelBase = PanelMediator.instance.openedPanel(PanelConst.TYPE_BAG);
            bagPanel.update();
        }

        private function clearIcon():void
        {
            if (_skin.costContainer)
            {
                while (_skin.costContainer.numChildren > 0)
                {
                    _skin.costContainer.removeChildAt(0);
                }
            }
        }

        public function destroy():void
        {
            if (_skin)
            {
                _skin.removeEventListener(Event.ADDED_TO_STAGE, onStageEvt);
                _skin.txtInput.removeEventListener(Event.CHANGE, onChange);
                _skin.removeEventListener(MouseEvent.CLICK, onClick);
                clearIcon();
                if (_panel.stage)
                {
                    _panel.stage.focus = null;
                }
            }
        }
    }
}
