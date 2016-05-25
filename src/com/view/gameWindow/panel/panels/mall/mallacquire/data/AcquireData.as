package com.view.gameWindow.panel.panels.mall.mallacquire.data
{
	/**
	 * Created by Administrator on 2014/11/22.
	 */
	public class AcquireData
	{
		public function AcquireData()
		{
		}

		private var _keyName:String;

		public function get keyName():String
		{
			return _keyName;
		}

		public function set keyName(value:String):void
		{
			_keyName = value;
		}

		private var _value:String;

		public function get value():String
		{
			return _value;
		}

		public function set value(value:String):void
		{
			_value = value;
		}
	}
}
