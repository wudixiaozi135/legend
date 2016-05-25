package com.view.gameWindow.panel.panels.dungeon
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.DungeonCfgData;
	import com.model.configData.constants.ConfigType;
	import com.model.consts.DungeonConst;
	import com.model.dataManager.DataManagerBase;
	import com.view.gameWindow.mainUi.MainUiMediator;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.boss.BossDataManager;
	import com.view.gameWindow.panel.panels.boss.individual.IndividualBossData;
	import com.view.gameWindow.panel.panels.boss.individual.IndividualItemData;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.onhook.AutoSystem;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.task.TaskDataManager;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	
	public class DgnDataManager extends DataManagerBase
	{
		private static var _instance:DgnDataManager;
		public static function get instance():DgnDataManager
		{
			return _instance ||= new DgnDataManager(new PrivateClass());
		}
		
		/**DungeonData字典*/
		public var datas:Dictionary;
		public var isDealChrDgnInfo:Boolean;
		private var searchDgnInfoType:int;
		private var searchDgnInfoResult:Array;
		public var isInDgn:Boolean = false;
		public var dungeonId:int = 0;
		public var dungeonFunc:int = 0;
		private var firstLogin:Boolean = true;
		
		public function DgnDataManager(pc:PrivateClass)
		{
			super();
			if(!pc)
			{
				throw new Error("该类使用单例模式");
			}
			DistributionManager.getInstance().register(GameServiceConstants.SM_CHR_DUNGEON_INFO,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_ENTER_DUNGEON,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_LEAVE_DUNGEON,this);
			datas = new Dictionary();
		}
		
		public function clearInstance():void
		{
			_instance = null;
		}
		
		public function cmEnterDungeon(dgnId:int):void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeInt(dgnId);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_ENTER_DUNGEON,byteArray);
		}
		
		public function queryChrDungeonInfo():void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeInt(0);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_QUERY_CHR_DUNGEON_INFO,byteArray);
		}
		
		override public function resolveData(proc:int, data:ByteArray):void
		{
			switch(proc)
			{
				default:
					break;
				case GameServiceConstants.SM_CHR_DUNGEON_INFO:
					dealChrDgnInfo(data);
					refreshChrDungeon();
					TaskDataManager.instance.refreshVirtualTasks();
					isDealChrDgnInfo = true;
					break;
				case GameServiceConstants.SM_ENTER_DUNGEON:
					dealInDgn(data);
					break;
				case GameServiceConstants.SM_LEAVE_DUNGEON:
					dealOutDgn();
					break;
			}
			super.resolveData(proc, data);
		}
		
		public function refreshChrDungeon():void
		{
//			if(!firstLogin)return;
			var individualBossData:IndividualBossData = BossDataManager.instance.individualBossData;
			var items:Array = individualBossData.items;
			var dgnDataManager:DgnDataManager = DgnDataManager.instance;
			var dungeonData:DungeonData;
			var dungeon_id:int
			var individualItemData:IndividualItemData 
			for(var i:int = 0;i < items.length;i++)
			{
				individualItemData = items[i] as IndividualItemData;
				dungeon_id = individualItemData.bossCfgData.dungeon_id;
				dungeonData = dgnDataManager.getDgnDt(dungeon_id);
				if(dungeonData)
				{
					individualItemData.daily_complete_count = dungeonData.daily_complete_count;
					individualItemData.online_cleared = dungeonData.online_cleared;
				}
				items[i] = individualItemData;
			}
			BossDataManager.instance.individualBossData.items = items;
			BossDataManager.instance.checkNoneBoss();
			if(firstLogin)
			{
				if(BossDataManager.instance.getIndividualBossCount()){
					BossDataManager.instance.notify(BossDataManager.INDIVIDUAL_BOSS_NEW);
				}
				firstLogin = false;
			}
		}
		
		private function dealInDgn(bytearray:ByteArray):void
		{
			isInDgn = true;
			var enterDgnId:int = bytearray.readInt();
			dungeonId = enterDgnId;
			var dgnCfgDt:DungeonCfgData = ConfigDataManager.instance.dungeonCfgDataId(enterDgnId);
			MainUiMediator.getInstance().taskTrace.showHide(false);
			MainUiMediator.getInstance().changeUIState(MainUiMediator.getInstance().taskTrace,false);
			dungeonFunc = dgnCfgDt.func_type;
			switch(dgnCfgDt.func_type)
			{
				case DungeonConst.FUNC_TYPE_TOWER:
				case DungeonConst.FUNC_TYPE_MAIN_TOWER:
					PanelMediator.instance.openPanel(PanelConst.TYPE_DUNGEON_TOWER_INFO);
					PanelMediator.instance.openPanel(PanelConst.TYPE_DUNGEON_TOWER_BTNS);
					/*DgnTowerDataManger.instance.dungeonId = enterDgnId;*/
					break;
				case DungeonConst.FUNC_TYPE_REINCARN:
				case DungeonConst.FUNC_TYPE_PRIVATE:
					BossDataManager.instance.dungeonId = enterDgnId;
					PanelMediator.instance.openPanel(PanelConst.TYPE_DUNGEON_INDIVIDUALBOSS_INFO);
					break;
				case DungeonConst.FUNC_TYPE_MAIN:
					MainUiMediator.getInstance().taskTrace.showHide(true);
					MainUiMediator.getInstance().changeUIState(MainUiMediator.getInstance().taskTrace,true);
					/*PanelMediator.instance.openPanel(PanelConst.TYPE_DUNGEON_GOALS);*/
					break;
				case DungeonConst.FUNC_TYPE_NORMAL:
				case DungeonConst.FUNC_TYPE_SPECIAL_RING:
					PanelMediator.instance.openPanel(PanelConst.TYPE_DUNGEON_GOALS);
					if(dgnCfgDt.func_type != DungeonConst.FUNC_TYPE_NORMAL)
					{
						PanelMediator.instance.openPanel(PanelConst.TYPE_DUNGEON_STAR);
					}
					break;
				default:
					PanelMediator.instance.openPanel(PanelConst.TYPE_DUNGEON_GOALS);
					break;
			}
			
			AutoSystem.instance.stopAutoEx();
			
			//副本次数需要更新
			DgnDataManager.instance.queryChrDungeonInfo();
		}
		
		private function dealOutDgn():void
		{
			DgnGoalsDataManager.instance.reset();
			PanelMediator.instance.closePanel(PanelConst.TYPE_DUNGEON_INDIVIDUALBOSS_INFO);
			PanelMediator.instance.closePanel(PanelConst.TYPE_DUNGEON_TOWER_INFO);
			PanelMediator.instance.closePanel(PanelConst.TYPE_DUNGEON_TOWER_BTNS);
			PanelMediator.instance.closePanel(PanelConst.TYPE_DUNGEON_GOALS);
			PanelMediator.instance.closePanel(PanelConst.TYPE_DUNGEON_STAR);
			PanelMediator.instance.closePanel(PanelConst.TYPE_DUNGEON_REWARD);
			PanelMediator.instance.closePanel(PanelConst.TYPE_DUNGEON_REWARD_CARD);
			MainUiMediator.getInstance().taskTrace.showHide(true);
			BossDataManager.instance.dungeonId = 0;
			isInDgn = false;
			dungeonId = 0;
			dungeonFunc = 0;
			TaskDataManager.instance.setAutoTask(true,"DgnDataManager::dealOutDgn");
			
			HeroDataManager.instance.recoverActivityMode();
			
			queryChrDungeonInfo();
		}
		
		public var isChrDgnInfoInited:Boolean = false;
		private function dealChrDgnInfo(data:ByteArray):void
		{
			var count:int = data.readShort();//2字节有符号整形,已进过副本的数量
			//下面缩进部分为按照count循环，包含所有副本进入数据
			while(count--)
			{
				var id:int = data.readInt();//4字节有符号整形，副本id
				var daily_enter_count:int = data.readByte();//1字节有符号整形，当日进入次数
				var daily_complete_count:int = data.readByte();//1字节有符号整形，当日完成次数
				var online_cleared:int = data.readByte();//是否已清理在线时间
				var dungeonData:DungeonData = new DungeonData();
				dungeonData.dgnId = id;
				dungeonData.daily_enter_count = daily_enter_count;
				dungeonData.daily_complete_count = daily_complete_count;
				dungeonData.online_cleared = online_cleared;
				datas[id] = dungeonData;
			}
			
			isChrDgnInfoInited = true;
		}
		/**副本id*/
		public function getDgnDt(dgnId:int):DungeonData
		{
			var dgnDt:DungeonData = datas[dgnId] as DungeonData;
			return dgnDt;
		}
		/**
		 *  {num:num,curMax:curMax,max:max,npcId:npcId}
		 */
		public function getDgnInfo(func_type:int):Object
		{
			var list:Array = getDgnByType(func_type);
			
			var num:int = 0;
			var max:int = 0;
			var npcId:int = 0;
			var curMax:int = 0;
			
			for each(var data:DungeonCfgData in list)
			{
				var record:DungeonData = getDgnDt(data.id);
				num += record ? record.daily_enter_count : 0;
				max += data.free_count + data.toll_count;
				if(RoleDataManager.instance.checkReincarnLevel(data.reincarn,data.level))
				{
					curMax += data.free_count + data.toll_count;
				}
				if(npcId == 0)
				{
					npcId = data.npc;
				}
			}
			
			return {num:num,max:max,curMax:curMax,npcId:npcId};
		}
		
		/**
		 * key:func_type
		 */
		private var dgnCfgDict:Dictionary = new Dictionary();
		
		private function searchSameFuncDgn(data:DungeonCfgData):void
		{
			if(data.func_type == searchDgnInfoType)
			{
				searchDgnInfoResult.push(data);
			}
		}
		
		public function getDgnByType(func_type:int):Array
		{
			if(!dgnCfgDict[func_type])
			{
				searchDgnInfoType = func_type;
				searchDgnInfoResult = [];
				ConfigDataManager.instance.forEach([ConfigType.keyDungeonId],searchSameFuncDgn);
				dgnCfgDict[func_type] = searchDgnInfoResult.concat();
			}
			
			return dgnCfgDict[func_type];
		}
	}
}
class PrivateClass{}