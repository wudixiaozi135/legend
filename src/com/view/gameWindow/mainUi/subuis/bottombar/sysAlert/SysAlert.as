package com.view.gameWindow.mainUi.subuis.bottombar.sysAlert
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.consts.GameConst;
	import com.model.gameWindow.mem.MemEquipDataManager;
	import com.pattern.Observer.IObserver;
	import com.view.gameWindow.mainUi.subuis.activityTrace.ActivityDataManager;
	import com.view.gameWindow.mainUi.subuis.bottombar.teamHint.TeamHintDataManager;
	import com.view.gameWindow.panel.panels.achievement.AchievementDataManager;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.boss.BossDataManager;
	import com.view.gameWindow.panel.panels.daily.DailyDataManager;
	import com.view.gameWindow.panel.panels.expStone.ExpStoneDataManager;
	import com.view.gameWindow.panel.panels.friend.ContactDataManager;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.newLife.NewLifeDataManager;
	import com.view.gameWindow.panel.panels.skill.SkillDataManager;
	import com.view.gameWindow.panel.panels.trade.TradeDataManager;
	import com.view.gameWindow.panel.panels.vip.VipDataManager;
	import com.view.gameWindow.panel.panels.welfare.WelfareDataMannager;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	public class SysAlert extends Sprite implements IObserver,ISysAlert
	{
		private var _items:Vector.<ISysAlertCell>;
		private var _sysAlertHandle:SysAlertHandle;

		public function SysAlert()
		{
			super();
			_sysAlertHandle = new SysAlertHandle(this);
			this.mouseEnabled = false;
			_items = new Vector.<ISysAlertCell>();
			
			RoleDataManager.instance.attach(this);
			BagDataManager.instance.attach(this);
			HeroDataManager.instance.attach(this);
			TeamHintDataManager.instance.attach(this);
			ContactDataManager.instance.attach(this);
			SysAlertDataManage.getInstance().attach(this);
			TradeDataManager.instance.attach(this);
			MemEquipDataManager.instance.attach(this);
			ActivityDataManager.instance.loongWarDataManager.attach(this);
			NewLifeDataManager.instance.attach(this);
			SkillDataManager.instance.attach(this);
			AchievementDataManager.getInstance().attach(this);
			WelfareDataMannager.instance.attach(this);
			BossDataManager.instance.attach(this);
			DailyDataManager.instance.attach(this);
			ExpStoneDataManager.instance.attach(this);
			NewLifeDataManager.instance.attach(this);
		}

		
		public function addItem(alertItem:ISysAlertCell):void
		{
			if (getItem(alertItem.id))
			{
				return;  //如果已经存在，不要添加
			}
			addChild(alertItem as DisplayObject);
			alertItem.x = _items.length * 43;
			alertItem.y = 0;
			alertItem.show();
			_items.push(alertItem);
		}

		public function removeItem(alertCell:ISysAlertCell):void
		{
			if (alertCell == null)
			{
				return;
			}
			_items.splice(_items.indexOf(alertCell), 1);
			removeChild(alertCell as DisplayObject);
			alertCell.destroy();
			alertCell = null;

			for (var i:int = 0; i < _items.length; i++)
			{
				_items[i].x = i * 43;
			}
		}

		public function removeItemById(id:int):void
		{
			var item:ISysAlertCell = getItem(id);
			removeItem(item);
		}

		public function getItem(id:int):ISysAlertCell
		{
			for each(var item:ISysAlertCell in _items)
			{
				if (item.id == id)
				{
					return item;
				}
			}
			return null;
		}

		public function getItemByType(id:int, type:int):ISysAlertCell
		{
			for each(var item:ISysAlertCell in _items)
			{
				if (item.id == id && item.type == type)
				{
					return item;
				}
			}
			return null;
		}

		public function getTotalCellLength():int
		{
			if (_items && _items.length)
			{
				return _items.length;
			}
			return 0;
		}
		
		public function refreshPosition():void
		{
			for (var i:int = 0; i < _items.length; i++)
			{
				_items[i].x = i * 43;
			}
		}
		
		public function update(proc:int=0):void
		{
			if (proc == GameServiceConstants.SM_BAG_ITEMS)
			{
				_sysAlertHandle.checkRoleBagData();
				_sysAlertHandle.checkReincarn();
//				_sysAlertHandle.cheakRingUp();
			}
			else if(proc == GameServiceConstants.SM_ALL_EXP_YU_INFO)
			{
				_sysAlertHandle.checkExpStone();
			}
			else if (proc == GameServiceConstants.SM_HERO_INFO)
			{
				_sysAlertHandle.checkHeroBagData();
			}
			else if (proc == GameServiceConstants.SM_ADD_FRIEND_PUSH_MESSAGE)
			{
				_sysAlertHandle.checkFriendMessage();
			}
			else if (proc==GameServiceConstants.SM_FAMILY_APPLY)
			{
				_sysAlertHandle.checkSchoolApplyMessage();
			}
			else if (proc==GameServiceConstants.SM_FAMILY_CALL)
			{
				_sysAlertHandle.checkSchoolCallMessage();
			}
			else if (proc==GameServiceConstants.SM_FAMILY_INVITE)
			{
				_sysAlertHandle.checkSchoolRequetMessage();
			}
			else if (proc == GameServiceConstants.SM_CREATE_EXCHANGE)
			{
				_sysAlertHandle.checkTradeMessage();
			}
			else if (proc == GameServiceConstants.SM_CHR_INFO||proc == GameServiceConstants.SM_MEM_UNIQUE_EQUIP_INFO)
			{
				_sysAlertHandle.checkReincarn();
				_sysAlertHandle.checkLasting();
				_sysAlertHandle.checkSkillLearn();
//				_sysAlertHandle.cheakRingUp();
				if(RoleDataManager.instance.oldLv == 29&&RoleDataManager.instance.lv == 30)
				{
					if(VipDataManager.instance.lv>=1)
						return;
					_sysAlertHandle.checkSign();
				}
				if(RoleDataManager.instance.oldLv == 53&&RoleDataManager.instance.lv == 54)
					_sysAlertHandle.checkIndBoss();
					
			}
			else if(proc ==GameServiceConstants.CM_REINCARN)
			{
				removeItemById(GameConst.NEWLIFE);
			}
			else if (proc == GameServiceConstants.SM_FAMILY_MEMBER_TRAILER_ASK_HELP)
			{
				_sysAlertHandle.checkTrailerAsk();
			}
			else if (proc == GameServiceConstants.SM_FAMILY_LONGCHENG_LEAGUE)
			{
				_sysAlertHandle.checkSchoolUnionMessage();
			}
			else if(proc == GameServiceConstants.SM_REINCARN_DUNGEON_INFO)
			{
				_sysAlertHandle.checkReincarn();
			} else if (proc == GameServiceConstants.SM_CREATE_TEAM_INVITE)
			{//当对方未设置自动允许组队，向对方下发组队请求的协议
				_sysAlertHandle.checkInviteBuildTeam();
			} else if (proc == GameServiceConstants.SM_SET_TEAM_LEADER_CHECK)//设置队长请求
			{
				_sysAlertHandle.checkSetTeamLeader();
			} else if (proc == GameServiceConstants.SM_TEAM_APPLY_CHECK)
			{
				_sysAlertHandle.checkTeamApply();
			} else if (proc == GameServiceConstants.SM_TEAM_INVITE_CHECK)
			{
				_sysAlertHandle.checkTeamInvite();
			}
			else if(proc == GameServiceConstants.SM_SKILL_LIST)
			{
				_sysAlertHandle.checkSkillLearn();
			}
//			else if(proc == GameServiceConstants.SM_ACHIEVEMENT_LIST)
//			{
//				_sysAlertHandle.checkAchievement();
//			}
			else if(proc == GameServiceConstants.SM_QUERY_SIGN || proc == GameServiceConstants.SM_QUERY_OFF_LINE)
			{
				if(VipDataManager.instance.lv>=1)
					return;
				_sysAlertHandle.checkSign();
					
			}else if(/*proc == GameServiceConstants.SM_BOSS_HP_INFO ||*/proc == BossDataManager.INDIVIDUAL_BOSS_NEW)
			{
				_sysAlertHandle.checkIndBoss();
				
			}else if(proc == GameServiceConstants.SM_DAILY_INFO)
			{
				_sysAlertHandle.checkEnergy();
			}
		}
	}
}