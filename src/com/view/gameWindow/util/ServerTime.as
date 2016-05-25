package com.view.gameWindow.util
{
	import flash.utils.getTimer;
	
	/**
	 * @author wqhk
	 * 2014-9-6
	 */
	public class ServerTime
	{
		public static var firstLongChengOpen:int;	  //开服龙城天数
		public static var openTime:uint;    // 开服时间
		
		private static var _time:Number = new Date().time;
		private static var _startTime:int;

		private static var _date:Date;
		/**服务器时间（秒）*/
		public static function get time():int
		{
			return Math.ceil((_time + getTimer() - _startTime)/1000);
		}
		/**服务器时间（毫秒）*/
		public static function get timeMs():Number
		{
			return _time + getTimer() - _startTime;
		}
		/**获取服务器日期*/
		public static function get date():Date
		{
			if(!_date)
			{
				_date = new Date();
			}
			_date.time = timeMs;
			return _date;//1420355856*1000
		}
		/**第一次龙城活动的星期值（0 代表星期日，1 代表星期一，依此类推）*/
		public static function get firstLWDay():int
		{
			var date:Date = new Date(openTime * 1000);
			return date.day + (firstLongChengOpen - 1);
		}
		/**是否第一次龙城活动已完成*/
		public static function get isFirstLWDayOver():Boolean
		{
			var dayZero:int = TimeUtils.dayZero(time);
			var dayZero2:int = TimeUtils.dayZero(openTime);
			var b:Boolean = dayZero > (dayZero2 + firstLongChengOpen * 86400);
			return b;
		}
		
		public function ServerTime()
		{
		}
		
		public static function update(time:Number):void
		{
			_time = time;
			_startTime = getTimer();
		}
	}
}