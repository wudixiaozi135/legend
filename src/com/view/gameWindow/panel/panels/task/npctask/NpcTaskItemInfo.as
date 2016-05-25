package com.view.gameWindow.panel.panels.task.npctask
{
	public class NpcTaskItemInfo
	{
		private var _type : int;
		private var _id : int;
		private var _count : int;
		private var _icon:String;
		private var _special_tips:String
		private var _barFlyKey:int = -1;
		
		public function get type():int
		{
			return _type;
		}

		public function set type(value:int):void
		{
			_type = value;
		}

		public function get id():int
		{
			return _id;
		}

		public function set id(value:int):void
		{
			_id = value;
		}

		public function get count():int
		{
			return _count;
		}

		public function set count(value:int):void
		{
			_count = value;
		}

		public function get special_tips():String
		{
			return _special_tips;
		}

		public function set special_tips(value:String):void
		{
			_special_tips = value;
		}

		public function get icon():String
		{
			return _icon;
		}

		public function set icon(value:String):void
		{
			_icon = value;
		}
		/**飞至动作的快捷键值*/
		public function get barFlyKey():int
		{
			return _barFlyKey;
		}
		/**
		 * @private
		 */
		public function set barFlyKey(value:int):void
		{
			_barFlyKey = value;
		}
	}
}