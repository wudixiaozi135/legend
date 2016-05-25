package com.model.configData.cfgdata
{
	public class ActivitySeaFeastCfgData
	{
		public var id:int;//11	序列
		public var exp_base_ratio:int;//11	基础经验比率
		public var lay_exp_ratio:int;//11	日光浴经验比率
		public var exp_cd:int;//11	获得经验的时间间隔(秒)
		public var lay_cd:int;//11	日光浴cd(秒)
		public var lay_bubble:String;//1024	日光浴泡泡
		public var free_tease_count:int;//11	免费挑逗次数
		public var toll_tease_count:int;//11	收费挑逗次数
		public var tease_item:int;//11	挑逗消耗道具id
		public var tease_item_shop:int;//11	挑逗道具商店id
		public var tease_cd:int;//11	挑逗的cd(秒)
		public var tease_exp_ratio:int;//11	挑逗的经验比率
		public var teaser_bubble:String;//1024	挑逗方泡泡
		public var teasee_bubble:String;//1024	被挑逗方泡泡
		public var free_push_oil_count:int;//11	免费推油次数
		public var toll_push_oil_count:int;//11	收费推油次数
		public var push_oil_item:int;//11	推油消耗道具id
		public var push_oil_item_shop:int;//11	推油道具商店id
		public var push_oil_cd:int;//11	推油的cd(秒)
		public var push_oil_time:int;//11	推油的时间(秒)
		public var push_oil_exp_ratio:int;//11	推油经验比率
		public var oil_pusher_bubble:String;//1024	推油方泡泡
		public var oil_pushee_bubble:String;//1024	被推油方泡泡
		public var free_watermelon_count:int;//11	免费砸西瓜次数
		public var toll_watermelon_count:int;//11	收费砸西瓜次数
		public var watermelon_item:int;//11	砸西瓜消耗道具id
		public var watermelon_item_shop:int;//11	砸西瓜道具商店id
		public var watermelon_bubble:String;//1024	砸西瓜泡泡
		public var pick_bubble:String;//1024	拾内衣泡泡

        public function ActivitySeaFeastCfgData()
		{
		}
	}
}