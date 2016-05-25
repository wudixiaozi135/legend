package com.view.gameWindow.mainUi.subuis.monsterhp.dropList
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.EquipCfgData;

	public class DropData
	{
		private var _cfg:EquipCfgData;
		public var endtime:int;//second unix
		
		public function get cfg():EquipCfgData
		{
			return _cfg;
		}
		
		public function get id():int
		{
			return _cfg?_cfg.id:0;
		}
		
		public function set id(value:int):void
		{
			if(id == value)
			{
				return;
			}
			if(value == 0)
			{
				_cfg = null;
			}
			else
			{
				_cfg = ConfigDataManager.instance.equipCfgData(value);
			}
		}
		
/*		public function copy(data:BuffData):void
		{
			id = data.id;
		}*/
	}
}