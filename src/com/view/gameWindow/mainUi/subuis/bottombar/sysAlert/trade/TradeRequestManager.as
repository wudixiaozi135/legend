package com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.trade
{
	import com.view.gameWindow.panel.panels.trade.data.ExchangeData;

	/**
	 * Created by Administrator on 2014/12/19.
	 * 管理交易请求
	 */
	public class TradeRequestManager
	{
		private var _requestDataVec:Vector.<ExchangeData>;

		public function TradeRequestManager()
		{
			_requestDataVec = new Vector.<ExchangeData>();
		}

		/**添加一项请求*/
		public function addRequestTrade(data:ExchangeData):void
		{
			if (exist(data)) return;
			_requestDataVec.push(data);
		}

		public function exist(data:ExchangeData):Boolean
		{
			for each(var it:ExchangeData in _requestDataVec)
			{
				if (data == it)
				{
					return true;
				}
			}
			return false;
		}

		public function getLastData():ExchangeData
		{
			return size ? _requestDataVec[size - 1] : null;
		}

		public function deleteLastData():void
		{
			var data:ExchangeData = getLastData();
			if (data)
			{
				var index:int = 0;
				for (var i:int = 0, len:int = size; i < len; i++)
				{
					if (_requestDataVec[i] == data)
					{
						index = i;
						break;
					}
				}
				_requestDataVec.splice(index, 1);
			}
		}

		public function get size():int
		{
			return _requestDataVec ? _requestDataVec.length : 0;
		}

		private static var _instance:TradeRequestManager = null;
		public static function get instance():TradeRequestManager
		{
			if (_instance == null)
			{
				_instance = new TradeRequestManager();
			}
			return _instance;
		}
	}
}
