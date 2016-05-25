package com.view.gameWindow.panel.panels.guardSystem
{
	public class BenefitType
	{
		public static const BT_NORMAL:int = 1;
		public static const BT_TIRED:int = 2;
		public static const BT_HURT:int = 3;
		
		/**
		 * 根据类型获得比例
		 * @param type
		 * @return 
		 */		
		public static function proportion(type:int):Number
		{
			var proportion:Number;
			switch(type)
			{
				case BT_NORMAL:
					proportion = 1;
					break;
				case BT_TIRED:
					proportion = .5;
					break;
				case BT_HURT:
					proportion = 0;
					break;
				default:
					proportion = 1;
					break;
			}
			return proportion;
		}
	}
}