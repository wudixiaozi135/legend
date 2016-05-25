package com.view.gameWindow.panel.panels.pray.data
{
	/**
	 * Created by Administrator on 2014/11/25.
	 */
	public class PrayData
	{
		public function PrayData()
		{
		}//4字节有符号整形 已祈福金币次数

		private var _coinCount:int;//4字节有符号整形  祈福获得金币总数

		public function get coinCount():int
		{
			return _coinCount;
		}//4字节有符号整形  祈福金币总数

		public function set coinCount(value:int):void
		{
			_coinCount = value;
		}//4字节有符号整形 已祈福礼券次数

		private var _coinTotal:int;//4字节有符号整形  祈福获得礼券总数

		public function get coinTotal():int
		{
			return _coinTotal;
		}//4字节有符号整形  祈福礼券总数

		public function set coinTotal(value:int):void
		{
			_coinTotal = value;
		}

		private var _coinTotalCount:int;

		public function get coinTotalCount():int
		{
			return _coinTotalCount;
		}

		public function set coinTotalCount(value:int):void
		{
			_coinTotalCount = value;
		}

		private var _goldCount:int;

		public function get goldCount():int
		{
			return _goldCount;
		}

		public function set goldCount(value:int):void
		{
			_goldCount = value;
		}

		private var _goldTotal:int;

		public function get goldTotal():int
		{
			return _goldTotal;
		}

		public function set goldTotal(value:int):void
		{
			_goldTotal = value;
		}

		private var _goldTotalCount:int;

		public function get goldTotalCount():int
		{
			return _goldTotalCount;
		}

		public function set goldTotalCount(value:int):void
		{
			_goldTotalCount = value;
		}
	}
}
