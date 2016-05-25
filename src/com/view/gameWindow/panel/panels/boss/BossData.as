package com.view.gameWindow.panel.panels.boss
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.MapMonsterCfgData;
	import com.view.gameWindow.util.ServerTime;
	

	public class BossData
	{
		public var map_monster_id:int;
		public var hp:int;
		public var revive_time:int;
		private var _mapId:int;
		private var _mapMstCfgData:MapMonsterCfgData;
		
		public function BossData()
		{
		}
 		
		public function dealReviveTime():int
		{
			if(hp>0)return 0;
			return revive_time - ServerTime.time<0?0:revive_time-ServerTime.time;
		}

		public function get mapMstCfgData():MapMonsterCfgData
		{
			_mapMstCfgData = ConfigDataManager.instance.mapMstCfgData(map_monster_id);
			return _mapMstCfgData;
		}
		
		public function get mapId():int
		{
			return mapMstCfgData ? mapMstCfgData.map_id : 0;
		}
	}
}