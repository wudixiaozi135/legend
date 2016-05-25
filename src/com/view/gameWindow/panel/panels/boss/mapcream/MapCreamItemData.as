package com.view.gameWindow.panel.panels.boss.mapcream
{
	import com.model.configData.ConfigDataManager;

	public class MapCreamItemData
	{
		
		public var items:Vector.<MapCreamItemNode> = new Vector.<MapCreamItemNode>();
		public var mapId:int;
		
		public function MapCreamItemData()
		{
			
		}
		public function injert(mapId:int,data:Object):void
		{
			this.mapId = mapId;
			var index:int = items.length+1;
			data.index = index;
			var temp:MapCreamItemNode = new MapCreamItemNode;
			temp.injert(data);
			items.push(temp);
		}
		
		public function getMapName():String
		{
			return ConfigDataManager.instance.mapCfgData(mapId).name;
		}
		public function clear():void
		{
			items.length = 0;
		}
	}
}