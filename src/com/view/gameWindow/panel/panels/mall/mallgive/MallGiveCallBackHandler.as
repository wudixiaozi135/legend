package com.view.gameWindow.panel.panels.mall.mallgive
{
	import com.model.gameWindow.rsr.RsrLoader;

	/**
	 * Created by Administrator on 2014/11/21.
	 */
	public class MallGiveCallBackHandler
	{
		public function MallGiveCallBackHandler(panel:PanelMallGive, rsrLoader:RsrLoader)
		{
			this._panel = panel;
		}

		private var _panel:PanelMallGive;

		public function destroy():void
		{

		}
	}
}
