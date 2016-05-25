package com.view.gameWindow.mainUi.subuis.actvEnter
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.consts.EffectConst;
    import com.view.gameWindow.panel.panels.charge.ChargeDataManager;
    import com.view.gameWindow.panel.panels.everydayReward.EveryDayRewardDataManager;
    import com.view.gameWindow.panel.panels.loginReward.LoginRewardDataManager;
    import com.view.gameWindow.panel.panels.pray.PrayDataManager;
    import com.view.gameWindow.panel.panels.welfare.WelfareDataMannager;
    import com.view.gameWindow.util.Calendar;
    import com.view.gameWindow.util.UIEffectLoader;
    
    import flash.display.MovieClip;
    import flash.utils.Dictionary;

    /**
     * Created by Administrator on 2015/2/3.
     */
    public class ActEnterEffectManager
    {
        private var _effectPool:Dictionary;
        private var _mcActvEnter:McActvEnter;
        private var _effectNamePool:Dictionary;
        public function ActEnterEffectManager()
        {
            _effectPool = new Dictionary(true);
            _effectNamePool = new Dictionary(true);
        }

        public function register(mc:MovieClip):void
        {
            _mcActvEnter = mc as McActvEnter;
        }

        public function notify(proc:int = 0):void
        {
            if (proc == GameServiceConstants.SM_PRAY_INFO)
            {
                updatePrayIcon();
            }
            else if (proc == GameServiceConstants.SM_QUERY_SIGN || proc == GameServiceConstants.CM_GET_OFF_LINE_EXP)
            {
                updateWelfare();
            } else if (proc == GameServiceConstants.SM_GET_GAME_COLLECTION_REWORD)
            {
                updateKeepGame();
            } else if (proc == GameServiceConstants.SM_FIRST_PAY_REWARD_GET)
            {
                updateFirstCharge();
            } else if (proc == GameServiceConstants.SM_FIFTEEN_REWARD_GET)
            {
                updateLoginReward();
            } else if (proc == GameServiceConstants.SM_DAILY_PAY_REWARD_GET)
            {
                updateEveryDayReward();
            }
			else if (proc == GameServiceConstants.SM_SPECIALPREFERENCEREWORD_GET||proc == GameServiceConstants.SM_LEVEL_COMPETITIVE_REWORD_INFOR
				||proc == GameServiceConstants.SM_LEVEL_COMPETITIVE_REWORD_GET||proc == GameServiceConstants.SM_CHR_INFO)
			{
				updateOpenReward();
			}
			else if(proc == GameServiceConstants.SM_GET_MICRO_REWARD_REWORD||proc == GameServiceConstants.CM_MICRO_REWARD)
			{
				updateSmartLoad();
			}
        }
		
		private function updateSmartLoad():void
		{
			// TODO Auto Generated method stub
			addEffect("btnSmart");
		}
		
		private function updateOpenReward():void
		{
			// TODO Auto Generated method stub
//			var hasReward:Boolean = OpenServiceActivityDatamanager.instance.checkCanGetReward();
//			if (hasReward)
//			{
//				
//			} else
//			{
//				deleteEffect("btnOpenActivity");
//			}
			addEffect("btnOpenActivity");
		}
		
        private function updateEveryDayReward():void
        {
            var dataManager:EveryDayRewardDataManager = EveryDayRewardDataManager.instance;
            var hasReward:Boolean = dataManager.checkHasReward();
            if (hasReward)
            {
                addEffect("btnEveryDay");
            } else
            {
                deleteEffect("btnEveryDay");
            }
        }

        /**更新累计登陆特效*/
        private function updateLoginReward():void
        {
            var dataManager:LoginRewardDataManager = LoginRewardDataManager.instance;
            var hasReward:Boolean = dataManager.checkHasReward();
            if (hasReward)
            {
                addEffect("btnLogin");
            } else
            {
                deleteEffect("btnLogin");
            }
        }

        /**更新首充特效*/
        private function updateFirstCharge():void
        {
            var dataManager:ChargeDataManager = ChargeDataManager.instance;
            var alreadGetCount:int = dataManager.alreadyGetCount;
            if (alreadGetCount < 0)
            {
                deleteEffect("btnCharge");
            } else
            {
                addEffect("btnCharge");
            }
        }

        /**更新祈福特效*/
        private function updatePrayIcon():void
        {
            var freeCount:int = PrayDataManager.instance.stasticFreeCount();
            if (freeCount)
            {
                addEffect("btnPray");
            } else
            {
                deleteEffect("btnPray");
            }
        }

        /**更新福利的特效*/
        private function updateWelfare():void
        {
            var data:Array = WelfareDataMannager.instance.signList;
            Calendar.instance.checkCalendar();
            var today:int = Calendar.instance.currentDate.date - 1;

            var index:int = WelfareDataMannager.instance.awardIndex;
            var awardList:Array = WelfareDataMannager.instance.awardList;
            var receivableRewards:Array = WelfareDataMannager.instance.getRecivableAward();

            var offLineExp:Boolean = WelfareDataMannager.instance.isGetOffLineExp;
            var flag:int = WelfareDataMannager.instance.flag;
            var todaySign:Boolean = data[today];//今天是否签到
            var hasReward:Boolean = awardList[index];
            var receiveAward:Boolean = receivableRewards.indexOf(index) == -1;
            var timeObj:Object;
            var num:Number = WelfareDataMannager.instance.offLineTime / 60;
//            timeObj = TimeUtils.calcTime3(num);
            var isHasOffLineExp:Boolean = false;//是否有离线经验
//            if (timeObj.min == 0 && timeObj.hour == 0)
//            {
//                isHasOffLineExp = false;
//            }
            if (num < 60)
            {//离线60分钟以内不显示特效
                isHasOffLineExp = false;
            }
            if (todaySign && (hasReward || receiveAward) && ((!isHasOffLineExp) || offLineExp || flag))
            {
                deleteEffect("btnWelfare");
            } else
            {
                addEffect("btnWelfare");
            }
        }

        /*更新收藏游戏的特效*/
        private function updateKeepGame():void
        {
//            var count:int = KeepGameDataManager.instance.count;
            var count:int = 1;
            if (count)
            {
                deleteEffect("btnKeepGame");
            } else
            {
                addEffect("btnKeepGame");
            }
        }

        private function deleteEffect(keyName:String):void
        {
            if (!keyName) return;
            if (_effectPool[keyName] && _effectNamePool[keyName])
            {
                _effectPool[keyName].destroyEffect();
                delete _effectPool[keyName];
                delete _effectNamePool[keyName];
                keyName = null;
            }
        }

        private function addEffect(keyName:String):void
        {
            if (!keyName) return;
            if (!_effectPool[keyName] && !_effectNamePool[keyName])
            {
                _effectNamePool[keyName] = true;
                var mc:MovieClip = _mcActvEnter.mcBtns.mcLayer[keyName];
                var effectContainer:MovieClip = _mcActvEnter.mcBtns.mcLayer["effectContainer"];
                var uiEffect:UIEffectLoader = new UIEffectLoader(effectContainer, mc.x, mc.y, 1, 1, EffectConst.RES_ACT_ENTER_EFFECT, function ():void
                {
                    uiEffect.effect.x = mc.x + (mc.width >> 1) + 58;//58是特效容器的位置差
                    uiEffect.effect.y = mc.y + (mc.height >> 1) - 2;//2是特效容器的位置差
                    _effectPool[keyName] = uiEffect;
                    refreshPosition();
                });
            }
        }

        public function refreshPosition():void
        {
            var btn:MovieClip;
            var effectLoader:UIEffectLoader;
            for (var key:String in _effectPool)
            {
                btn = _mcActvEnter.mcBtns.mcLayer[key];
                effectLoader = _effectPool[key];
                if (effectLoader.effect)
                {
                    effectLoader.effect.x = btn.x + (btn.width >> 1) + 58;
                    effectLoader.effect.y = btn.y + (btn.height >> 1) - 2;
                    effectLoader.effect.visible = btn.visible;
                }
            }
        }

        private static var _instance:ActEnterEffectManager = null;
        public static function get instance():ActEnterEffectManager
        {
            if (_instance == null)
            {
                _instance = new ActEnterEffectManager();
            }
            return _instance;
        }
    }
}
