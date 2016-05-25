package com.view.gameWindow.mainUi.subuis.bottombar.sysAlert
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.GameShopCfgData;
	import com.model.configData.cfgdata.ReinCarnCfgData;
	import com.model.configData.cfgdata.SkillCfgData;
	import com.model.consts.GameConst;
	import com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.ExpStone.ExpStoneAlert;
	import com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.RingUp.RingUpAlert;
	import com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.achievement.AchievementAlert;
	import com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.drug.DrugAlertCell;
	import com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.eneygy.EnergyAlert;
	import com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.friend.FriendAlertCell;
	import com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.individualBoss.IndividualBossAlert;
	import com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.lasting.LastingAlertCell;
	import com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.newLife.NewLifeAlert;
	import com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.school.SchoolCallAlert;
	import com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.school.SchoolRequestAlert;
	import com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.school.SchoolUnionAlert;
	import com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.school.SchoolapplyAlert;
	import com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.sign.SignAlert;
	import com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.skill.SkillLearnAlert;
	import com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.team.InviteBuildTeamAlert;
	import com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.team.InviteBuildTeamManager;
	import com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.team.OthersApplyAlert;
	import com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.team.OthersApplyTeamManager;
	import com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.team.TeamInviteAlert;
	import com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.team.TeamInviteManager;
	import com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.team.TeamSetLeaderAlert;
	import com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.trade.TradeAlert;
	import com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.trade.TradeRequestManager;
	import com.view.gameWindow.mainUi.subuis.bottombar.teamHint.TeamHintDataManager;
	import com.view.gameWindow.mainUi.subuis.bottombar.teamHint.data.ApplyData;
	import com.view.gameWindow.mainUi.subuis.bottombar.teamHint.data.InviteData;
	import com.view.gameWindow.mainUi.subuis.bottombar.teamHint.data.InviteJoin;
	import com.view.gameWindow.mainUi.subuis.lasting.LastingHandler;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.achievement.AchievementDataManager;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.boss.BossDataManager;
	import com.view.gameWindow.panel.panels.daily.DailyDataManager;
	import com.view.gameWindow.panel.panels.expStone.ExpStoneDataManager;
	import com.view.gameWindow.panel.panels.friend.ContactDataManager;
	import com.view.gameWindow.panel.panels.friend.ContactType;
	import com.view.gameWindow.panel.panels.guideSystem.GuideSystem;
	import com.view.gameWindow.panel.panels.guideSystem.unlock.UIUnlockHandler;
	import com.view.gameWindow.panel.panels.guideSystem.unlock.UnlockFuncId;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.mall.MallDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.newLife.NewLifeDataManager;
	import com.view.gameWindow.panel.panels.skill.SkillDataManager;
	import com.view.gameWindow.panel.panels.trade.TradeDataManager;
	import com.view.gameWindow.panel.panels.trade.data.ExchangeData;
	import com.view.gameWindow.panel.panels.welfare.OpenDayConsts;
	import com.view.gameWindow.panel.panels.welfare.WelfareDataMannager;
	
	public class SysAlertHandle
	{
		private var _skin:SysAlert;
		
		/*主角等级	红药道具ID	红药包ID	蓝药道具ID	蓝药包ID
		1~39	２５０１	２５3１	２５１１	２５4１
		40~59	２５０２	２５3２	２５１２	２５4２
		60+	２５０３	２５3３	２５１３	２５4３*/
		public static const HP:int = 1;
		public static const MP:int = 2;
		public static const ROLE:int = 1;
		public static const HERO:int = 2;
		private var _mouseHandler:SysAlertMouseHandler;
		
		private const MAXLEVEL:int = 68;
		private var _level:int;
		private var _num:int;//每次转生之前icon出现次数
		private var _reincarn:int;
		private var lastSignNum:int;
		private var lastAchievementNum:int;
		private var unlock:UIUnlockHandler;
		
		public function SysAlertHandle(sysAlert:SysAlert)
		{
			_skin = sysAlert;
			_mouseHandler = new SysAlertMouseHandler(_skin);
			unlock = new UIUnlockHandler(null,0,unlockUpdate);
		}
		
		private function unlockUpdate(id:int):void
		{
			if(id == UnlockFuncId.BUY_SKILL_BOOK_TIP)
			{
				checkSkillLearn();
			}
		}
		
		private function checkBottomBtnOpenState(id:int):Boolean
		{
			var isOpen:Boolean = GuideSystem.instance.isUnlock(id);
			
			return isOpen;
		}
		
		public function checkHeroBagData():void
		{
			if(HeroDataManager.instance.lv<50)return;
			var cellH:AlertCellBase = checkHero();
			if (cellH)
			{
				_skin.removeItemById(HERO);
				_skin.addItem(cellH);
			}
		}
		
		public function checkRoleBagData():void
		{
			if(RoleDataManager.instance.lv<50)return;
			//			if(!WelfareDataMannager.instance.initOpenTime)return;
			var cellR:AlertCellBase = checkRole();
			if (cellR)
			{
				_skin.removeItemById(ROLE);
				_skin.addItem(cellR);
			}
		}
		
		public function checkFriendMessage():void
		{
			var isNeed:Boolean = false;
			
			var list:Array = ContactDataManager.instance.getList(ContactType.MESSAGE);
			
			if (list.length > 0)
			{
				isNeed = true;
			}
			
			if (isNeed)
			{
				var sysCell:AlertCellBase = _skin.getItem(GameConst.FRIEND_MESSAGE) as AlertCellBase;
				
				if (!sysCell)
				{
					sysCell = new FriendAlertCell();
					sysCell.id = GameConst.FRIEND_MESSAGE;
					_skin.addItem(sysCell);
				}
			}
			else
			{
				_skin.removeItemById(GameConst.FRIEND_MESSAGE);
			}
		}
		
		public function checkSchoolApplyMessage():void
		{
			var sysCell:AlertCellBase = _skin.getItem(GameConst.SCHOOL_APPLY_MESSAGE) as AlertCellBase;
			if (!sysCell)
			{
				sysCell = new SchoolapplyAlert();
				sysCell.id = GameConst.SCHOOL_APPLY_MESSAGE;
				_skin.addItem(sysCell);
			}
		}
		
		public function checkSchoolUnionMessage():void
		{
			var sysCell:AlertCellBase = _skin.getItem(GameConst.SCHOOL_UNION_MESSAGE) as AlertCellBase;
			if (!sysCell)
			{
				sysCell = new SchoolUnionAlert();
				sysCell.id = GameConst.SCHOOL_UNION_MESSAGE;
				_skin.addItem(sysCell);
			}
		}
		
		private function checkRole():AlertCellBase
		{
			var bagDataManager:BagDataManager = BagDataManager.instance;
			var sysCell:AlertCellBase;
			var bagDataCount:int;
			var bagDataBackageCount:int;
			var level:int = RoleDataManager.instance.lv;
			var isNeed:Boolean = false;   //是否需要提示
			var day:int = WelfareDataMannager.instance.openServiceDay;
			//对于红药的判断  蓝药的判断本可以与这次等级判断一起写，但是为了方便阅读，再次做等级判断
			if (level > 0 && level < 50)
			{
				bagDataBackageCount = bagDataManager.getItemNumById(2531);
				bagDataCount = bagDataManager.getItemNumById(2501);
				if (bagDataBackageCount < 1 && bagDataCount <= 10)
				{
					isNeed = true;
				}
			}
			else if (level > 49 && level < 70)
			{
				bagDataBackageCount = bagDataManager.getItemNumById(2532);
				bagDataCount = bagDataManager.getItemNumById(2502);
				if (bagDataBackageCount < 1 && bagDataCount <= 10)
				{
					if(day+1<OpenDayConsts.FIRST)
					{
						bagDataBackageCount = bagDataManager.getItemNumById(2531);
						bagDataCount = bagDataManager.getItemNumById(2501);
						if (bagDataBackageCount < 1 && bagDataCount <= 10)
						{
							isNeed = true;
						}else{
							isNeed = false;
						}
						
					}
					else
					{
						isNeed = true;
					}
				}
			}
			else
			{
				bagDataBackageCount = bagDataManager.getItemNumById(2533);
				bagDataCount = bagDataManager.getItemNumById(2503);
				if (bagDataBackageCount < 1 && bagDataCount <= 10)
				{
					if(day+1<OpenDayConsts.FIRST)
					{
						bagDataBackageCount = bagDataManager.getItemNumById(2531);
						bagDataCount = bagDataManager.getItemNumById(2501);
						if (bagDataBackageCount < 1 && bagDataCount <= 10)
						{
							isNeed = true;
						}else{
							isNeed = false;
						}
					}
					else if(day+1<OpenDayConsts.SECOND)
					{
						bagDataBackageCount = bagDataManager.getItemNumById(2532);
						bagDataCount = bagDataManager.getItemNumById(2502);
						if (bagDataBackageCount < 1 && bagDataCount <= 10)
						{
							isNeed = true;
						}else{
							isNeed = false;
						}
					}
					else
					{
						isNeed = true;
					}
				}
			}
			
			if (isNeed)
			{
				if (_skin.getItemByType(ROLE, HP))  //检测类型相同的提示是否已经存在了
				{
					return null;
				}
				sysCell = new DrugAlertCell();
				sysCell.id = ROLE;
				sysCell.type = HP;
				return sysCell;
			}
			//对于蓝药的判断
			if (level > 0 && level < 50)
			{
				bagDataBackageCount = bagDataManager.getItemNumById(2541);
				bagDataCount = bagDataManager.getItemNumById(2511);
				if (bagDataBackageCount < 1 && bagDataCount <= 10)
				{
					isNeed = true;
				}
			}
			else if (level > 49 && level < 70)
			{
				bagDataBackageCount = bagDataManager.getItemNumById(2542);
				bagDataCount = bagDataManager.getItemNumById(2512);
				if (bagDataBackageCount < 1 && bagDataCount <= 10)
				{
					if(day+1<OpenDayConsts.FIRST)
					{
						bagDataBackageCount = bagDataManager.getItemNumById(2541);
						bagDataCount = bagDataManager.getItemNumById(2511);
						if (bagDataBackageCount < 1 && bagDataCount <= 10)
						{
							isNeed = true;
						}else{
							isNeed = false;
						}
					}
					else
					{
						isNeed = true;
					}
				}
			}
			else
			{
				bagDataBackageCount = bagDataManager.getItemNumById(2543);
				bagDataCount = bagDataManager.getItemNumById(2513);
				if (bagDataBackageCount < 1 && bagDataCount <= 10)
				{
					if(day+1<OpenDayConsts.FIRST)
					{
						bagDataBackageCount = bagDataManager.getItemNumById(2541);
						bagDataCount = bagDataManager.getItemNumById(2511);
						if (bagDataBackageCount < 1 && bagDataCount <= 10)
						{
							isNeed = true;
						}else{
							isNeed = false;
						}
					}
					else if(day+1<OpenDayConsts.SECOND)
					{
						bagDataBackageCount = bagDataManager.getItemNumById(2542);
						bagDataCount = bagDataManager.getItemNumById(2512);
						if (bagDataBackageCount < 1 && bagDataCount <= 10)
						{
							isNeed = true;
						}else{
							isNeed = false;
						}
					}
					else
					{
						isNeed = true;
					}
				}
			}
			if (isNeed)
			{
				if (_skin.getItemByType(ROLE, MP))return null;
				sysCell = new DrugAlertCell();
				sysCell.id = ROLE;
				sysCell.type = MP;
				return sysCell;
			}
			
			_skin.removeItemById(ROLE);
			return null;
		}
		
		private function checkHero():AlertCellBase
		{
			var heroDataManager:HeroDataManager = HeroDataManager.instance;
			if (heroDataManager.isHeroExist == false) return null;
			var sysCell:AlertCellBase;
			var bagDataCount:int;
			var bagDataBackageCount:int;
			var level:int = heroDataManager.lv;
			var isNeed:Boolean = false;
			var day:int = WelfareDataMannager.instance.openServiceDay;
			//对于红药的判断
			if (level > 0 && level < 50)
			{
				bagDataBackageCount = heroDataManager.getItemNumById(2531);
				bagDataCount = heroDataManager.getItemNumById(2501);
				if (bagDataBackageCount < 1 && bagDataCount <= 10)
				{
					isNeed = true;
				}
			}
			else if (level > 49 && level < 70)
			{
				bagDataBackageCount = heroDataManager.getItemNumById(2532);
				bagDataCount = heroDataManager.getItemNumById(2502);
				if (bagDataBackageCount < 1 && bagDataCount <= 10)
				{
					if(day+1<OpenDayConsts.FIRST)
					{
						bagDataBackageCount = heroDataManager.getItemNumById(2531);
						bagDataCount = heroDataManager.getItemNumById(2501);
						if (bagDataBackageCount < 1 && bagDataCount <= 10)
						{
							isNeed = true;
						}else{
							isNeed = false;
						}
						
					}
					else
					{
						isNeed = true;
					}
				}
			}
			else
			{
				bagDataBackageCount = heroDataManager.getItemNumById(2533);
				bagDataCount = heroDataManager.getItemNumById(2503);
				if (bagDataBackageCount < 1 && bagDataCount <= 10)
				{
					if(day+1<OpenDayConsts.FIRST)
					{
						bagDataBackageCount = heroDataManager.getItemNumById(2531);
						bagDataCount = heroDataManager.getItemNumById(2501);
						if (bagDataBackageCount < 1 && bagDataCount <= 10)
						{
							isNeed = true;
						}else{
							isNeed = false;
						}
					}
					else if(day+1<OpenDayConsts.SECOND)
					{
						bagDataBackageCount = heroDataManager.getItemNumById(2532);
						bagDataCount = heroDataManager.getItemNumById(2502);
						if (bagDataBackageCount < 1 && bagDataCount <= 10)
						{
							isNeed = true;
						}else{
							isNeed = false;
						}
					}
					else
					{
						isNeed = true;
					}
				}
			}
			
			if (isNeed)
			{
				if (_skin.getItemByType(HERO, HP))
				{
					return null;
				}
				sysCell = new DrugAlertCell();
				sysCell.id = HERO;
				sysCell.type = HP;
				return sysCell;
			}
			
			//对于蓝药的判断  目前不需要这个功能
			/*if(level>0&&level<40)  
			{
			bagDataBackage=heroDataManager.getHeroBagDataById(2541);
			bagData=heroDataManager.getHeroBagDataById(2511);
			if((bagDataBackage==null||bagDataBackage.count<1)&&(bagData==null||bagData.count<=10))
			{
			isNeed=true;
			}
			}
			else if(level>39&&level<60)
			{
			bagDataBackage=heroDataManager.getHeroBagDataById(2542);
			bagData=heroDataManager.getHeroBagDataById(2512);
			if((bagDataBackage==null||bagDataBackage.count<1)&&(bagData==null||bagData.count<=10))
			{
			if(day+1<OpenDayConsts.FIRST)
			{
			isNeed = false;
			}
			else
			{
			isNeed=true;
			}
			}
			}
			else
			{
			bagDataBackage=heroDataManager.getHeroBagDataById(2543);
			bagData=heroDataManager.getHeroBagDataById(2513);
			if((bagDataBackage==null||bagDataBackage.count<1)&&(bagData==null||bagData.count<=10))
			{
			if(day+1<OpenDayConsts.FIRST || day+1<OpenDayConsts.SECOND)
			{
			isNeed = false;
			}
			else
			{
			isNeed=true;
			}
			}
			}*/
			_skin.removeItemById(HERO);
			return null;
		}
		
		public function checkSchoolCallMessage():void
		{
			var sysCell:AlertCellBase = _skin.getItem(GameConst.SCHOOL_CALL_MESSAGE) as AlertCellBase;
			if (!sysCell)
			{
				sysCell = new SchoolCallAlert();
				sysCell.id = GameConst.SCHOOL_CALL_MESSAGE;
				_skin.addItem(sysCell);
			}
		}
		
		public function checkSchoolRequetMessage():void
		{
			var sysCell:AlertCellBase = _skin.getItem(GameConst.SCHOOL_REQUEST_MESSAGE) as AlertCellBase;
			if (!sysCell)
			{
				sysCell = new SchoolRequestAlert();
				sysCell.id = GameConst.SCHOOL_REQUEST_MESSAGE;
				_skin.addItem(sysCell);
			}
		}
		
		public function checkTradeMessage():void
		{
			var sysCell:AlertCellBase = _skin.getItem(GameConst.TRADE_MESSAGE) as AlertCellBase;
			if (!sysCell)
			{
				sysCell = new TradeAlert();
				sysCell.id = GameConst.TRADE_MESSAGE;
				_skin.addItem(sysCell);
			}
			var data:ExchangeData = TradeDataManager.instance.exchangeData;
			TradeRequestManager.instance.addRequestTrade(data);
		}
		
		public function checkLasting():void
		{
			if(LastingHandler.refreshData())
			{
				var sysCell:AlertCellBase = _skin.getItem(GameConst.LASTING_MESSAGE) as AlertCellBase;
				if (!sysCell)
				{
					var lastingAlertCell:LastingAlertCell = new LastingAlertCell();
					//					lastingAlertCell.lastingHandler=this._lastingHandler;
					sysCell =lastingAlertCell;
					sysCell.id = GameConst.LASTING_MESSAGE;
					
					_skin.addItem(sysCell);
				}
			}
			else
			{
				_skin.removeItemById(GameConst.LASTING_MESSAGE);
			}
		}
		
		private var _isUnlearn:Boolean = false;
		public function checkSkillLearn():void
		{
			var isUnlock:Boolean = GuideSystem.instance.isUnlock(UnlockFuncId.BUY_SKILL_BOOK_TIP);
			
			if(!isUnlock)
			{
				return;
			}
			if(!SkillDataManager.instance.hasInit)
			{
				return;
			}
			
			var skillLearn:SkillCfgData = SkillDataManager.instance.getGuideSkillState();
			if(RoleDataManager.instance.checkReincarnLevel(SkillDataManager.LEARN_RE,SkillDataManager.LEARN_LV) 
				&& !skillLearn)
			{
				var sysCell:AlertCellBase = _skin.getItem(GameConst.SKILL_LEARN) as AlertCellBase;
				if (!sysCell)
				{
					sysCell = new SkillLearnAlert();
					sysCell.id = GameConst.SKILL_LEARN;
					_skin.addItem(sysCell);
				}
				
				var skill:SkillCfgData = ConfigDataManager.instance.skillCfgData1(SkillDataManager.instance.getGuideLearnSkillId());
				
				_isUnlearn = true;
				return;
			}
			
			if(skillLearn)
			{
				var shopData:GameShopCfgData = MallDataManager.instance.getShopCfgDataBySkillId(skillLearn.id);
				if(shopData)
				{
					shopData.hight_light = false;
				}
			}
			
			_skin.removeItemById(GameConst.SKILL_LEARN);
			
			if(_isUnlearn)
			{
				PanelMediator.instance.closePanel(PanelConst.TYPE_MALL);
				_isUnlearn = false;
			}
		}
		
		public function checkTrailerAsk():void
		{
			
		}
		
		public function checkReincarn():void
		{
			var roleDataManager:RoleDataManager = RoleDataManager.instance;
			var reincarnCfg:ReinCarnCfgData = ConfigDataManager.instance.reincarnCfgData(roleDataManager.reincarn);
			if(!ConfigDataManager.instance.reincarnCfgData(roleDataManager.reincarn + 1))
			{
				return;
			}
			if(_reincarn != roleDataManager.reincarn)
			{
				_num = 0;
			}
			if(roleDataManager.lv == MAXLEVEL + roleDataManager.reincarn && _level != roleDataManager.lv && _num == 0)
			{
				_num = 1;
				var sysCell:AlertCellBase = _skin.getItem(GameConst.NEWLIFE) as AlertCellBase;
				if (!sysCell)
				{
					sysCell = new NewLifeAlert();
					sysCell.id = GameConst.NEWLIFE;
					
					_skin.addItem(sysCell);
				}
				//				showReincarnIconTip();
			}
			if((_num == 1 && roleDataManager.lv == MAXLEVEL + roleDataManager.reincarn && 
				reincarnCfg.coin <= BagDataManager.instance.coinBind + BagDataManager.instance.coinUnBind && 
				(roleDataManager.exp/ConfigDataManager.instance.levelCfgData(MAXLEVEL + roleDataManager.reincarn).player_exp == 1 ||
				(NewLifeDataManager.instance.dungeon == reincarnCfg.dungeon && NewLifeDataManager.instance.time))))
			{
				_num = 2;
				if (!sysCell)
				{
					sysCell = new NewLifeAlert();
					sysCell.id = GameConst.NEWLIFE;
					
					_skin.addItem(sysCell);
				}
				//				showReincarnIconTip();
			}
			_reincarn = roleDataManager.reincarn;
			_level = roleDataManager.lv;
		}
		
		public function checkInviteBuildTeam():void
		{
			var sysCell:AlertCellBase = _skin.getItem(GameConst.INVITE_BUILD_TEAM) as AlertCellBase;
			if (!sysCell)
			{
				sysCell = new InviteBuildTeamAlert();
				sysCell.id = GameConst.INVITE_BUILD_TEAM;
				_skin.addItem(sysCell);
			}
			var data:InviteData = TeamHintDataManager.instance.dataInvite;
			InviteBuildTeamManager.instance.addInviteBuildTeamData(data);
			(sysCell as InviteBuildTeamAlert).refreshNum(InviteBuildTeamManager.instance.size);
		}
		
		public function checkSetTeamLeader():void
		{
			var sysCell:AlertCellBase = _skin.getItem(GameConst.SET_TEAM_LEADER) as AlertCellBase;
			if (!sysCell)
			{
				sysCell = new TeamSetLeaderAlert();
				sysCell.id = GameConst.SET_TEAM_LEADER;
				_skin.addItem(sysCell);
			}
		}
		
		public function checkTeamApply():void
		{
			var sysCell:AlertCellBase = _skin.getItem(GameConst.OTHERS_APPLY_TEAM) as AlertCellBase;
			if (!sysCell)
			{
				sysCell = new OthersApplyAlert();
				sysCell.id = GameConst.OTHERS_APPLY_TEAM;
				_skin.addItem(sysCell);
			}
			var data:ApplyData = TeamHintDataManager.instance.dataApply;
			OthersApplyTeamManager.instance.addInviteBuildTeamData(data);
			(sysCell as OthersApplyAlert).refreshNum(OthersApplyTeamManager.instance.size);
		}
		
		public function checkTeamInvite():void
		{
			var sysCell:AlertCellBase = _skin.getItem(GameConst.INVITE_OTHER_JOIN) as AlertCellBase;
			if (!sysCell)
			{
				sysCell = new TeamInviteAlert();
				sysCell.id = GameConst.INVITE_OTHER_JOIN;
				_skin.addItem(sysCell);
			}
			var data:InviteJoin = TeamHintDataManager.instance.dataInviteJoin;
			TeamInviteManager.instance.addInviteBuildTeamData(data);
			(sysCell as TeamInviteAlert).refreshNum(TeamInviteManager.instance.size);
		}
		
		public function checkAchievement():void
		{
			if(RoleDataManager.instance.lv<50)return;
			var count:int = AchievementDataManager.getInstance().noRequstCount;
			if(count==lastAchievementNum)
				return;
			lastAchievementNum = count;
			if(count > 0)
			{
				var sysCell:AlertCellBase = _skin.getItem(GameConst.ACHIEVEMENT_NEW) as AlertCellBase;
				if (!sysCell)
				{
					sysCell = new AchievementAlert();
					sysCell.id = GameConst.ACHIEVEMENT_NEW;
					_skin.addItem(sysCell);
				}
				return;
			}
			_skin.removeItemById(GameConst.ACHIEVEMENT_NEW);
		}
		
		public function checkSign():void
		{
			if(RoleDataManager.instance.lv<30)return;
			var num:int = WelfareDataMannager.instance.getSignNum();
			if(num==lastSignNum)
				return;
			lastSignNum = num;
			if(num>0){
				var sysCell:AlertCellBase = _skin.getItem(GameConst.SIGN_NEW) as AlertCellBase;
				if (!sysCell)
				{
					sysCell = new SignAlert();
					sysCell.id = GameConst.SIGN_NEW;
					_skin.addItem(sysCell);
				}
				return;
			}
			_skin.removeItemById(GameConst.SIGN_NEW);
			
		}
		
		
		public function checkIndBoss():void
		{
			if(RoleDataManager.instance.lv<58)return;
			var num:int = BossDataManager.instance.getIndividualBossCount();
			if(num>0)
			{
				var sysCell:AlertCellBase = _skin.getItem(GameConst.INDIVIDUAL_BOSS) as AlertCellBase;
				if (!sysCell)
				{
					sysCell = new IndividualBossAlert();
					sysCell.id = GameConst.INDIVIDUAL_BOSS;
					_skin.addItem(sysCell);
				}
				return;
			}
			_skin.removeItemById(GameConst.INDIVIDUAL_BOSS);
		}
		
		public function cheakRingUp():void
		{
			if (!checkBottomBtnOpenState(UnlockFuncId.CONVERT_LIST))return;
			var num:int = RoleDataManager.instance.canDoRingUp();
			if(num>0){
				var sysCell:AlertCellBase = _skin.getItem(GameConst.RINGUP_MESSAGE) as AlertCellBase;
				if (!sysCell)
				{
					sysCell = new RingUpAlert();
					sysCell.id = GameConst.RINGUP_MESSAGE;
					_skin.addItem(sysCell);
				}
				return;
			}
			_skin.removeItemById(GameConst.RINGUP_MESSAGE);
		}
		
		public function checkExpStone():void
		{
//			if(ExpStoneDataManager.instance.checked == false)return;
			var num:int = ExpStoneDataManager.instance.getFullExpStoneNum();
			var canuse:Boolean = (ExpStoneDataManager.instance.num< ExpStoneDataManager.instance.sum);
			if(num>0&&canuse){
				var sysCell:AlertCellBase = _skin.getItem(GameConst.EXPSTONE_MESSAGE) as AlertCellBase;
				if (!sysCell)
				{
					sysCell = new ExpStoneAlert();
					sysCell.id = GameConst.EXPSTONE_MESSAGE;
					_skin.addItem(sysCell);
				}
				//				(sysCell as ExpStoneAlert).refreshNum(num);
				return;
			}
			_skin.removeItemById(GameConst.EXPSTONE_MESSAGE);
		}
		
		public function checkEnergy():void
		{
			var num:int = DailyDataManager.instance.getCanGetRewardNum();
			if(num>0){
				var sysCell:AlertCellBase = _skin.getItem(GameConst.ENERGY_MESSAGE) as AlertCellBase;
				if (!sysCell)
				{
					sysCell = new EnergyAlert();
					sysCell.id = GameConst.ENERGY_MESSAGE;
					_skin.addItem(sysCell);
				}
				return;
			}
			_skin.removeItemById(GameConst.ENERGY_MESSAGE);
		}
		
	}
}