package com.view.gameWindow.tips.toolTip
{
	
	/**
	 * @author jhj
	 */
	public class TipVO
	{
		public var tipType:int;
		public var tipData:Object;
		public var tipCount:int = 1;
		/**若tipData为函数则该值为对应传入的参数*/
		public var tipDataValue:* = null;
		/**0 为不同装备类型比对   1为同种装备的不同强化等级比对*/
		public var completeTipeType:int = 0;
		/**是否需要像素级滑动检测*/
		public var isNeedPixelCheck:Boolean = false;
		
		
		public function TipVO()
		{
			
		}
	}
}