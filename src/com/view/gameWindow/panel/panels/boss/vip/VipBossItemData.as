package com.view.gameWindow.panel.panels.boss.vip
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.BossCfgData;
	import com.model.configData.cfgdata.MonsterCfgData;

	public class VipBossItemData
	{
		
		public var bossName:String;
		public var bossVip:String;
		public var hp:int;
		public var map_monster_id:int;
		public var monster_id:int;
		public var mapId:int; 
		public var monsterCfgData:MonsterCfgData;
		public var maps_noFlys:Array = [];
		public var mapName:String;
		public var percent:int;
		public var level:int;
		public var revive:int;
		public var reward_items:String;
		public var group_id:int;
		public var url:String;
		public var tip_url:String;
		public function VipBossItemData()
		{
			
		}
		public function injert(mapId:int,data:Object):void
		{
			//entityId:entityId,monster_id:monster_id,map_monster_id:map_monster_id,hp:hp,revive_time:revive_time
			this.hp = data.hp;
			this.map_monster_id = data.map_monster_id;
			this.monster_id = data.monster_id;
			this.mapId = mapId;
			var bossCfgData:BossCfgData =  ConfigDataManager.instance.bossCfgDataByGroupId(data.map_monster_id);
			monsterCfgData = ConfigDataManager.instance.monsterCfgData(data.monster_id);
//			maps_noFlys = bossCfgData.maps_nofly.split(":");
			mapName = ConfigDataManager.instance.mapCfgData(mapId).name;
			percent =Number(((data.hp/monsterCfgData.maxhp)*100).toFixed());
			level = monsterCfgData.level;
			revive = monsterCfgData.revive;
			bossVip = bossCfgData.reward_desc;
			bossName = bossCfgData.name;
			reward_items = bossCfgData.reward_items;
			group_id = monsterCfgData.group_id;
//			url = bossCfgData.url;
//			tip_url = bossCfgData.tip_url;
		}
	}
}