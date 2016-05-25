package com.view.gameWindow.mainUi.subuis.onlineReward
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.OnlineRewardCfgData;
	import com.model.consts.EffectConst;
	import com.model.consts.StringConst;
	import com.model.consts.ToolTipConst;
	import com.model.dataManager.LoginDataManager;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.pattern.Observer.IObserver;
	import com.view.gameWindow.mainUi.MainUi;
	import com.view.gameWindow.mainUi.subclass.McOnlineReward;
	import com.view.gameWindow.panel.panels.dungeon.TextFormatManager;
	import com.view.gameWindow.panel.panels.guideSystem.GuideSystem;
	import com.view.gameWindow.panel.panels.guideSystem.unlock.UnlockFuncId;
	import com.view.gameWindow.panel.panels.guideSystem.unlock.UnlockObserver;
	import com.view.gameWindow.panel.panels.welfare.WelfareDataMannager;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.LoaderCallBackAdapter;
	import com.view.gameWindow.util.ServerTime;
	import com.view.gameWindow.util.TimeUtils;
	import com.view.gameWindow.util.TimerManager;
	import com.view.gameWindow.util.UIEffectLoader;
	import com.view.gameWindow.util.cell.IconCellEx;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Dictionary;
	
	public class OnlineReward extends MainUi implements IObserver
	{
		internal var mouseHandle:OnlineRewardMouseEvent;
		internal var _icon:IconCellEx;
		private var _text:TextField;
		internal var _rewardTime:int;
		private var _unlockObserver:UnlockObserver;
		private var effect:UIEffectLoader;
		private var _isAllLoaded:Boolean = false;
		private var _effectSprite:Sprite;
		
		private var _isAllGet:Boolean;
		private var _onlineRewardCfg:OnlineRewardCfgData;
		
		public function get onlineRewardCfg():OnlineRewardCfgData
		{
			if(!_onlineRewardCfg && !_isAllGet)
			{
				var onlineRewardCfg:OnlineRewardCfgData;
				var onlineRewardDic:Dictionary = ConfigDataManager.instance.onlineRewardCfgData();
				for each(onlineRewardCfg in onlineRewardDic)
				{
					if (OnlineRewardDataManager.instance.isRewardGetted(onlineRewardCfg.index) == false)
					{
						_onlineRewardCfg = onlineRewardCfg;
						break;
					}
				}
				if(!_onlineRewardCfg)
				{
					_isAllGet = true;
				}
			}
			return _onlineRewardCfg;
		}
		
		public function resetOnlineRewardCfg():void
		{
			_onlineRewardCfg = null;
		}
		
		public function OnlineReward()
		{
			super();
			LoginDataManager.instance.attach(this);
		}
		
		override public function initView():void
		{
			_skin = new McOnlineReward();
			addChild(_skin);
			_skin.visible = false;
			_icon = new IconCellEx(this,0,0,35,35);
			_icon.buttonMode = true;
			addChild(_icon);
			_icon.visible = false;
			_icon.url =  ResourcePathConstants.IMAGE_ICON_ITEM_FOLDER_LOAD + "liquan" + ResourcePathConstants.POSTFIX_PNG;
			_icon.setTipType(ToolTipConst.TEXT_TIP);
			ToolTipManager.getInstance().attach(_icon);
			initData();
			_effectSprite=new Sprite();
			_effectSprite.mouseEnabled=_effectSprite.mouseChildren=false;
			addChild(_effectSprite);
			super.initView();
		}
		
		private function initData():void
		{
			mouseHandle = new OnlineRewardMouseEvent(this);
			mouseHandle.init();
			initText();
			checkLockState(UnlockFuncId.UNLOCK_REWARD);
			initLockStateObserver();
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var skin:McOnlineReward = _skin as McOnlineReward;
			var adapt:LoaderCallBackAdapter = new LoaderCallBackAdapter();
			adapt.addCallBack(rsrLoader, function ():void
			{
				_isAllLoaded = true;
				update();
				adapt = null;
			}, skin.bg, skin.countBg);
		}
		
		private function initLockStateObserver():void
		{
			if(!_unlockObserver)
			{
				_unlockObserver = new UnlockObserver();
				_unlockObserver.setCallback(checkLockState);
				GuideSystem.instance.unlockStateNotice.attach(_unlockObserver);
			}
		}
		
		private function destroyLockStateObserver():void
		{
			if(_unlockObserver)
			{
				_unlockObserver.destroy();
				GuideSystem.instance.unlockStateNotice.detach(_unlockObserver);
				_unlockObserver = null;
			}
		}
		
		private function checkLockState(id:int):void
		{
			if(id == UnlockFuncId.UNLOCK_REWARD)
			{
				visible = GuideSystem.instance.isUnlock(id);
			}
		}
		
		private function initText():void
		{
			_text = new TextField();
			TextFormatManager.instance.setTextFormat(_text,0xffffff,false,false);
			_text.mouseEnabled = false;
			_text.width = 52;
			_text.autoSize = TextFieldAutoSize.CENTER;
			_text.textColor = 0x00ff00;
			_text.filters = [new GlowFilter(0,1,2,2,10)];
			_icon.x = (this.width - _icon.width)/2 - 2;
			_icon.y = 10;
			_text.x+=4;
			_text.y = _icon.y + 46;
			
			addChild(_text);
			update();
		}
		
		public function update(proc:int=0):void
		{
			var day:int = WelfareDataMannager.instance.openDay+1;
			if(day>1)
			{
				visible = false;
				return;
			}
			else
				visible = true;
			var time:int = ServerTime.time;
			var startTime:int = OnlineRewardDataManager.instance.startTime;
			if(!time || !startTime)
			{
				return;
			}
			var online:int = time - startTime;
			if(onlineRewardCfg)
			{
				_rewardTime = (onlineRewardCfg.seconds - online <= 0 ? 0 : onlineRewardCfg.seconds - online);				
				if (_skin)
				{
					_skin.visible = true;
				}
				if (_icon)
				{
					_icon.visible = true;
				}
			}
			else
			{
				if (_skin)
				{
					_skin.visible = false;
				}
				if (_icon)
				{
					_icon.visible = false;
				}
				trace("已全部领取奖励");
				destory();
				return;
			}
			if (_icon)
			{
				_icon.setTipData(StringConst.PROMPT_PANEL_0031.replace("Y",String(onlineRewardCfg.bind_gold)));
			}
			
			if(_rewardTime > 0)
			{
				var obj:Object =  TimeUtils.calcTime3(_rewardTime);
				obj.hour = obj.hour<10?"0"+obj.hour:obj.hour;
				obj.min = obj.min<10?"0"+obj.min:obj.min;
				obj.sec =  obj.sec<10?"0"+obj.sec:obj.sec;
				_text.text = obj.hour+":"+obj.min+":"+obj.sec;
				TimerManager.getInstance().add(1000,updateTime);
				if (effect)
				{
					removeEffect();
				}
			}
			else
			{
				_text.text = StringConst.PROMPT_PANEL_0032;
				if (_isAllLoaded)
				{
					addEffect(_effectSprite);
				}
			}
		}
		
		public function updateTime():void 
		{
			var _online:int = ServerTime.time - OnlineRewardDataManager.instance.startTime;
			_rewardTime = onlineRewardCfg.seconds - _online;
			var num:int = int(_rewardTime/60);
			if(0 >= _rewardTime)
			{
				addEffect(_skin);
				TimerManager.getInstance().remove(updateTime); 
				_text.text = StringConst.PROMPT_PANEL_0032;
				_rewardTime = 0;
				return;
			}
			var obj:Object =  TimeUtils.calcTime3(_rewardTime);
			obj.hour = obj.hour<10?"0"+obj.hour:obj.hour;
			obj.min = obj.min<10?"0"+obj.min:obj.min;
			obj.sec =  obj.sec<10?"0"+obj.sec:obj.sec;
			_text.text = obj.hour+":"+obj.min+":"+obj.sec;
		}
		
		private function addEffect(mc:DisplayObjectContainer):void
		{
			if(!effect)
			{
				effect = new UIEffectLoader(mc, mc.x+28, mc.y+28, 1, 1, EffectConst.RES_ACT_ENTER_EFFECT,function():void
				{
					if (mc && effect.effect)
					{
						mc.addChildAt(effect.effect, 0);
						effect.effect.mouseEnabled = false;
					}
				});
			}
		}
		
		private function removeEffect():void
		{
			if(effect)
			{
				effect.destroyEffect();
				effect = null;
			}
		}
		
		private function destory():void
		{
			destroyLockStateObserver();
			LoginDataManager.instance.detach(this);
			if(mouseHandle)
			{
				mouseHandle.destory();
				mouseHandle = null;
			}
			if(_icon)
			{
				ToolTipManager.getInstance().detach(_icon);
				removeChild(_icon);
				_icon = null;
			}
			if(_text)
			{
				removeChild(_text);
				_text = null;
			}
			if(_skin){
				removeEffect();
				removeChild(_skin);
				_skin = null;
			}
			if(_effectSprite)
			{
				_effectSprite.parent&&_effectSprite.parent.removeChild(_effectSprite);
				_effectSprite=null;
			}
			if (effect)
			{
				effect.destroyEffect();
			}
		}
	}
}