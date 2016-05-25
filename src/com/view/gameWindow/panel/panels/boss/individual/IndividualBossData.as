package com.view.gameWindow.panel.panels.boss.individual
{
	import com.model.configData.cfgdata.BossCfgData;

	public class IndividualBossData
	{
		public var items:Array = [];
		 
		public function IndividualBossData()
		{
			
		}
		
		public function injertBasic(index:int,data:BossCfgData):void
		{
			var temp:IndividualItemData = new IndividualItemData;
			temp.injertBasic(data);
			items[index] = temp;
		}
		 
		public function sortData():void
		{
			items.sortOn("monster_group_id",Array.NUMERIC);
		}
		public function clear():void
		{
			items.length = 0;
		}
	}
}