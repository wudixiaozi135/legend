package com.view.gameWindow.panel.panels.openGift.data
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.OpenServerJourneyRewardCfgData;
	
	import flash.utils.Dictionary;

	public class OpenJourneyData
	{
		public static const ROLE_LV:int = 1;
		public static const HERO_LV:int = 2;
		public static const ROLE_ATTR:int = 11;
		public static const REPUTION_INTERGAL:int = 7;
		public var day:int;
		public var data:Dictionary;
		public function OpenJourneyData()
		{
		}
		public function canGet():int
		{
			var count:int;
			var cfg:OpenServerJourneyRewardCfgData;
			for each(var _data:Object in data)
			{
				cfg = ConfigDataManager.instance.OpenServerJourneyRewardData(day,_data.index); 
				if(cfg.type == ROLE_LV || cfg.type == HERO_LV)
				{
					if(_data.num<cfg.level||_data.state == 1)
						continue;
				}else
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