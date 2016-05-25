package com.model.configData.cfgdata
{
	public class EquipDegreeCfgData
	{
		public var id:int;//11	序列
		public var name:String;
		public var next_id:int;//11	升阶后id
		public var coin:int;//11	消耗金币
		public var material_id:int;//11	消耗材料id
		public var material_count:int;//11	消耗材料数量
		public var material_price:int;//11	材料单价
		public var isbroadcast:int;//是否广播
		public var broadcastid:int;//广播id
		
		public function EquipDegreeCfgData()
		{
		}
	}
}