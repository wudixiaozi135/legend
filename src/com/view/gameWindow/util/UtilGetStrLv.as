package com.view.gameWindow.util
{
	import com.model.consts.StringConst;

	public class UtilGetStrLv
	{
		public function UtilGetStrLv()
		{
		}
		
		public static function strReincarnLevel(reincarnValue:int,levelValue:int):String
		{
			var levelDes:String = (reincarnValue == 0 ? "" : reincarnValue+StringConst.REINCARN)+levelValue+StringConst.LEVEL;
			return levelDes;
		}
		
	}
}