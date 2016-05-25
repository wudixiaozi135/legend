package com.model.configData.cfgdata
{
	import com.model.configData.ConfigDataManager;
	import com.model.consts.ItemType;

	//合成
	public class CombineCfgData
	{
		public var id:int;//序列
		public var name:String;//名称
		public var type:int;//类型
		public var distinguish:int;//小分类
		public var combined_id:int;
		public var combined_type:int;
		
		public var material1_id:int;
		public var material1_type:int;
		public var material1_count:int;
		
		public var material2_id:int;
		public var material2_type:int;
		public var material2_count:int;
		
		public var material3_id:int;
		public var material3_type:int;
		public var material3_count:int;
		
		public var coin:int;
		public var unbind_gold:int;
		
		public function get color():int
		{
			var itemCfgData:ItemCfgData = ConfigDataManager.instance.itemCfgData(combined_id);
			return ItemType.getColorByQuality(itemCfgData ? itemCfgData.quality : 0);
		}
		/**需求的3种材料是否为同一种*/
		public function get isMaterialAllSame():Boolean
		{
			return material1_id && material2_id && material3_id && material1_id == material2_id && material2_id == material3_id;
		}
		
		public function CombineCfgData()
		{
		}
	}
}