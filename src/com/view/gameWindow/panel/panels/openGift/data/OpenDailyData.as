package com.view.gameWindow.panel.panels.openGift.data
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.OpenServerDailyRewardCfgData;
	
	import flash.utils.Dictionary;

	public class OpenDailyData
	{
		public static const ONLINE_TIME:int = 1;
		public static const TOTAL_RECHARGE:int = 3;
		public var day:int;
		public var data:Dictionary;
		public function OpenDailyData()
		{
		}
		
		public function canGet():int
		{
			var count:int;
			var cfg:OpenServerDailyRewardCfgData;
			for each(var _data:Object in data)
			{
				cfg = ConfigDataManager.instance.openServerDailyRewardData(day,_data.index);
				if(cfg.type==ONLINE_TIME)
				{
					if(cfg.param*60>_data.param||day!=OpenServiceActivityDatamanager.instance.curDay||_data.state == 1)
						continue;
				}else if(cfg.type == TOTAL_RECHARGE)
				{
					if(cfg.param>_data.param||_data.state == 1)
						continue;
				}else
				{
					if(cfg.param>_data.param||day!=OpenServiceActivityDatamanager.instance.curDay||_data.state == 1)
						continue;
				}
				count++;	
			}
			return count;
			
		}
	}
}