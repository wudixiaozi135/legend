package com.view.gameWindow.panel.panels.boss.individual
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.BossCfgData;
	import com.model.configData.cfgdata.DungeonCfgData;
	import com.model.configData.cfgdata.MapMonsterCfgData;
	import com.model.configData.cfgdata.MonsterCfgData;
	
	import flash.utils.Dictionary;

	public class IndividualItemData
	{
  		
		public var hp:int;
		public var map_monster_id:int;		 
		 
		public var monsterCfgData:MonsterCfgData;
	 	public var bossCfgData:BossCfgData;
 
		 
		public var level:int;
		
		public var reward_items:String;
		public var group_id:int;
		public var url:String;
		public var tip_url:String;
		public var daily_complete_count:int;
		
		public var online:int;
		public var online_cleared:int;
		public var leftTime:int;
		public var reincarn:int;
		public var monster_group_id:int;
		
		public function IndividualItemData()
		{
		}
		
		public function injertBasic(data:BossCfgData):void
		{
			bossCfgData = data;
			monster_group_id = data.monster_group_id
//			map_monster_id = bossCfgData.map_monster_id;
		 
			reward_items = bossCfgData.reward_items;
			 
			url = bossCfgData.url;
//			tip_url = bossCfgData.tip_url;
			var dungeonCfgData:DungeonCfgData =  ConfigDataManager.instance.dungeonCfgDataId(bossCfgData.dungeon_id);
			online = dungeonCfgData.online*60;
			reincarn = dungeonCfgData.reincarn;
			level = dungeonCfgData.level;
//			var mapMstCfgData:MapMonsterCfgData = ConfigDataManager.instance.mapMstCfgData(bossCfgData.map_monster_id);
//			ConfigDataManager.instance.mapms
//			var monsterCfgData:MonsterCfgData=ConfigDataManager.instance.monsterCfgData(data.monster_group_id+1);
//			mapId = mapMstCfgData.map_id;
			group_id = data.monster_group_id;
			
			var monsterGroup:Dictionary = ConfigDataManager.instance.monsterCfgDatas(group_id);  
			
			for each(var monsterCfg:MonsterCfgData in monsterGroup)
			{
				monsterCfgData = monsterCfg;
			} 
		}
  
	}
}