package com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.trade
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.consts.StringConst;
	import com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.AlertCellBase;
	import com.view.gameWindow.panel.panels.trade.data.ExchangeData;

	/**
	 * Created by Administrator on 2014/12/16.
	 */
	public class TradeAlert extends AlertCellBase
	{
		private var _data:ExchangeData;

		public function TradeAlert()
		{
			super();
		}

		override protected function getIconUrl():String
		{
			var url:String = "mainUiBottom/tradeIcon.swf";
			return url;
		}

		override protected function getTipStr():String
		{
			return StringConst.TRADE_007;
		}

		public function get data():ExchangeData
		{
			return _data;
		}

		public function set data(value:ExchangeData):void
		{
			_data = value;
		}
	}
}
