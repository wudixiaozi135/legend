package com.view.gameWindow.mainUi.subuis.actvEnter
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.configData.cfgdata.ActivityCfgData;
	import com.model.dataManager.LoginDataManager;
	import com.pattern.Observer.IObserver;
	import com.view.gameWindow.panel.panels.charge.ChargeDataManager;
	import com.view.gameWindow.panel.panels.everydayReward.EveryDayRewardDataManager;
	import com.view.gameWindow.panel.panels.guideSystem.GuideSystem;
	import com.view.gameWindow.panel.panels.guideSystem.unlock.UIUnlockHandler;
	import com.view.gameWindow.panel.panels.guideSystem.unlock.UnlockFuncId;
	import com.view.gameWindow.panel.panels.loginReward.LoginRewardDataManager;
	import com.view.gameWindow.panel.panels.openGift.data.OpenServiceActivityDatamanager;
	import com.view.gameWindow.panel.panels.pray.PrayDataManager;
	import com.view.gameWindow.panel.panels.pray.data.PrayData;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.smartLoad.SmartLoadDatamanager;
	import com.view.gameWindow.panel.panels.welfare.WelfareDataMannager;

	import flash.display.DisplayObject;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Dictionary;

	/**
	 * 活动入口显示相关处理
	 * @author Administrator
	 */	
	internal class ActvEnterViewHandle implements IObserver
	{
		private var _ui:ActvEnter;
		private var _skin:McActvEnter;
		internal var nextCfgDt:ActivityCfgData;
		private var _nextCfgDts:Vector.<ActivityCfgData>;

		private var _isActvPromptShow:Dictionary;
		
		private var _unlock:UIUnlockHandler;
		private var _btnList:Array;
        private var _iconGroup0:Array;//Boss图标
        private var _iconGroup1:Array;//第一排图标
        private var _iconGroup2:Array;//第二排图标
		public function ActvEnterViewHandle(ui:ActvEnter)
		{
			_ui = ui;
			_skin = _ui.skin as McActvEnter;
			_skin.mcBtns.mcLayer.txtPrayCount.mouseEnabled = false;
			_skin.mcBtns.mcLayer.txtWelfareCount.mouseEnabled = false;
			_skin.mcBtns.mcLayer.txtPrayCount.autoSize = TextFieldAutoSize.RIGHT;
			_skin.mcBtns.mcLayer.txtWelfareCount.autoSize = TextFieldAutoSize.RIGHT;

			LoginDataManager.instance.attach(this);
			PrayDataManager.instance.attach(this);
			WelfareDataMannager.instance.attach(this);
			KeepGameDataManager.instance.attach(this);
            ChargeDataManager.instance.attach(this);
            LoginRewardDataManager.instance.attach(this);
            RoleDataManager.instance.attach(this);
            EveryDayRewardDataManager.instance.attach(this);
			OpenServiceActivityDatamanager.instance.attach(this);
            ActEnterEffectManager.instance.register(_skin);
			SmartLoadDatamanager.instance.attach(this);
            initIcon();
			_unlock = new UIUnlockHandler(getUnlockUI,1,arrangeBtns);
			_unlock.updateUIStates([UnlockFuncId.BOSS,UnlockFuncId.DAILY_VIT,
									UnlockFuncId.DRAGEON_TREASURE,UnlockFuncId.ARTIFACT,
									UnlockFuncId.PRAY,UnlockFuncId.WELFARE,
									UnlockFuncId.STRONGER,UnlockFuncId.LOONG_WARE,
									UnlockFuncId.CHARGE,UnlockFuncId.LOGIN_REWARD,
				UnlockFuncId.CHARGE_EVERYDAY, UnlockFuncId.EQUIP_STONE_SHOP]);
		}

        private function initIcon():void
        {
//            _iconGroup0 = [_skin.mcBtns.mcLayer.btnBoss];
//
//            _iconGroup1 = [_skin.mcBtns.mcLayer.btnArtifact,
//                _skin.mcBtns.mcLayer.btnLoongWar];
//
//            _iconGroup2 = [_skin.mcBtns.mcLayer.btnDragon,
//                _skin.mcBtns.mcLayer.btnPray,
//                _skin.mcBtns.mcLayer.btnWelfare,
//                _skin.mcBtns.mcLayer.btnStronger,
//                _skin.mcBtns.mcLayer.btnKeepGame
//            ];
			
			//swf 会被替换
			_iconGroup0 = ["btnBoss"];
			
			_iconGroup1 = ["btnArtifact",
				"btnLoongWar", "btnLogin", "btnSmart", "btnBug"];
			
			_iconGroup2 = ["btnDragon",
				"btnPray",
				"btnWelfare",
                /*"btnStronger",*/
                "btnKeepGame",
                "btnCharge",
                "btnEveryDay",
				"btnOpenActivity"
			];

			///以下是屏蔽的
			_skin.mcBtns.mcLayer.btnBug.visible = false;
        }
		
		private function getIcon(id:String):DisplayObject
		{
			return _skin.mcBtns.mcLayer[id];
		}

		private function arrangeBtns(id:int):void
		{
			if(id == UnlockFuncId.BOSS ||
				id == UnlockFuncId.DAILY_VIT ||
				id == UnlockFuncId.DRAGEON_TREASURE ||
				id == UnlockFuncId.ARTIFACT ||
				id == UnlockFuncId.PRAY ||
				id == UnlockFuncId.WELFARE ||
				id == UnlockFuncId.STRONGER ||
				id == UnlockFuncId.LOONG_WARE ||
					id == UnlockFuncId.EQUIP_STONE_SHOP ||
				id == UnlockFuncId.CHARGE_EVERYDAY)
			{
                refreshIcon();
			}
			else if(id == UnlockFuncId.CHARGE)
			{
				updateFirstChargeInner();//解锁时不一定显示所以再判断下
				refreshIcon();
			}
			else if(id == UnlockFuncId.LOGIN_REWARD)
			{
				updateLoginRewardInner();//解锁时不一定显示所以再判断下
				refreshIcon();
			}
        }

        /**当图标的visible发生变化时调用*/
        public function refreshIcon():void
        {
            var bossPosition:int = 102, startPosition:int = 173, hGap:int = 4;
            var w:int = 0, i:int = 0, len:int = 0, m:DisplayObject = null;
            var arr0:Array = getVisibleDatas(_iconGroup0);
            for (i = 0, len = arr0.length; i < len; i++)
            {
                m = arr0[i];
                w = bossPosition + m.width * i;
                m.x = -w;
            }

			if(!arr0.length)
			{
				startPosition = 58;
			}

            var arr1:Array = getVisibleDatas(_iconGroup1);
            for (i = 0, len = arr1.length; i < len; i++)
            {
                m = arr1[i];
                w = startPosition + (i * (m.width + hGap));
                m.x = -w;
            }

            var arr2:Array = getVisibleDatas(_iconGroup2);
            for (i = 0, len = arr2.length; i < len; i++)
            {
                m = arr2[i];
                w = startPosition + (i * (m.width + hGap));
                m.x = -w;
            }

            var pos:Number = Math.abs((_skin.mcBtns.mcLayer.txtPrayCount.textWidth - 18) >> 1);
            _skin.mcBtns.mcLayer.txtRequstBG.x = _skin.mcBtns.mcLayer.btnPray.x + _skin.mcBtns.mcLayer.btnPray.width - _skin.mcBtns.mcLayer.txtRequstBG.width;
            _skin.mcBtns.mcLayer.txtPrayCount.x = _skin.mcBtns.mcLayer.txtRequstBG.x + pos + 1;

            pos = Math.abs((_skin.mcBtns.mcLayer.txtWelfareCount.textWidth - 18) >> 1);
            _skin.mcBtns.mcLayer.txtWelfareBG.x = _skin.mcBtns.mcLayer.btnWelfare.x + _skin.mcBtns.mcLayer.btnWelfare.width - _skin.mcBtns.mcLayer.txtWelfareBG.width;
            _skin.mcBtns.mcLayer.txtWelfareCount.x = _skin.mcBtns.mcLayer.txtWelfareBG.x + pos + 1;
            updatePray();
            updateWelfare();

            ActEnterEffectManager.instance.refreshPosition();
		}

		private function getUnlockUI(id:int):*
		{
			if(id == UnlockFuncId.BOSS)
			{
				return _skin.mcBtns.mcLayer.btnBoss;
			}
			else if(id == UnlockFuncId.DAILY_VIT)
			{
				return _skin.mcBtns.mcLayer.btnDaily;
			}
			else if(id == UnlockFuncId.DRAGEON_TREASURE)
			{
				return _skin.mcBtns.mcLayer.btnDragon;
			}
			else if(id == UnlockFuncId.ARTIFACT)
			{
				return _skin.mcBtns.mcLayer.btnArtifact;
			}
			else if(id == UnlockFuncId.PRAY)
			{
				return [_skin.mcBtns.mcLayer.btnPray,_skin.mcBtns.mcLayer.txtRequstBG,_skin.mcBtns.mcLayer.txtPrayCount];
			}
			else if(id == UnlockFuncId.WELFARE)
			{
				return [_skin.mcBtns.mcLayer.btnWelfare,_skin.mcBtns.mcLayer.txtWelfareBG,_skin.mcBtns.mcLayer.txtWelfareCount];
			}
//			else if(id == UnlockFuncId.STRONGER)
//			{
//				return _skin.mcBtns.mcLayer.btnStronger;
//			}
			else if(id == UnlockFuncId.LOONG_WARE)
			{
				return _skin.mcBtns.mcLayer.btnLoongWar;
			}
			else if(id == UnlockFuncId.CHARGE)
			{
				return _skin.mcBtns.mcLayer.btnCharge;
			}
			else if(id == UnlockFuncId.LOGIN_REWARD)
			{
				return _skin.mcBtns.mcLayer.btnLogin;
			}
			else if(id == UnlockFuncId.CHARGE_EVERYDAY)
			{
				return _skin.mcBtns.mcLayer.btnEveryDay;
			}
			
			return null;
		}
		
		internal function initialize():void
		{
			_isActvPromptShow = new Dictionary();
		}
		
		
		public function update(proc:int=0):void
		{
			if (proc == GameServiceConstants.SM_PRAY_INFO)
			{
				updatePray();
			}
			else if(proc == GameServiceConstants.SM_QUERY_SIGN)
			{
				updateWelfare();
			} else if (proc == GameServiceConstants.SM_GET_GAME_COLLECTION_REWORD)
			{
				updateKeepGame();
            } else if (proc == GameServiceConstants.SM_FIRST_PAY_REWARD_GET)
            {
                updateFirstCharge();
            } else if (proc == GameServiceConstants.SM_FIFTEEN_REWARD_GET || proc == GameServiceConstants.SM_CHR_INFO)
            {
                updateLoginReward();
            } else if (proc == GameServiceConstants.SM_DAILY_PAY_REWARD_GET)
            {
                updateEveryDayReward();
            }
			else if(proc == GameServiceConstants.CM_MICRO_REWARD||proc == GameServiceConstants.SM_GET_MICRO_REWARD_REWORD)
			{
				updateSmartRewar();
			}
            ActEnterEffectManager.instance.notify(proc);
		}
		
		private function updateSmartRewar():void
		{
			var alreadyCount:int = SmartLoadDatamanager.instance.count;
			alreadyCount = 1000;//屏蔽掉
			if (alreadyCount > 0)
			{
				_skin.mcBtns.mcLayer.btnSmart.visible = false;
			}
			else
			{
				_skin.mcBtns.mcLayer.btnSmart.visible = true;
			}
			refreshIcon();
		}
		
        private function updateEveryDayReward():void
        {
            if (_skin.mcBtns.mcLayer.btnCharge.visible == false)
            {
                var dataManager:EveryDayRewardDataManager = EveryDayRewardDataManager.instance;
                if (dataManager.todayHas())
                {
                    _skin.mcBtns.mcLayer.btnEveryDay.visible = true;
                } else
                {
                    _skin.mcBtns.mcLayer.btnEveryDay.visible = false;
                }
            } else
            {
                _skin.mcBtns.mcLayer.btnEveryDay.visible = false;
            }
            refreshIcon();
        }

        private function updateLoginReward():void
        {
			updateLoginRewardInner();
            refreshIcon();
        }
		
		private function updateLoginRewardInner():void
		{
//			if (RoleDataManager.instance.lv >= LoginRewardDataManager.openLevel)
//			{
				var flagDay:int = LoginRewardDataManager.flagDay;
				if (flagDay == -1)
				{
					_skin.mcBtns.mcLayer.btnLogin.visible = false;
				} else
				{
					_skin.mcBtns.mcLayer.btnLogin.visible = GuideSystem.instance.isUnlock(UnlockFuncId.LOGIN_REWARD);
				}
//			} else
//			{
//				_skin.mcBtns.mcLayer.btnLogin.visible = false;
//			}
		}

        private function updateFirstCharge():void
        {
			updateFirstChargeInner();
            refreshIcon();
        }
		
		private function updateFirstChargeInner():void
		{
			var alreadyGetCount:int = ChargeDataManager.instance.alreadyGetCount;
			if (alreadyGetCount)
			{
				_skin.mcBtns.mcLayer.btnCharge.visible = false;
			}
			else
			{
				_skin.mcBtns.mcLayer.btnCharge.visible = GuideSystem.instance.isUnlock(UnlockFuncId.CHARGE);
			}
            if (_skin.mcBtns.mcLayer.btnCharge.visible == false)
            {//消失时，要更新下每日充值Icon
                updateEveryDayReward();
            }
		}

		public function updateKeepGame():void
		{
			var count:int = KeepGameDataManager.instance.count;
//            var count:int = 100;//临时去掉收藏游戏
			var bool:Boolean = false;
			if (count == 0)
			{
				bool = true;
			} else
			{
				bool = false;
			}
			_skin.mcBtns.mcLayer.btnKeepGame.visible = bool;
            refreshIcon();
		}

		private function updatePray():void
		{
			// TODO Auto Generated method stub
			var pmdt:PrayDataManager = PrayDataManager.instance;
			var prayData:PrayData = pmdt.data;
			var totalCount:int, remainCount:int;
			if (prayData) 
			{
//				totalCount = prayData.coinTotalCount + prayData.goldTotalCount;
//				remainCount = totalCount - (prayData.coinCount + prayData.goldCount);

                remainCount = pmdt.stasticFreeCount();
				if (remainCount <= 0)
				{
					_skin.mcBtns.mcLayer.txtRequstBG.visible = false;
					_skin.mcBtns.mcLayer.txtPrayCount.text = "";
				}
				else
				{
					_skin.mcBtns.mcLayer.txtRequstBG.visible = true;
					_skin.mcBtns.mcLayer.txtPrayCount.text = remainCount.toString();
					
					var pos:Number = Math.abs((_skin.mcBtns.mcLayer.txtPrayCount.textWidth - 18) >> 1);
					_skin.mcBtns.mcLayer.txtPrayCount.x = _skin.mcBtns.mcLayer.txtRequstBG.x + pos+1;
				}
			}
			_skin.mcBtns.mcLayer.txtRequstBG.visible = _skin.mcBtns.mcLayer.btnPray.visible;
			if(remainCount<=0)
				_skin.mcBtns.mcLayer.txtRequstBG.visible = false;
			if(!_skin.mcBtns.mcLayer.txtRequstBG.visible)
				_skin.mcBtns.mcLayer.txtPrayCount.text = "";
		}
		
		private function updateWelfare():void
		{
			var count:int = (WelfareDataMannager.instance.getRecivableAward() as Array).length;
			if(count == 0)
			{
				_skin.mcBtns.mcLayer.txtWelfareBG.visible = false;
				_skin.mcBtns.mcLayer.txtWelfareCount.text = "";
			}else
			{
				_skin.mcBtns.mcLayer.txtWelfareBG.visible = true;
				_skin.mcBtns.mcLayer.txtWelfareCount.text = count.toString();
				
				var poss:Number = Math.abs((_skin.mcBtns.mcLayer.txtWelfareCount.textWidth - 18) >> 1);
				_skin.mcBtns.mcLayer.txtWelfareCount.x = _skin.mcBtns.mcLayer.txtWelfareBG.x + poss+1;
			}
			_skin.mcBtns.mcLayer.txtWelfareBG.visible = _skin.mcBtns.mcLayer.btnWelfare.visible;
			if(count<=0)
				_skin.mcBtns.mcLayer.txtWelfareBG.visible = false;
			if(!_skin.mcBtns.mcLayer.txtWelfareBG.visible)
				_skin.mcBtns.mcLayer.txtWelfareCount.text = "";
		}

        private function getVisibleDatas(arr:Array):Array
        {
            var data:Array = [];
//            arr.forEach(function (element:MovieClip, index:int, array:Array):void
//            {
//                if (element.visible)
//                    data.push(element);
//            });
			
			var element:DisplayObject;
			for each(var id:String in arr)
			{
				element = getIcon(id);	
				if(element && element.visible)
				{
					data.push(element);
				}
			}
            return data;
        }
		
	}
}