package com.view.gameWindow.panel.panels.boss.mapcream
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.BossCfgData;
	import com.model.configData.cfgdata.MonsterCfgData;
	import com.view.gameWindow.util.ServerTime;
	import com.view.gameWindow.util.TimerManager;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;

	public class MapCreamItemNode
	{
		
		public var index:int;
		public var name:String;
		//private  var entityId:int;
		//public var hp:int;
		public var revive_time:int;
		public var map_monster_id:int;
		
		public var percent:Number;
		public var decText:String;
		public var url:String;
		
		public var monsterCfgData:MonsterCfgData;
		public var monster_id:int;
		
		public var maps_noFlys:Array = [];
		private var totalTime:int;
		public var lv:int;
		public function MapCreamItemNode()
		{
			
			
		}
		public function injert(data:Object):void 
		{
			//{map_monster_id:map_monster_id,hp:hp,revive_time:revive_time}	
			//this.entityId = data.entityId;
			//this.hp = data.hp;
			this.map_monster_id = data.map_monster_id;
			this.totalTime = data.revive_time;
			this.revive_time = data.revive_time - ServerTime.time;
			this.index = data.index;
			this.monster_id = data.monster_id;
			monsterCfgData = ConfigDataManager.instance.monsterCfgData(data.monster_id);
			var bossCfgData:BossCfgData = ConfigDataManager.instance.bossCfgDataByGroupId(data.map_monster_id);
			decText = bossCfgData.reward_desc;
			decText = CfgDataParse.pareseDesToStr(decText);
//			maps_noFlys =  bossCfgData.maps_nofly.split(':');
			percent =Number(((data.hp/monsterCfgData.maxhp)*100).toFixed());
			name = bossCfgData.name;
			lv = monsterCfgData.level;
//			url = bossCfgData.url;
			//startTimer(true);
		}
		
		public function dealReviveTime():void
		{
			this.revive_time = totalTime - ServerTime.time;
		}
		
		public function startTimer(bool:Boolean):void
		{
			if(revive_time>0 && bool)
			{
				TimerManager.getInstance().add(1000,updateTime);
			}
			else
			{
				TimerManager.getInstance().remove(updateTime);
			}
			
		}
		private  function updateTime():void
		{
			this.revive_time = totalTime - ServerTime.time;
			if(0>revive_time)
			{
				TimerManager.getInstance().remove(updateTime);
			}
		}
		
	}
}