package com.view.gameWindow.mainUi.subuis.bottombar.actBar
{
	public class ActionBarCellType
	{
		public static const TYPE_ITEM:int = 1;
		public static const TYPE_SKILL:int = 2;
		
		/**
		 * 根据key值取对应的字符
		 * @param key
		 * @return 
		 */		
		public static function getKeyString(key:int):String
		{
			var keyStr:String = "";
			if(key < 6)
			{
				keyStr = (key+1)+"";
			}
			else
			{
				switch(key)
				{
					default:
					case 6:
						keyStr = "q";
						break;
					case 7:
						keyStr = "w";
						break;
					case 8:
						keyStr = "e";
						break;
					case 9:
						keyStr = "r";
						break;
				}
			}
			return keyStr;
		}
		
		public function ActionBarCellType()
		{
		}
	}
}