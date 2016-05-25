package com.model.consts
{
	public class ConstPriceType
	{
		public static const UNBIND_COIN:int = 1;
		public static const BIND_COIN:int = 2;
		public static const UNBIND_GOLD:int = 3;
		public static const BIND_GOLD:int = 4;
		public function ConstPriceType()
		{
		}
		public static function getResUrl(value:int):String
		{
			switch(value)
			{
				case UNBIND_COIN:
					return "bagPanel/money.png";
				case BIND_COIN:
                    return "bagPanel/boundMoney.png";
				case UNBIND_GOLD:
					return "bagPanel/gold.png";
				case BIND_GOLD:
					return "bagPanel/boundGold.png";
			}
			return "";
		}
		
		public static function getPriceStr(value:int):String
		{
			switch(value)
			{
				case UNBIND_COIN:
					return StringConst.PROMPT_PANEL_0018;
				case BIND_COIN:
					return StringConst.PROMPT_PANEL_0015;
				case UNBIND_GOLD:
					return StringConst.PROMPT_PANEL_0019;
				case BIND_GOLD:
					return StringConst.PROMPT_PANEL_0020;
			}
			return "";
		}
	}
}