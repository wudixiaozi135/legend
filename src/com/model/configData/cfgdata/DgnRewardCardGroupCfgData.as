package com.model.configData.cfgdata
{
	import com.model.configData.ConfigDataManager;
	import com.model.consts.SlotType;

	public class DgnRewardCardGroupCfgData
	{
		public var group_id:int;//11	奖励组id
		public var id:int;//11	序号[NL]
		public var item_id:int;//11	产出id
		public var type:int;//11	产出类型
		public var count:int;//11	产出数量
		public var bind:int;//11	产出绑定
		public var probability:int;//11	概率
		
		public function get itemCfgData():ItemCfgData
		{
			if(type != SlotType.IT_ITEM)
			{
				return null;
			}
			var cfgDt:ItemCfgData = ConfigDataManager.instance.itemCfgData(item_id);
			return cfgDt;
		}
		
		public function get equipCfgData():EquipCfgData
		{
			if(type != SlotType.IT_EQUIP)
			{
				return null;
			}
			var cfgDt:EquipCfgData = ConfigDataManager.instance.equipCfgData(item_id);
			return cfgDt;
		}
		
		public function DgnRewardCardGroupCfgData()
		{
		}
	}
}