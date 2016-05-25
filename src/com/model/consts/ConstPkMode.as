package com.model.consts
{
	public class ConstPkMode
	{
		/**和平模式PK*/		
		public static const PEACE:int = 0;
		/**队伍模式PK*/	
		public static const TEAM:int = 1;
		/**帮派模式PK*/	
		public static const FACTION:int = 2;
		/**善恶模式PK*/	
		public static const GOOD_BAD:int = 3;
		/**全体模式PK*/	
		public static const ALL:int = 4;
		/**阵营模式PK*/
		public static const CAMP:int = 5;
		
		public static function getStringByPkMode(mode:int):String
		{
			switch(mode)
			{
				case PEACE:
					return StringConst.ROLE_HEAD_0003;
				case TEAM:
					return StringConst.ROLE_HEAD_0004;
				case FACTION:
					return StringConst.ROLE_HEAD_0005;
				case GOOD_BAD:
					return StringConst.ROLE_HEAD_0006;
				case ALL:
					return StringConst.ROLE_HEAD_0007;
				case CAMP:
					return StringConst.ROLE_HEAD_0008;
			}
			return "";
		}
		
		public function ConstPkMode()
		{
		}
	}
}