package com.view.gameWindow.panel.panels.activitys.goldenPig
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.ActivityCfgData;
	import com.model.configData.cfgdata.ActivityEventCfgData;
	import com.view.gameWindow.mainUi.subuis.activityTrace.ActivityData;
	import com.view.gameWindow.mainUi.subuis.activityTrace.ActivityDataManager;
	import com.view.gameWindow.util.TimeUtils;
	
	import flash.utils.Dictionary;

	/**
	 * 金猪送礼活动数据管理类
	 * @author Administrator
	 */	
	public class GoldenPigDataManager
	{
		public function GoldenPigDataManager()
		{
			super();
		}
		
		public function get strWave():String
		{
			return (actvData && actvData.step <= stepTotal) ? (actvData.step + "/" + stepTotal) : "";
		}
		
		public function get strPigNum():String
		{
			var total:int;
			var finish:int;
			var i:int,l:int = actvData ? actvData.count : 0;
			for (i=0;i<l;i++) 
			{
				finish += actvData.countFinish(i);
				total += actvData.countTotal(i);
			}
			return (actvData && total >= finish) ? ((total - finish) + "/" + total) : "";
		}
		
		public function get strNextWaveTime():String
		{
			var activityId:int = actvData ? actvData.activityId : 0;
			var triggerId:int = actvData ? actvData.triggerId : 0;
			var eventCfgDt:ActivityEventCfgData = ConfigDataManager.instance.activityEventCfgData(activityId,triggerId);
			var second:int = int(eventCfgDt ? int(eventCfgDt.trigger_param) : 0) + (actvCfgDt ? actvCfgDt.secondToStart : 0) - 1;
			second = second < 0 ? 0 : second;
			return (actvData && actvData.step < stepTotal) ? TimeUtils.format(TimeUtils.calcTime(second)) : "";
		}
		
		private function get stepTotal():int
		{
			var eventCfgdts:Dictionary = ConfigDataManager.instance.activityEventCfgDatas(actvData ? actvData.activityId : 0);
			var eventCfgDt:ActivityEventCfgData;
			var stepTotal:int;
			for each(eventCfgDt in eventCfgdts)
			{
				if(eventCfgDt.event_type == ActivityEventCfgData.EVENT_TYPE_ADD_MST)
				{
					stepTotal++;
				}
			}
			return stepTotal;
		}
		
		private function get actvCfgDt():ActivityCfgData
		{
			var manager:ActivityDataManager = ActivityDataManager.instance;
			var currentActvCfgDtAtMap:ActivityCfgData = manager.currentActvCfgDtAtMap;
			return currentActvCfgDtAtMap;
		}
		
		private function get actvData():ActivityData
		{
			var manager:ActivityDataManager = ActivityDataManager.instance;
			var actvDataAtMap:ActivityData = manager.currentActvDataAtMap;
			return actvDataAtMap;
		}
	}
}