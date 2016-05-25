package com.view.gameWindow.util.cell
{
	import com.model.gameWindow.mem.MemEquipData;

	public class CellData
	{
		/**单服唯一识别ID<br>在bagData中根据type值不同代表不同的值*/
		public var id:int;
		/**服务器ID<br>在bagData中，若为-1表示id为基础id*/
		public var bornSid:int = -1;
		public var slot:int;
		public var storageType:int;
		
		public function CellData()
		{
		}

		public function get memEquipData():MemEquipData
		{
			return null;
		}
	}
}