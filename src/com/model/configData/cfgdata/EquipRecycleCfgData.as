package com.model.configData.cfgdata
{
	/**
	 * 回收装备信息配置类
	 * @author Administrator
	 */	
	public class EquipRecycleCfgData
	{
		public var type:int;//11	装备类型
		public var quality:int;//11	装备品质
		public var level:int;//11	装备等级
		public var bind_coin:int;//11	绑定金币
		public var bind_gold:int;//11	绑定元宝
		public var exp:int;//11	经验
		public var reward_point:int;//11	点数
		public var prob_item1:int;//11	复合道具1id
		public var prob_count1:int;//11	复合道具1数量
		public var prob_probability1:int;//11	复合道具1概率
		public var prob_item2:int;//11	复合道具2id
		public var prob_count2:int;//11	复合道具2数量
		public var prob_probability2:int;//11	复合道具2概率
		public var prob_item3:int;//11	复合道具3id
		public var prob_count3:int;//11	复合道具3数量
		public var prob_probability3:int;//11	复合道具3概率
		public var is_operation:int//	11	是否可以回收经验和兑换帮贡
		public var family_contribute:int//	11	捐献获得的帮会贡献
		
		public function EquipRecycleCfgData()
		{
		}
	}
}