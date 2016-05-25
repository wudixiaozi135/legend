package com.view.gameWindow.panel.panels.mall.mallbuy.data
{
	import com.model.configData.cfgdata.GameShopCfgData;

	/**
	 * Created by Administrator on 2014/11/21.
	 */
	public class MallBuyData
	{
		public static const BUY_MAX_COUNT:int = 999;
		public static var buyCount:int = 1;
		public static var giveCount:int = 1;

		private static var _buyData:GameShopCfgData;

		public static function get buyData():GameShopCfgData
		{
			return _buyData;
		}

		public static function set buyData(value:GameShopCfgData):void
		{
			_buyData = value;
		}

		private static var _giveData:GameShopCfgData;

		public static function get giveData():GameShopCfgData
		{
			return _giveData;
		}

		public static function set giveData(value:GameShopCfgData):void
		{
			_giveData = value;
		}

		public function MallBuyData()
		{
		}
	}
}
