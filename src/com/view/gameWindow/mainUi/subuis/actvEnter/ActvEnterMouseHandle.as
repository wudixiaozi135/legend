package com.view.gameWindow.mainUi.subuis.actvEnter
{
    import com.greensock.TweenLite;
    import com.model.configData.cfgdata.ActivityCfgData;
    import com.view.gameWindow.mainUi.subuis.activityTrace.ActivityDataManager;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panels.artifact.ArtifactDataManager;
    import com.view.gameWindow.panel.panels.boss.BossDataManager;
    import com.view.gameWindow.panel.panels.charge.ChargeDataManager;
    import com.view.gameWindow.panel.panels.daily.DailyDataManager;
    import com.view.gameWindow.panel.panels.dragonTreasure.DragonTreasureManager;
    import com.view.gameWindow.panel.panels.everydayReward.EveryDayRewardDataManager;
    import com.view.gameWindow.panel.panels.exchangeShop.ExchangeShopDataManager;
    import com.view.gameWindow.panel.panels.loginReward.LoginRewardDataManager;
    import com.view.gameWindow.panel.panels.pray.PrayDataManager;
    import com.view.gameWindow.panel.panels.stronger.StrongerDataManager;
    import com.view.gameWindow.panel.panels.welfare.WelfareDataMannager;
    import com.view.gameWindow.util.JsUtils;

    import flash.events.MouseEvent;
    import flash.utils.getTimer;

    /**
     * 活动入口鼠标相关处理
     * @author Administrator
     */
    internal class ActvEnterMouseHandle
    {
        private var _ui:ActvEnter;
        private var _skin:McActvEnter;
        private var _isSelect:Boolean;

        private var tweenLite:TweenLite;
        private var duration:Number = .4;
        private var xTo:int;
        private var _timeId:uint = getTimer();
        private var _keepGameHandler:KeepGameHandler;

        public function get isSelect():Boolean
        {
            return _isSelect;
        }

        public function ActvEnterMouseHandle(ui:ActvEnter)
        {
            _ui = ui;
            _skin = _ui.skin as McActvEnter;
        }

        internal function initialize():void
        {
            var skin:McActvEnter = _skin as McActvEnter;
            skin.addEventListener(MouseEvent.CLICK, onClick);
            xTo = skin.mcBtns.width;
        }

        protected function onClick(event:MouseEvent):void
        {
            var skin:McActvEnter = _skin as McActvEnter;
            switch (event.target)
            {
                case skin.btnPickUp:
                    dealBtnPickUp();
                    break;
                case skin.mcBtns.mcLayer.txt:
                    dealTxtClick();
                    break;
                case skin.mcBtns.mcLayer.btnWing:
                    dealBtnWing();
                    break;
                case skin.mcBtns.mcLayer.btnLoongWar:
                    dealBtnLoongWar();
                    break;
                case skin.mcBtns.mcLayer.btnDaily:
                    dealBtnDaily();
                    break;
                case skin.mcBtns.mcLayer.btnBoss:
                    dealBtnBoss();
                    break;
                case skin.mcBtns.mcLayer.btnPray:
                    dealBtnPray();
                    break;
                case skin.mcBtns.mcLayer.btnDragon:
                    dealBtnDragon();
                    break;
                case skin.mcBtns.mcLayer.btnArtifact:
                    dealBtnArtifact();
                    break;
                case skin.mcBtns.mcLayer.btnWelfare:
                    dealBtnWelfare();
                    break;
                case skin.mcBtns.mcLayer.btnStronger:
                    dealBtnStronger();
                    break;
                case skin.mcBtns.mcLayer.btnKeepGame:
                    dealKeepGame();
                    break;
                case skin.mcBtns.mcLayer.btnCharge:
                    dealCharge();
                    break;
                case skin.mcBtns.mcLayer.btnLogin:
                    dealLoginReward();
                    break;
                case skin.mcBtns.mcLayer.btnEveryDay:
                    dealEveryDayReward();
                    break;
				case skin.mcBtns.mcLayer.btnOpenActivity:
					dealOpenActivity();
					break;
				case skin.mcBtns.mcLayer.btnSmart:
					dealSmart();
					break;
                case skin.mcBtns.mcLayer.btnBug:
                    dealBug();
                    break;
                case skin.mcBtns.mcLayer.btnExchangeShop:
                    dealExchangeShop();
                    break;
				case skin.mcBtns.mcLayer.btnEverydayReward:
					dealEverydayReward();
					break;
                default:
                    break;
            }
        }

        private function dealExchangeShop():void
        {
            ExchangeShopDataManager.instance.dealSwitchPanel();
        }
		
		private function dealEverydayReward():void
		{
			// TODO Auto Generated method stub
			PanelMediator.instance.switchPanel(PanelConst.TYPE_EVERYDAY_ONLINE_REWARD);
		}
		
        private function dealBug():void
        {
            JsUtils.gotoForum();
        }
		
		private function dealSmart():void
		{
			// TODO Auto Generated method stub
			PanelMediator.instance.switchPanel(PanelConst.TYPE_SMART_LOAD);
		}
		
		private function dealOpenActivity():void
		{
			// TODO Auto Generated method stub
			PanelMediator.instance.switchPanel(PanelConst.TYPE_OPEN_GIFT_PANEL);
		}
		
        private function dealEveryDayReward():void
        {
            EveryDayRewardDataManager.instance.dealPanel();
        }

        private function dealLoginReward():void
        {
            LoginRewardDataManager.instance.dealPanel();
        }

        private function dealCharge():void
        {
            ChargeDataManager.instance.dealPanel();
        }

        private function dealKeepGame():void
        {
            if ((getTimer() - _timeId) < 1000) return;
            _timeId = getTimer();
            if (_keepGameHandler)
            {
                _keepGameHandler.destroy();
                _keepGameHandler = null;
            }
            _keepGameHandler = _keepGameHandler || new KeepGameHandler();
        }

        private function dealBtnPickUp():void
        {
            var skin:McActvEnter = _skin as McActvEnter;
            if (!tweenLite)
            {
                tweenLite = new TweenLite(skin.mcBtns.mcLayer, duration, {x: xTo});
            }
            if (!_isSelect/*skin.btnPickUp.selected*/)
            {
                tweenLite.play();
            }
            else
            {
                tweenLite.reverse();
            }
            _isSelect = !_isSelect;
        }

        private function dealTxtClick():void
        {
            var nextCfgDt:ActivityCfgData = _ui.viewHandle.nextCfgDt;
            if (nextCfgDt)
            {
                var manager:DailyDataManager = DailyDataManager.instance;
                manager.selectTab = manager.tabActivity;
                manager.dealSwitchPanelDaily();
            }
        }

        private function dealBtnWing():void
        {
            var nextCfgDt:ActivityCfgData = _ui.viewHandle.nextCfgDt;
            if (nextCfgDt)
            {
                var npcId:int = nextCfgDt.npc;
                DailyDataManager.instance.requestTeleport(npcId);
            }
        }

        private function dealBtnLoongWar():void
        {
            ActivityDataManager.instance.loongWarDataManager.dealSwitchPanleLoongWar();
        }

        private function dealBtnDaily():void
        {
            DailyDataManager.instance.dealSwitchPanelDaily();
        }

        private function dealBtnBoss():void
        {
            BossDataManager.instance.dealSwitchPanleBoss();
        }

        private function dealBtnPray():void
        {
            PrayDataManager.instance.dealSwitchPanlePray();
        }

        private function dealBtnWelfare():void
        {
            WelfareDataMannager.instance.dealSwitchPanleWelfare();
        }

        private function dealBtnStronger():void
        {
            StrongerDataManager.instance.dealSwitchPanleStronger();
        }

        private function dealBtnDragon():void
        {
            DragonTreasureManager.instance.dealSwitchPanleDragon();
        }

        private function dealBtnArtifact():void
        {
            ArtifactDataManager.instance.dealSwitchPanleArtifact();
        }
    }
}

import com.model.business.fileService.constants.ResourcePathConstants;
import com.model.business.flashVars.FlashVarsManager;
import com.model.consts.StringConst;
import com.view.gameWindow.mainUi.subuis.actvEnter.KeepGameDataManager;

import flash.events.Event;
import flash.net.FileReference;

class KeepGameHandler
{
    private var _file:FileReference;

    public function KeepGameHandler()
    {
        _file = new FileReference();
        _file.addEventListener(Event.COMPLETE, onComplete, false, 0, true);
        var favoriteUrl:String = FlashVarsManager.getInstance().favoriteUrl;
        if (!favoriteUrl)
        {
//            favoriteUrl = "http://192.168.1.109";//临时使用
        }
        var data:String = "[InternetShortcut]\r\n" +
                "URL='" + favoriteUrl + "'\r\n";
        _file.save(data, StringConst.GAME_NAME + ResourcePathConstants.POSTFIX_URL);
    }

    private function onComplete(event:Event):void
    {
        KeepGameDataManager.instance.sendKeepGame();
    }

    public function destroy():void
    {
        if (_file)
        {
            _file.removeEventListener(Event.COMPLETE, onComplete);
            _file = null;
        }
    }
}