package com.view.gameWindow.mainUi.subuis.stoneShop
{
    import com.event.GameDispatcher;
    import com.event.GameEventConst;
    import com.model.consts.StringConst;
    import com.model.consts.ToolTipConst;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.pattern.Observer.IObserver;
    import com.view.gameWindow.mainUi.MainUi;
    import com.view.gameWindow.mainUi.subclass.McExchangeShop;
    import com.view.gameWindow.mainUi.subuis.IconGroup;
    import com.view.gameWindow.panel.panels.dungeon.TextFormatManager;
    import com.view.gameWindow.panel.panels.exchangeShop.ExchangeShopDataManager;
    import com.view.gameWindow.panel.panels.guideSystem.GuideSystem;
    import com.view.gameWindow.panel.panels.guideSystem.unlock.UnlockFuncId;
    import com.view.gameWindow.panel.panels.guideSystem.unlock.UnlockObserver;
    import com.view.gameWindow.tips.toolTip.ToolTipManager;
    import com.view.gameWindow.util.ServerTime;
    import com.view.gameWindow.util.TimeUtils;
    import com.view.gameWindow.util.TimerManager;

    import flash.filters.GlowFilter;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;

    public class ExchangeShopIcon extends MainUi implements IObserver
    {
        internal var mouseHandle:StoneShopIconMouseHandler;
        private var _text:TextField;
        internal var _remainTime:int;
        private var _unlockObserver:UnlockObserver;

        private var _timeSpans:Array;

        public function ExchangeShopIcon()
        {
            super();
            IconGroup.instance.addIcon(this);
        }

        override public function initView():void
        {
            _skin = new McExchangeShop();
            addChild(_skin);
            _timeSpans = ExchangeShopDataManager.instance.getRefreshTimeArr();

            initData();
            initCheck();
            super.initView();
        }

        private function initCheck():void
        {
            var serverDate:Date = ServerTime.date;
            var totalSeconds:int = serverDate.hours * 3600 + serverDate.minutes * 60 + serverDate.seconds;
            var time:int = getCheckTime(totalSeconds);
            if (time >= 0)
            {
                updateTime();
                TimerManager.getInstance().add(1000, updateTime);
            } else
            {
                TimerManager.getInstance().add(1000, checkNowTime);
                _skin.countBg.visible = false;
            }
        }

        private function checkNowTime():void
        {
            var serverDate:Date = ServerTime.date;
            var totalSeconds:int = serverDate.hours * 3600 + serverDate.minutes * 60 + serverDate.seconds;
            var time:int = getCheckTime(totalSeconds);
            if (time >= 0)
            {
                TimerManager.getInstance().remove(checkNowTime);
                updateTime();
                TimerManager.getInstance().add(1000, updateTime);
            }
        }

        private function initData():void
        {
            mouseHandle = new StoneShopIconMouseHandler(this);
            initText();
            checkLockState(UnlockFuncId.EQUIP_STONE_SHOP);
            initLockStateObserver();
        }

        override protected function addCallBack(rsrLoader:RsrLoader):void
        {
            var skin:McExchangeShop = _skin as McExchangeShop;
            rsrLoader.addCallBack(skin.bg, function ():void
            {
                ToolTipManager.getInstance().attachByTipVO(skin.bg, ToolTipConst.TEXT_TIP, StringConst.BTNTIPS_0036);
            });
        }

        private function initLockStateObserver():void
        {
            if (!_unlockObserver)
            {
                _unlockObserver = new UnlockObserver();
                _unlockObserver.setCallback(checkLockState);
                GuideSystem.instance.unlockStateNotice.attach(_unlockObserver);
            }
        }

        private function destroyLockStateObserver():void
        {
            if (_unlockObserver)
            {
                _unlockObserver.destroy();
                GuideSystem.instance.unlockStateNotice.detach(_unlockObserver);
                _unlockObserver = null;
            }
        }

        private function checkLockState(id:int):void
        {
            if (id == UnlockFuncId.EQUIP_STONE_SHOP)
            {
                visible = GuideSystem.instance.isUnlock(id);
                GameDispatcher.dispatchEvent(GameEventConst.ICON_CHANGE);
            }
        }

        private function initText():void
        {
            _text = new TextField();
            TextFormatManager.instance.setTextFormat(_text, 0xffffff, false, false);
            TextFormatManager.instance.setFont(_text, "SimSun");
            _text.mouseEnabled = false;

            _text.width = 52;
            _text.autoSize = TextFieldAutoSize.CENTER;
            _text.textColor = 0x00ff00;
            _text.filters = [new GlowFilter(0, 1, 2, 2, 10)];
            _text.x += 4;
            _text.y = _skin.countBg.y + 8;
            _skin.addChild(_text);
        }

        public function update(proc:int = 0):void
        {

        }

        private function getCheckTime(serverSeconds:int):int
        {
            var timeSpan:int, durTime:int;
            for (var i:int = _timeSpans.length - 1; i >= 0; i--)
            {
                if (i == 0)
                {
                    durTime = 2;
                } else
                {
                    durTime = _timeSpans[i] - _timeSpans[i - 1]
                }
                timeSpan = (_timeSpans[i] - durTime) * 3600;//得到时间段
                if (serverSeconds >= timeSpan)
                {
                    return durTime * 3600 + timeSpan - serverSeconds;
                }
            }
            return -1;
        }

        public function updateTime():void
        {
            var serverDate:Date = ServerTime.date;
            var totalSeconds:int = serverDate.hours * 3600 + serverDate.minutes * 60 + serverDate.seconds;
            _remainTime = getCheckTime(totalSeconds);

            if (_remainTime < 0)
            {
                TimerManager.getInstance().remove(updateTime);
                var skin:McExchangeShop = _skin as McExchangeShop;
                skin.countBg.visible = false;
                _remainTime = -1;
                if (_text)
                {
                    _text.visible = false;
                }
                return;
            } else
            {
                if (_skin.countBg.visible != true)
                {
                    _skin.countBg.visible = true;
                }
                if (_text && _text.visible != true)
                {
                    _text.visible = true;
                }
            }

            var obj:Object = TimeUtils.calcTime3(_remainTime);
            obj.hour = obj.hour < 10 ? "0" + obj.hour : obj.hour;
            obj.min = obj.min < 10 ? "0" + obj.min : obj.min;
            obj.sec = obj.sec < 10 ? "0" + obj.sec : obj.sec;
            _text.text = obj.hour + ":" + obj.min + ":" + obj.sec;
        }

        private function destory():void
        {
            destroyLockStateObserver();
            if (mouseHandle)
            {
                mouseHandle.destroy();
                mouseHandle = null;
            }
            if (_skin)
            {
                _skin.removeChild(_text);
                removeChild(_skin);
                _skin = null;
                _text = null;
            }
        }
    }
}