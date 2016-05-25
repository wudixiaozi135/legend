package com.model.configData.cfgdata
{
	import com.view.gameWindow.util.ServerTime;
	import com.view.gameWindow.util.TimeUtils;

	public class ActivityTimeCfgData
	{
		public var id:int;//11	活动id
		public var index:int;//11	序列
		public var start_time:int;//11	开始时间(分钟)
		public var duration:int;//11	持续时间(分钟)
		public var enter_duration:int;//11 入口开放持续时间(分钟)
		public var effect:String;//效果
		
		private var _today_start_to_end:String;
		public function get today_start_to_end():String
		{
			if(!_today_start_to_end)
			{
				var str:String = "";
				var string:String = TimeUtils.formatClock1(start_time*60) as String;
				string = (string.split(" ")[0] as String).substr(0,5);
				str += string;
				str += "-";
				string = TimeUtils.formatClock1((start_time+Math.min(enter_duration,duration))*60) as String;
				string = (string.split(" ")[0] as String).substr(0,5);
				str += string;
				_today_start_to_end = str;
			}
			return _today_start_to_end;
		}
		/**正数表示到该活动开始时刻的秒数，负数表示该活动开始的秒数，负最大值表示活动已结束*/
		public function get secondToStart():int
		{
			var second:int = secondRemain;//剩余时间
			second = second > 0 ? (start_time*60 - timeToday) : int.MIN_VALUE;
			return second;
		}
		/**正数表示到该活动入口开始时刻的秒数，负数表示该活动开始的秒数，负最大值表示活动入口已结束*/
		public function get secondToEnter():int
		{
			var second:int = secondRemainOpen;//剩余时间
			second = second > 0 ? (start_time*60 - timeToday) : int.MIN_VALUE;
			return second;
		}
		/**剩余的描述，正最大值表示今日无该活动*/
		public function get secondRemain():int
		{
			var second:int = (start_time+duration)*60 - timeToday;
			return second < 0 ? 0 : second;
		}
		/**剩余入口开启时间*/
		public function get secondRemainOpen():int
		{
			var second:int = (start_time+enter_duration)*60 - timeToday;
			return second < 0 ? 0 : second;
		}
		
		private function get timeToday():int
		{
			var date:Date = ServerTime.date;
			var timeToday:int = date.hours*3600 + date.minutes*60 + date.seconds + Math.ceil(date.milliseconds*.001);
			return timeToday;
		}
		
		public function ActivityTimeCfgData()
		{
		}
	}
}