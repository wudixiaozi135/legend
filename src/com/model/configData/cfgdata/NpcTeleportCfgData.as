package com.model.configData.cfgdata
{
	import com.model.configData.ConfigDataManager;

	public class NpcTeleportCfgData
	{
		public var id:int;
		public var name:String;
		public var type:int;
		public var npc:int;
		public var order:int;
		public var region_to:int;
		public var vip:int;
		public var coin:int;
		public var unbind_coin:int;
		public var bind_gold:int;
		public var unbind_gold:int;
		public var item:int;
		public var item_count:int;
		public var isbroadcast:int;//是否广播
		public var broadcastid:int;//广播id
		
		public function get mapRegionCfgData():MapRegionCfgData
		{
			var mapRegionCfgData:MapRegionCfgData = ConfigDataManager.instance.mapRegionCfgData(region_to);
			return mapRegionCfgData;
		}
		
		public function get itemCfgData():ItemCfgData
		{
			var itemCfgData:ItemCfgData = ConfigDataManager.instance.itemCfgData(item);
			return itemCfgData;
		}
		
		public function NpcTeleportCfgData()
		{
		}
	}
}