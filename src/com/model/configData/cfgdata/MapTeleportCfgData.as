package com.model.configData.cfgdata
{
	import com.model.configData.ConfigDataManager;

	public class MapTeleportCfgData
	{
		public var id:int;
		public var name:String;
		public var map_from:int;
		public var x_from:int;
		public var y_from:int;
		public var region_to:int;
		public var vip:int;
		public var bind_gold:int;
		public var taskid:int;
		public var dungeonid:int;
		public var url:String;
		public var isbroadcast:int;//是否广播
		public var broadcastid:int;//广播id
		public var is_hide:int//传送阵是否在副本完成前隐藏
		
		public function get mapRegionCfgData():MapRegionCfgData
		{
			var cfgDt:MapRegionCfgData = ConfigDataManager.instance.mapRegionCfgData(region_to);
			return cfgDt;
		}
		
		public function MapTeleportCfgData()
		{
		}
	}
}