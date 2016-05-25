package com.view.gameWindow.mainUi
{
	import com.view.gameWindow.mainUi.subuis.DeadMask.DeadMask;
	import com.view.gameWindow.mainUi.subuis.IconGroup;
	import com.view.gameWindow.mainUi.subuis.activityNow.ActivityNow;
	import com.view.gameWindow.mainUi.subuis.actvEnter.ActvEnter;
	import com.view.gameWindow.mainUi.subuis.autoSign.AutoSign;
	import com.view.gameWindow.mainUi.subuis.autoSign.IAutoSign;
	import com.view.gameWindow.mainUi.subuis.bottombar.BottomBar;
	import com.view.gameWindow.mainUi.subuis.bottombar.IBottomBar;
	import com.view.gameWindow.mainUi.subuis.bottombar.MailNewEffect;
	import com.view.gameWindow.mainUi.subuis.chatframe.ChatFrame;
	import com.view.gameWindow.mainUi.subuis.chatframe.ChatInput;
	import com.view.gameWindow.mainUi.subuis.chatframe.ChatOutputExx;
	import com.view.gameWindow.mainUi.subuis.chatframe.IChatFrame;
	import com.view.gameWindow.mainUi.subuis.effect.fightNum.FightNumEffect;
	import com.view.gameWindow.mainUi.subuis.effect.fightNum.IFightNumEffect;
	import com.view.gameWindow.mainUi.subuis.effect.propertyChange.PropertyChange;
	import com.view.gameWindow.mainUi.subuis.effect.taskEffect.ITaskEffect;
	import com.view.gameWindow.mainUi.subuis.effect.taskEffect.TaskEffect;
	import com.view.gameWindow.mainUi.subuis.expStoneInfo.ExpStoneInfo;
	import com.view.gameWindow.mainUi.subuis.herohead.HeroHead;
	import com.view.gameWindow.mainUi.subuis.herohead.IHeroHead;
	import com.view.gameWindow.mainUi.subuis.income.IIncome;
	import com.view.gameWindow.mainUi.subuis.income.Income;
	import com.view.gameWindow.mainUi.subuis.mapBossInfo.MapBossInfo;
	import com.view.gameWindow.mainUi.subuis.minimap.IMiniMap;
	import com.view.gameWindow.mainUi.subuis.minimap.MiniMap;
	import com.view.gameWindow.mainUi.subuis.monsterhp.BossHP;
	import com.view.gameWindow.mainUi.subuis.monsterhp.IMonsterHp;
	import com.view.gameWindow.mainUi.subuis.monsterhp.MonsterHp;
	import com.view.gameWindow.mainUi.subuis.movie.MovieCurtain;
	import com.view.gameWindow.mainUi.subuis.onlineReward.OnlineReward;
	import com.view.gameWindow.mainUi.subuis.onlineReward.OnlineShield;
	import com.view.gameWindow.mainUi.subuis.onlineWelfare.OnlineWelfare;
	import com.view.gameWindow.mainUi.subuis.pet.PetUi;
	import com.view.gameWindow.mainUi.subuis.progress.ActionProgress;
	import com.view.gameWindow.mainUi.subuis.rolehead.IRoleHead;
	import com.view.gameWindow.mainUi.subuis.rolehead.PkMenuUi;
	import com.view.gameWindow.mainUi.subuis.rolehead.RoleHead;
	import com.view.gameWindow.mainUi.subuis.rolehp.PlayerHP;
	import com.view.gameWindow.mainUi.subuis.stoneShop.ExchangeShopIcon;
	import com.view.gameWindow.mainUi.subuis.tasktrace.ITaskTrace;
	import com.view.gameWindow.mainUi.subuis.tasktrace.TaskTrace;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.panels.unlock.FuncInfoPanel;
	import com.view.gameWindow.util.DebugUI;
	
	import flash.display.Sprite;

	public class MainUiMediator implements IMainUiMediator
	{
		private static var _instance:MainUiMediator;
		
		public static function getInstance():MainUiMediator
		{
			if (!_instance)
			{
				_instance = new MainUiMediator(new PrivateClass());
			}
			return _instance;
		}
		
		/**鼠标是否在任何面板上*/	
		public function get isMouseOnMainUI():Boolean
		{
			/*var panelBases:Vector.<PanelBase>;
			var panelBase:PanelBase;
			for each(panelBases in _openPanels)
			{
				for each(panelBase in panelBases)
				{
					if(panelBase && panelBase.isMouseOn())
					{
						return true;
					}
				}
			}*/
			return false;
		}
		
		public var isShowDeadMask:Boolean = false;
		private var _layer:Sprite;
		private var _bottomWidth:int;
		private var _actvEnter:ActvEnter;
        private var _activityNow:ActivityNow;
		private var _onlineReward:OnlineReward;
        private var _onlineRewardShield:OnlineShield;//在线盾牌
		private var _deadMask:DeadMask;
		private var _actionProgress:ActionProgress;
		private var _propertyChange:PropertyChange;
//		private var _teamLayer:TeamHeadLayer;
		private var _roleHead:RoleHead;
		private var _bottomBar:BottomBar;
		private var _mapBossInfo:MapBossInfo;
		private var _pet:PetUi;
		private var _expStone:ExpStoneInfo;
		private var _heroHead:HeroHead;
		private var _miniMap:MiniMap;
		private var _monsterHp:MonsterHp;
		private var _bossHp:BossHP;
		private var _playHp:PlayerHP;
		private var _taskTrace:TaskTrace;
		private var _chatFrame:ChatFrame;
		private var _income:Income;
		private var _autoSign:AutoSign;
		private var _taskEffect:TaskEffect;
		private var _fightNumEffect:FightNumEffect;
		private var _mailFly:MailNewEffect;
        private var _pkMenuUi:PkMenuUi;
		private var _onlineWelfare:OnlineWelfare;
		private var _stoneShop:ExchangeShopIcon;

		public function get roleHead():IRoleHead
		{
			return _roleHead;
		}
		
		public function get bottomBar():IBottomBar
		{
			return _bottomBar;
		}

        public function get actvEnter():ActvEnter
        {
            return _actvEnter;
        }

        public function get activityNow():ActivityNow
        {
            return _activityNow;
        }

		public function get exchangeShop():ExchangeShopIcon
		{
			return _stoneShop;
		}
		public function get heroHead():IHeroHead
		{
			return _heroHead;
		}
		
		public function get miniMap():IMiniMap
		{
			return _miniMap;
		}
		
		public function get monsterHp():IMonsterHp
		{
			return _monsterHp;
		}
		
		public function get bossHp():IMonsterHp
		{
			return _bossHp;
		}
		
		public function get playHp():PlayerHP
		{
			return _playHp;
		}
		
		public function get taskTrace():ITaskTrace
		{
			return _taskTrace;
		}
		
		public function get chatFrame():IChatFrame
		{
			return _chatFrame
		}
		
		public function get income():IIncome
		{
			return _income;
		}
		
		public function get autoSign():IAutoSign
		{
			return _autoSign;
		}
		
		public function get taskEffect():ITaskEffect
		{
			return _taskEffect;
		}
		
		public function get fightNumEffect():IFightNumEffect
		{
			return _fightNumEffect;
		}

        public function get onlineReward():OnlineReward
        {
            return _onlineReward;
        }
		public function get settingPanel():Sprite
		{
			return _settingPanel;
		}
		
		public function get mailFly():MailNewEffect
		{
			return _mailFly;
		}
		
		public function get pet():PetUi
		{
			return _pet;
		}
		
		public function get onlineWelfare():OnlineWelfare
		{
			return _onlineWelfare;
		}
		
//		public function get teamLayer():TeamHeadLayer
//		{
//			return _teamLayer;
//		}
		
		//
		private var _movieCurtain:MovieCurtain;
		private var _settingPanel:Sprite;
		private var _funcInfo:FuncInfoPanel;//功能介绍
		public function get movieCurtain():MovieCurtain
		{
			return _movieCurtain;
		}
		//
		private var _uiList:Array = [];
		private var _uiState:Array; //需要恢复的状态
		
		public function get isMouseOn():Boolean
		{
			var obj:Object;
			for each(obj in _uiList)
			{
				var mainUi:MainUi = obj as MainUi;
				if(mainUi && mainUi.isMouseOn())
				{
					return true;
				}
			}
			return false;
		}
		
		public function MainUiMediator(pc:PrivateClass)
		{
			if (!pc)
			{
				throw new Error();
			}
		}
		/**初始化所有主界面元件（加载图片及SWF资源并替换）*/
		public function initView():void
		{
			_movieCurtain = new MovieCurtain();
			_roleHead = new RoleHead();
			_roleHead.initView();
            _pkMenuUi = new PkMenuUi();
            _pkMenuUi.initView();
			_bottomBar = new BottomBar();
			_bottomBar.initView();
			_bottomWidth = _bottomBar.width;
			_heroHead = new HeroHead();
			_heroHead.initView();
			_miniMap = new MiniMap();
			_miniMap.initView();
			_monsterHp = new MonsterHp();
			_monsterHp.initView();
			_bossHp = new BossHP();
			_bossHp.initView();
			_playHp = new PlayerHP();
			_playHp.initView();
			_taskTrace = new TaskTrace();
			_taskTrace.initView();
			_chatFrame = new ChatFrame();
			_chatFrame.initView();
			_chatFrame.output = new ChatOutputExx();
			_chatFrame.outputLoud = new ChatOutputExx(1,1);
			_chatFrame.input = new ChatInput();
			_income = new Income();
			_income.initView();
			_autoSign = new AutoSign();
			_autoSign.initView();
			_actvEnter = new ActvEnter();
			_actvEnter.initView();
            _activityNow = new ActivityNow();
            _activityNow.initView();
			_onlineReward = new OnlineReward();
			_onlineReward.initView();
			_onlineWelfare = new OnlineWelfare();
			_onlineWelfare.initView();
			_onlineRewardShield = new OnlineShield();
			_onlineRewardShield.initView();
			_actionProgress = new ActionProgress();
			_actionProgress.initView();
			_taskEffect = new TaskEffect();
			_taskEffect.initView();
			_fightNumEffect = new FightNumEffect();
			_fightNumEffect.initView();
			_propertyChange = new PropertyChange();
			_propertyChange.initView();
			_pet = new PetUi();
			_pet.initView();
			_expStone = new ExpStoneInfo();
			_expStone.initView();
//			_teamLayer = new TeamHeadLayer();
//			_teamLayer.initView();
			_stoneShop = new ExchangeShopIcon();
			_stoneShop.initView();

			_settingPanel = new Sprite();
			_funcInfo = new FuncInfoPanel();
			_mapBossInfo = new MapBossInfo();
			_mapBossInfo.initView();
			_mailFly = new MailNewEffect();
			_mailFly.initView();
			//_teamLayer,
			_uiList = [	_roleHead,_bottomBar,_heroHead,_miniMap,_monsterHp,_bossHp,_playHp,_taskTrace,_chatFrame,
                _income, _autoSign, _actvEnter, _activityNow, _onlineReward,_onlineWelfare,_onlineRewardShield, _actionProgress, _taskEffect, _fightNumEffect,
				_propertyChange, _pet, _expStone, _settingPanel, _funcInfo, _mapBossInfo, _mailFly, _stoneShop];
			_uiState = [];
			for(var i:int = 0; i < _uiList.length; ++i)
			{
				_uiState.push(_uiList[i].visible);
			}
		}
		
		public function changeUIState(ui:*,show:Boolean):void
		{
			var index:int = _uiList.indexOf(ui);
			if(index != -1)
			{
				_uiState[index] = show;
			}
		}
		
		public function show():void
		{
			for(var i:int = 0; i < _uiList.length; ++i)
			{
				var item:* = _uiList[i];
				item.visible = _uiState[i];
			}
		}
		
		public function hide():void
		{
			for(var i:int = 0; i < _uiList.length; ++i)
			{
				var item:* = _uiList[i];
				
				_uiState[i] = item.visible;
				item.visible = false;
			}
		}
		
		public function getUI(type:String):*
		{
			var re:* = null;
			if (type == PanelConst.TYPE_MAIN_BOTTOMBAR)
			{
				re = _bottomBar;
			}
			else if (type == PanelConst.TYPE_MAIN_TASKTRACE)
			{
				re = _taskTrace;
			}
			else if (type == PanelConst.TYPE_MAIN_ROLEHEAD)
			{
				re = _roleHead;
			}
			else if (type == PanelConst.TYPE_MAIN_HEROHEAD)
			{
				re = _heroHead;
			}
			else if(type == PanelConst.TYPE_MAIN_MINIMAP)
			{
				re = _miniMap;
			}
			else if(type == PanelConst.TYPE_MAIN_ACTVENTER)
			{
				re = _actvEnter;
			}
			else if(type == PanelConst.TYPE_MAIN_FUNCINFO)
			{
				re = _funcInfo;
			}
			return re;
		}
		
		public function showUI(layer:Sprite):void
		{
			_layer = layer;
//            layer.addChild(_teamLayer);
			layer.addChild(_roleHead);
			layer.addChild(_miniMap);
			layer.addChild(_income);
			layer.addChild(_taskTrace);
			layer.addChild(_pet);
			layer.addChild(_bottomBar);
			layer.addChild(_chatFrame);
			layer.addChild(_autoSign);
			layer.addChild(_onlineReward);
			layer.addChild(_onlineWelfare);
			layer.addChild(_onlineRewardShield);
            layer.addChild(_activityNow);
			layer.addChild(_actionProgress);
			layer.addChild(_taskEffect);
			layer.addChild(_fightNumEffect);
			layer.addChild(_propertyChange);
			layer.addChild(_expStone);
			layer.addChild(_actvEnter);
			layer.addChild(_monsterHp);
			layer.addChild(_bossHp);
			layer.addChild(_playHp);
			layer.addChild(_settingPanel);
			layer.addChild(_funcInfo);
			layer.addChild(_mapBossInfo);
			layer.addChild(_movieCurtain);
            layer.addChild(_heroHead);
			layer.addChild(_mailFly);
            layer.addChild(_pkMenuUi);
			layer.addChild(_stoneShop);
            if (DEF::CLIENTLOGIN)
            {
                var log:DebugUI = DebugUI.instance;
                _layer.addChild(log);
            }
		}
		
		/**添加遮罩层*/
		public function addMaskLayer():void
		{
			if(isShowDeadMask)
			{
				removeMask();
			}
			
			_deadMask = new DeadMask;
			_layer.addChild(_deadMask);
			isShowDeadMask = true;
		}
		
		/**移除遮罩层*/
		public function removeMask():void
		{
			if (_deadMask)
			{
				_layer.removeChild(_deadMask);
				_deadMask.destroy();
				_deadMask = null;
			}
			isShowDeadMask = false;
		}
		
		/**添加倒计时*/
		public function addDelayTimer():void
		{
			if (_deadMask)
			{
				_deadMask.addTimer();
			}
		}
		
		public function resize(newWidth:int, newHeight:int):void
		{
			if(_movieCurtain)
			{
				_movieCurtain.resize(newWidth,newHeight);
			}
			IconGroup.instance.resize(newWidth);
			_roleHead.x = 0;
			_roleHead.y = 0;
			
			_miniMap.x = int(newWidth - 214);
			_miniMap.y = 0;
			
			_actvEnter.x = int(newWidth - 210);
			_actvEnter.y = 1;

//			_expStone.x =  int(newWidth - 440);
//			_expStone.y =  130;
			
			_onlineReward.x = int(newWidth - 380);
			_onlineReward.y = 130;

			_onlineWelfare.x = int(newWidth - 380);
			_onlineWelfare.y = 130;
			
            _onlineRewardShield.x = _roleHead.x + _roleHead.width + 10;
            _onlineRewardShield.y = 10;

//			_stoneShop.x=_onlineReward.x-65;
//			_stoneShop.y=130;

            _activityNow.x = int(newWidth - 320);
            _activityNow.y = 130;
			
			_monsterHp.x = int((newWidth - _monsterHp.width) / 2);
			_monsterHp.y = 20;
			
			_bossHp.x = int((newWidth - _bossHp.width) / 2);
			/*_bossHp.y = 20;*/
			_playHp.x = int((newWidth - _playHp.width) / 2);
			
			_taskTrace.x = int(newWidth - _taskTrace.innerWidth);
			_taskTrace.y = 250;
			
			_mapBossInfo.x = _taskTrace.x - 300;
			_mapBossInfo.y = 280;
			
			var chatFrameWidth:Number = /*_chatFrame.width*/336 ;
			var bottomWidthMax:Number = chatFrameWidth + _bottomWidth;
			_chatFrame.x = 0;
			if (newWidth && newWidth < bottomWidthMax)
			{
				_chatFrame.y = int(newHeight - _chatFrame.height - 160);
			}
			else
			{
				_chatFrame.y = int(newHeight - _chatFrame.height);
			}
			
			_bottomBar.x = int((newWidth - _bottomWidth) / 2);
			if(newWidth >= bottomWidthMax && _bottomBar.x < chatFrameWidth)
			{
				_bottomBar.x = _chatFrame.x + chatFrameWidth;
			}
			_bottomBar.y = int(newHeight - 184);
			
            _heroHead.resize();
            _pkMenuUi.x = 0;
            _pkMenuUi.y = 90;

			_income.x = int(newWidth - _income.width - 20);
			_income.y = int(newHeight - _income.height - 20);

			_autoSign.x = int(newWidth - _autoSign.WIDTH) / 2 + _autoSign.MOVETOX;
			_autoSign.y = int(newHeight - _autoSign.HEIGHT) / 2 - _autoSign.MOVETOY;
			/*_autoSign.resize();*/
			
			_actionProgress.x = int((newWidth - _actionProgress.width) * .5);
			_actionProgress.y = _bottomBar.y - 100;
			
			_taskEffect.x = _taskTrace.x - 50;
			_taskEffect.y = 250;
			
			_fightNumEffect.x = _bottomBar.x + 20;
			_fightNumEffect.y = _bottomBar.y-50;
			
			_propertyChange.x = 200;
			_propertyChange.y = 200;
			
			_pet.x =  int(_bottomBar.x+_bottomBar.width-155);
			_pet.y =  int(newHeight - 184);
			
			_funcInfo.x = 0;
            if (_heroHead.visible)
            {
                _funcInfo.y = 280 + 20;
            } else
            {
                _funcInfo.y = 280;
            }

//			if (_teamLayer)
//			{
//				_teamLayer.x = 0;
//				_teamLayer.y = 120;
//			}
			
			if (_settingPanel)
			{
				_settingPanel.x = newWidth - 185;
				_settingPanel.y = 160;
			}
			
			_mailFly.refreshPosition();
		}
	}
}
class PrivateClass
{
}