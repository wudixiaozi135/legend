package com.view.gameWindow.panel.panels.boss.vip
{
	public class VipBossData
	{
		public var items:Array = [];
		public var firstData:VipBossItemData
		public function VipBossData()
		{
			
		}
		
		public function injert(mapId:int,data:Object):void
		{
			var temp:VipBossItemData = new VipBossItemData;
			temp.injert(mapId,data);
			items.push(temp);
			if(!firstData)
			{
				firstData = temp;
			}
		}
		
		public function clear():void
		{
			items.length = 0;
		}
		
	}
}