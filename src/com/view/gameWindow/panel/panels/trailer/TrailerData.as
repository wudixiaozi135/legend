package com.view.gameWindow.panel.panels.trailer
{
	import com.model.configData.ConfigDataManager;
	import com.view.gameWindow.panel.panels.vip.VipDataManager;

	public class TrailerData
	{
		public function TrailerData()
		{
		}
		public var tid:int;
		public var level:uint;
		public var state:int;
		public var quality:int;
		public var count:int;
		private var _totalCount:int;
		public var refreshCount:int;
		public var mapId:int;
		public var tileX:int;
		public var tileY:int;
		public var expire:int;
		public var insure:int;
		public var hp:int;
		
		public function get totalCount():int
		{
			if(VipDataManager.instance.lv==0)return 3;
			return 	ConfigDataManager.instance.vipCfgData(VipDataManager.instance.lv).add_task_trailer_num+3;
		}
	}
}