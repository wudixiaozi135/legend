package com.view.gameWindow.panel.panels.boss.mapcream
{
	import com.view.gameWindow.util.HashMap;

	public class MapCreamData
	{
		
		//public var items:Vector.<MapCreamItemData> = new Vector.<MapCreamItemData>();
		public var items:HashMap ;
		public var mapIds:Array ;
		public function MapCreamData()
		{
			mapIds = [];
			items = new HashMap();
		}
		public function injert(mapId:int,data:Object):void
		{
			var temp:MapCreamItemData;
			if(mapIds.indexOf(mapId) ==-1)
			{
				mapIds.push(mapId);	
				temp =new MapCreamItemData();
				temp.injert(mapId,data);
				items.add(mapId,temp);
			}
			else
			{
				temp = items.getValue(mapId) as MapCreamItemData;
				temp.injert(mapId,data);
			}
			 
		}
		
		public function sortData():void
		{
			var data:Array = items.getValues(); //MapCreamItemData
			data.sortOn('mapId',Array.NUMERIC);
		}
		
		public function clear():void
		{
			var data:Array = items.getValues();
			for each (var item:MapCreamItemData in data)
			{
				item.clear();
			}
		}
		
	}
}