package com.model.configData.cfgdata
{
	import com.model.configData.ConfigDataManager;

	public class MstDigCfgData
	{
		public var monster_id:int;//11	怪物id
		public var time:int;//11	挖掘次数(从0开始)
		public var remain:int;//11	挖掘时间(毫秒)
		public var item_cost:int;//11	道具消耗
		public function get itemCfgDt():ItemCfgData
		{
			return ConfigDataManager.instance.itemCfgData(item_cost);
		}
		public var item_count:int;//11	道具消耗数量
		public var coin:int;//11	消耗金币
		public var bind_gold:int;//11	消耗绑定元宝
		public var item:String;//64	稀有物品
		
		public function MstDigCfgData()
		{
		}
	}
}