package com.view.gameWindow.mainUi.subuis.bottombar.sysAlert
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.EquipExchangeCfgData;
	import com.model.configData.cfgdata.GameShopCfgData;
	import com.model.consts.ConstStorage;
	import com.model.consts.GameConst;
	import com.model.consts.ItemType;
	import com.model.consts.StringConst;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.mainUi.subuis.activityTrace.ActivityDataManager;
	import com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.team.TeamAlertMouseHandler;
	import com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.trade.TradeRequestManager;
	import com.view.gameWindow.mainUi.subuis.lasting.LastingDataMananger;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.IPanelTab;
	import com.view.gameWindow.panel.panels.bag.BagData;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.boss.BossDataManager;
	import com.view.gameWindow.panel.panels.convert.ConvertListPanelNew;
	import com.view.gameWindow.panel.panels.daily.DailyDataManager;
	import com.view.gameWindow.panel.panels.expStone.ExpStoneData;
	import com.view.gameWindow.panel.panels.expStone.ExpStoneDataManager;
	import com.view.gameWindow.panel.panels.expStone.ExpStonePanel;
	import com.view.gameWindow.panel.panels.friend.AddFriendAlert;
	import com.view.gameWindow.panel.panels.guideSystem.action.OpenPanelAction;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.keyBuy.KeyBuyPanel;
	import com.view.gameWindow.panel.panels.mall.MallDataManager;
	import com.view.gameWindow.panel.panels.mall.constant.ShopShelfType;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.school.complex.SchoolElseDataManager;
	import com.view.gameWindow.panel.panels.school.complex.member.SchoolMemberData;
	import com.view.gameWindow.panel.panels.school.simpleness.list.item.SchoolData;
	import com.view.gameWindow.panel.panels.skill.SkillDataManager;
	import com.view.gameWindow.panel.panels.trade.TradeDataManager;
	import com.view.gameWindow.panel.panels.trade.data.ExchangeData;
	import com.view.gameWindow.scene.entity.EntityLayerManager;
	import com.view.gameWindow.scene.entity.entityItem.interf.IFirstPlayer;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	import mx.utils.StringUtil;

	public class SysAlertMouseHandler
	{
		
		private var _skin:SysAlert;
		private var _teamAlertHandler:TeamAlertMouseHandler;
		public function SysAlertMouseHandler(panel:SysAlert)
		{
			_skin=panel;
			_skin.addEventListener(MouseEvent.CLICK,onClickFunc);
			if (!_teamAlertHandler)
			{
				_teamAlertHandler = new TeamAlertMouseHandler(_skin);
			}
		}

		private function onClickFunc(e:MouseEvent):void
		{
			var cell:AlertCellBase=e.target.parent.parent.parent as AlertCellBase;
			if(cell==null)return;
			if(cell.id == GameConst.FRIEND_MESSAGE)
			{
				var alert:AddFriendAlert = new AddFriendAlert();
				alert.show();
			}
			else if(cell.id==GameConst.SCHOOL_APPLY_MESSAGE)
			{
				_skin.removeItemById(cell.id);
				PanelMediator.instance.switchPanel(PanelConst.TYPE_SCHOOL_APPLY);
			}
			else if(cell.id==GameConst.SCHOOL_CALL_MESSAGE)
			{
				var callperson:SchoolMemberData = SysAlertDataManage.getInstance().callperson;
				var content:String=StringUtil.substitute(StringConst.SCHOOL_PANEL_2020,callperson.name);
				Alert.show2(content,onSureFunc,null,StringConst.TEAM_PANEL_00033,StringConst.TEAM_PANEL_00034,onCancelFunc);
				_skin.removeItemById(cell.id);
			}
			else if(cell.id==GameConst.SCHOOL_REQUEST_MESSAGE)
			{
				var requestSchool:SchoolData = SysAlertDataManage.getInstance().requestSchool;
				var content1:String=StringUtil.substitute(StringConst.SCHOOL_PANEL_2027,requestSchool.name);
				Alert.show2(content1,onSureFunc1,null,StringConst.TEAM_PANEL_00033,StringConst.TEAM_PANEL_00034,onCancelFunc1,"left");
				_skin.removeItemById(cell.id);
			}
			else if(cell.id == GameConst.SCHOOL_UNION_MESSAGE)
			{
				ActivityDataManager.instance.loongWarDataManager.cmFamilyQueryLeagueApply();
				PanelMediator.instance.openPanel(PanelConst.TYPE_LOONG_WAR_LIST_UNION,true,cell.id);
			}
			else if(cell.id==GameConst.LASTING_MESSAGE)
			{
//				Panel1ImgPrompt.strContent=StringConst.PROMPT_PANEL_0028;
//				Panel1ImgPrompt.strSureBtn=StringConst.PROMPT_PANEL_0029;
//				Panel1ImgPrompt.strCancelBtn=StringConst.PROMPT_PANEL_0030;
//				Panel1ImgPrompt.sureFunc=repairFunc;
//				PanelMediator.instance.switchPanel(PanelConst.TYPE_1IMG_PROMPT);
				PanelMediator.instance.switchPanel(PanelConst.TYPE_EQUIP_REPAIR_ALERT);
			}
			else if (cell.id == GameConst.TRADE_MESSAGE)
			{
				var requestManager:TradeRequestManager = TradeRequestManager.instance;
				var size:int = requestManager.size;
				if (size > 0)
				{
					var requestTrade:ExchangeData = requestManager.getLastData();
					var msg:String = StringUtil.substitute(StringConst.TRADE_008, requestTrade.name);
					Alert.show2(msg, function ():void
					{
						TradeDataManager.instance.argreeOrRefuseTrade(requestTrade.cid, requestTrade.sid, 1);
						TradeRequestManager.instance.deleteLastData();
						if (requestManager.size <= 0)
						{
							_skin.removeItemById(cell.id);
						}
					}, null, StringConst.TEAM_PANEL_00033, StringConst.TEAM_PANEL_00034, function ():void
					{
						TradeDataManager.instance.argreeOrRefuseTrade(requestTrade.cid, requestTrade.sid, 0);
						TradeRequestManager.instance.deleteLastData();
						if (requestManager.size <= 0)
						{
							_skin.removeItemById(cell.id);
						}
					}, "left");
				} else
				{
					_skin.removeItemById(cell.id);
				}
			}
			else if(cell.id == GameConst.NEWLIFE)
			{
				_skin.removeItemById(cell.id);
				var panel:IPanelTab;
				PanelMediator.instance.openPanel(PanelConst.TYPE_ROLE_PROPERTY);
				panel = getUI(PanelConst.TYPE_ROLE_PROPERTY) as IPanelTab;
				panel.setTabIndex(1);
			} else if (cell.id == GameConst.INVITE_BUILD_TEAM)
			{
				_teamAlertHandler.handlerInviteBuildTeam(cell);
			} else if (cell.id == GameConst.SET_TEAM_LEADER)
			{
				_teamAlertHandler.handlerSetTeamLeader(cell);
			} else if (cell.id == GameConst.OTHERS_APPLY_TEAM)
			{
				_teamAlertHandler.handlerOthersApply(cell);
			} else if (cell.id == GameConst.INVITE_OTHER_JOIN)
			{
				_teamAlertHandler.handlerInviteOtherJoin(cell);
			}
			else if(cell.id == GameConst.SKILL_LEARN)
			{
				var skillId:int = SkillDataManager.instance.getGuideLearnSkillId();
				var shopData:GameShopCfgData = MallDataManager.instance.getShopCfgDataBySkillId(skillId);
				if(shopData)
				{
					shopData.hight_light = true;
					var pageIndex:int = MallDataManager.instance.getPageIndex(ShopShelfType.TYPE_SKILL,shopData.id);
					var shelfIndex:int = ShopShelfType.TYPE_SKILL - 1;
					var skillOpen:OpenPanelAction = new OpenPanelAction(PanelConst.TYPE_MALL,shelfIndex,pageIndex);
					skillOpen.act();
				}
				
				
//				if(shopData)
//				{
//					MallBuyData.buyData = shopData;
//					PanelMediator.instance.switchPanel(PanelConst.TYPE_MALL_BUY);
//				}
			}
			else if(cell.id == GameConst.ACHIEVEMENT_NEW)
			{
				_skin.removeItemById(cell.id);
				PanelMediator.instance.switchPanel(PanelConst.TYPE_ACHI);
			}
			else if(cell.id == GameConst.SIGN_NEW)
			{
				_skin.removeItemById(cell.id);
				PanelMediator.instance.switchPanel(PanelConst.TYPE_WELFARE);
			}
			else if(cell.id == GameConst.INDIVIDUAL_BOSS)
			{
				_skin.removeItemById(cell.id);
//				PanelMediator.instance.openDefaultIndexPanel(PanelConst.TYPE_BOSS,BossDataManager.INDIVIDUAL_BOSS_INDEX);
				BossDataManager.instance.dealSwitchPanleBoss();
				panel = getUI(PanelConst.TYPE_BOSS) as IPanelTab;
				panel.setTabIndex(2);
			}
			else if(cell.id == GameConst.ENERGY_MESSAGE)
			{
				DailyDataManager.instance.dealSwitchPanelDaily();
			}
			else if(cell.id == GameConst.EXPSTONE_MESSAGE)
			{
//				PanelMediator.instance.openPanel(PanelConst.TYPE_EXP_STONE);
				var data:ExpStoneData = ExpStoneDataManager.instance.getCurrrntExpStone();
				ExpStonePanel.show(data.storage, data.slot);
			}
			else if(cell.id == GameConst.RINGUP_MESSAGE)
			{
				var cfg:EquipExchangeCfgData  = ConfigDataManager.instance.equipExchangeCfgData(RoleDataManager.instance.getFireHeartId());
				ConvertListPanelNew.DEFAULT_SELECTED_INDEX = cfg.step-1;
				PanelMediator.instance.switchPanel(PanelConst.TYPE_CONVERT_LIST);
			}
			else
			{
				KeyBuyPanel.HOR=cell.id;
				KeyBuyPanel.TYPE = cell.type;
				PanelMediator.instance.switchPanel(PanelConst.TYPE_BAG_KEYBUY);
			}
		}
		
		
		public function getUI(name:String):*
		{
			var panel:DisplayObjectContainer = null;
			if(!panel)
			{
				panel = PanelMediator.instance.openedPanel(name) as DisplayObjectContainer;
			}
			
			return panel;
		}
		
		public function openUI(name:String):void
		{
			PanelMediator.instance.openPanel(name);
		}
		
		private function repairFunc():void
		{
			var dt:BagData=new BagData();
			if(LastingDataMananger.getInstance().roleLasting)
			{
				var count:int = BagDataManager.instance.getItemNumByType(ItemType.IT_BATTLE_YOU,-1,dt);
				if(count<1)
				{
					Alert.warning(StringConst.BAG_PANEL_0036);
					return ;
				}
				BagDataManager.instance.requestUseItem(dt.id,1,true);
			}
			
			if(LastingDataMananger.getInstance().heroLasting)
			{
				var firstPlayer:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
				if (firstPlayer.isPalsy && dt.storageType == ConstStorage.ST_CHR_BAG)
				{
					return;
				}
				var count1:int = HeroDataManager.instance.getItemNumByType(ItemType.IT_BATTLE_YOU,-1,dt);
				if(count1<1)
				{
					Alert.warning(StringConst.BAG_PANEL_0037);
					return ;
				}
				BagDataManager.instance.sendUseData(dt.slot,dt.storageType);
			}
		}

		private function onCancelFunc1():void
		{
			var requestSchool:SchoolData = SysAlertDataManage.getInstance().requestSchool;
			SchoolElseDataManager.getInstance().sendRequestAction(2,requestSchool.id,requestSchool.sid,requestSchool.leaderCid,requestSchool.leaderSid);
		}
		
		private function onSureFunc1():void
		{
			var requestSchool:SchoolData = SysAlertDataManage.getInstance().requestSchool;
			SchoolElseDataManager.getInstance().sendRequestAction(1,requestSchool.id,requestSchool.sid,requestSchool.leaderCid,requestSchool.leaderSid);
		}
		
		private function onCancelFunc():void
		{			
			var callperson:SchoolMemberData = SysAlertDataManage.getInstance().callperson;
			SchoolElseDataManager.getInstance().sendCallAction(2,callperson.cid,callperson.sid);
		}
		
		private function onSureFunc():void
		{
			var callperson:SchoolMemberData = SysAlertDataManage.getInstance().callperson;
			SchoolElseDataManager.getInstance().sendCallAction(1,callperson.cid,callperson.sid);
		}
	}
}