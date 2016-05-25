package com.model.configData.cfgdata
{
	public class EquipPolishCfgData
	{
		public var level:int;//11	打磨等级
		public var equipstrong_limit:int;//11	强化等级限制 
		public var coin:int;//11	消耗金币（优先消耗绑定金币）
		public var stone:int;//11	打磨石id
		public var stone_count:int;//11	打磨石数量
		public var stone_price:int;//11	打磨石价格 
		public var exp:int;//11	单次打磨进度
		public var exp_rate:int;//11	单次打磨小暴击概率
		public var max_exp:int;//11	打磨进度上限
		public var move_coin:int;//11	转移消耗金币
		public var isbroadcast:int;//是否广播
		public var broadcastid:int;//广播id
		
		public function EquipPolishCfgData()
		{
		}
	}
}