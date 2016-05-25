package com.view.gameWindow.panel.panels.specialRing
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.DungeonCfgData;
	import com.model.configData.cfgdata.SpecialRingCfgData;
	import com.model.configData.cfgdata.SpecialRingDungeonCfgData;
	import com.model.configData.cfgdata.SpecialRingLevelCfgData;
	import com.model.dataManager.DataManagerBase;
	import com.pattern.Observer.IObserver;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.specialRing.upgrade.RingCondition;
	import com.view.gameWindow.panel.panels.vip.VipDataManager;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	
	/**
	 * 特戒数据管理类
	 * @author Administrator
	 */	
	public class SpecialRingDataManager extends DataManagerBase implements IObserver
	{
		/**投骰消耗活力值*/
		public static const VIT_COST_VALUE:int = 20;
		
		private static var _instance:SpecialRingDataManager;
		public static function get instance():SpecialRingDataManager
		{
			return _instance ||= new SpecialRingDataManager(new PrivateClass());
		}
		
		public static function clearInstance():void
		{
			_instance = null;
		}
		
		public var isFlying:Boolean = false;
		
		private var isInit:Boolean;
		/**第一页为0*/
		public var selectTab:int;
		
		public const totalRing:int = 8;
		public var datas:Dictionary;
		/**选中戒子的ring_id*/
		public var select:int;
		/**根据数据自动选中的id*/
		public var autoSelect:int = 1;
		/**1字节有符号整形，当前所在特戒副本系统格子*/
		public var dungeon_point:int;
		public var dungeon_index:int;
		/**达到条件激活的戒子id*/
		public var ringGet:int;
		
		public var ringDgnData:Array=[];
		
		public var has_upgrade:Boolean = false;
		
		public function SpecialRingDataManager(pc:PrivateClass)
		{
			super();
			if(!pc)
			{
				throw new Error("该类使用单例模式");
			}
			DistributionManager.getInstance().register(GameServiceConstants.SM_RING_INFO,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_RING_PROGRESS_INFO,this);
			doAttach();
		}
		
		public function initialize():void
		{
			if(isInit)
			{
				return;
			}
			isInit = true;
			var cfgDts:Vector.<SpecialRingCfgData> = specialRingCfgDatas();
			datas = new Dictionary();
			var i:int;
			for(i=0;i<totalRing;i++)
			{
				var cfgDt:SpecialRingCfgData = cfgDts[i];
				var data:SpecialRingData = new SpecialRingData(i+1,cfgDt.id);
				datas[data.ringId] = data;
			}
			select = ringIdBy(SpecialRingData.RING_INDEX_1);
		}
		
		private function specialRingCfgDatas():Vector.<SpecialRingCfgData>
		{
			var job:int = RoleDataManager.instance.job;
			var cfgDts:Vector.<SpecialRingCfgData> = ConfigDataManager.instance.specialRingCfgDatas(job);
			return cfgDts;
		}
		
		public function ringIdBy(ringIndex:int):int
		{
			var cfgDts:Vector.<SpecialRingCfgData> = specialRingCfgDatas();
			return cfgDts[ringIndex-1].id;
		}
		
		/*public function queryRingInfo():void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_QUERY_RING_INFO,byteArray);
		}*/
		
		public function getRing(id:int):void
		{
			var specialRingData:SpecialRingData = datas[id];
			if(!specialRingData.isActive)
			{
				var byteArray:ByteArray = new ByteArray();
				byteArray.endian = Endian.LITTLE_ENDIAN;
				byteArray.writeInt(id);
				ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_GET_RING,byteArray);
			}
		}
		
		public function upgradeRing(id:int):void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeInt(id);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_UPGRADE_RING,byteArray);
		}
		
		public function useRing(id:int):void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeInt(id);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_USE_RING,byteArray);
		}
		
		public function randomRingDungeon():void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_RANDOM_RING_DUNGEON_POINT,byteArray);
		}
		
		public function enterRingDungeon():void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_ENTER_RING_DUNGEON,byteArray);
		}
		
		public function enterDungeonByUpgrade(rId:int,dId:int):void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeByte(1);
			byteArray.writeInt(dId);
			byteArray.writeInt(rId);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_RIGHT_NOW_CHALLENGE,byteArray);
		}
		
		override public function resolveData(proc:int, data:ByteArray):void
		{
			switch(proc)
			{
				case GameServiceConstants.SM_RING_INFO:
					initialize();
					dealRingInfo(data);
					dealConditionRefresh();
					break;
				case GameServiceConstants.SM_RING_PROGRESS_INFO:
					updateRingProgressData(data);
					dealConditionRefresh();
					break;
				default:
					break;
			}
			super.resolveData(proc, data);
		}
		
		public function update(proc:int=0):void
		{
			if(proc == GameServiceConstants.SM_BAG_ITEMS || proc == GameServiceConstants.SM_CHR_INFO || proc == GameServiceConstants.SM_VIP_INFO)
			{
				dealConditionRefresh();
			}
		}
		
		private function dealConditionRefresh():void
		{
			var data:SpecialRingData,condition:RingCondition;
			for each(data in datas)
			{
				data.target1;
				data.target2;
				data.checkOnlyRequest();
			}
		}
		
		public function doAttach():void
		{
			BagDataManager.instance.attach(this);
			RoleDataManager.instance.attach(this);
			VipDataManager.instance.attach(this);
		}
		
		public function doDetach():void
		{
			VipDataManager.instance.detach(this);
			RoleDataManager.instance.detach(this);
			BagDataManager.instance.detach(this);
		}
		
		private function dealRingInfo(data:ByteArray):void
		{
			var size:int;//循环数，主要是特戒数，为1字节有符号整形
			//下面缩进部分表示依照size数量循环的数据
			var ring_id:int;//特戒id，4字节有符号整形
			var level:int;//特戒等级，1字节有符号整形
			var in_use:int;//是否使用，1字节有符号整形，1表示使用，0表示未使用，仅仅需要使用的特戒才有效
			dungeon_point = data.readByte();
			dungeon_index=data.readByte();//随机值
			size = data.readByte();
			has_upgrade = false;
			while(size--)
			{
				ring_id = data.readInt();
				level = data.readByte();
				in_use = data.readByte();
				var dt:SpecialRingData = datas[ring_id];
				dt.isActive = true;
				dt.ringId = ring_id;
				if(dt.isInit&&dt.level<level)
					has_upgrade = true;
				dt.level = level;
				dt.in_use = in_use;
				dt.skillCfgDatas;
			}
			for each( dt in datas)
			{
				dt.isInit = true;
			}
			autoSelectFunc();
		}
		
		public function autoSelectFunc(isAuto:Boolean=false):void
		{
			for each(var dt:SpecialRingData in datas)
			{
				var specialRingLevelCfgDatas:Vector.<SpecialRingLevelCfgData> = ConfigDataManager.instance.specialRingLevelCfgDatas(dt.ringId);
				if(dt.level<specialRingLevelCfgDatas.length)  //如果已经满级了
				{
					autoSelect=dt.ringId;
					break;
				}
			}
			if(select== ringIdBy(SpecialRingData.RING_INDEX_1))
			{
				select=autoSelect;
				return;
			}
			if(isAuto)
			{
				select=autoSelect;
			}
		}
		
		private function updateRingProgressData(data:ByteArray):void
		{
			var size:int=data.readByte();
			ringDgnData.splice(0,ringDgnData.length);
			while(size--)
			{
				var rid:int=data.readInt();
				var ctype:int=data.readByte();
				var para1:int=data.readInt();
				var para2:int=data.readInt();
				
				ringDgnData.push([rid,ctype,para1,para2]);
			}
		}
		
		public function isCanEnter():Boolean
		{
			if(dungeon_point==0)
				return false;
			return !Boolean(dungeon_point % 2);
		}
		
		public function getSelectData():SpecialRingData
		{
			return datas[select];
		}
		
		public function getDataById(id:int):SpecialRingData
		{
			return datas[id];
		}
		
		public function getDungeonCfgData(cell:int = -1):DungeonCfgData
		{
			var specialRingDungeonCfgData:SpecialRingDungeonCfgData = ConfigDataManager.instance.specialRingDungeonCfgData(cell == -1 ? dungeon_point : cell);
			if(specialRingDungeonCfgData)
			{
				var dungeonCfgData:DungeonCfgData = ConfigDataManager.instance.dungeonCfgDataId(specialRingDungeonCfgData.dungeon);
				return dungeonCfgData;
			}
			return null;
		}
		
		public function isCoinEnough(lvCfgDt:SpecialRingLevelCfgData,uesd:int = 0):Boolean
		{
			var coinBind:int = BagDataManager.instance.coinBind;
			var coinUnBind:int = BagDataManager.instance.coinUnBind;
			if(coinBind+coinUnBind-uesd < lvCfgDt.coin_cost)
			{
				return false;
			}
			else
			{
				return true;
			}
		}
		
		public function isItemEnough(lvCfgDt:SpecialRingLevelCfgData,uesd:int = 0):Boolean
		{
			var num:int = BagDataManager.instance.getItemNumById(lvCfgDt.item_id);
			if(num-uesd < lvCfgDt.item_count)
			{
				return false
			}
			else
			{
				return true;
			}
		}
		
		public function isLvEnough(lvCfgDt:SpecialRingLevelCfgData):Boolean
		{
			var checkReincarnLevel:Boolean = RoleDataManager.instance.checkReincarnLevel(lvCfgDt.reincarn,lvCfgDt.player_level);
			return checkReincarnLevel;
		}
		/**可升级的星星数*/
		public function upableNum():int
		{
			var num:int;
			var coinUsed:int,itemsUsed:Dictionary = new Dictionary();
			var dt:SpecialRingData;
			for each(dt in datas)
			{
				if(!dt.isActive)
				{
					continue;
				}
				var lvCfgDts:Vector.<SpecialRingLevelCfgData> = ConfigDataManager.instance.specialRingLevelCfgDatas(dt.ringId);
				var lvCfgDt:SpecialRingLevelCfgData = lvCfgDts.length > dt.level ? lvCfgDts[dt.level] : null;
				if(!lvCfgDt)
				{
					continue;
				}
				var isLvEnough:Boolean = isLvEnough(lvCfgDt);
				if(!isLvEnough)
				{
					continue;
				}
				var isCoinEnough:Boolean = isCoinEnough(lvCfgDt,coinUsed);
				if(!isCoinEnough)
				{
					continue;
				}
				var isNaN:Boolean = isNaN(itemsUsed[lvCfgDt.item_id]);
				var itemUsed:int = isNaN ? 0 : itemsUsed[lvCfgDt.item_id];
				var isItemEnough:Boolean = isItemEnough(lvCfgDt,itemUsed);
				if(!isItemEnough)
				{
					continue;
				}
				coinUsed += lvCfgDt.coin_cost;
				isNaN ? itemsUsed[lvCfgDt.item_id] = lvCfgDt.item_count : itemsUsed[lvCfgDt.item_id] += lvCfgDt.item_count;
				num += 1;
			}
			return num;
		}
	}
}
class PrivateClass{}