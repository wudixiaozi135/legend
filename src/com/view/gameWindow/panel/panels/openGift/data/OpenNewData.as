package com.view.gameWindow.panel.panels.openGift.data
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.OpenServerNewRewardCfgData;
	
	import flash.utils.Dictionary;

	public class OpenNewData
	{
		public var day:int;
		public var data:Dictionary;
		public function OpenNewData()
		{
		}
		public function canGet():int
		{
			var count:int;
			var cfg:OpenServerNewRewardCfgData;
			for each(var _data:Object in data)
			{
				cfg = ConfigDataManager.instance.OpenServerNewRewardData(day,_data.index);
				if(_data.sum>=cfg.max_num||_data.dailyNum>=cfg.daily_num||_data.state == 1)
					continue;
				count++;	
			}
			return count;
			
		}
	}
}