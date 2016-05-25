package com.view.gameWindow.panel.panels.mall.mallbuy
{
	import com.model.gameWindow.rsr.RsrLoader;

	/**
	 * Created by Administrator on 2014/11/21.
	 */
	public class MallBuyCallBackHandler
	{
		public function MallBuyCallBackHandler(panel:PanelMallBuy, rsrLoader:RsrLoader)
		{
			this._panel = panel;

		}

		private var _panel:PanelMallBuy;

		public function destroy():void
		{

		}
	}
}
