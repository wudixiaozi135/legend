package com.view.gameWindow.panel.panels.daily
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
	import com.model.business.gameService.serverMessageManager.subManages.SuccessMessageManager;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.DailyCfgData;
	import com.model.configData.cfgdata.DailyVitRewardCfgData;
	import com.model.configData.cfgdata.MapRegionCfgData;
	import com.model.configData.cfgdata.NpcCfgData;
	import com.model.consts.StringConst;
	import com.model.dataManager.DataManagerBase;
	import com.model.dataManager.TeleportDatamanager;
	import com.view.gameWindow.mainUi.subuis.activityTrace.constants.ActivityFuncTypes;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.IPanelBase;
	import com.view.gameWindow.panel.panels.dungeon.DgnDataManager;
	import com.view.gameWindow.panel.panels.onhook.AutoSystem;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	
	/**
	 * 日常数据管理类
	 * @author Administrator
	 */	
	public class DailyDataManager extends DataManagerBase
	{
		private static var _instance:DailyDataManager;
		public static function get instance():DailyDataManager
		{
			return _instance ||= new DailyDataManager(new PrivateClass());
		}
		
		public const tabPep:int = 0,tabActivity:int = 1,tabTask:int = 2,tabDgn:int = 3;
		public var selectTab:int;
		public var daily_online_start:int = 0;
		public var player_daily_vit:int;
		public var hero_daily_vit:int;
		public var player_vit_daily_hour:int;
		public var player_vit_daily_reward:int;
		public var player_vit_daily_vip:int;
		public var hero_vit_daily_hour:int;
		public var hero_vit_daily_reward:int;
		public var hero_vit_daily_vip:int;
		public var vit_today_player:int,vit_today_hero:int,vit_today_total:int;
		public const daily_vit_max:int = 300;
		private var _is_vit_today_total_change:Boolean;
		/**今日总活力值是否改变<br>仅用于刷新面板上的总活力值显示*/
		public function get is_vit_today_total_change():Boolean
		{
			var _is_vit_today_total_change2:Boolean = _is_vit_today_total_change;
			_is_vit_today_total_change = false;
			return _is_vit_today_total_change2;
		}
		/**
		 * @private
		 */
		public function set is_vit_today_total_change(value:Boolean):void
		{
			_is_vit_today_total_change = value;
		}
		private var _reward_get:int;
		/**储存DailyData（使用DailyData.id作为key）*/		
		public var datas:Dictionary;
		/**储存Vector.<DailyData>（使用"type"+DailyData.type作为key）*/		
		private var typeDatas:Dictionary;
		private var typeNums:Dictionary;
		/**超额领取是否提示*/
		public var isPrompt:Boolean = true;
		
		public function DailyDataManager(pc:PrivateClass)
		{
			super();
			if(!pc)
			{
				throw new Error("该类使用单例模式");
			}
			
			DistributionManager.getInstance().register(GameServiceConstants.SM_QUERY_DAILY_CONTENT,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_DAILY_INFO,this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_GET_DAILY_VIT_REWARD,this);
			
			datas = new Dictionary;
			typeDatas = new Dictionary();
			typeNums = new Dictionary();
			var dailyCfgDatas:Dictionary = ConfigDataManager.instance.dailyCfgDatas(),cfgDt:DailyCfgData;
			for each(cfgDt in dailyCfgDatas)
			{
				if(cfgDt.type)
				{
					var dt:DailyData = new DailyData(cfgDt.id,0);
					datas[dt.id] = dt;
					var typeDts:Vector.<DailyData> = typeDatas["type"+dt.type] as Vector.<DailyData>;
					if(!typeDts)
					{
						typeDatas["type"+dt.type] = new Vector.<DailyData>();
						typeDts = typeDatas["type"+dt.type];
					}
					typeDts.length < cfgDt.sub_order ? typeDts.length = cfgDt.sub_order : null;
					!typeNums[dt.type] ? typeNums[dt.type] = 1 : typeNums[dt.type] += 1;
					typeDts[cfgDt.sub_order] = dt;
				}
			}
		}
		
		public function clearInstance():void
		{
			_instance = null;
		}
		
		public function dealSwitchPanelDaily():void
		{
			var openedPanel:IPanelBase = PanelMediator.instance.openedPanel(PanelConst.TYPE_DAILY);
			if(!openedPanel)
			{
				cmQueryDailyContent();
				DgnDataManager.instance.queryChrDungeonInfo();
				PanelMediator.instance.openPanel(PanelConst.TYPE_DAILY);
			}
			else
			{
				PanelMediator.instance.closePanel(PanelConst.TYPE_DAILY);
			}
		}
		/**
		 * 获取每日活力值
		 * @param id 4字节有符号整形，daily表的id
		 */		
		public function requestGetDailyVit(id:int):void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeInt(id);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_GET_DAILY_VIT_REWARD,byteArray);
		}
		/**
		 * 获取每日活力值奖励
		 * @param order
		 */		
		public function requestGetDailyVitTotalReward(order:int):void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			var dt:DailyVitRewardCfgData = getDailyVitRewardCfgData(order);
			byteArray.writeInt(dt.daily_vit);//4字节有符号整形，daily_vit_reward表的键值
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_GET_VIT_DAILY_TOTAL_REWARD,byteArray);
		}
		
		public function requestTeleport(npcId:int):void
		{
			var npcCfgData:NpcCfgData = ConfigDataManager.instance.npcCfgData(npcId);
			if(!npcCfgData)
			{
				trace("DailyDataManager.requestTeleport npcCfgData == null");
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.PROMPT_PANEL_0007);
				return;
			}
			var isCanFly:int = RoleDataManager.instance.isCanFly;
			if(!isCanFly)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.PROMPT_PANEL_0008);
				return;
			}
			/*TeleportDatamanager.instance.setTargetPos(npcCfgData.mapid,new Point(npcCfgData.teleport_x,npcCfgData.teleport_y), AutoJobManager.TO_TELEPORT_TILE_DIST);*/
			TeleportDatamanager.instance.setTargetEntity(npcId,EntityTypes.ET_NPC);
			TeleportDatamanager.instance.requestTeleportPostioin(npcCfgData.mapid,npcCfgData.teleport_x,npcCfgData.teleport_y);
			
		    AutoSystem.instance.stopAuto();
		}
		
		public function requestTeleport1(regionId:int):void
		{
			var mapRegionCfgData:MapRegionCfgData = ConfigDataManager.instance.mapRegionCfgData(regionId);
			if(!mapRegionCfgData)
			{
				trace("DailyDataManager.requestTeleport npcCfgData == null");
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.PROMPT_PANEL_0007);
				return;
			}
			var isCanFly:int = RoleDataManager.instance.isCanFly;
			if(!isCanFly)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.PROMPT_PANEL_0008);
				return;
			}
			var randomPoint:Point = mapRegionCfgData.randomPoint;
			TeleportDatamanager.instance.setTargetPos(mapRegionCfgData.map_id, randomPoint, 0);
			TeleportDatamanager.instance.requestTeleportPostioin(mapRegionCfgData.map_id,randomPoint.x,randomPoint.y);
			
			AutoSystem.instance.stopAuto();
		}
		
		public function cmQueryDailyContent():void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_QUERY_DAILY_CONTENT,byteArray);
		}
		
		override public function resolveData(proc:int, data:ByteArray):void
		{
			switch(proc)
			{
				case GameServiceConstants.SM_QUERY_DAILY_CONTENT:
					dealSmQueryDailyContent(data);
					break;
				case GameServiceConstants.SM_DAILY_INFO:
					dealDailyInfo(data);
					break;
				case GameServiceConstants.CM_GET_DAILY_VIT_REWARD:
					dealGetDailyVitReward(data);
					break;
				default:
					break;
			}
			super.resolveData(proc, data);
		}
		
		private function dealSmQueryDailyContent(data:ByteArray):void
		{
			var dt:DailyData;
			dt = typeDatas["type"+DailyData.TYPE_SIGN_IN][0] as DailyData;
			dt.countDone = data.readInt();//签到
			dt = typeDatas["type"+DailyData.TYPE_MICRO_LOGIN][0] as DailyData;
			dt.countDone = data.readInt();//微端登录
			data.readInt();//星级任务
			data.readInt();//悬赏任务
			dt = typeDatas["type"+DailyData.TYPE_EQUIP_DUNGEON][0] as DailyData;
			dt.countDone = data.readInt();//装备副本
			dt = typeDatas["type"+DailyData.TYPE_SPECIAL_RING_DUNGEON][0] as DailyData;
			dt.countDone = data.readInt();//特戒副本
			data.readInt();//封魔谷
			dt = typeDatas["type"+DailyData.TYPE_EXP_STONE][0] as DailyData;
			dt.countDone = data.readInt();//经验玉
			dt = typeDatas["type"+DailyData.TYPE_PRAY][0] as DailyData;
			dt.countDone = data.readInt();//祈福
			data.readInt();//押运任务
			dt = actvDailyData(ActivityFuncTypes.AFT_SEA_SIDE);
			dt.countDone = data.readInt();//海天盛宴
			dt = actvDailyData(ActivityFuncTypes.AFT_NIGHT_FIGHT);
			dt.countDone = data.readInt();//夜战比奇
			dt = actvDailyData(ActivityFuncTypes.AFT_GOD_DEVIL);
			dt.countDone = data.readInt();//神威魔域
			dt = actvDailyData(ActivityFuncTypes.AFT_WORSHIP);
			dt.countDone = data.readInt();//膜拜城主
			dt = actvDailyData(ActivityFuncTypes.AFT_GOLDEN_PIG);
			dt.countDone = data.readInt();//金猪送礼
			dt = typeDatas["type"+DailyData.TYPE_EQUIP_STRENGTHEN][0] as DailyData;
			dt.countDone = data.readInt();//装备强化
			dt = typeDatas["type"+DailyData.TYPE_EQUIP_DEGREE][0] as DailyData;
			dt.countDone = data.readInt();//装备进阶
			dt = typeDatas["type"+DailyData.TYPE_RUNE_COMPOUND][0] as DailyData;
			dt.countDone = data.readInt();//符文合成
			dt = typeDatas["type"+DailyData.TYPE_KILL_BOSS][0] as DailyData;
			dt.countDone = data.readInt();//击杀BOSS
		}
		
		public function getDailyDataIsGet():Boolean
		{
			for each(var data:DailyData in datas)
			{
				if(data.countDone>=data.dailyCfgData.count&&data.isGet!=1)
				{
					return true;
				}
			}
			return false;
		}
		
		private function actvDailyData(type:int):DailyData
		{
			var dts:Vector.<DailyData> = typeDatas["type"+DailyData.TYPE_ACTIVITY] as Vector.<DailyData>;
			var dt:DailyData;
			for each(dt in dts)
			{
				if(dt && dt.actCfgData && dt.actCfgData.func_type == type)
				{
					return dt;
				}
			}
			return null;
		}
		
		private function dealDailyInfo(data:ByteArray):void
		{
			daily_online_start = data.readInt();//用于计算今天累计在线时间的起始值
			player_daily_vit = data.readInt();//4字节有符号整形,玩家活力值
			hero_daily_vit = 0;//data.readInt();//4字节有符号整形,英雄活力值
			player_vit_daily_hour = data.readInt();//4字节有符号整形,玩家时间获得的活力值
			player_vit_daily_reward = data.readInt();//4字节有符号整形,玩家参加活动获得的活力值
			player_vit_daily_vip = data.readInt();//4字节有符号整形,玩家道具获得的活力值
			hero_vit_daily_hour = 0;//data.readInt();//4字节有符号整形,英雄时间获得的活力值
			hero_vit_daily_reward = 0;//data.readInt();//4字节有符号整形,英雄参加活动获得的活力值
			hero_vit_daily_vip = 0;//data.readInt();//4字节有符号整形,英雄道具获得的活力值
			vit_today_player = player_vit_daily_hour + player_vit_daily_reward + player_vit_daily_vip;
			vit_today_hero = hero_vit_daily_hour + hero_vit_daily_reward + hero_vit_daily_vip;
			var newValue:int = vit_today_player/* + vit_today_hero*/;
			_is_vit_today_total_change = newValue != vit_today_total ? true : false;
			vit_today_total = vit_today_player/* + vit_today_hero*/;
			_reward_get = data.readInt();//4字节有符号整形,活力值奖励领取情况，以daily_vit_reward的order左移1确定
			var count:int = data.readShort();//2字节有符号整形,活力值领取数量
			//下面缩进部分为按照count循环，包含所有副本进入数据
			while(count--)
			{
				var id:int = data.readInt();//4字节有符号整形，daily表id
				var get:int = data.readByte();//1字节有符号整形，1表示已领取，0表示未领取
				var dt:DailyData = datas[id] as DailyData;
				dt.isGet = get;
			}
		}
		
		public function getVitTotaoCount():int
		{
			return vit_today_hero+vit_today_player;
		}
		
		private function dealGetDailyVitReward(data:ByteArray):void
		{
			var id:int = data.readInt();//4字节有符号整形,即客户端请求时上发的id
		}
		/**奖励项是否可领取*/
		public function isRewardCanGet(order:int):Boolean
		{
			var dt:DailyVitRewardCfgData = getDailyVitRewardCfgData(order);
			if(/*vit_today_total*/player_vit_daily_reward >= dt.daily_vit)
			{
				return true;
			}
			else
			{
				return false;
			}
				
		}
		/**可领取奖励数*/
		public function getCanGetRewardNum():int
		{
			var count:int;
			for(var i:int = 1;i<5;i++)
			{
				var dt:DailyVitRewardCfgData = getDailyVitRewardCfgData(i);
				{
					if(/*vit_today_total*/player_vit_daily_reward>=dt.daily_vit&&_reward_get>>1<i)
						count++
				}
			}
			return count;
		}
		/**奖励项是否已领取*/
		public function isRewardGetted(order:int):Boolean
		{
			return Boolean((_reward_get>>order) & 1);
		}
		
		public function getDailyCfgData(order:int):DailyCfgData
		{
			var dailyCfgData:DailyCfgData = ConfigDataManager.instance.dailyCfgData(0,order);
			return dailyCfgData;
		}
		
		public function getDailyVitRewardCfgData(order:int):DailyVitRewardCfgData
		{
			var dailyVitRewardCfgData:DailyVitRewardCfgData = ConfigDataManager.instance.dailyVitRewardCfgDataByOrder(order);
			return dailyVitRewardCfgData;
		}
		/**
		 * 
		 * @param type
		 * @return 使用DailyCfgData.sub_order作为index的矢量数组
		 */		
		public function getDailyDatasByType(type:int):Vector.<DailyData>
		{
			return typeDatas["type"+type] as Vector.<DailyData>;
		}
		
		public function numByTab():int
		{
			var num:int = typeNums[selectTab];
			return num;
		}
		
		public function getDailyDatasByTab():Vector.<DailyData>
		{
			var vector:Vector.<DailyData> = null;
			switch(selectTab)
			{
				default:
					break;
				case tabPep:
					break;
				case tabActivity:
					vector = getDailyDatasByType(DailyData.TYPE_ACTIVITY);
					break;
				case tabTask:
					vector = getDailyDatasByType(DailyData.TYPE_TASK);
					break;
				case tabDgn:
					vector = getDailyDatasByType(DailyData.TYPE_DUNGEON);
					break;
			}
			return vector;
		}
	}
}
class PrivateClass{}