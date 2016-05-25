package com.view.gameWindow.panel.panels.openGift.data
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
	import com.model.business.gameService.serverMessageManager.subManages.SuccessMessageManager;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.AllBossRewardCfgData;
	import com.model.configData.cfgdata.LevelCompetitiveRewordCfgData;
	import com.model.configData.cfgdata.OpenServerDailyRewardCfgData;
	import com.model.configData.cfgdata.OpenServerPromoteRewardCfgData;
	import com.model.configData.cfgdata.SpecialPreferenceRewordCfgData;
	import com.model.consts.StringConst;
	import com.model.dataManager.DataManagerBase;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.mainUi.subclass._McRoleHead;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.boss.BossData;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.welfare.WelfareDataMannager;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	
	public class OpenServiceActivityDatamanager extends DataManagerBase
	{
		public var specialReward:Array = [0,0,0,0];
		public var levelReward:Array = [0,0,0,0,0];
		public var curLevelIndex:int = -1;
		public var levelRewardNum:Array = [0,0,0,0,0];
		private var initSp:Boolean,initLv:Boolean,initNum:Boolean;
		public var bossGroup:Array;
		public var selectTab:int = 1;
		public var curDay:int;
		public var dailyData:Dictionary;
		public var journeyData:Dictionary;
		public var promoteData:Dictionary;
		public var newData:Dictionary;
		override public function clearDataManager():void
		{
			_instance = null;
		}
		
		private static var _instance:OpenServiceActivityDatamanager = null;
		public static function get instance():OpenServiceActivityDatamanager
		{
			if (_instance == null)
			{
				_instance = new OpenServiceActivityDatamanager();
			}
			return _instance;
		}
		
		public function OpenServiceActivityDatamanager()
		{
			super();
			initData();
//			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_SPECIAL_PREFERENCE_REWARD_GET, this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_SPECIAL_PREFERENCE_REWARD_GET, this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_GET_OPEN_SERVER_DAILY, this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_GET_OPEN_SERVER_JOURNEY, this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_GET_OPEN_SERVER_PROMOTE, this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_BUY_OPEN_SERVER_NEW, this);
//			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_ALL_BOSS_REWARD_GET,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_SPECIALPREFERENCEREWORD_GET, this);
//			DistributionManager.getInstance().register(GameServiceConstants.SM_LEVEL_COMPETITIVE_REWORD_INFOR, this);
//			DistributionManager.getInstance().register(GameServiceConstants.SM_LEVEL_COMPETITIVE_REWORD_GET, this);
//			DistributionManager.getInstance().register(GameServiceConstants.SM_GET_LEVEL_COMPETITIVE_REWARD_END, this);
//			DistributionManager.getInstance().register(GameServiceConstants.SM_ALL_BOSS_REWARD_INFOR,this);
//			DistributionManager.getInstance().register(GameServiceConstants.SM_ALL_BOSS_REWARD_GET,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_OPEN_SERVER_DAILY_LIST,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_OPEN_SERVER_JOURNEY_LIST,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_OPEN_SERVER_PROMOTE_LIST,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_OPEN_SERVER_NEW_LIST,this);
		}
		
		private function initData():void
		{
			// TODO Auto Generated method stub
//			bossGroup = new Array();
//			var num:int = ConfigDataManager.instance.allBossRewardNum();
//			for(var i:int = 0;i<num;i++)
//			{
//				var cfg:AllBossRewardCfgData = ConfigDataManager.instance.allBossReward(i+1);
//				var data:BossGroupData = new BossGroupData();
//				var arr:Array = cfg.boss_monsters.split(":");
//				data.id = cfg.id;
//				data.isGet = false;
//				data.bossDic = new Dictionary();
//				for(var j:int = 0;j<arr.length;j++)
//				{
//					data.bossDic[arr[j]] = 0;
//				}
//				bossGroup[i]  = data;
//			}
			dailyData = new Dictionary();
			journeyData = new Dictionary();
			promoteData = new Dictionary();
			newData = new Dictionary();
		}
		
		public function getInfo():void
		{
//			getLevelMatchRewardInfo();
//			getBossRewardInfo();
		}
		
		override public function resolveData(proc:int, data:ByteArray):void
		{
			switch (proc)
			{
				case GameServiceConstants.SM_SPECIALPREFERENCEREWORD_GET:
					dealSpecialReward(data);
					break;
				case GameServiceConstants.CM_SPECIAL_PREFERENCE_REWARD_GET:
					dealSpecialGet(data);
					break;
				case GameServiceConstants.SM_OPEN_SERVER_DAILY_LIST:
					dealDaily(data);
					break;
				case GameServiceConstants.SM_OPEN_SERVER_JOURNEY_LIST:
					dealJourney(data)
					break;
				case GameServiceConstants.SM_OPEN_SERVER_PROMOTE_LIST:
					dealPromote(data);
					break;
				case GameServiceConstants.SM_OPEN_SERVER_NEW_LIST:
					dealNew(data);
					break;
				case GameServiceConstants.CM_GET_OPEN_SERVER_DAILY:
					break;
				case GameServiceConstants.CM_GET_OPEN_SERVER_JOURNEY:
					break;
				case GameServiceConstants.CM_GET_OPEN_SERVER_PROMOTE:
					break;
				case GameServiceConstants.CM_BUY_OPEN_SERVER_NEW:
					break;
			}
			super.resolveData(proc, data);
		}
		
		private function dealDaily(data:ByteArray):void
		{
			// TODO Auto Generated method stub
			var day:int = data.readInt();
			var size:int = data.readInt();
			var item:OpenDailyData = new OpenDailyData();
			item.day = day;
			item.data = new Dictionary();
			for(var i:int = 0;i<size;i++)
			{
				var obj:Object = new Object;
				obj.index = data.readInt();
				obj.state = data.readByte();
				obj.type = data.readByte();
				obj.param = data.readInt();
				item.data[obj.index] = obj;
			}
			dailyData[day] = item;
		}
		
		private function dealJourney(data:ByteArray):void
		{
			// TODO Auto Generated method stub
			var day:int = data.readInt();
			var size:int = data.readInt();
			var item:OpenJourneyData = new OpenJourneyData();
			item.day = day;
			item.data = new Dictionary();
			for(var i:int = 0;i<size;i++)
			{
				var obj:Object = new Object;
				obj.index = data.readInt();
				obj.state = data.readByte();
				obj.type = data.readByte();
				if(obj.type == OpenJourneyData.ROLE_LV)
				{
					obj.num = RoleDataManager.instance.lv;
				}
				else if(obj.type == OpenJourneyData.HERO_LV)
				{
					obj.num = HeroDataManager.instance.lv;
				}
				else if(obj.type == OpenJourneyData.ROLE_ATTR)
				{
					obj.num = RoleDataManager.instance.getRoleMaxAttack();
				}
				else
				{
					obj.num = data.readInt();
				}
				item.data[obj.index] = obj;
			}
			journeyData[day] = item;
		}
		
		private function dealPromote(data:ByteArray):void
		{
			// TODO Auto Generated method stub
			var day:int = data.readInt();
			var size:int = data.readInt();
			var item:OpenPromoteData = new OpenPromoteData();
			item.day = day;
			item.data = new Dictionary();
			var cfg:OpenServerPromoteRewardCfgData;
			for(var i:int = 0;i<size;i++)
			{
				var obj:Object = new Object;
				obj.index = data.readInt();
				obj.state = data.readByte();
				obj.type = data.readByte();
				cfg = ConfigDataManager.instance.OpenServerPromoteRewardData(day,obj.index);
				if(obj.type == OpenPromoteData.ROLE_EQUIP_LV)
				{
					obj.num = RoleDataManager.instance.getEquipLvNum(cfg.level);
				}
				else if(obj.type == OpenPromoteData.HERO_EQUIP_LV)
				{
					obj.num = HeroDataManager.instance.getEquipLvNum(cfg.level);
				}
				else if(obj.type == OpenPromoteData.ROLE_EQUIP_SLV)
				{
					obj.num = RoleDataManager.instance.getEquipStrengthenLvNum(cfg.level);
				}
				else if(obj.type == OpenPromoteData.HERO_EQUIP_SLV)
				{
					obj.num = HeroDataManager.instance.getEquipStrengthenLvNum(cfg.level);
				}
				else if(obj.type == OpenPromoteData.ROLE_DUNPAI)
				{
					obj.num = RoleDataManager.instance.getDunpaiNum(cfg.num,cfg.level);
				}
				else if(obj.type == OpenPromoteData.ROLE_CHOP_LV)
				{
					obj.num = RoleDataManager.instance.getChopLvNum(cfg.num);
				}
				else if(obj.type == OpenPromoteData.ROLE_POSITION)
				{
					obj.num = RoleDataManager.instance.position>cfg.num?1:0;
				}
				else if(obj.type == OpenPromoteData.ROLE_WING_LV)
				{
					obj.num = RoleDataManager.instance.getWingLvNum();
				}
				else if(obj.type == OpenPromoteData.ROLE_HLZX)
				{
					obj.num = RoleDataManager.instance.getHlzxNum(cfg.num,cfg.level);
				}
				else if(obj.type == OpenPromoteData.ROLE_LV)
				{
					obj.num = RoleDataManager.instance.isReinLvUp(cfg.num,cfg.level);
				}
				else
				{
					obj.num = data.readInt();
				}
				item.data[obj.index] = obj;
			}
			promoteData[day] = item;
		}
		
		private function dealNew(data:ByteArray):void
		{
			// TODO Auto Generated method stub
			var day:int = data.readInt();
			var size:int = data.readInt();
			var item:OpenNewData = new OpenNewData();
			item.day = day;
			item.data = new Dictionary();
			for(var i:int = 0;i<size;i++)
			{
				var obj:Object = new Object;
				obj.index = data.readInt();
				obj.dailyNum = data.readInt();
				obj.sum = data.readInt();
				item.data[obj.index] = obj;
			}
			newData[day] = item;
		}		
		
		
		private function dealSpecialGet(data:ByteArray):void
		{
			// TODO Auto Generated method stub
			var index:int = data.readByte();
			var cfg:SpecialPreferenceRewordCfgData = ConfigDataManager.instance.cheapReward(index);
			var s:String = StringConst.PANEL_OPEN_GIFT_012.replace("x",cfg.cost_unbind);
			s = s.replace("y",cfg.name);
			Alert.message(s);
		}
		
		private function dealSpecialReward(data:ByteArray):void
		{
			// TODO Auto Generated method stub
			for(var i:int = 0;i<4;i++)
			{
				specialReward[i] = data.readInt();
			}
			initSp = true;
		}
		
		public function getSpecialReward(index:int):void
		{
			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			data.writeByte(index);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_SPECIAL_PREFERENCE_REWARD_GET,data);
		}
		
		
		
		public function getDailyInfo():void
		{
			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			data.writeInt(curDay);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_QUERY_OPEN_SERVER_DAILY,data);
		}
		
		public function getJourneyInfo():void
		{
			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			data.writeInt(curDay);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_QUERY_OPEN_SERVER_JOURNEY,data);
		}
		
		public function getPromoteInfo():void
		{
			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			data.writeInt(curDay);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_QUERY_OPEN_SERVER_PROMOTE,data);
		}
		
		public function getNewInfo():void
		{
			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			data.writeInt(curDay);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_QUERY_OPEN_SERVER_NEW,data);
		}
		
		public function getDailyReward(index:int):void
		{
			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			data.writeInt(curDay);
			data.writeInt(index);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_GET_OPEN_SERVER_DAILY,data);
		}
		public function getJourneyReward(index:int):void
		{
			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			data.writeInt(curDay);
			data.writeInt(index);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_GET_OPEN_SERVER_JOURNEY,data);
		}
		public function getPromoteReward(index:int):void
		{
			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			data.writeInt(curDay);
			data.writeInt(index);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_GET_OPEN_SERVER_PROMOTE,data);
		}
		public function getNewReward():void
		{
			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			data.writeInt(curDay);
			data.writeInt(curDay);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_BUY_OPEN_SERVER_NEW,data);
		}
		
		public function askALL():void
		{
			getJourneyInfo();
			getPromoteInfo();
			getNewInfo();
		}
		
		public function getCanGetReward():Array
		{
			var arr:Array = new Array();
			if(dailyData[curDay])
				arr.push((dailyData[curDay] as OpenDailyData).canGet());
			else
				arr.push(0);
			
			if(journeyData[curDay])
				arr.push((journeyData[curDay] as OpenJourneyData).canGet());
			else
				arr.push(0);
			
			if(promoteData[curDay])
				arr.push((promoteData[curDay] as OpenPromoteData).canGet());
			else
				arr.push(0);
			
			if(newData[curDay])
				arr.push((newData[curDay] as OpenNewData).canGet());
			else
				arr.push(0);
			
			return arr;
		}
		
	}
}