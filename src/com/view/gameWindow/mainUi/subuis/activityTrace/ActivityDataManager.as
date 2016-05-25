package com.view.gameWindow.mainUi.subuis.activityTrace
{
	import com.core.toArray;
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.ActivityCfgData;
	import com.model.configData.cfgdata.MapRegionCfgData;
	import com.model.configData.cfgdata.NpcTeleportCfgData;
	import com.model.consts.StringConst;
	import com.model.dataManager.DataManagerBase;
	import com.model.dataManager.LoginDataManager;
	import com.model.dataManager.TeleportDatamanager;
	import com.pattern.Observer.IObserver;
	import com.view.gameWindow.common.ModelEvents;
	import com.view.gameWindow.mainUi.subuis.activityTrace.constants.ActivityFuncTypes;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.IPanelBase;
	import com.view.gameWindow.panel.panels.activitys.castellanWorship.WorshipDataManager;
	import com.view.gameWindow.panel.panels.activitys.goldenPig.GoldenPigDataManager;
	import com.view.gameWindow.panel.panels.activitys.loongWar.LoongWarDataManager;
	import com.view.gameWindow.panel.panels.activitys.nightFight.NightFightDataManager;
	import com.view.gameWindow.panel.panels.activitys.seaFeast.SeaFeastDataManager;
	import com.view.gameWindow.panel.panels.map.MapDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.scene.entity.EntityLayerManager;
	import com.view.gameWindow.scene.entity.entityItem.interf.IFirstPlayer;
	import com.view.gameWindow.scene.map.SceneMapManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	
	/**
	 * ModelEvents.UPDATE_MAP_ACTIVITY
	 * @see ModelEvents
	 * @author wqhk
	 * 2014-11-26
	 */
	public class ActivityDataManager extends DataManagerBase implements IObserver
	{
		private static var _instance:ActivityDataManager;
		public static function get instance():ActivityDataManager
		{
			if(!_instance)
			{
				_instance = new ActivityDataManager();
			}
			
			return _instance;
		}
		public static function clearInstance():void
		{
			_instance = null;
		}
		
		private var _seaFeastDataManager:SeaFeastDataManager;
		private var _goldenPigDataManager:GoldenPigDataManager;
		private var _worshipDataManager:WorshipDataManager;
		private var _loongWarDataManager:LoongWarDataManager;
		private var _nightFightDataManger:NightFightDataManager;
		
		/**ActivityData字典*/		
		public var openActvs:Dictionary;
		private var _mapActivity:Dictionary;
		private var _activityList:Vector.<ActivityCfgData>;
		private var _currentActvCfgDtAtMap:ActivityCfgData;
		private var _currentMap:int;
		/**已获得的协议标志，一位代表一条协议*/
		private var _procGetted:int;

		public function get currentActvDataAtMap():ActivityData
		{
			return currentActvCfgDtAtMap ? openActvs[currentActvCfgDtAtMap.id] : null;
		}
		
		public function ActivityDataManager()
		{
			super();
			
			DistributionManager.getInstance().register(GameServiceConstants.SM_ACTIVITY_STEP_PROGRESS,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_ACTIVITY_CAN_LEAVE,this);
			EntityLayerManager.getInstance().attach(this);
			LoginDataManager.instance.attach(this);
			MapDataManager.instance.attach(this);
			
			_mapActivity = new Dictionary();
			_activityList = new Vector.<ActivityCfgData>();
			toArray(ConfigDataManager.instance.activityCfgDatas(),_activityList);
			
			initMapActivity();
			update(GameServiceConstants.SM_ENTER_MAP);
			
			openActvs = new Dictionary();
			
			_seaFeastDataManager = new SeaFeastDataManager();
			_goldenPigDataManager = new GoldenPigDataManager();
			_worshipDataManager = new WorshipDataManager();
			_loongWarDataManager = new LoongWarDataManager();
			_nightFightDataManger = new NightFightDataManager();
		}
		
		private function initMapActivity():void
		{
			for each(var cfgDt:ActivityCfgData in _activityList)
			{
				var mapId:int;
				for each(mapId in cfgDt.mapIds)
				{
					if(!_mapActivity[mapId])
					{
						_mapActivity[mapId] = new Vector.<ActivityCfgData>();
					}
					_mapActivity[mapId].push(cfgDt);
				}
			}
		}
		
		public function get seaFeastDataManager():SeaFeastDataManager
		{
			return _seaFeastDataManager;
		}
		
		public function get goldenPigDataManager():GoldenPigDataManager
		{
			return _goldenPigDataManager;
		}
		
		public function get worshipDataManager():WorshipDataManager
		{
			return _worshipDataManager;
		}
		
		public function get loongWarDataManager():LoongWarDataManager
		{
			return _loongWarDataManager;
		}
		
		public function get nightFightDataManager():NightFightDataManager
		{
			return _nightFightDataManger;
		}
		
		public function get currentActvCfgDtAtMap():ActivityCfgData
		{
			return _currentActvCfgDtAtMap;
		}
		/**在value类型活动的活动地图中*/
		public function isAcitivtyTypeEqualValue(value:int):Boolean
		{
			var activityCfgDatas:Vector.<ActivityCfgData> = _mapActivity[_currentMap];
			if (activityCfgDatas && activityCfgDatas.length > 0 && activityCfgDatas[0].func_type == value)
			{
				return true;
			}
			return false;
		}
		
		public function enterActivity(type:int,isRollTipShow:Boolean = true):void
		{
			var activityCfgData:ActivityCfgData = ConfigDataManager.instance.activityCfgData2(type);
			if(!activityCfgData)
			{
				trace("ActivityDataManager.enterActivity(type, isRollTipShow) 活动配置信息错误");
				return;
			}
			if(!activityCfgData.isInActv)
			{
				if(isRollTipShow)
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.ACTV_ENTER_TIP_0001);
				}
				return;
			}
			if(!activityCfgData.isEnterOpen)
			{
				if(isRollTipShow)
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.ACTV_ENTER_TIP_0002);
				}
				return;
			}
			var limitLv:int = activityCfgData ? activityCfgData.level : int.MAX_VALUE;
			var limitReincarn:int = activityCfgData ? activityCfgData.reincarn : int.MAX_VALUE;
			var checkReincarnLevel:Boolean = RoleDataManager.instance.checkReincarnLevel(limitReincarn,limitLv);
			if(!checkReincarnLevel)
			{
				if(isRollTipShow)
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.DGN_TOWER_0034);
				}
				return;
			}
			var dic:Dictionary = ConfigDataManager.instance.npcTeleportCfgDatas(activityCfgData.npc);
			var npcTeleprotCfgDt:NpcTeleportCfgData;
			for each(npcTeleprotCfgDt in dic)
			{
				TeleportDatamanager.instance.requestTeleportNpc(npcTeleprotCfgDt.id);
				break;
			}
		}
		
		public function update(proc:int=0):void
		{
			if(proc == GameServiceConstants.SM_ENTER_MAP)
			{
				_procGetted |= (1<<1);
				if(_procGetted == 3)
				{
					enterMap(SceneMapManager.getInstance().mapId);
				}
			}
			else if(proc == GameServiceConstants.SM_SERVER_TIME)
			{
				_procGetted |= (1<<0);
				if(_procGetted == 3)
				{
					enterMap(SceneMapManager.getInstance().mapId);
				}
			}
			else if(proc == ModelEvents.UPDATE_ACTIV_INFO_BY_POSTION)
			{
				var isChange:Boolean = updateActvAtMap();
				if(isChange)
				{
					notify(ModelEvents.UPDATE_MAP_ACTIVITY);
				}
			}
		}
		
		private function enterMap(mapId:int):void
		{
			if(_currentMap != mapId)
			{
				_currentMap = mapId;
				
				var isChange:Boolean = updateActvAtMap();
				if(isChange)
				{
					if(_currentActvCfgDtAtMap)
					{
						notify(ModelEvents.UPDATE_MAP_ACTIVITY);
						cmQueryActivityStepProgress(_currentActvCfgDtAtMap.id);
						if(_currentActvCfgDtAtMap.func_type == ActivityFuncTypes.AFT_LOONG_WAR)
						{
							loongWarDataManager.cmLongchengQueryTrack();
						}
					}
					else
					{
						notify(ModelEvents.UPDATE_MAP_ACTIVITY);
					}
				}
			}
		}
		/**
		 * 刷新当前地图当前时间当前区域的活动配置信息
		 * @return 活动配置信息是否改变
		 */		
		public function updateActvAtMap():Boolean
		{
			var list:Vector.<ActivityCfgData> = _mapActivity[_currentMap];
			var newActivity:ActivityCfgData = null;
			
			for each(var cfgDt:ActivityCfgData in list)
			{
				if(cfgDt.isInActv)
				{
					var firstPlayer:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
					var isIn:Boolean = cfgDt.isIn(firstPlayer.tileX,firstPlayer.tileY);
					if(isIn)
					{
						loongWarRegionExpRatio();
						//
						newActivity = cfgDt;
						break;
					}
				}
			}
			
			if(_currentActvCfgDtAtMap != newActivity)
			{
				_currentActvCfgDtAtMap = newActivity;
				if(_currentActvCfgDtAtMap)
				{
					var checkReincarnLevel:Boolean = RoleDataManager.instance.checkReincarnLevel(_currentActvCfgDtAtMap.reincarn,_currentActvCfgDtAtMap.level);
					if(checkReincarnLevel)
					{
						return true;
					}
					else
					{
						return false;
					}
				}
				else
				{
					return true;
				}
			}
			return false;
		}
		
		private function loongWarRegionExpRatio():void
		{
			var firstPlayer:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
			var isEqual:Boolean = isAcitivtyTypeEqualValue(ActivityFuncTypes.AFT_LOONG_WAR);
			if(isEqual)
			{
				var cfgDts:Dictionary = ConfigDataManager.instance.mapRegionCfgDatasByMap(_currentMap);
				var cfgDt:MapRegionCfgData;
				var maxExpRatio:int;
				for each (cfgDt in cfgDts)
				{
					var isIn:Boolean = cfgDt.isIn(firstPlayer.tileX,firstPlayer.tileY);
					if(isIn)
					{
						if(maxExpRatio < cfgDt.exp_base_ratio)
						{
							maxExpRatio = cfgDt.exp_base_ratio;
						}
					}
				}
				loongWarDataManager.dtLWTrace.expRatio = maxExpRatio * .01;
			}
		}
		
		public function cmQueryActivityStepProgress(activityId:int):void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeInt(activityId);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_QUERY_ACTIVITY_STEP_PROGRESS,byteArray);
		}
		
		public function cmLeaveActivityMap():void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_LEAVE_ACTIVITY_MAP,byteArray);
		}
		
		override public function resolveData(proc:int, data:ByteArray):void
		{
			switch(proc)
			{
				case GameServiceConstants.SM_ACTIVITY_STEP_PROGRESS:
					readData(data);
					break;
				case GameServiceConstants.SM_ACTIVITY_CAN_LEAVE:
					var panel:IPanelBase = PanelMediator.instance.openedPanel(PanelConst.TYPE_NIGHT_FIGHT_RANK);
					if(!panel)
					{
						PanelMediator.instance.openPanel(PanelConst.TYPE_ACTV_OVER_TRANS);
					}
					break;
				default:
					break;
			}
			super.resolveData(proc, data);
		}
		
		private function readData(byteArray:ByteArray):void
		{
			var activityData:ActivityData = new ActivityData();
			activityData.activityId = byteArray.readInt();
			activityData.step = byteArray.readByte();
			activityData.triggerId = byteArray.readInt();
			activityData.endTime = byteArray.readInt();
			activityData.count = byteArray.readByte();
			activityData.countData = byteArray;
			openActvs[activityData.activityId] = activityData;
			//
			updateActvAtMap();
			notify(ModelEvents.UPDATE_MAP_ACTIVITY);
		}
	}
}