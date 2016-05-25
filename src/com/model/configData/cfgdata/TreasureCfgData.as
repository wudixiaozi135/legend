package com.model.configData.cfgdata
{
	/**
	 * Created by Administrator on 2014/11/29.
	 */
	public class TreasureCfgData
	{
		public var id:int;
		public var name:String;
		public var min_world_level:int;
		public var max_world_level:int;
		public var reward_id:int;
		public var gift_desc:String;//依次：物品ID，物品类型，数量，职业，性别
		public var one_gold_cost:int;
		public var one_item_cost:String;
		public var five_gold_cost:int;
		public var five_item_cost:String;
		public var ten_gold_cost:int;
		public var ten_item_cost:String;
		public var isbroadcast:int;//是否广播
		public var broadcastid:int;//广播id

		public function TreasureCfgData()
		{
		}
	}
}
