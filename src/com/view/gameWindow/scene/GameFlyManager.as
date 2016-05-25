package com.view.gameWindow.scene
{
	import com.core.getDictElement;
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.MapMonsterCfgData;
	import com.model.configData.cfgdata.MapPlantCfgData;
	import com.model.configData.cfgdata.MapTeleportCfgData;
	import com.model.configData.cfgdata.MonsterCfgData;
	import com.model.configData.cfgdata.NpcCfgData;
	import com.model.consts.StringConst;
	import com.model.dataManager.TeleportDatamanager;
	import com.view.gameWindow.panel.panels.school.complex.SchoolElseDataManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;

	public class GameFlyManager
	{
		public function GameFlyManager()
		{
			_instance=this;
		}
		
		private static var _instance:GameFlyManager;
		
		public static function getInstance():GameFlyManager
		{
			return _instance||new GameFlyManager();
		}
		
		/***
		 * 根据PCid  飞到NPC附近
		 * */
		public function flyToMapByNPC(npcId:int):void
		{
			var npcCfgData:NpcCfgData = ConfigDataManager.instance.npcCfgData(npcId);
			if(!npcCfgData)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.HEJI_PANEL_0004);
				trace("GameFlyManager.flyToMapByNPC(npcId) npcCfgData == null");
				return;
			}
			TeleportDatamanager.instance.requestTeleportPostioin(npcCfgData.mapid,npcCfgData.teleport_x,npcCfgData.teleport_y);
		}
		
		public function flyToMapByMonster(monsterId:int,mapId:int = 0):void
		{
			var monster:MapMonsterCfgData;
			var dict:Dictionary = ConfigDataManager.instance.mapMstCfgDatas(monsterId);
			for each(var m:MapMonsterCfgData in dict)
			{
				if(mapId == 0 || m.map_id == mapId)
				{
					monster = m;
					break;
				}
			}
			if(monster)
			{
				TeleportDatamanager.instance.requestTeleportPostioin(monster.map_id,monster.x,monster.y);
			}
		}
		
		public function flyToMapByPlant(plantId:int):void
		{
			var plant:MapPlantCfgData = getDictElement(ConfigDataManager.instance.mapPlantCfgDatas(plantId));
			if(plant)
			{
				TeleportDatamanager.instance.requestTeleportPostioin(plant.map_id,plant.x,plant.y);
			}
		}
		
		public function flyToVIPMapByMapId(mapId:int):void
		{
			TeleportDatamanager.instance.requestFlyVIPMap(mapId);
		}
		
		public function flyToMapByRegId(regId:int):void
		{
			if(regId!=0)
			{
				TeleportDatamanager.instance.requestTeleportRegion(regId);
			}
		}
		
		public function flyToTrailer():void
		{
			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_FLY_TO_TRAILER,data);
		}
		
		public function flyToMapByTeleport(teleportId:int):void
		{
			var mapTeleprotCfgDt:MapTeleportCfgData = ConfigDataManager.instance.mapTeleporterCfgData(teleportId);
			if(!mapTeleprotCfgDt)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.HEJI_PANEL_0004);
				trace("GameFlyManager.flyToMapByNPC(npcId) mapTeleprotCfgDt == null");
				return;
			}
			TeleportDatamanager.instance.requestTeleportPostioin(mapTeleprotCfgDt.map_from,mapTeleprotCfgDt.x_from,mapTeleprotCfgDt.y_from);
		}
	}
}