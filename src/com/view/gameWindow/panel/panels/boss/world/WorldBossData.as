package com.view.gameWindow.panel.panels.boss.world
{
	import com.model.configData.cfgdata.BossCfgData;
	import com.view.gameWindow.panel.panels.boss.BossDataManager;

	public class WorldBossData
	{
		
		public var items:Array = new Array(10);
		public var bookItems:Array = new Array(10);
		public var firstData:WorldBossItemData;
		public function WorldBossData()
		{
			
		}
		
		public function injertBasic(index:int,data:BossCfgData):void
		{
//			var temp:WorldBossItemData = new WorldBossItemData;
//			temp.injertBasic(data);
//			items[index] = temp;
		}
		public function sortData():void
		{
			items.sortOn("map_monster_id",Array.NUMERIC);
		}
		public function injert(mapId:int,data:Object):void
		{
			//var temp:WorldBossItemData = new WorldBossItemData;
			//temp.injert(mapId,data);
			var temp:WorldBossItemData;
			var index:int = BossDataManager.instance.worldcBossArr.indexOf(data.map_monster_id);
			
			if(index!=-1)
			{
				//items[index] = temp;
				temp = items[index];
				temp.injert(mapId,data);
				//items[index] = temp;
			}
			
			if(!firstData)
			{
				firstData = temp;
			}
			 
			//items.push(temp);
			
			
		}
		
		public function clear():void
		{
			items.length = 0;
		}
	}
}