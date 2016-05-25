package com.model.consts
{

	public class HeadConst
	{
		public static const ZS_MALE:String = "1_1";
		public static const ZS_FEMALE:String = "1_2";
		public static const FS_MALE:String = "2_1";
		public static const FS_FEMALE:String = "2_2";
		public static const DS_MALE:String = "3_1";
		public static const DS_FEMALE:String = "3_2";
			
		public static function getHead(i:int,j:int):String
		{
			var str:String = String(i)+"_"+String(j);
			switch(str)
			{
				case ZS_MALE:
					return "zhanshi_1_1.png";
					break;
				case ZS_FEMALE:
					return "zhanshi_1_2.png";
					break;
				case FS_MALE:
					return "fashi_2_1.png";
					break;
				case FS_FEMALE:
					return "fashi2_2.png";
					break;
				case DS_MALE:
					return "daoshi3_1.png";
					break;
				case DS_FEMALE:
					return "daoshi3_2.png";
					break;
				default:
					return "";
					break;
			}
		}
		public function HeadConst()
		{
		}
	}
}