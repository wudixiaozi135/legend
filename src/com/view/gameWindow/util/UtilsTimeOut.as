package com.view.gameWindow.util
{
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	public class UtilsTimeOut
	{
		public function UtilsTimeOut()
		{
			RollTipType.REWARD;
		}
		
		/**
		 *showRollTip处理延时 
		 * @param color
		 * @param str
		 * @param timer
		 * 
		 */		
		public static function dealTimeOut(str:String,timer:int,rollTipType:int = RollTipType.REWARD):void
		{	
			var timeId:uint = setTimeout(function():void
			{
				clearTimeout(timeId);
				RollTipMediator.instance.showRollTip(rollTipType,str);
			},timer)
		}
		
	}
}