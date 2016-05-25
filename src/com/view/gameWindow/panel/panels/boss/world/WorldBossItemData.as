package com.view.gameWindow.panel.panels.boss.world
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.ActivityCfgData;
	import com.model.configData.cfgdata.BossCfgData;
	import com.model.configData.cfgdata.MapMonsterCfgData;
	import com.model.configData.cfgdata.MonsterCfgData;
	
	import flash.utils.Dictionary;

	public class WorldBossItemData
	{
		
		public var bossCfgData:BossCfgData;
		public var start_time_str:String;
		public var bossName:String;
		public var mapName:String;
		public var url:String;
		public var reward_items:String;
		
		public var maps_noFlys:Array = [];
		
		public var isFresh:Boolean = false;
		
		public var hp:int;
		public var percent:int;
		public var revive_time:int;
		public var map_monster_id:int;
		public var monsterCfgData:MonsterCfgData;
		public var monsterCfgData2:MonsterCfgData;
		public var group_id:int;

		public var endTime:Number;
		public function WorldBossItemData()
		{
		}
		
		public function injertBasic(data:BossCfgData):void
		{
//			bossCfgData = data;
//			map_monster_id = bossCfgData.map_monster_id;
//			bossName = bossCfgData.name;
//			reward_items = bossCfgData.reward_items;
//			maps_noFlys = bossCfgData.maps_nofly.split(":");
//			url = bossCfgData.url;
//			
//			var activityCfgData:ActivityCfgData = ConfigDataManager.instance.activityCfgData(bossCfgData.activity_id);
//			start_time_str =  activityCfgData.start_time_str;
//			endTime = (activityCfgData.currentActvTimeCfgDt.start_time+activityCfgData.currentActvTimeCfgDt.duration)*60;
//			var mapMstCfgData:MapMonsterCfgData = ConfigDataManager.instance.mapMstCfgData(bossCfgData.map_monster_id)
//			var mapId:int = ConfigDataManager.instance.mapCfgData(mapMstCfgData.map_id).id;
//			mapName = ConfigDataManager.instance.mapCfgData(mapId).name;
//			
//			group_id = mapMstCfgData.monster_group_id;
//			var monsterGroup:Dictionary = ConfigDataManager.instance.monsterCfgDatas(group_id);  
//			
//			for each(var monsterCfg:MonsterCfgData in monsterGroup)
//			{
//				monsterCfgData = monsterCfg;
//			}
		 
		}
		public function injert(mapId:int,data:Object):void
		{
			isFresh = true;
			this.hp = data.hp;
			
			this.revive_time = data.revive_time;
			
			//bossCfgData =  ConfigDataManager.instance.bossCfgDataByMapMon(data.map_monster_id);
			monsterCfgData2 = ConfigDataManager.instance.monsterCfgData(data.monster_id);		
			percent =int(((data.hp/monsterCfgData2.maxhp)*100).toFixed());
		}
		
		 
	}
}