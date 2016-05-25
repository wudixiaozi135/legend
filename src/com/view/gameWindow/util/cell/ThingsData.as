package com.view.gameWindow.util.cell
{
	import com.model.configData.cfgdata.EquipCfgData;
	import com.model.configData.cfgdata.ItemCfgData;
	import com.model.consts.ItemType;
	import com.model.consts.SlotType;
	import com.view.gameWindow.panel.panels.bag.BagData;
	import com.view.gameWindow.util.UtilGetCfgData;
	
	public class ThingsData extends BagData
	{
		public function ThingsData()
		{
			super();
		}
		
		public function get equipCfgData():EquipCfgData
		{
			var utilGetCfgData:UtilGetCfgData = new UtilGetCfgData();
			if(type == SlotType.IT_EQUIP)
			{
				return utilGetCfgData.GetEquipCfgData(id,bornSid);
			}
			return null;
		}
		
		public function get itemCfgData():ItemCfgData
		{
			var utilGetCfgData:UtilGetCfgData = new UtilGetCfgData();
			if(type == SlotType.IT_ITEM)
			{
				return utilGetCfgData.GetItemCfgData(id);
			}
			return null;
		}
		
		public function get cfgData():*
		{
			return type == SlotType.IT_EQUIP ? equipCfgData : itemCfgData;
		}
		
		public function get color():int
		{
			return ItemType.getColorByQuality(cfgData ? cfgData.quality : 0);
		}
	}
}