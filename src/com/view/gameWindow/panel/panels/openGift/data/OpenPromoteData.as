package com.view.gameWindow.panel.panels.openGift.data
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.OpenServerPromoteRewardCfgData;
	
	import flash.utils.Dictionary;

	public class OpenPromoteData
	{
		public static const ROLE_EQUIP_LV:int = 1;
		public static const HERO_EQUIP_LV:int =2;
		public static const ROLE_EQUIP_SLV:int=3;
		public static const HERO_EQUIP_SLV:int=4;
		public static const ROLE_DUNPAI:int=5;
		public static const ROLE_CHOP_LV:int = 8;
		public static const ROLE_POSITION:int= 9;
		public static const ROLE_WING_LV:int = 10;
		public static const ROLE_HLZX:int = 11;
		public static const ROLE_LV:int = 12;
		public var day:int;
		public var data:Dictionary;
		public function OpenPromoteData()
		{
		}
		public function canGet():int
		{
			var count:int;
			var cfg:OpenServerPromoteRewardCfgData;
			for each(var _data:Object in data)
			{
				cfg = ConfigDataManager.instance.OpenServerPromoteRewardData(day,_data.index);
				if(cfg.type>= ROLE_EQUIP_LV && cfg.type <= HERO_EQUIP_SLV)
				{
					if(_data.num<10||_data.state == 1)
						continue;
				}
				else if(cfg.type == ROLE_DUNPAI||cfg.type == ROLE_HLZX||cfg.type == ROLE_LV)
				{
					if(_data.num<1||_data.state == 1)
						continue;
				}
				else
				{
					if(_data.num<cfg.num||_data.state == 1)
						continue;
				}
				count++;	
			}
			return count;
		}
	}
}