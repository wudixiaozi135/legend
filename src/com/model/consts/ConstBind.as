package com.model.consts
{
	
	/**
	 * 是否绑定
	 * @author jhj
	 */
	public class ConstBind
	{
		public static const NO_BIND:int = 0;
		public static const HAS_BIND:int = 1;
		
		public static function bindName(bind:int):String
		{
			var bindStr:String = "";
			
			switch(bind)
			{
				case NO_BIND:
					bindStr = StringConst.TYPE_BIND;
					break;
				case HAS_BIND:
					bindStr = StringConst.TYPE_NO_BIND;
					break;
			}
			return bindStr;
		}
		public function ConstBind()
		{
			
		}
	}
}