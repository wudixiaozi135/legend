package com.model.consts
{
	public class JobConst
	{
		public static const TYPE_ZS:int = 1;
		public static const TYPE_FS:int = 2;
		public static const TYPE_DS:int = 3;
		public static const TYPE_NO:int = 0;
		
		/**取职业名称*/
		public static function jobName(type:int):String
		{
			var str:String
			switch(type)
			{
				case TYPE_ZS:
					str = StringConst.JOB_0001;
					break;
				case TYPE_FS:
					str = StringConst.JOB_0002;
					break;
				case TYPE_DS:
					str = StringConst.JOB_0003;
					break;
				default:
					str = StringConst.JOB_0000;
					break;
			}
			return str;
		}
		
		/**取职业名称*/
		public static function jobName2(type:int):String
		{
			var str:String
			switch(type)
			{
				case TYPE_ZS:
					str = StringConst.JOB_0004;
					break;
				case TYPE_FS:
					str = StringConst.JOB_0005;
					break;
				case TYPE_DS:
					str = StringConst.JOB_0006;
					break;
				default:
					str = StringConst.JOB_0000;
					break;
			}
			return str;
		}
		
		public static function isNO(type:int):Boolean
		{
			return type == TYPE_NO;
		}
		
		public static function isZS(type:int):Boolean
		{
			return type == TYPE_ZS;
		}
		
		public static function isFS(type:int):Boolean
		{
			return type == TYPE_FS;
		}
		
		public static function isDS(type:int):Boolean
		{
			return type == TYPE_DS;
		}
		
		public function JobConst()
		{
		}
	}
}