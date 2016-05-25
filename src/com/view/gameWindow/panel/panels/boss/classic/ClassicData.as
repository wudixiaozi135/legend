package com.view.gameWindow.panel.panels.boss.classic
{
	public class ClassicData
	{
		
		public var items:Array = [];
		public function ClassicData()
		{
		}
		public function injert(mapId:int,data:Object):void
		{
			var temp:ClassicItemData = new ClassicItemData;
			temp.injert(mapId,data);
			items.push(temp);
		}
		
		public function sortData():void
		{
			items.sortOn("map_monster_id",Array.NUMERIC);
		}
		
		public function clear():void
		{
			items.length = 0;
		}
	}
}