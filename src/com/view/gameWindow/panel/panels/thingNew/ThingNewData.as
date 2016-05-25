package com.view.gameWindow.panel.panels.thingNew
{
	import com.view.gameWindow.panel.panels.bag.BagData;

	public class ThingNewData
	{
		private static var _isUniqueEquip:int = -1;
		private static var _bnfType:int = -1;
		private static var _bagData:BagData = null;
		
		public function ThingNewData()
		{
		}
		/**
		 * 1表示包含的装备为唯一id，0表示包含的装备为基础id
		 * @return 
		 */
		public static function get isUniqueEquip():int
		{
			var _isUniqueEquip2:int = _isUniqueEquip;
			_isUniqueEquip = -1;
			return _isUniqueEquip2;
		}

		public static function set isUniqueEquip(value:int):void
		{
			_isUniqueEquip = value;
		}

		public static function get bnfType():int
		{
			var _bnfType2:int = _bnfType;
			_bnfType = -1;
			return _bnfType2;
		}

		public static function set bnfType(value:int):void
		{
			_bnfType = value;
		}

		public static function get bagData():BagData
		{
			var _bagDatas2:BagData = _bagData;
			_bagData = null;
			return _bagDatas2;
		}

		public static function set bagData(value:BagData):void
		{
			_bagData = value;
		}
	}
}