package com.model.dataManager
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
	import com.model.business.gameService.serverMessageManager.subManages.SuccessMessageManager;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.MapCfgData;
	import com.model.configData.cfgdata.MapRegionCfgData;
	import com.model.configData.cfgdata.NpcTeleportCfgData;
	import com.model.consts.StringConst;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.panel.panels.onhook.AutoSystem;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.vip.VipDataManager;
	import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.util.UtilCostRollTip;
	
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;

	public class TeleportDatamanager extends DataManagerBase
	{
		private static var _instance:TeleportDatamanager;
		public static function get instance():TeleportDatamanager
		{
			return _instance ||= new TeleportDatamanager(new PrivateClass());
		}
		public static function clearInstance():void
		{
			_instance = null;
		}
		
		internal var isTeleport:Boolean;
		internal var telePortSuccess:TeleportSuccess;
		
		public function TeleportDatamanager(pc:PrivateClass)
		{
			super();
			if(!pc)
			{
				throw new Error("该类使用单例模式");
			}
			/*SuccessMessageManager.getInstance().register(GameServiceConstants.CM_SWITCH_MAP,this);*/
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_NPC_TELEPORT,this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_TELEPORT,this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_BOSS_TELEPORT,this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_TASK_TELEPOTER,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_NPC_TELEPORT_SUCCESS,this);
			telePortSuccess = new TeleportSuccess();
		}
		
		public function requestTeleportPostioin(mapId:int,teleportX:int,teleportY:int):void
		{
			resetAuto();
			//
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeByte(1);//1字节有符号整形，1表示按坐标点传送，2表示按区域传送
			//如果按坐标点传送，按以下缩进部分下发数据：
			byteArray.writeInt(mapId);//4字节有符号整形，地图id
			byteArray.writeShort(teleportX);//2字节有符号整形，横向格子
			byteArray.writeShort(teleportY);//2字节有符号整形，纵向格子
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_TELEPORT,byteArray);
		}
		
		public function requestTeleportRegion(regionId:int):void
		{
			resetAuto();
			//
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeByte(2);//1字节有符号整形，1表示按坐标点传送，2表示按区域传送
			//如果按区域传送，按以下缩进部分下发数据：
			byteArray.writeInt(regionId);//4字节有符号整形，传送的区域id
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_TELEPORT,byteArray);
		}
		
		public function requestFlyVIPMap(mapId:int):void
		{
			resetAuto();
			//
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			//如果按区域传送，按以下缩进部分下发数据：
			byteArray.writeInt(mapId);//4字节有符号整形，传送的区域id
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_VIP_MAP_TELEPORT,byteArray);
		}
		
		public function requestTeleportTask(taskId:int):void
		{
			resetAuto();
			//
			var byteArr:ByteArray = new ByteArray();
			byteArr.endian = Endian.LITTLE_ENDIAN;
			byteArr.writeInt(taskId);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_TASK_TELEPOTER,byteArr);
		}
		
		public function requestTeleportNpcNeedCheck(npcId:int):void
		{
			var npcTeleportCfgDatas:Dictionary = ConfigDataManager.instance.npcTeleportCfgDatas(npcId);
			var npcTeleportCfgData:NpcTeleportCfgData;
			for each(npcTeleportCfgData in npcTeleportCfgDatas)
			{
				if(!npcTeleportCfgData)
				{
					return;
				}
				requestTeleportNpcNeedCheck1(npcTeleportCfgData.id);
			}
		}
		
		public function requestTeleportNpcNeedCheck1(teleportId:int):void
		{
			var npcTeleportCfgData:NpcTeleportCfgData = ConfigDataManager.instance.npcTeleportCfgData(teleportId);
			if(!npcTeleportCfgData)
			{
				return;
			}
			var mapRegionCfgData:MapRegionCfgData = npcTeleportCfgData.mapRegionCfgData;
			if(!mapRegionCfgData)
			{
				return;
			}
			var mapCfgData:MapCfgData = mapRegionCfgData.mapCfgData;
			if(!mapCfgData)
			{
				return;
			}
			var checkReincarnLevel:Boolean = RoleDataManager.instance.checkReincarnLevel(mapCfgData.reincarn,mapCfgData.level);
			if(!checkReincarnLevel)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.DUNGEON_PANEL_0024);
				return;
			}
			var vip:int = VipDataManager.instance.lv;
			if(npcTeleportCfgData.vip && npcTeleportCfgData.vip > vip)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.DUNGEON_PANEL_0032.replace("&x",npcTeleportCfgData.vip));
				return;
			}
			if(!UtilCostRollTip.costEnoughOnlyOne(npcTeleportCfgData))
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,UtilCostRollTip.str);
				return;
			}
			TeleportDatamanager.instance.requestTeleportNpc(npcTeleportCfgData.id);
		}
		
		public function requestTeleportNpc(teleportId:int):void
		{
			resetAuto();
			//
			var byteArr:ByteArray = new ByteArray();
			byteArr.endian = Endian.LITTLE_ENDIAN;
			byteArr.writeInt(teleportId);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_NPC_TELEPORT,byteArr);
		}
		
		public function requestTeleportBoss(type:int,teleportType:int,region:int):void
		{
			var _byte:ByteArray = new ByteArray();
			_byte.endian = Endian.LITTLE_ENDIAN;
			_byte.writeByte(type);
			_byte.writeByte(teleportType);
			_byte.writeInt(region);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_BOSS_TELEPORT,_byte);
		}
		
		private function resetAuto():void
		{
			AutoJobManager.getInstance().overEntity = null;
			AutoJobManager.getInstance().selectEntity = null;
			AutoJobManager.getInstance().reset();
			AutoSystem.instance.stopAuto();
		}
		
		override public function resolveData(proc:int, data:ByteArray):void
		{
			switch(proc)
			{
				default:
					break;
				/*case GameServiceConstants.CM_SWITCH_MAP:*/
				case GameServiceConstants.CM_NPC_TELEPORT:
					cmNpcTeleportDeal(data);
					break;
				case GameServiceConstants.CM_TELEPORT:
				case GameServiceConstants.CM_BOSS_TELEPORT:
				case GameServiceConstants.CM_TASK_TELEPOTER:
					isTeleport = true;
					telePortSuccess.dealTeleportSuccess();
					break;
				case GameServiceConstants.SM_NPC_TELEPORT_SUCCESS:
					npcTeleportSuccess(data);
					break;
			}
			super.resolveData(proc, data);
		}
		
		private function npcTeleportSuccess(data:ByteArray):void
		{
			var npcTeleportId:int = data.readInt();
			var type:int = data.readByte();
			var npcTeleportCfgData:NpcTeleportCfgData = ConfigDataManager.instance.npcTeleportCfgData(npcTeleportId);
			var str:String = UtilCostRollTip.costTeleport(npcTeleportCfgData,type);
			str != "" ? Alert.message(str) : null;
		}
		
		private function cmNpcTeleportDeal(data:ByteArray):void
		{
			
		}
		/**
		 * 设置在传送后再次调用的值
		 * @param targetId 自动目标组id
		 * @param targetType 自动目标类型
		 * @param plusId 自动目标id
		 */		
		public function setTargetEntity(targetId:int,targetType:int,plusId:int = 0,resetAutoTask:Boolean = false):void
		{
			telePortSuccess.targetId = targetId;
			telePortSuccess.targetType = targetType;
			telePortSuccess.isResetAutoTask = resetAutoTask;
			plusId ? telePortSuccess.plusId = plusId : null;
		}
		
		
		/**
		 * 设置在传送后再次调用的值
		 * @param mapId 自动区域地图id
		 * @param postion 自动区域位置
		 */		
		public function setTargetPos(mapId:int, postion:Point, targetTileDist:int):void
		{
			telePortSuccess.targetMapId = mapId;
			telePortSuccess.targetPos = postion;
			telePortSuccess.targetTileDist = targetTileDist;
		}
	}
}
class PrivateClass{}
