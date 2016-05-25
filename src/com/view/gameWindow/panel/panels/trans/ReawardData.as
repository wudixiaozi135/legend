package com.view.gameWindow.panel.panels.trans
{
	public class ReawardData
	{
		private var _type:int;
		private var _id:int;
		private var _count:int;
		public function ReawardData()
		{
		}

		public function get count():int
		{
			return _count;
		}

		public function set count(value:int):void
		{
			_count = value;
		}

		public function get id():int
		{
			return _id;
		}

		public function set id(value:int):void
		{
			_id = value;
		}

		public function get type():int
		{
			return _type;
		}

		public function set type(value:int):void
		{
			_type = value;
		}

	}
}