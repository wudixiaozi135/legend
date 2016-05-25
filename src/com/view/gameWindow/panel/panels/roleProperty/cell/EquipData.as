package com.view.gameWindow.panel.panels.roleProperty.cell
{
	import com.model.gameWindow.mem.MemEquipData;
	import com.model.gameWindow.mem.MemEquipDataManager;
	import com.view.gameWindow.util.cell.CellData;

	public class EquipData extends CellData
	{
		public function EquipData()
		{
		}
		
		override public function get memEquipData():MemEquipData
		{
			var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(bornSid,id);
			return memEquipData;
		}
	}
}