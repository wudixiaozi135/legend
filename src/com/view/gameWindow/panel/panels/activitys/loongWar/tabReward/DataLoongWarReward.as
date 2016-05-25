package com.view.gameWindow.panel.panels.activitys.loongWar.tabReward
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.ActivityLoongWarRewardCfgData;
	import com.model.configData.cfgdata.EquipCfgData;
	import com.view.gameWindow.util.UtilItemParse;
	import com.view.gameWindow.util.cell.ThingsData;

	public class DataLoongWarReward
	{
		/**城主帮*/
		public static const SCORE_RANK_0:int = 0;
		/**击杀总分第一*/
		public static const SCORE_RANK_1:int = 1;
		/**击杀总分第二*/
		public static const SCORE_RANK_2:int = 2;
		
		public var familyId:int;//	4字节有符号整形  
		public var familySid:int;//	4字节有符号整形
		public var familyName:String;// utf8 
		public var scoreRank:int;//	1字节有符号整形 0是城主帮 1击杀总分第一  2击杀总分第二
		public var isFashionGet:int;// 1字节有符号整形 帮主时装是够领过 0未领过 1领过

		private var _cfgDts:Vector.<ActivityLoongWarRewardCfgData>;
		
		public function get fashionId():int
		{
			var cfgDt:ActivityLoongWarRewardCfgData = loongWarRewardCfgDts[0];
			var dt:ThingsData = UtilItemParse.getThingsData(cfgDt.wang_reward);
			return dt.id;
		}
		
		public function get loongWarRewardCfgDts():Vector.<ActivityLoongWarRewardCfgData>
		{
			var cfgDts:Vector.<ActivityLoongWarRewardCfgData> = ConfigDataManager.instance.loongWarRewardCfgDatas(scoreRank);
			return cfgDts;
		}
		
		public function get loongWarRewardDts():Vector.<ThingsData>
		{
			var vector:Vector.<ThingsData> = new Vector.<ThingsData>();
			var cfgDt:ActivityLoongWarRewardCfgData;
			for each (cfgDt in loongWarRewardCfgDts)
			{
				var dt:ThingsData = UtilItemParse.getThingsData(cfgDt.reward);
				vector.push(dt);
			}
			return vector;
		}
		
		public function get equipCfgData():EquipCfgData
		{
			var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(fashionId);
			return equipCfgData;
		}
		
		public function DataLoongWarReward()
		{
		}
	}
}