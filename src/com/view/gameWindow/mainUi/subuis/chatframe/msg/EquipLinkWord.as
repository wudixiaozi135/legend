package com.view.gameWindow.mainUi.subuis.chatframe.msg
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.EquipCfgData;
	import com.model.consts.ItemType;
	import com.model.consts.ToolTipConst;
	import com.model.gameWindow.mem.MemEquipData;
	import com.model.gameWindow.mem.MemEquipDataManager;
	
	/**
	 * @author wqhk
	 * 2014-8-14
	 */
	public class EquipLinkWord extends LinkWord
	{
		public function EquipLinkWord()
		{
			super();
		}
		
		override public function getDescription():String
		{
			var ids:Array = LinkWord.splitData(data);
			
			
			var equip:EquipCfgData = getEquip(ids);
			
			if(equip)
			{
				return "["+equip.name+"]";
			}
			else
			{
				return "[找不到装备"+data+"]";
			}
		}
		
		private function getEquip(ids:Array):EquipCfgData
		{
			var mem:MemEquipData = MemEquipDataManager.instance.memEquipData(parseInt(ids[0]),parseInt(ids[1]));
			
			var equip:EquipCfgData;
			if(mem)
			{
				equip = ConfigDataManager.instance.equipCfgData(mem.baseId);
			}
			else
			{
				equip = ConfigDataManager.instance.equipCfgData(parseInt(ids[1]));
			}
			
			return equip;
		}
		
		override public function getTooltipData():Object
		{
			var ids:Array = data.split(":");
			
			var sid:int = parseInt(ids[0]);
			if(sid == 0)
			{
				return ConfigDataManager.instance.equipCfgData(ids[1]);
			}
			var mem:MemEquipData = MemEquipDataManager.instance.memEquipData(ids[0],ids[1]);
			
			return mem;
		}
		
		override public function getTooltipType():int
		{
			return ToolTipConst.EQUIP_BASE_TIP;
		}
		
		override public function get needTooltip():Boolean
		{
			return true;
		}
		
		override public function getColor():uint
		{
			var ids:Array = LinkWord.splitData(data);
			
			var equip:EquipCfgData = getEquip(ids);
			
			return ItemType.getColorByQuality(equip.color);
		}
	}
}