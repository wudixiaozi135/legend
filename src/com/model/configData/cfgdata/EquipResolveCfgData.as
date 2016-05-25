package com.model.configData.cfgdata
{
	public class EquipResolveCfgData
	{
		public var id:int;//11	装备id
		public var name:String;
		public var item:int;//11	必出道具
		public var count:int;//11	必出道具数量
		public var prob_item1:int;//11	复合道具1id
		public var prob_count1:int;//11	复合道具1数量
		public var prob_probability1:int;//11	复合道具1概率
		public var prob_item2:int;//11	复合道具2id
		public var prob_count2:int;//11	复合道具2数量
		public var prob_probability2:int;//11	复合道具2概率
		public var prob_item3:int;//11	复合道具3id
		public var prob_count3:int;//11	复合道具3数量
		public var prob_probability3:int;//11	复合道具3概率
		public var unbind_coin:int;//11	非绑定金币
		public var coin:int;//11	绑金优先
		public var unbind_gold:int;//11	非绑元宝
		public var bind_gold:int;//11	绑定元宝
		
		public function EquipResolveCfgData()
		{
		}
	}
}