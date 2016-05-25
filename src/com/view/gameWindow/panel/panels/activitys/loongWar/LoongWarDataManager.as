package com.view.gameWindow.panel.panels.activitys.loongWar
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.business.gameService.serverMessageManager.dataManager.IDataManager;
    import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
    import com.model.business.gameService.serverMessageManager.subManages.SuccessMessageManager;
    import com.model.business.gameService.socketManager.ClientSocketManager;
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.ActivityCfgData;
    import com.model.consts.StringConst;
    import com.pattern.Observer.Observe;
    import com.view.gameWindow.common.Alert;
    import com.view.gameWindow.common.ModelEvents;
    import com.view.gameWindow.mainUi.subuis.activityTrace.ActivityDataManager;
    import com.view.gameWindow.mainUi.subuis.activityTrace.constants.ActivityFuncTypes;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panelbase.IPanelBase;
    import com.view.gameWindow.panel.panels.activitys.loongWar.panelList.DataLoongWarSet;
    import com.view.gameWindow.panel.panels.activitys.loongWar.tabApply.DataLoongWarApplyGuild;
    import com.view.gameWindow.panel.panels.activitys.loongWar.tabInfo.DataLoongWarInfo;
    import com.view.gameWindow.panel.panels.activitys.loongWar.tabReward.DataLoongWarReward;
    import com.view.gameWindow.panel.panels.activitys.loongWar.trace.DataLoongWarFamilyRank;
    import com.view.gameWindow.panel.panels.activitys.loongWar.trace.DataLoongWarTrace;
    import com.view.gameWindow.panel.panels.guardSystem.GuardManager;
    import com.view.gameWindow.panel.panels.school.simpleness.SchoolBasicData;
    import com.view.gameWindow.panel.panels.school.simpleness.SchoolDataManager;
    import com.view.gameWindow.scene.entity.EntityLayerManager;
    import com.view.gameWindow.util.ServerTime;
    import com.view.gameWindow.util.TimeUtils;
    import com.view.selectRole.SelectRoleDataManager;

    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    import flash.utils.Endian;

    public class LoongWarDataManager extends Observe implements IDataManager
	{
		/**进入皇宫传送点*/
		public static const TELEPROT_ID:int = 1900191;
		/**龙城争霸信息页*/
		public static const TAB_INFO:int = 0;
		/**龙城争霸奖励页*/
		public static const TAB_REWARD:int = 1;
		/**龙城争霸申请页*/
		public static const TAB_APPLY:int = 2;
		//
		public var currentTab:int;
		/**下一次活动开始的完整时间字符串*/
		public function get nextFullTime():String
		{
			var actCfgData:ActivityCfgData = ConfigDataManager.instance.activityCfgData2(ActivityFuncTypes.AFT_LOONG_WAR);
			var date:Date = ServerTime.date;
			var i:int = date.day + (actCfgData.secondToStart == int.MIN_VALUE ? 1 : 0);//今日活动已结束时从明天开始
			var l:int = actCfgData.vctDays.length;
			for (;i<l;i++)
			{
				if(!actCfgData.vctDays[i])
				{
					continue;
				}
				var timeNext:int = ServerTime.time + (i - date.day) * 86400;
				var dateNext:Date = new Date(timeNext * 1000);
				var string:String = TimeUtils.fixNum(dateNext.month+1) + StringConst.MONTH + TimeUtils.fixNum(dateNext.date) + StringConst.DATE + 
					actCfgData.currentActvTimeCfgDtToStart.today_start_to_end + "(" + StringConst.WEEK + StringConst["WEEK"+i] + ")";
				return string;
			}
			return "";
		}
		
		public var familyIdDefense:int;
		public var familySidDefense:int;
		private var _familyNameDefense:String = "";
		public function get familyNameDefense():String
		{
			return _familyNameDefense ? _familyNameDefense : StringConst.POSITION_PANEL_0026;
		}
		public var nameCity:String = "";
		/**占城的时间（时间戳）*/
		public var time:int;
		
		public var dtsApplyGuild:Vector.<DataLoongWarApplyGuild>;
		public var dtsApplyLeague:Vector.<DataLoongWarApplyGuild>;
		public var applyGuildDataMy:DataLoongWarApplyGuild;
		
		private var _dtsApplyLeagueMine:Vector.<DataLoongWarApplyGuild>;
		public function get dtsApplyLeagueMine():Vector.<DataLoongWarApplyGuild>
		{
			if(!applyGuildDataMy)
			{
				return null;
			}
			if(applyGuildDataMy.familyIdLeague == 0 && applyGuildDataMy.familySidLeague == 0)
			{
				return null;
			}
			_dtsApplyLeagueMine = new Vector.<DataLoongWarApplyGuild>();
			var dt:DataLoongWarApplyGuild;
			for each(dt in dtsApplyGuild)
			{
				if ((dt.familyId != applyGuildDataMy.familyId || dt.familySid != applyGuildDataMy.familySid) && 
					dt.familyIdLeague == applyGuildDataMy.familyIdLeague && dt.familySidLeague == applyGuildDataMy.familySidLeague)
				{
					_dtsApplyLeagueMine.push(dt);
				}
			}
			return _dtsApplyLeagueMine;
		}
		
		public var dtsReward:Dictionary;
		/**礼包是否领过 0不能领 1未领取 2已被领取*/
		public var isRewardGet:int;
		/**时装是否可领取0不能领，1未领取，2已领取*/
		public function get isFashionGet():int
		{
			var schoolBaseData:SchoolBasicData = SchoolDataManager.getInstance().schoolBaseData;
			if(!schoolBaseData.isMainLeader)
			{
				return 0;
			}
			var dt:DataLoongWarReward;
			for each (dt in dtsReward)
			{
				if(dt.familyId == schoolBaseData.schoolId && dt.familySid == schoolBaseData.schoolSid)
				{
					return dt.isFashionGet ? 2 : 1;
				}
			}
			return 0;
		}
		/**是否为占领帮*/
		public function get isTheGuildOccupy():Boolean
		{
			var schoolBaseData:SchoolBasicData = SchoolDataManager.getInstance().schoolBaseData;
			/*if(!schoolBaseData.isMainLeader)
			{
				return false;
			}*/
			var dt:DataLoongWarReward = dtsReward[DataLoongWarReward.SCORE_RANK_0];
			if(dt.familyId == schoolBaseData.schoolId && dt.familySid == schoolBaseData.schoolSid)
			{
				return true;
			}
			return false;
		}
		/**是否为积分第一帮*/
		public function get isTheGuildFirst():Boolean
		{
			var schoolBaseData:SchoolBasicData = SchoolDataManager.getInstance().schoolBaseData;
			/*if(!schoolBaseData.isMainLeader)
			{
				return false;
			}*/
			var dt:DataLoongWarReward = dtsReward[DataLoongWarReward.SCORE_RANK_1];
			if(dt.familyId == schoolBaseData.schoolId && dt.familySid == schoolBaseData.schoolSid)
			{
				return true;
			}
			return false;
		}
		/**是否为积分第二帮*/
		public function get isTheGuildSecond():Boolean
		{
			var schoolBaseData:SchoolBasicData = SchoolDataManager.getInstance().schoolBaseData;
			/*if(!schoolBaseData.isMainLeader)
			{
				return false;
			}*/
			var dt:DataLoongWarReward = dtsReward[DataLoongWarReward.SCORE_RANK_2];
			if(dt.familyId == schoolBaseData.schoolId && dt.familySid == schoolBaseData.schoolSid)
			{
				return true;
			}
			return false;
		}
		
		public const countPosition:int = 6;
		/**职位信息*/
		public var dtsPositionInfo:Dictionary;
		/**任命信息*/
		public var dtsSet:Vector.<DataLoongWarSet>;
		/**是否为龙城争霸城主*/
		public function get isLoongWarChatelain():Boolean
		{
			var dt:DataLoongWarInfo = dtsPositionInfo[DataLoongWarInfo.POSITION_MAIN] as DataLoongWarInfo;
			if(!dt)
			{
				return false;
			}
			var cid:int = SelectRoleDataManager.getInstance().selectCid;
			var sid:int = SelectRoleDataManager.getInstance().selectSid;
			if(dt.cid == cid && dt.sid == sid)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		public var dtLWTrace:DataLoongWarTrace;
		
		public function LoongWarDataManager()
		{
			super();
			dtsApplyGuild = new Vector.<DataLoongWarApplyGuild>();
			dtsApplyLeague = new Vector.<DataLoongWarApplyGuild>();
			initDtsReward();
			dtsPositionInfo = new Dictionary();
			dtsSet = new Vector.<DataLoongWarSet>();
			dtLWTrace = new DataLoongWarTrace();
			//
			DistributionManager.getInstance().register(GameServiceConstants.SM_FAMILY_QUERY_LEAGUE_INFO,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_FAMILY_LONGCHENG_LEAGUE,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_FAMILY_QUERY_LEAGUE_APPLY,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_FAMILY_QUERY_LONGCHENG_POSITION_LIST,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_LONGCHENG_APPOINT_LIST,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_LONGCHENG_AWARD_INFO_LIST,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_LONGCHENG_END_REWARD,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_LONGCHENG_FAMILY_SCORE_LIST,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_LONGCHENG_FAMILY_NOW_LEADER,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_LONGCHENG_FAMILY_CHR_SCORE,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_LONGCHENG_CHR_TOTAL_EXP,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_FAMILY_LEAGUE_INFO_BY_STATUS,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_LONGCHENG_LEADER_FAMILY,this);
			//
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_CHANGE_CITY_NAME,this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_LONGCHENG_APPOINT,this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_LONGCHENG_AWARD_RECEIVE,this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_LONGCHENG_CHEST_RECEIVE,this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_FAMILY_LONGCHENG_APPLY,this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_FAMILY_LONGCHENG_LEAGUE,this);
		}
		
		private function initDtsReward():void
		{
			dtsReward = new Dictionary();
			var dt:DataLoongWarReward;
			dt = new DataLoongWarReward();
			dt.scoreRank = DataLoongWarReward.SCORE_RANK_0;
			dtsReward[dt.scoreRank] = dt;
			dt = new DataLoongWarReward();
			dt.scoreRank = DataLoongWarReward.SCORE_RANK_1;
			dtsReward[dt.scoreRank] = dt;
			dt = new DataLoongWarReward();
			dt.scoreRank = DataLoongWarReward.SCORE_RANK_2;
			dtsReward[dt.scoreRank] = dt;
		}
		
		public function dealSwitchPanleLoongWar():void
		{
			var openedPanel:IPanelBase = PanelMediator.instance.openedPanel(PanelConst.TYPE_LOONG_WAR);
			if(!openedPanel)
			{
				PanelMediator.instance.openPanel(PanelConst.TYPE_LOONG_WAR);
			}
			else
			{
				PanelMediator.instance.closePanel(PanelConst.TYPE_LOONG_WAR);
				PanelMediator.instance.closePanel(PanelConst.TYPE_LOONG_WAR_CHANGE);
				PanelMediator.instance.closePanel(PanelConst.TYPE_LOONG_WAR_LIST_SET);
				PanelMediator.instance.closePanel(PanelConst.TYPE_LOONG_WAR_LIST_UNION);
			}
		}
		/**申请攻城战*/
		public function cmFamilyLongchengApply():void
		{
			var schoolBaseData:SchoolBasicData = SchoolDataManager.getInstance().schoolBaseData;
			if(!schoolBaseData.isMainViceLeader)
			{
				Alert.warning(StringConst.LOONG_WAR_ERROR_0001);
				return;
			}
			var manager:ActivityDataManager = ActivityDataManager.instance;
			var dtMy:DataLoongWarApplyGuild = manager.loongWarDataManager.applyGuildDataMy;
			if(dtMy)
			{
				Alert.warning(StringConst.LOONG_WAR_ERROR_0002);
				return;
			}
			/*var cfgDt:ActivityCfgData = ConfigDataManager.instance.activityCfgData2(ActivityFuncTypes.AFT_LOONG_WAR);
			if(!cfgDt.isInActv)
			{
				Alert.warning(StringConst.LOONG_WAR_ERROR_0003);
				return;
			}*/
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_FAMILY_LONGCHENG_APPLY,byteArray);
		}
		/**申请联盟协议*/
		public function cmFamilyLongchengLeague(dt:DataLoongWarApplyGuild):void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeInt(dt.familyId);
			byteArray.writeInt(dt.familySid);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_FAMILY_LONGCHENG_LEAGUE,byteArray);
		}
		/**查看申请联盟者列表*/
		public function cmFamilyQueryLeagueApply():void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_FAMILY_QUERY_LEAGUE_APPLY,byteArray);
		}
		/**
		 * 联盟操作,同意或拒接联盟申请
		 * @param type 1:同意 2：拒绝
		 * @param dt
		 */		
		public function cmFamilyLongchengLeagueAction(type:int,dt:DataLoongWarApplyGuild):void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeByte(type);//1字节有符号整形 1:同意 2：拒绝
			byteArray.writeInt(dt.familyId);//4字节有符号整形
			byteArray.writeInt(dt.familySid);//4字节有符号整形
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_FAMILY_LONGCHENG_LEAGUE_ACTION,byteArray);
		}
		/**退出联盟*/
		public function cmFamilyLongchengLeagueLeave():void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_FAMILY_LONGCHENG_LEAGUE_LEAVE,byteArray);
		}
		/**查看联盟信息*/
		public function cmFamilyQueryLeagueInfo():void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_FAMILY_QUERY_LEAGUE_INFO,byteArray);
		}
		/**查看龙城争霸沙城职位信息*/
		public function cmFamilyQueryLongchengPositionList():void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_FAMILY_QUERY_LONGCHENG_POSITION_LIST,byteArray);
		}
		/**修改城号*/
		public function cmChangeCityName(name:String):void
		{
			if(!name)
			{
				Alert.warning(StringConst.LOONG_WAR_ERROR_0004);
				return;
			}
			var containBannedWord:Boolean = GuardManager.getInstance().containBannedWord(name);
			if(containBannedWord)
			{
				Alert.warning(StringConst.LOONG_WAR_ERROR_0005);
				return;
			}
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeUTF(name);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_CHANGE_CITY_NAME,byteArray);
		}
		/**任命列表*/
		public function cmLongchengAppointList(position:int):void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeInt(position);//  4字节有符号整形 沙城职位 2:副城主 3:大将军 4:圣战 5:圣法 6:圣道
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_LONGCHENG_APPOINT_LIST,byteArray);
		}
		/**任命沙城职位*/
		public function cmLongchengAppoint(dt:DataLoongWarSet,position:int):void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeInt(dt.cid);//  4字节有符号整形
			byteArray.writeInt(dt.sid);//  4字节有符号整形
			byteArray.writeInt(position);//  4字节有符号整形 沙城职位 2:副城主 3:大将军 4:圣战 5:圣法 6:圣道
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_LONGCHENG_APPOINT,byteArray);
		}
		/**奖励面板信息*/
		public function cmLongchengAwardInfoList():void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_LONGCHENG_AWARD_INFO_LIST,byteArray);
		}
		/**领取每日沙城礼包奖励*/
		public function cmLongchengAwardReceive():void
		{
			if(isRewardGet == 1)
			{
				var byteArray:ByteArray = new ByteArray();
				byteArray.endian = Endian.LITTLE_ENDIAN;
				ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_LONGCHENG_AWARD_RECEIVE,byteArray);
			}
		}
		/**领取帮主时装*/
		public function cmLongchengChestReceive():void
		{
			if(isFashionGet == 1)
			{
				var byteArray:ByteArray = new ByteArray();
				byteArray.endian = Endian.LITTLE_ENDIAN;
				ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_LONGCHENG_CHEST_RECEIVE,byteArray);
			}
		}
		/**死亡复活传送*/
		public function cmLongchengRevive():void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_LONGCHENG_REVIVE,byteArray);
		}
		/**查询活动追踪信息*/
		public function cmLongchengQueryTrack():void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_LONGCHENG_QUERY_TRACK,byteArray);
		}
		
		public function resolveData(proc:int, data:ByteArray):void
		{
			switch(proc)
			{
				case GameServiceConstants.CM_FAMILY_LONGCHENG_LEAGUE:
					dealCmFamilyLongchengLeague();
					break;
				case GameServiceConstants.CM_FAMILY_LONGCHENG_APPLY:
					dealCmFamilyLongchengApply();
					break;
				case GameServiceConstants.CM_LONGCHENG_CHEST_RECEIVE:
					dealCmLongchengChestReceive();
					break;
				case GameServiceConstants.CM_LONGCHENG_AWARD_RECEIVE:
					dealCmLongchengAwardReceive();
					break;
				case GameServiceConstants.CM_LONGCHENG_APPOINT:
					dealCmLongchengAppoint();
					break;
				case GameServiceConstants.CM_CHANGE_CITY_NAME:
					dealCmChangeCityName();
					break;
				case GameServiceConstants.SM_LONGCHENG_CHR_TOTAL_EXP:
					dealSmLongchengChrTotalExp(data);
					break;
				case GameServiceConstants.SM_LONGCHENG_FAMILY_CHR_SCORE:
					dealSmLongchengFamilyChrScore(data);
					break;
				case GameServiceConstants.SM_LONGCHENG_FAMILY_NOW_LEADER:
					dealSmLongchengFamilyNowLeader(data);
					break;
				case GameServiceConstants.SM_LONGCHENG_FAMILY_SCORE_LIST:
					dealSmLongchengFamilyScoreList(data);
					break;
				case GameServiceConstants.SM_LONGCHENG_END_REWARD:
					dealSmLongchengEndReward(data);
					break;
				case GameServiceConstants.SM_LONGCHENG_AWARD_INFO_LIST:
					dealSmLongchengAwardInfoList(data);
					break;
				case GameServiceConstants.SM_LONGCHENG_APPOINT_LIST:
					dealSmLongchengAppointList(data);
					break;
				case GameServiceConstants.SM_FAMILY_QUERY_LONGCHENG_POSITION_LIST:
					dealSmFamilyQueryLongchengPositionList(data);
					break;
				case GameServiceConstants.SM_FAMILY_QUERY_LEAGUE_APPLY:
					dealSmFamilyQueryLeagueApply(data);
					break;
				case GameServiceConstants.SM_FAMILY_LONGCHENG_LEAGUE:
					dealSmFamilyLongchengLeague(data);
					break;
				case GameServiceConstants.SM_FAMILY_QUERY_LEAGUE_INFO:
					dealSmFamilyQueryLeagueInfo(data);
					break;
				case GameServiceConstants.SM_FAMILY_LEAGUE_INFO_BY_STATUS:
					dealSmFamilyLeagueInfoByStatus(data);
					break;
				case GameServiceConstants.SM_LONGCHENG_LEADER_FAMILY:
					dealLongChengLeader(data);
					break;
				default:
					break;
			}
			notify(proc);
		}
		
		private var leaderId:int;
		private var leaderSid:int;
		private function dealLongChengLeader(data:ByteArray):void
		{
			// TODO Auto Generated method stub
			leaderId =  data.readInt();
			leaderSid = data.readInt();
		}
		
		public function isInLeaderFamily(id:int,sid:int):Boolean
		{
			return id == leaderId&&sid == leaderSid;
		}
		
		private function dealCmFamilyLongchengLeague():void
		{
			Alert.message(StringConst.LOONG_WAR_SUCCESS_0006);
		}
		
		private function dealCmFamilyLongchengApply():void
		{
			Alert.message(StringConst.LOONG_WAR_SUCCESS_0005);
		}
		
		private function dealCmLongchengChestReceive():void
		{
			Alert.message(StringConst.LOONG_WAR_SUCCESS_0004);
		}
		
		private function dealCmLongchengAwardReceive():void
		{
			Alert.message(StringConst.LOONG_WAR_SUCCESS_0003);
		}
		
		private function dealCmLongchengAppoint():void
		{
			Alert.message(StringConst.LOONG_WAR_SUCCESS_0002);
		}
		
		private function dealCmChangeCityName():void
		{
			Alert.message(StringConst.LOONG_WAR_SUCCESS_0001);
		}
		/**已累计获得的经验*/
		private function dealSmLongchengChrTotalExp(data:ByteArray):void
		{
			var exp:int = data.readInt();//4字节有符号整形 累计经验
			var gainExp:int = exp - dtLWTrace.exp;
			if(gainExp>0)
				/*Alert.reward(StringConst.WORSHIP_TIP_0002 + gainExp);*/
			dtLWTrace.exp = exp;
			ActivityDataManager.instance.notify(ModelEvents.UPDATE_MAP_ACTIVITY);
		}
		/**个人积分情况*/
		private function dealSmLongchengFamilyChrScore(data:ByteArray):void
		{
			var score:int = data.readInt();//  4字节有符号整形   积分	
			var rank:int = data.readInt();// 4字节有符号整形  当前排名
			dtLWTrace.score = score;
			dtLWTrace.rank = rank;
			ActivityDataManager.instance.notify(ModelEvents.UPDATE_MAP_ACTIVITY);
		}
		/**下发当前皇宫所属*/
		private function dealSmLongchengFamilyNowLeader(data:ByteArray):void
		{
			var familyName:String = data.readUTF();// utf8 帮派名字 （"" 无所属）
			var type:int = data.readByte();// 1字节有符号整形 0.当前无所属 1.单独的帮会 2.是联盟的
			var time:int = data.readInt();//  4字节有符号整形   占领的时间点
			dtLWTrace.familyName = familyName;
			dtLWTrace.type = type;
			dtLWTrace.time = time;
			ActivityDataManager.instance.notify(ModelEvents.UPDATE_MAP_ACTIVITY);
		}
		/**每隔10s下发帮会排行*/
		private function dealSmLongchengFamilyScoreList(data:ByteArray):void
		{
			dtLWTrace.dtsFamilyRank.length = 0;
			var size:int = data.readInt();//4字节有符号整形 数量
			while(size--)//下面缩进部分为按照size数量的循环
			{
				var familyId:int = data.readInt();//  4字节有符号整形  
				var familySid:int = data.readInt();// 4字节有符号整形
				var familyName:String = data.readUTF();// utf8 
				var familyScore:int = data.readInt();// 4字节有符号整形 帮会积分
				var dt:DataLoongWarFamilyRank = new DataLoongWarFamilyRank();
				dt.familyId = familyId;
				dt.familySid = familySid;
				dt.familyName = familyName;
				dt.familyScore = familyScore;
				dtLWTrace.dtsFamilyRank.push(dt);
			}
			ActivityDataManager.instance.notify(ModelEvents.UPDATE_MAP_ACTIVITY);
		}
		/**活动结束，系统提示奖励*/
		private function dealSmLongchengEndReward(data:ByteArray):void
		{
			/*var exp:int = data.readInt();// 4字节有符号整形   得到的经验
			var gongxun:int = data.readInt();// 4字节有符号整形 得到的功勋
			var txt:String = StringConst.LOONG_WAR_SUCCESS_0007.replace(/&x/g,gongxun).replace(/&y/,exp);
			Alert.message(txt);
			IncomeDataManager.instance.addOneLine(txt);*/
		}
		/**奖励面板信息返回处理*/
		private function dealSmLongchengAwardInfoList(data:ByteArray):void
		{
			var size:int = data.readInt()//4字节有符号整形 数量
			while(size--)//下面缩进部分为按照size数量的循环
			{
				var familyId:int = data.readInt();//	4字节有符号整形  
				var familySid:int = data.readInt();//	4字节有符号整形
				var familyName:String = data.readUTF();// utf8 
				var scoreRank:int = data.readByte();//	1字节有符号整形 0是城主帮 1击杀总分第一  2击杀总分第二
				var fashionIsGet:int = data.readByte();// 1字节有符号整形 帮主时装是够领过 0未领过 1领过
				var dt:DataLoongWarReward = new DataLoongWarReward();
				dt.familyId = familyId;
				dt.familySid = familySid;
				dt.familyName = familyName;
				dt.scoreRank = scoreRank;
				dt.isFashionGet = fashionIsGet;
				dtsReward[dt.scoreRank] = dt;
			}
			isRewardGet = data.readByte();//  1字节有符号整形  礼包是否领过 0不能领 1未领取 2已被领取
        };
		/**任命列表返回处理*/
		private function dealSmLongchengAppointList(data:ByteArray):void
		{
			dtsSet.length = 0;
			var size:int = data.readInt();//4字节有符号整形 数量
			while(size--)//下面缩进部分为按照size数量的循环
			{
				var cid:int = data.readInt();//  4字节有符号整形
				var sid:int = data.readInt();//  4字节有符号整形
				var name:String = data.readUTF();// utf8 名字
				var score:int = data.readInt();// 4字节有符号整形 积分
				var dt:DataLoongWarSet = new DataLoongWarSet();
				dt.cid = cid;
				dt.sid = sid;
				dt.name = name;
				dt.score = score;
				dtsSet.push(dt);
			}
		}
		/**查看龙城争霸沙城职位信息返回处理*/
		private function dealSmFamilyQueryLongchengPositionList(data:ByteArray):void
		{
			dtsPositionInfo = new Dictionary();
			_familyNameDefense = data.readUTF();// utf8 占领帮会的名字
			nameCity = data.readUTF();//	utf8	当前城号
			time = data.readInt();//    4字节有符号整形   占城的时间（时间戳）		
			var size:int = data.readInt();//	4字节有符号整形 数量
			while(size--)//下面缩进部分为按照size数量的循环
			{
				var cid:int = data.readInt();//  4字节有符号整形
				var sid:int = data.readInt();//  4字节有符号整形
				var namePlayer:String = data.readUTF();//	utf8	名字
				var sex:int = data.readByte();//  1字节有符号整形	性别
				var level:int = data.readInt();// 4字节有符号整形 等级
				var fightPower:int = data.readInt();// 4字节有符号整形 战斗力
				var position:int = data.readInt();// 4字节有符号整形 沙城职位 1:城主 2:副城主 3:大将军 4:圣战 5:圣法 6:圣道
				var clothesId:int = data.readInt();// 4字节有符号整形 衣服装备baseId
				var weaponId:int = data.readInt();//  4字节有符号整形 武器装备baseId
				var shieldId:int = data.readInt();//  4字节有符号整形 盾牌装备baseId
                var wing:int = data.readInt();//  4字节有符号整形 盾牌装备baseId

				var dt:DataLoongWarInfo = new DataLoongWarInfo();
				dt.cid = cid;
				dt.sid = sid;
				dt.namePlayer = namePlayer;
				dt.sex = sex;
				dt.level = level;
				dt.fightPower = fightPower;
				dt.position = position;
				dt.clothesId = clothesId;
				dt.weaponId = weaponId;
				dt.shieldId = shieldId;
                dt.wing = wing;
                var chestSize:int = data.readInt();// 4字节有符号整形 时装数量（默认为4）按照时装,斗笠，足迹，幻武
				while(chestSize--)//下面缩进部分为按照chestSize数量的循环
				{
					var chestId:int = data.readInt();// 4字节有符号整形 时装  （0代表没有该时装）
					dt.fashionIds.push(chestId);
				}
				dtsPositionInfo[dt.position] = dt;
			}
		}
		/**申请联盟者列表*/
		private function dealSmFamilyQueryLeagueApply(data:ByteArray):void
		{
			dtsApplyLeague.length = 0;
			var size:int = data.readInt();//4字节有符号整形 数量
			//下面缩进部分为按照size数量的循环
			while(size--)
			{
				var familyName:String = data.readUTF();// utf8
				var familyId:int = data.readInt();//  4字节有符号整形
				var familySid:int = data.readInt();//  4字节有符号整形
				var dt:DataLoongWarApplyGuild = new DataLoongWarApplyGuild();
				dt.familyName = familyName;
				dt.familyId = familyId;
				dt.familySid = familySid;
				dtsApplyLeague.push(dt);
			}
		}
		/**申请联盟提示*/
		private function dealSmFamilyLongchengLeague(data:ByteArray):void
		{
			trace("LoongWarDataManager.dealSmFamilyLongchengLeague(data) 有人申请联盟");
		}
		/**报名帮会列表信息返回处理*/
		private function dealSmFamilyQueryLeagueInfo(data:ByteArray):void
		{
			dtsApplyGuild.length = 0;
			_familyNameDefense = data.readUTF();// utf8 守城帮  （""代表无守城帮）
			var size:int = data.readInt();//4字节有符号整形 数量
			//下面缩进部分为按照size数量的循环
			while(size--)
			{
				var familyName:String = data.readUTF();// utf8
				var familyId:int = data.readInt();//  4字节有符号整形  
				var familySid:int = data.readInt();// 4字节有符号整形
				var familyIdLeague:int = data.readInt();//  4字节有符号整形    联盟的帮会id  if（familyIdLeague == familyId）就是盟主帮  
				var familySidLeague:int = data.readInt();//  4字节有符号整形   联盟的帮会sid
				var familyNameLeague:String = data.readUTF();// utf   联盟的帮会名称
				var dt:DataLoongWarApplyGuild = new DataLoongWarApplyGuild();
				dt.familyName = familyName;
				dt.familyId = familyId;
				dt.familySid = familySid;
				dt.familyIdLeague = familyIdLeague;
				dt.familySidLeague = familySidLeague;
				dt.familyNameLeague = familyNameLeague;
				dtsApplyGuild.push(dt);
				//
				var schoolBaseData:SchoolBasicData = SchoolDataManager.getInstance().schoolBaseData;
				if(schoolBaseData.schoolSid == dt.familySid && schoolBaseData.schoolId == dt.familyId)
				{
					applyGuildDataMy = dt;
				}
			}
			dtsApplyGuild.sort(function(dt1:DataLoongWarApplyGuild,dt2:DataLoongWarApplyGuild):int
			{
				var numCode1:Number = 0,numCode2:Number = 0;
				var i:int,l:int;
				l = dt1.familyNameLeague.length;
				for (i=0;i<l;i++) 
				{
					numCode1 += dt1.familyNameLeague.charCodeAt(i);
				}
				l = dt2.familyNameLeague.length;
				for (i=0;i<l;i++) 
				{
					numCode2 += dt2.familyNameLeague.charCodeAt(i);
				}
				return numCode1 - numCode2;
			});
			var colors:Array = [0x00ffe5,0x00a2ff];
			var colorIndex:int;
			var familyIdLeagueLast:int;
			for each (dt in dtsApplyGuild)
			{
				if(familyIdLeagueLast != dt.familyIdLeague || familyIdLeagueLast == dt.familyIdLeague == 0)
				{
					familyIdLeagueLast = dt.familyIdLeague;
					colorIndex = 1 - colorIndex;
				}
				dt.textColor = colors[colorIndex];
			}
		}
		/**报名帮会列表信息返回处理(仅联盟数据信息)<br>用于刷新其他玩家名称颜色*/
		private function dealSmFamilyLeagueInfoByStatus(data:ByteArray):void
		{
			familyIdDefense = data.readInt();//4字节有符号整形 守城帮id
			familySidDefense = data.readInt();//4字节有符号整形 守城帮sid
			var size:int = data.readInt();//4字节有符号整形 数量
			//下面缩进部分为按照size数量的循环
			while(size--)
			{
				var familyId:int = data.readInt();//  4字节有符号整形  
				var familySid:int = data.readInt();// 4字节有符号整形
				var familyIdLeague:int = data.readInt();//  4字节有符号整形    联盟的帮会id  if（familyIdLeague == familyId）就是盟主帮  
				var familySidLeague:int = data.readInt();//  4字节有符号整形   联盟的帮会sid
				var dt:DataLoongWarApplyGuild = new DataLoongWarApplyGuild();
				dt.familyId = familyId;
				dt.familySid = familySid;
				dt.familyIdLeague = familyIdLeague;
				dt.familySidLeague = familySidLeague;
				dtsApplyGuild.push(dt);
				//
				var schoolBaseData:SchoolBasicData = SchoolDataManager.getInstance().schoolBaseData;
				if(schoolBaseData.schoolSid == dt.familySid && schoolBaseData.schoolId == dt.familyId)
				{
					applyGuildDataMy = dt;
				}
			}
			EntityLayerManager.getInstance().refreshPlayerTitle();
		}
	}
}