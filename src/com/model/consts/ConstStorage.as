package com.model.consts
{
	public class ConstStorage
	{
		public static const ST_NO_TYPE:int = 0;
		public static const ST_CHR_EQUIP:int = 1;
		public static const ST_CHR_BAG:int = 2;
		public static const ST_HERO_EQUIP:int = 3;
		public static const ST_HERO_BAG:int = 4;
		public static const ST_CHR_STORE_FIRST:int = 5;
		public static const ST_CHR_STORE_SECOND:int = 6;
		public static const ST_CHR_STORE_THREE:int = 7;
		public static const ST_CHR_STORE_FOUR:int = 8;
		public static const ST_CHR_STORE_FIVE:int = 9;
		public static const ST_MAX_STORAGE:int = 10;
		public static const ST_STORAGE:Array = [5, 6, 7, 8, 9];
		public static const ST_SCHOOL_BAG:int = 11;
		public static const ST_SCHOOL_MY_BAG:int = 12;
	

		/**交易自己的格子*/
		public static const ST_TRADE_SELF_BAG:int = 20;
		/**交易对方的格子*/
		public static const ST_TRADE_OTHER_BAG:int = 21;
		/**摆摊的自己的格子*/
		public static const ST_STALL_SELF_BAG:int = 22;

		/**摆摊的对方的格子*/
		public static const ST_STALL_OTHER_BAG:int = 23;

		public function ConstStorage()
		{
		}
	}
}