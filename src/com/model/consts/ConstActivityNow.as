package com.model.consts
{
	public class ConstActivityNow
	{
		private static const YABIAO:int = 801;
		private static const LONGWAR:int = 802;
		private static const DOUBLEEXP:int = 803;
		private static const SEAFOOD:int = 805;
		private static const ADMIRELORD:int = 806;
		private static const GOLDPIG:int = 808;
		private static const NIGHTBIQI:int = 809;
		private static const MARTIALREGION:int = 810;
		public function ConstActivityNow()
		{
		}
		
		public static function getResUrlSmall(value:int):String
		{
			switch(value)
			{
				case YABIAO:
					return "activityNow/yaBiao.png";
				case LONGWAR:
					return "activityNow/longWar.png";
				case DOUBLEEXP:
					return "activityNow/doubleExp.png";
				case SEAFOOD:
					return "activityNow/seaFood.png";
				case ADMIRELORD:
					return "activityNow/admireLord.png";
				case GOLDPIG:
					return "activityNow/goldPig.png";
				case NIGHTBIQI:
					return "activityNow/nightBiqi.png";
				case MARTIALREGION:
					return 	"activityNow/martialRegin.png";
			}
			return "";
		}
		
		public static function getResUrlBig(value:int):String
		{
			switch(value)
			{
				case YABIAO:
					return "activityNow/yaBiao.jpg";
				case LONGWAR:
					return "activityNow/longWar.jpg";
				case DOUBLEEXP:
					return "activityNow/doubleExp.jpg";
				case SEAFOOD:
					return "activityNow/seaFood.jpg";
				case ADMIRELORD:
					return "activityNow/admireLord.jpg";
				case GOLDPIG:
					return "activityNow/goldPig.jpg"
				case NIGHTBIQI:
					return "activityNow/nightBiqi.jpg"
				case MARTIALREGION:
					return 	"activityNow/martialRegin.jpg";
			}
			return "";
		}
		
	}
}