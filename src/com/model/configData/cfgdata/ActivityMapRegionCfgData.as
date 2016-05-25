package com.model.configData.cfgdata
{
	import com.model.configData.ConfigDataManager;

	public class ActivityMapRegionCfgData
	{
		public var activity_id:int;//11	活动id
		public var index:int;//11	序号
		public var type:int;//11	类型
		public var map_id:int;//11	地图id
		public var region_id:int;//11	区域id
		
		public function get mapCfgData():MapCfgData
		{
			var mapCfgData:MapCfgData = ConfigDataManager.instance.mapCfgData(map_id);
			return mapCfgData;
		}
		/**活动实际区域，区域id不存在时表示全地图都是活动区域*/
		public function get regionCfgDtTrue():MapRegionCfgData
		{
			if(!region_id)
			{
				return null;
			}
			var mapRegionCfgData:MapRegionCfgData = ConfigDataManager.instance.mapRegionCfgData(region_id);
			return mapRegionCfgData;
		}
		
		public function isIn(tileX:int, tileY:int):Boolean
		{
			if(!region_id)
			{
				return true;
			}
			return regionCfgDtTrue.isIn(tileX, tileY);
		}
		
		public function ActivityMapRegionCfgData()
		{
		}
	}
}