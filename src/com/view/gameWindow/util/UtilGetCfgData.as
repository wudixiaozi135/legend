package com.view.gameWindow.util
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.EquipCfgData;
	import com.model.configData.cfgdata.ItemCfgData;
	import com.model.gameWindow.mem.MemEquipData;
	import com.model.gameWindow.mem.MemEquipDataManager;

	/**
	 * 获得装备或物品的配置信息
	 * @author Administrator
	 */	
	public class UtilGetCfgData
	{
		public function UtilGetCfgData()
		{
		}
		/**
		 * 获取装备配置信息
		 * @param id
		 * @param bornSid 若bornSid为-1表示id为基础id
		 * @return 
		 */		
		public function GetEquipCfgData(id:int,bornSid:int = -1):EquipCfgData
		{
			var equipCfgData:EquipCfgData;
			if(bornSid != -1)
			{
				var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(bornSid,id);
				if(!memEquipData)
				{
					trace("UtilGetCfgData.GetEquipCfgData MemEquipData信息不存在,bornSid:"+bornSid);
					return null;
				}
				equipCfgData = ConfigDataManager.instance.equipCfgData(memEquipData.baseId);
				if(equipCfgData)
				{
					return equipCfgData;
				}
			}
			else
			{
				equipCfgData = ConfigDataManager.instance.equipCfgData(id);
				if(equipCfgData)
				{
					return equipCfgData;
				}
			}
			trace("UtilGetCfgData.GetEquipCfgData EquipCfgData信息不存在,bornSid:"+bornSid);
			return null;
		}
		/**
		 * 获取物品配置信息
		 * @param id
		 * @return 
		 */		
		public function GetItemCfgData(id:int):ItemCfgData
		{
			var itemCfgData:ItemCfgData = ConfigDataManager.instance.itemCfgData(id);
			if(itemCfgData)
			{
				return itemCfgData;
			}
			trace("UtilGetCfgData.GetItemCfgData ItemCfgData信息不存在");
			return null;
		}
	}
}