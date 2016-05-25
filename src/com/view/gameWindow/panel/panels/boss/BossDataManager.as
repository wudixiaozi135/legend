package com.view.gameWindow.panel.panels.boss
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
	import com.model.business.gameService.serverMessageManager.subManages.SuccessMessageManager;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.BossCfgData;
	import com.model.configData.cfgdata.MapBossCfgData;
	import com.model.consts.StringConst;
	import com.model.dataManager.DataManagerBase;
	import com.model.dataManager.TeleportDatamanager;
	import com.view.gameWindow.mainUi.subuis.income.IncomeDataManager;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.IPanelBase;
	import com.view.gameWindow.panel.panels.boss.classic.ClassicData;
	import com.view.gameWindow.panel.panels.boss.classic.ClassicItemData;
	import com.view.gameWindow.panel.panels.boss.individual.IndividualBossData;
	import com.view.gameWindow.panel.panels.boss.individual.IndividualItemData;
	import com.view.gameWindow.panel.panels.boss.mapcream.MapCreamData;
	import com.view.gameWindow.panel.panels.boss.mapcream.MapCreamItemNode;
	import com.view.gameWindow.panel.panels.boss.vip.VipBossData;
	import com.view.gameWindow.panel.panels.boss.vip.VipBossItemData;
	import com.view.gameWindow.panel.panels.boss.world.WorldBossItemData;
	import com.view.gameWindow.panel.panels.daily.DailyDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.vip.VipDataManager;
	import com.view.gameWindow.scene.GameFlyManager;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.util.ServerTime;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	
	import mx.utils.StringUtil;

	public class BossDataManager  extends DataManagerBase
	{
		private static var _instance:BossDataManager;
		public static function get instance():BossDataManager
		{
			return _instance ||= new BossDataManager(new PrivateClass());
		}
		
		public static const INDIVIDUAL_BOSS_INDEX:int = 2;
		public static const INDIVIDUAL_BOSS_NEW:int = 77777;
		
		public var mapCreamData:MapCreamData;
		public var classicData:ClassicData;
//		public var worldData:WorldBossData;
		public var vipBossData:VipBossData;
		public var individualBossData:IndividualBossData;
		
		public var selectTab:int;
		
		private var jingyingBoss:Dictionary;
		private var classicBoss:Dictionary;
		private var worldcBoss:Dictionary;
		private var vipBoss:Dictionary;
		private var outSideBoss:Dictionary;
		private var individualBoss:Dictionary;
		
		public var isLockClassic:Boolean = true;
		public var isLockWorld:Boolean = true;
		
		public var worldcBossArr:Array = [];
		
		public var dungeonId:int;
		public var isLockClassicVip:int;
		
		private var _bossDatas:Vector.<BossData>;

		private var outsideBossCfgData:Vector.<BossCfgData>;
		
		private var _emSquareBossData:Vector.<BossData>;
		
		public function BossDataManager(pc:PrivateClass)
		{
			super();
			if(!pc)
			{
				throw new Error("该类使用单例模式");
			}
			_bossDatas=new Vector.<BossData>();
			_emSquareBossData = new Vector.<BossData>();
			jingyingBoss = ConfigDataManager.instance.bossCfgDatasByType(BossConst.TYPE_MAPCREAMBOSS);
			classicBoss =  ConfigDataManager.instance.bossCfgDatasByType(BossConst.TYPE_CLISSICBOSS);
			worldcBoss = ConfigDataManager.instance.bossCfgDatasByType(BossConst.TYPE_WORLDBOSS);
			vipBoss = ConfigDataManager.instance.bossCfgDatasByType(BossConst.TYPE_VIPBOSS);
			individualBoss = ConfigDataManager.instance.bossCfgDatasByType(BossConst.TYPE_INDIVIDUALBOSS);
				
			mapCreamData = new MapCreamData;
			classicData = new ClassicData;
//			worldData = new WorldBossData;
			vipBossData = new VipBossData;
			individualBossData = new IndividualBossData;
			//dealWorldBossData(); 
			dealIndividualBossData();
			DistributionManager.getInstance().register(GameServiceConstants.SM_BOSS_HP_INFO,this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_CLEAR_DUNGEON_ONLINE_CHECK,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_MAP_BOSS_HP_INFO,this);
			
		}
		 
		/*private function dealWorldBossData():void
		{
			var temp:BossCfgData;
			var index:int = 0;
			for each(temp in worldcBoss)
			{
				worldData.injertBasic(index,temp);
				worldcBossArr[index] = temp.map_monster_id;
				index++;
			}
			worldcBossArr.sort(Array.NUMERIC); 
			worldData.sortData();
		}*/
		
		private function dealIndividualBossData():void
		{
			var temp:BossCfgData;
			var index:int = 0;
			for each(temp in individualBoss)
			{
				individualBossData.injertBasic(index,temp);
				index++;
			}
			individualBossData.sortData();
		}
		
		public function GetBossHPInfo():void
		{
			var byte:ByteArray = new ByteArray(); 
			byte.endian = Endian.LITTLE_ENDIAN;
			byte.writeByte(0);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_QUERY_BOSS_HP_INFO,byte);
		}
		override public function resolveData(proc:int, data:ByteArray):void 
		{
			switch(proc)
			{
				case GameServiceConstants.SM_BOSS_HP_INFO:
					dealBossInfo(data);
					break;
				 case GameServiceConstants.CM_CLEAR_DUNGEON_ONLINE_CHECK:
					 dealClearDungeon(data);
					 break; 
				 case GameServiceConstants.SM_MAP_BOSS_HP_INFO:
					 dealMapBossInfo(data);
					 break;
			}
			super.resolveData(proc, data);
		}
		
		private function dealMapBossInfo(data:ByteArray):void
		{
			// TODO Auto Generated method stub
			_emSquareBossData.length = 0;
			_storeByMapId = new Dictionary();
			var i:int = data.readShort();//2字节有符号整形
			while(i--)
			{
				var bossData:BossData = new BossData();
				bossData.map_monster_id =  data.readInt();
				if(bossData.map_monster_id==0)continue;
				bossData.hp =  data.readInt();
				bossData.revive_time =  data.readInt();
				_emSquareBossData.push(bossData);
			}
		}		
		
		private function dealClearDungeon(data:ByteArray):void
		{
			var gold:int = data.readInt();
			var str:String = StringUtil.substitute(StringConst.BOSS_PANEL_0033,String(gold));
			IncomeDataManager.instance.addOneLine(str);
		}
		
		private function dealBossInfo(data:ByteArray):void
		{
			_bossDatas.length=0
			mapCreamData.clear();
			classicData.clear(); 
			vipBossData.clear();
			var i:int = data.readShort();//2字节有符号整形
			while(i--)
			{
			     var bossData:BossData = new BossData();
				 bossData.map_monster_id =  data.readInt();
				 if(bossData.map_monster_id==0)continue;
				 bossData.hp =  data.readInt();
				 bossData.revive_time =  data.readInt();
				 _bossDatas.push(bossData);
//				if(jingyingBoss[ bossData.map_monster_id])
//				{
//					mapCreamData.injert(mapId,{entityId:entityId,monster_id: bossData.map_monster_id,map_monster_id:map_monster_id,hp:hp,revive_time:revive_time});
//				}
//				else if(classicBoss[map_monster_id])
//				{	 
//					classicData.injert(mapId,{entityId:entityId,monster_id:monster_id,map_monster_id:map_monster_id,hp:hp,revive_time:revive_time,killerSid:killerSid,killerName:killerName});
//				}
//				else if(vipBoss[map_monster_id])
//				{
//					vipBossData.injert(mapId,{entityId:entityId,monster_id:monster_id,map_monster_id:map_monster_id,hp:hp,revive_time:revive_time});	
//				}
				 
				/*else if(worldcBoss[map_monster_id])
				{
					worldData.injert(mapId,{entityId:entityId,monster_id:monster_id,map_monster_id:map_monster_id,hp:hp,revive_time:revive_time});
				}*/
			} 
//			getBossInfoByMapId(MapConst.EMOGUANGCHANG);
			classicData.sortData();
		}
		
		
		public function deliverBoss(data:Object,type:int):void
		{
			switch(type)
			{
				case 1:
					dealMapCream(data);
					break;
			 	case 2:
					dealClassic(data);
					break;
				case 3:
					dealWorld(data);
					break;
				case 4:
					dealVip(data);
					break;
				case 5:
					dealIndividual(data);
					break;
				case 6:
					dealOutside(data);
					break;
			}
			
		}
		
		private function dealOutside(data:Object):void
		{
			if (RoleDataManager.instance.stallStatue)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.STALL_PANEL_0019);
				return;
			}

			if(RoleDataManager.instance.isCanFly == 0)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.PROMPT_PANEL_0008);	
				return;
			} 
			if(data.npc!=0)
			{
				GameFlyManager.getInstance().flyToMapByNPC(data.npc);
			}else
			{
				TeleportDatamanager.instance.requestTeleportRegion(data.region);
			}
			PanelMediator.instance.closePanel(PanelConst.TYPE_BOSS);
		}
		
		private function dealMapCream(data:Object):void
		{
 
			if(RoleDataManager.instance.isCanFly == 0)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.PROMPT_PANEL_0008);	
				return;
			} 
			
			var _data:MapCreamItemNode = data as MapCreamItemNode;			
//			var region:int = ConfigDataManager.instance.bossCfgDataByMapMon(_data.map_monster_id).region;
			
			TeleportDatamanager.instance.setTargetEntity(_data.monster_id,EntityTypes.ET_MONSTER,_data.map_monster_id);
//			TeleportDatamanager.instance.requestTeleportRegion(region);
		}
		
		private function dealClassic(data:Object):void
		{
			if (RoleDataManager.instance.stallStatue)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.STALL_PANEL_0019);
				return;
			}
			if(RoleDataManager.instance.isCanFly == 0)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.PROMPT_PANEL_0008);	
				return;
			} 
			else if(isLockClassic)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringUtil.substitute(StringConst.BOSS_PANEL_0040,isLockClassicVip));	
				return;
			}
				
			
			var _data:ClassicItemData = data as ClassicItemData;
			var _type:int = 1;
			var _teleportType:int = 2;
//			var _region:int = ConfigDataManager.instance.bossCfgDataByMapMon(_data.map_monster_id).region;
			
			TeleportDatamanager.instance.setTargetEntity(_data.monsterCfgData.group_id,EntityTypes.ET_MONSTER);
//			TeleportDatamanager.instance.requestTeleportBoss(_type,_teleportType,_region);
			PanelMediator.instance.closePanel(PanelConst.TYPE_BOSS);
		}
		
		public function dealWorld(data:Object):void
		{
			if (RoleDataManager.instance.stallStatue)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.STALL_PANEL_0019);
				return;
			}
			if(RoleDataManager.instance.isCanFly == 0)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.PROMPT_PANEL_0008);	
				return;
			} 
			else if(isLockWorld)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.PROMPT_PANEL_0011);	
				return;
			}
			
			
			var _data:WorldBossItemData = data as WorldBossItemData;
			var _type:int = 2;
			var _teleportType:int = 2;
//			var _region:int = ConfigDataManager.instance.bossCfgDataByMapMon(_data.map_monster_id).region;
//			
//			TeleportDatamanager.instance.requestTeleportBoss(_type,_teleportType,_region);
		}
		
		public function dealVip(data:Object):void
		{
			if (RoleDataManager.instance.stallStatue)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.STALL_PANEL_0019);
				return;
			}
			var lv:int = VipDataManager.instance.lv;
			var _data:VipBossItemData = data as VipBossItemData;
			/*if(0 >= lv)
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.PROMPT_PANEL_0011);
			*/
			if(RoleDataManager.instance.isCanFly == 0)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.PROMPT_PANEL_0008);	
				return;
			} 
			var _type:int = 2;
			var _teleportType:int = 2; 
//			var _region:int = ConfigDataManager.instance.bossCfgDataByMapMon(_data.map_monster_id).region;	
//			TeleportDatamanager.instance.requestTeleportBoss(_type,_teleportType,_region);
			PanelMediator.instance.closePanel(PanelConst.TYPE_BOSS);
		}
		
		private function dealIndividual(data:Object):void
		{
			
		}
		
		public function clearDungeonTime(id:int,time:int):void
		{
			var byte:ByteArray = new ByteArray;
			byte.endian = Endian.LITTLE_ENDIAN;
			byte.writeInt(id);
			time = int((time+59)/60);
			byte.writeShort(time);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_CLEAR_DUNGEON_ONLINE_CHECK,byte);
			
		}
		
		public function enterBossDungeon(mapGroupId:int):void
		{
			var byte:ByteArray = new ByteArray;
			byte.endian = Endian.LITTLE_ENDIAN;
			byte.writeInt(mapGroupId);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_ENTER_BOSS_DUNGEON,byte);
		}
		public function dealSwitchPanleBoss():void
		{
			var openedPanel:IPanelBase = PanelMediator.instance.openedPanel(PanelConst.TYPE_BOSS);
			if(!openedPanel)
			{
				BossDataManager.instance.GetBossHPInfo();
				PanelMediator.instance.openPanel(PanelConst.TYPE_BOSS);
			}
			else
			{
				PanelMediator.instance.closePanel(PanelConst.TYPE_BOSS);
			}
		}
		
		private var _storeByMapId:Dictionary = new Dictionary();
		public function getBossInfoByMapId(mapId:int):Vector.<BossData>
		{
			var re:Vector.<BossData> = _storeByMapId[mapId];
			
			if(!re)
			{
				re = new Vector.<BossData>();
				for each(var data:BossData in _emSquareBossData)
				{
					if(data.mapId == mapId)
					{
						re.push(data);
					}
				}
				
				_storeByMapId[mapId] = re;
			}
			
			return re;
		}
		
		public function checkNoneBoss():void
		{
			if(getIndividualBossCount() == 0)
				notify(INDIVIDUAL_BOSS_NEW);
		}
		
		public function getIndividualBossCount():int
		{
			var individualBossData:IndividualBossData = BossDataManager.instance.individualBossData;
			var items:Array = individualBossData.items;
			var individualItemData:IndividualItemData; 
			var _leftTime:int;
			var count:int;
			for(var i:int = 0;i < items.length;i++)
			{
				individualItemData = items[i] as IndividualItemData;
				if(individualItemData.online_cleared == 0)
				{
					_leftTime = individualItemData.online-(ServerTime.time - DailyDataManager.instance.daily_online_start);
				}
				else
				{
					_leftTime = 0;
					
				}
				if(individualItemData.daily_complete_count<=0&&_leftTime<=0)
				{
					if(individualItemData.level<=RoleDataManager.instance.lv)
						count++
				}
			}
			return count;
			
		}
		
		public function getIndividualBossValidIndex(idList:Array):int
		{
			if(!idList || idList.length == 0)
			{
				return -1;
			}
			
			var individualBossData:IndividualBossData = BossDataManager.instance.individualBossData;
			var items:Array = individualBossData.items;
			var index:int = 0;
			
			for each(var item:IndividualItemData in items)
			{
				if(idList.indexOf(item.group_id) != -1 && checkIndividualBossValid(item))
				{
					return index;
				}
				
				++index;
			}
			
			return -1;
		}
		
		public function checkIndividualBossValid(data:IndividualItemData):Boolean
		{
			if(!RoleDataManager.instance.checkReincarnLevel(data.reincarn,data.level))
			{
				return false;
			}
			
			var leftTime:int;
			if(data.online_cleared == 0)
			{
				leftTime = data.online-(ServerTime.time - DailyDataManager.instance.daily_online_start);
			}
			else
			{
				leftTime = 0;
				
			}
			
			if( leftTime <= 0 && data.daily_complete_count<=0)
			{
				return true;
			}
			else  
			{
				return false;
			}
		}
		
		public function getBossData(map_monster_id:int):BossData
		{
			for (var i:int=0;i<_bossDatas.length;i++)
			{
				if(_bossDatas[i].map_monster_id==map_monster_id)
				{
					return _bossDatas[i];
				}
			}
			return null;
		}

		public function get bossDatas():Vector.<BossData>
		{
			return _bossDatas;
		}

		public function getOutsideBossCfg():Vector.<BossCfgData>
		{
			if(outsideBossCfgData==null)
			{
				outsideBossCfgData = new Vector.<BossCfgData>();
				var dic:Dictionary = ConfigDataManager.instance.bossCfgData();
				for each(var tmp:BossCfgData in dic)
				{
					if(tmp.type==BossConst.TYPE_OUTSIDE_BOSS)
					{
						outsideBossCfgData.push(tmp);
					}
				}
			}
			return outsideBossCfgData;
		}
		
		public function getRefreshOutsideBossCfg():Vector.<BossCfgData>
		{
			var bossVec:Vector.<BossCfgData> = new Vector.<BossCfgData>();
			var bossAllVec:Vector.<BossCfgData> = getOutsideBossCfg();
			for each(var tmp:BossCfgData in bossAllVec)
			{
				if( checkBossIsRefresh(tmp.monster_group_id))
				{
					bossVec.push(tmp);
				}
			}
			return bossVec;
		}
		
		public function checkBossIsRefresh(monster_group_id:int):Boolean
		{
			var mapBossCfgData:* = ConfigDataManager.instance.mapBossCfgData(monster_group_id);  //由于有可能是一对多，也有可能是一对一，所以返回类型不确定
			var bossData:BossData;
			if(mapBossCfgData is MapBossCfgData)
			{
				bossData=getBossData(mapBossCfgData.map_monster_id);
				if(bossData&&bossData.revive_time<=0)return true;
			}else
			{
				for each(var cfg:MapBossCfgData in mapBossCfgData)
				{
					bossData = getBossData(cfg.map_monster_id);
					if(bossData&&bossData.revive_time<=0)return true;
				}
			}
			return false;
		}
	}
}
class PrivateClass{}