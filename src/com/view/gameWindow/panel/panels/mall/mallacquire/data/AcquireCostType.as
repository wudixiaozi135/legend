package com.view.gameWindow.panel.panels.mall.mallacquire.data
{
	/**
	 * Created by Administrator on 2014/11/26.
	 * 用打开快速获取面板
	 * AcquireManager.costType=AcquireCostType.TYPE_GOLD;//打开快速获取元宝面板
	 * PanelMeditator.instance.openPanel(PanelConstant.TYPE_MALL_ACQUIRE);
	 */
	public class AcquireCostType
	{
		/**元宝*/
		public static const TYPE_GOLD:int = 1;
		/**礼券*/
		public static const TYPE_TICKET:int = 2;
		/**积分*/
		public static const TYPE_SCORE:int = 3;

		public function AcquireCostType()
		{
		}
	}
}
