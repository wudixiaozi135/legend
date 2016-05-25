package com.model.configData.cfgdata
{
	import com.model.configData.ConfigDataManager;

	public class NpcShopCfgData
	{
		public var id:int;//序列
		public var name:String;
		public var npc_id:int;//npcid
		public var base:int;//道具装备id
		public var type:int;//类型1:道具2:装备
		public var bind:int;//绑定类型0:非绑定1:绑定
		public var rank:int;//商店里面的位置
		public var price_type:int;//消耗类型
		public var price_value:int;//消耗价格
		
		public function get itemCfgData():ItemCfgData
		{
			var itemCfgData:ItemCfgData = ConfigDataManager.instance.itemCfgData(base);
			return itemCfgData;
		}
		
		public function NpcShopCfgData()
		{
		}
	}
}