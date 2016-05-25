package com.view.gameWindow.mainUi.subuis.progress
{
	public class ActionProgressData
	{
		public static const START:int = -1;
		public static const OVER:int = -2;
		public static const MINING_TIME_MAP:int = 5000;
		
		public static var strTxt:String = "";
		private static var _totalTime:int;
		
		public static function get totalTime():int
		{
			var _totalTime2:int = _totalTime;
			_totalTime = 0;
			return _totalTime2;
		}
		
		public static function set totalTime(value:int):void
		{
			_totalTime = value;
		}
		
		public function ActionProgressData()
		{
		}
	}
}