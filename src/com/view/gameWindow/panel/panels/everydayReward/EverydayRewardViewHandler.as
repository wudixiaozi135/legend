package com.view.gameWindow.panel.panels.everydayReward
{
    import com.greensock.TweenMax;
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.EveryDayRewardCfgData;
    import com.model.consts.EffectConst;
    import com.model.consts.StringConst;
    import com.pattern.Observer.IObserver;
    import com.view.gameWindow.flyEffect.FlyEffectMediator;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panels.everydayReward.item.EveryDayRewardItem;
    import com.view.gameWindow.util.UIEffectLoader;

    import flash.display.Sprite;
    import flash.geom.Point;

    import mx.utils.StringUtil;

    /**
     * Created by Administrator on 2015/2/28.
     */
    public class EverydayRewardViewHandler implements IObserver
    {
        private var _panel:PanelEverydayReward;
        private var _skin:McEveryReward;
        private var _rewardItems:Vector.<EveryDayRewardItem>;
        private var _positions:Array = [];

        private var _selectItem:EveryDayRewardItem;

        private var _total:int = 3;

        private var _btnEffect:UIEffectLoader;
        private var _btnEffectContainer:Sprite;
        public function EverydayRewardViewHandler(panel:PanelEverydayReward)
        {
            _panel = panel;
            _skin = _panel.skin as McEveryReward;
            _skin.addChild(_btnEffectContainer = new Sprite());
            _btnEffectContainer.mouseEnabled = false;
            _btnEffectContainer.mouseChildren = false;
            _btnEffect = new UIEffectLoader(_btnEffectContainer, 0, 0, 1, 1, EffectConst.RES_CHARGE_BTN_EFFECT);
            _btnEffectContainer.x = _skin.btnGet.x - ((168 - _skin.btnGet.width) >> 1);
            _btnEffectContainer.y = _skin.btnGet.y - ((85.5 - _skin.btnGet.height) >> 1) - 2;
            _btnEffectContainer.visible = false;

            initialize();
            initData();
            EveryDayRewardDataManager.instance.attach(this);
            refresh();
        }

        private function initData():void
        {
            _positions.push(new Point(150, 38), new Point(0, 0), new Point(300, 0));
            _rewardItems = new Vector.<EveryDayRewardItem>();

            for (var i:int = 0; i < _total; i++)
            {
                var item:EveryDayRewardItem = new EveryDayRewardItem();
                item.clickHandler = clickHandler;
                _skin.container.addChild(item);
                _rewardItems.push(item);
            }
            _selectItem = _rewardItems[0];
            _selectItem.hightLight = true;

            EveryDayRewardDataManager.selectRewardIndex = getPosition(_selectItem);

            setLayout();
            _skin.container.setChildIndex(_selectItem, _skin.container.numChildren - 1);
        }

        private function clickHandler(item:EveryDayRewardItem):void
        {
            if (item.x == 150) return;

            if (_selectItem)
            {
                _selectItem.hightLight = false;
            }
            _selectItem = item;
            _selectItem.hightLight = true;

            EveryDayRewardDataManager.selectRewardIndex = getPosition(item);

            var tempArr:Array = [];
            var i:int = 0, len:int = _positions.length;
            for (i = 0; i < len; i++)
            {
                if (item.x < 150)
                {
                    tempArr[(i + 1) % _total] = _positions[i];
                } else
                {
                    tempArr[i] = _positions[(i + 1) % _total];
                }
            }
            for (i = 0; i < len; i++)
            {
                _positions[i] = tempArr[i];
            }
            _skin.container.setChildIndex(item, _skin.container.numChildren - 1);
            tween();
        }

        public function getPosition(item:EveryDayRewardItem):int
        {
            var index:int = _rewardItems.indexOf(item);
            if (index != -1)
            {
                return index + 1;
            }
            return 0;
        }

        private function tween():void
        {
            var item:EveryDayRewardItem;
            var position:Point;
            var i:int = 0, len:int = 0;
            for (i = 0, len = _rewardItems.length; i < len; i++)
            {
                item = _rewardItems[i];
                item.disableBtn(true);
                position = _positions[i];
                TweenMax.to(item, .3 + i * .2, {
                    x: position.x,
                    y: position.y,
                    onComplete: tweenComplete,
                    onCompleteParams: [item]
                });
            }
        }

        private function tweenComplete(param:EveryDayRewardItem):void
        {
            if (param)
            {
                param.disableBtn(false);
                TweenMax.killTweensOf(param);
            }
        }
        private function setLayout():void
        {
            var item:EveryDayRewardItem;
            var position:Point;
            var i:int = 0, len:int = 0;
            for (i = 0, len = _rewardItems.length; i < len; i++)
            {
                item = _rewardItems[i];
                position = _positions[i];
                item.x = position.x;
                item.y = position.y;
            }
        }

        public function setData(cfg:EveryDayRewardCfgData):void
        {
            if (cfg)
            {
                for (var i:int = 0, len:int = _rewardItems.length; i < len; i++)
                {
                    _rewardItems[i].refreshData(cfg["reward" + (i + 1)]);
                }
                updateBtnVisible(cfg);
                _skin.txtPrice.htmlText = StringUtil.substitute(StringConst.PANEL_EVERY_DAY_REWARD_004, cfg.cost_value);
            }
        }

        private function initialize():void
        {
            _skin.txtChargedValue.textColor = 0x00ff00;
            _skin.txtChargedValue.mouseEnabled = false;
            _skin.txtChargedValue.text = StringConst.PANEL_EVERY_DAY_REWARD_001;

            _skin.txtPrice.mouseEnabled = false;

            _skin.txtExtract.selectable = false;
            _skin.txtTips.textColor = 0x675138;
            _skin.txtTips.mouseEnabled = false;
            _skin.txtTips.text = StringConst.PANEL_EVERY_DAY_REWARD_002;
        }

        public function update(proc:int = 0):void
        {
            if (proc == GameServiceConstants.SM_DAILY_PAY_REWARD_GET)
            {
                refresh();
            } else if (proc == GameServiceConstants.CM_DAILY_PAY_REWARD_GET)
            {
                var arr:Array = _selectItem.getBitmapDatas();
                FlyEffectMediator.instance.doFlyReceiveThings2(arr);
                _selectItem.destroyFlyDatas();

                var dataManager:EveryDayRewardDataManager = EveryDayRewardDataManager.instance;
                var getCount:int = dataManager.get_count;//已经领取的次数
                var cfg:EveryDayRewardCfgData = ConfigDataManager.instance.everydayRewardCfg(getCount + 1);
                if (!cfg)
                {
                    PanelMediator.instance.closePanel(PanelConst.TYPE_EVERYDAY_REWARD_PANEL);
                }
            }
        }

        private function refresh():void
        {
            var dataManager:EveryDayRewardDataManager = EveryDayRewardDataManager.instance;
            var payCount:int = dataManager.pay_count;//已经充值
            var getCount:int = dataManager.get_count;//已经领取的次数
            var remainCount:int = 0;
            var cfg:EveryDayRewardCfgData = ConfigDataManager.instance.everydayRewardCfg(getCount + 1);
            if (cfg)
            {
                setData(cfg);
                remainCount = cfg.pay_count - payCount;
                remainCount = remainCount <= 0 ? 0 : remainCount;
                _skin.txtChargedValue.text = remainCount.toString();
            } else
            {
                //没有奖励了
            }
        }

        public function updateBtnVisible(cfg:EveryDayRewardCfgData):void
        {
            var dataManager:EveryDayRewardDataManager = EveryDayRewardDataManager.instance;
            var payCount:int = dataManager.pay_count;//已经充值
            var getCount:int = dataManager.get_count;//已经领取次数

            if (cfg)
            {
                if (payCount < cfg.pay_count)
                {
                    _skin.btnGet.visible = false;
                    _skin.btnPlay.visible = true;
                } else
                {
                    if (getCount <= cfg.id - 1)
                    {

                    }
                    _skin.btnGet.visible = true;
                    _skin.btnPlay.visible = false;
                }
                _btnEffectContainer.visible = _skin.btnGet.visible;
            }
        }
        
        public function destroy():void
        {
            EveryDayRewardDataManager.instance.detach(this);
            if (_btnEffect)
            {
                _btnEffect.destroy();
                _btnEffect = null;
            }
            if (_btnEffectContainer && _btnEffectContainer.parent)
            {
                _skin.removeChild(_btnEffectContainer);
                _btnEffectContainer = null;
            }
            if (_rewardItems)
            {
                _rewardItems.forEach(function (element:EveryDayRewardItem, index:int, vec:Vector.<EveryDayRewardItem>):void
                {
                    if (element.parent)
                    {
                        _skin.container.removeChild(element);
                        element.destroy();
                        element = null;
                    }
                });
                _rewardItems.length = 0;
                _rewardItems = null;
            }
            if (_positions)
            {
                _positions.length = 0;
                _positions = null;
            }
            if (_skin)
            {
                _skin = null;
            }
            if (_panel)
            {
                _panel = null;
            }
        }
    }
}
