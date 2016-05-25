package com.model.configData.cfgdata
{
	import com.model.consts.StringConst;

	public class DemonTowerCfgData
	{
		public var id:int;//11	序号
		public var name:String;//64	描述
		public var map_id:int;//11	地图id
		public var min_reincarn:int;//11	最小转生次数
		public var min_level:int;//11	最小等级
		public var max_reincarn:int;//11	最大转生次数
		public var max_level:int;//11	最大等级
		
		public function get strLimit():String
		{
			var strMin:String = min_reincarn ? 
				(min_reincarn < 10 ? " " : "") + min_reincarn + StringConst.DEMON_TOWER_0003 : 
				(min_level < 10 ? " " : "") + min_level + StringConst.DEMON_TOWER_0004;
			var strMax:String = max_reincarn ? 
				(max_reincarn < 10 ? " " : "") + max_reincarn + StringConst.DEMON_TOWER_0003 : 
				(max_level < 10 ? " " : "") + max_level + StringConst.DEMON_TOWER_0004;
			return StringConst.DEMON_TOWER_0002 + strMin + "-" + strMax + StringConst.DEMON_TOWER_0005;
		}
		
		public function isInLimit(reincarn:int,lv:int):Boolean
		{
			if(reincarn == min_reincarn || reincarn == max_reincarn)
			{
				if(min_level <= lv && lv <= max_level)
				{
					return true;
				}
				else
				{
					return false;
				}
			}
			else if(min_reincarn < reincarn && reincarn < max_reincarn)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		public function DemonTowerCfgData()
		{
		}
	}
}