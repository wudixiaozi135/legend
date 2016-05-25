package com.view.gameWindow.mainUi.subuis.onlineReward
{
    import com.model.consts.StringConst;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
    import com.view.gameWindow.tips.rollTip.RollTipMediator;
    import com.view.gameWindow.tips.rollTip.RollTipType;

    import flash.events.MouseEvent;

    import mx.utils.StringUtil;

    public class OnlineShieldMouseEvent
    {
        private var _ui:OnlineShield;

        public function OnlineShieldMouseEvent(ui:OnlineShield):void
        {
            _ui = ui;

            _ui.mouseSp.addEventListener(MouseEvent.CLICK, clickHandle);
            _ui.mouseSp.addEventListener(MouseEvent.ROLL_OVER, rollHandle);
            _ui.mouseSp.addEventListener(MouseEvent.ROLL_OUT, rollHandle);
        }

        protected function rollHandle(event:MouseEvent):void
        {
            if (_ui && _ui.mouseSp)
            {
                var show:Boolean;
                event.type == MouseEvent.ROLL_OUT ? show = false : show = true;
                _ui.showTips(show);
            }
        }

        private function clickHandle(evt:MouseEvent):void
        {
            if (_ui.mouseSp)
            {
                if (evt.target == _ui.mouseSp)
                {
                    if (_ui._onlineRewardShieldCfg)
                    {
                        if (RoleDataManager.instance.checkReincarnLevel(_ui._onlineRewardShieldCfg.reincarn, _ui._onlineRewardShieldCfg.level))
                        {
                            _ui.storeBmp();
                            OnlineRewardDataManager.instance.sendShieldData(_ui._onlineRewardShieldCfg.id);
                        } else
                        {
                            var msg:String;
                            if (_ui._onlineRewardShieldCfg.reincarn > 0)
                            {
                                msg = StringUtil.substitute(StringConst.SHIELD_0005, _ui._onlineRewardShieldCfg.reincarn, _ui._onlineRewardShieldCfg.level);
                            } else
                            {
                                msg = StringUtil.substitute(StringConst.SHIELD_0004, _ui._onlineRewardShieldCfg.level);
                            }
                            RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, msg);
                        }
                    }
                }
            }
        }

        private function showRollTip():void
        {
            /*var color :uint = ItemType.itemTypeColor(ItemType.IT_GOLD_BIND);
             var string:String = HtmlUtils.createHtmlStr(color,ItemType.itemTypeName(ItemType.IT_GOLD_BIND) + _ui._onlineRewardShieldCfg.bind_gold,20);
             RollTipMediator.instance.showRollTip(RollTipType.REWARD,string);*/
        }

        public function destory():void
        {
            if (_ui)
            {
                _ui.showTips(false);
                _ui.mouseSp.removeEventListener(MouseEvent.CLICK, clickHandle);
                _ui.mouseSp.removeEventListener(MouseEvent.ROLL_OUT, rollHandle);
                _ui.mouseSp.removeEventListener(MouseEvent.ROLL_OVER, rollHandle);
                _ui = null;
            }
        }
    }
}