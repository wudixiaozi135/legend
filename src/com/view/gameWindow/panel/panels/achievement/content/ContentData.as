package com.view.gameWindow.panel.panels.achievement.content
{
	public class ContentData
	{
		public function ContentData()
		{
		}
		
		public var id:int;
		public var state:int;
		public var num:int;
		public var isCompled:Boolean;
		private var _gress:int;

		public function get gress():int
		{
			return _gress;
		}

		public function set gress(value:int):void
		{
			if(value<0)
			{
				_gress=0;
				return;
			}
			if(value>100)
			{
				_gress=100;
				return;
			}
			_gress = value;
		}

	}
}