package com.view.gameWindow.panel.panels.bag
{
	import com.model.consts.ConstStorage;
	import com.model.consts.SlotType;
	import com.model.gameWindow.mem.MemEquipData;
	import com.model.gameWindow.mem.MemEquipDataManager;
	import com.view.gameWindow.panel.panels.school.complex.SchoolElseDataManager;
	import com.view.gameWindow.util.cell.CellData;

	/**
	 * id在type为SlotType.IT_EQUIP时为装备的唯一id，否则为配置id
	 * @author Administrator
	 */	
	public class BagData extends CellData
	{
		/*public var id:int;
		public var bornSid:int;
		public var slot:int;
		public var storageType:int;*/
		/**使用SlotType中的值*/
		public var type:int;
		public var count:int;
		/**0：不绑定，1：绑定*/
		public var bind:int;
		/**0：显示，1：隐藏  2:变灰*/
		public var isHide:int;
		public function BagData()
		{
		}
		
		override public function get memEquipData():MemEquipData
		{
			if(type != SlotType.IT_EQUIP)
			{
				return null;
			}
			else if(storageType == ConstStorage.ST_SCHOOL_BAG) 
			{
				return SchoolElseDataManager.getInstance().getMemEquipData(bornSid, id);
			}
			var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(bornSid,id);
			return memEquipData;
		}
		
		public function clone():BagData
		{
			var bagData:BagData = new BagData();
			bagData.bind = bind;
			bagData.bornSid = bornSid;
			bagData.count = count;
			bagData.id = id;
			bagData.slot = slot;
			bagData.storageType = storageType;
			bagData.type = type;
			return bagData;
		}
		
		public function copyForm(dt:BagData):void
		{
			bind = dt.bind;
			bornSid = dt.bornSid;
			count = dt.count;
			id = dt.id;
			slot = dt.slot;
			storageType = dt.storageType;
			type = dt.type;
		}
		
		public function get job():int
		{
			var val:int;
			if(memEquipData)
				val = memEquipData.equipCfgData.job;
			return val;
		}
		
		public function get sex():int
		{
			var val:int;
			if(memEquipData)
				val = memEquipData.equipCfgData.sex;
			return val;
		}
		public function get level():int
		{
			var val:int;
			if(memEquipData)
				val = memEquipData.equipCfgData.level;
			return val;
		}
		public function get totalFightPower():int
		{
			var val:int;
			if(memEquipData)
				val = memEquipData.getTotalFightPower();
			return val;
		}
	}
}