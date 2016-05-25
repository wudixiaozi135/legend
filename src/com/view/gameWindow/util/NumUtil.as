package com.view.gameWindow.util
{
	import com.model.consts.StringConst;

	public class NumUtil
	{
		public function NumUtil()
		{
		}
		
		public static function getNUM(value:int):String
		{
			switch(value)
			{
				case 0:
					return StringConst.NUM_0000;
					break;
				case 1:
					return StringConst.NUM_0001;
					break;
				case 2:
					return StringConst.NUM_0002;
					break;
				case 3:
					return StringConst.NUM_0003;
					break;
				case 4:
					return StringConst.NUM_0004;
					break;
				case 5:
					return StringConst.NUM_0005;
					break;
				case 6:
					return StringConst.NUM_0006;
					break;
				case 7:
					return StringConst.NUM_0007;
					break;
				case 8:
					return StringConst.NUM_0008;
					break;
				case 9:
					return StringConst.NUM_0009;
					break;
				case 10:
					return StringConst.NUM_0010;
					break;
			}
			return "";
		}
	}
}