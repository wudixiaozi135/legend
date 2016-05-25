package com.view.gameWindow.panel.panels.wing
{
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.WingUpgradeCfgData;
    import com.model.consts.ConstStorage;
    import com.model.consts.StringConst;
    import com.view.gameWindow.common.Alert;
    import com.view.gameWindow.mainUi.subuis.onlineReward.OnlineRewardDataManager;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panels.bag.BagDataManager;
    import com.view.gameWindow.panel.panels.roleProperty.cell.ConstEquipCell;
    import com.view.gameWindow.tips.rollTip.RollTipMediator;
    import com.view.gameWindow.tips.rollTip.RollTipType;
    import com.view.gameWindow.util.JsUtils;

    import flash.events.MouseEvent;

    /**
     * Created by Administrator on 2015/3/19.
     */
    public class WingMouseHandler
    {
        private var _skin:McPanelWing;
        private var _panel:PanelWing;

        public function WingMouseHandler(panel:PanelWing)
        {
            _panel = panel;
            _skin = _panel.skin as McPanelWing;
            _skin.addEventListener(MouseEvent.CLICK, onClickHandler, false, 0, true);
        }

        private function onClickHandler(event:MouseEvent):void
        {
            switch (event.target)
            {
                case _skin.btnClose:
                    closeHandler();
                    break;
                case _skin.btnStart:
                    singleFoster();
                    break;
                case _skin.btnAuto:
                    autoHandler();
                    break;
                case _skin.btnActive:
                    activeHandler();
                    break;
                case _skin.btnCheck:
                    checkHandler();
                    break;
                default :
                    break;
            }
        }

        private function singleFoster():void
        {
            if (PanelWingDataManager.isAuto)
            {
                PanelWingDataManager.isAuto = false;
                _skin.txtAuto.text = StringConst.WING_006;
            }
            startHandler();
        }
        private function checkHandler():void
        {
            if (_panel)
            {
                var wingId:int = _panel.viewHandler.currentId;
                if (!ConfigDataManager.instance.wingUpgradeCfg(wingId))
                {
                    return;
                }
                _panel.setHight(!_skin.btnCheck.selected);
            }
        }

        private function activeHandler():void
        {
            OnlineRewardDataManager.instance.sendActiveEquip(OnlineRewardDataManager.WING_TYPE);
			_panel.viewHandler.showCloseGuide(true);
        }

        private function autoHandler():void
        {
            if (_panel.viewHandler)
            {
                var wingId:int = _panel.viewHandler.currentId;
                if (!ConfigDataManager.instance.wingUpgradeCfg(wingId))
                {
                    RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.WING_015);
                    return;
                }
            }

            var isAuto:Boolean = PanelWingDataManager.isAuto;
            isAuto = !isAuto;
            PanelWingDataManager.isAuto = isAuto;
            if (isAuto)
            {
                var bool:Boolean = startHandler();
                if (bool)
                {
                    _skin.txtAuto.text = StringConst.WING_014;
                } else
                {
                    _skin.txtAuto.text = StringConst.WING_006;
                }
            } else
            {
                _skin.txtAuto.text = StringConst.WING_006;
            }
        }

        public function startHandler():Boolean
        {
            if (_panel.viewHandler)
            {
                var wingId:int = _panel.viewHandler.currentId;
                if (wingId > 0)
                {
                    if (!ConfigDataManager.instance.wingUpgradeCfg(wingId))
                    {
                        RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.WING_015);
                        reset();
                        return false;
                    }
                }
            }

            var type:int = checkCost();
            if (type == 1)
            {
                RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.WING_010);
                reset();
                return false;
            }
            if (type == 3)
            {
                RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.WING_011);
                reset();
                return false;
            }
            if (type == 2)
            {
                Alert.show2(StringConst.WING_012, function ():void
                {
                    JsUtils.callRecharge();
                }, null, StringConst.WING_TIP_007, StringConst.PROMPT_PANEL_0013);
                reset();
                return false;
            }

            var useGold:int = int(_skin.btnCheck.selected);
            var slot:int = ConstEquipCell.getRoleEquipSlot(ConstEquipCell.TYPE_CHIBANG);
            PanelWingDataManager.instance.sendCM_WING_UPGRADE(ConstStorage.ST_CHR_EQUIP, slot, useGold);
            return true;
        }

        private function reset():void
        {
            PanelWingDataManager.isAuto = false;
            _skin.txtAuto.text = StringConst.WING_006;
        }

        /**
         *  1 金币不足
         *  2 元宝不足
         *  3 材料不足
         * */
        private function checkCost():int
        {
            var moneyNum:int = 0;
            var goldNum:int = 0;
            var materialNum:int = 0;
            var useMaterial:Boolean;
            var wingCfg:WingUpgradeCfgData = _panel.viewHandler.currentCfg;
            if (wingCfg)
            {
                useMaterial = _skin.btnCheck.selected;
                moneyNum = BagDataManager.instance.coinBind + BagDataManager.instance.coinUnBind;
                goldNum = BagDataManager.instance.goldUnBind;
                materialNum = BagDataManager.instance.getItemNumById(wingCfg.cost_item_id, -1);

                if (moneyNum < wingCfg.cost_coin)
                {
                    return 1;
                }
                if (useMaterial)
                {//选中自动购买材料
                    if (materialNum < wingCfg.cost_item_num)
                    {
                        if (goldNum < wingCfg.cost_gold * wingCfg.cost_item_num)
                        {
                            return 2;
                        }
                    }
                } else
                {
                    if (materialNum < wingCfg.cost_item_num)
                    {
                        return 3;
                    }
                }
            }
            return 0;
        }

        private function closeHandler():void
        {
            PanelMediator.instance.closePanel(PanelConst.TYPE_WING);
        }

        public function destroy():void
        {
            if (_skin)
            {
                _skin.removeEventListener(MouseEvent.CLICK, onClickHandler);
                _skin = null;
            }
            if (_panel)
            {
                _panel = null;
            }
        }
    }
}
