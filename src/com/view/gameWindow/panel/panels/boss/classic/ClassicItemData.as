package com.view.gameWindow.panel.panels.boss.classic
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.BossCfgData;
	import com.model.configData.cfgdata.MonsterCfgData;
	import com.view.gameWindow.util.ServerTime;

	public class ClassicItemData
	{
		public var hp:int;
		public var revive_time:int;
		public var map_monster_id:int;
		public var monster_id:int;
		public var mapName:String;
		public var mapId:int;
		public var url:String;
		 
		 
		public var monsterCfgData:MonsterCfgData;
		public var reward_desc:String;
		public var tip_url:String;
		public var maps_noFlys:Array = [];
		public var killerName:String;
		public var killerSid:int;
		public var totalTime:int;
		public function ClassicItemData()
		{
			
		}
		public function injert(mapId:int,data:Object):void
		{
			//{map_monster_id:map_monster_id,hp:hp,revive_time:revive_time}	
			this.hp = data.hp;
			this.map_monster_id = data.map_monster_id;
			this.monster_id = data.monster_id;
			this.totalTime = data.revive_time;
			this.revive_time = data.revive_time - ServerTime.time;
			this.killerSid = data.killerSid;
			this.killerName = data.killerName;
			this.mapId = mapId;
			var bossCfgData:BossCfgData =  ConfigDataManager.instance.bossCfgDataByGroupId(data.map_monster_id);
			monsterCfgData = ConfigDataManager.instance.monsterCfgData(data.monster_id);
//			tip_url = bossCfgData.tip_url;
//			maps_noFlys = bossCfgData.maps_nofly.split(":");
//			url = bossCfgData.url;
			reward_desc = bossCfgData.reward_desc;
			mapName = ConfigDataManager.instance.mapCfgData(mapId).name;
			
		}
		
		public function dealReviveTime():void
		{
			this.revive_time = totalTime - ServerTime.time;
		}
	}
}