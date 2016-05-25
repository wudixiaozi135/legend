package com.view.gameWindow.panel.panels.task.item
{
	public class AutoTaskItem
	{
		private var _taskId : int;
		private var _state : int;
		private var _type : int;
		private var _fail : Boolean;
		private var _click : Boolean; 
		public function get taskId():int
		{
			return _taskId;
		}

		public function set taskId(value:int):void
		{
			_taskId = value;
		}

		public function get state():int
		{
			return _state;
		}

		public function set state(value:int):void
		{
			_state = value;
		}

		public function get type():int
		{
			return _type;
		}

		public function set type(value:int):void
		{
			_type = value;
		}

		public function get fail():Boolean
		{
			return _fail;
		}

		public function set fail(value:Boolean):void
		{
			_fail = value;
		}

		public function get click():Boolean
		{
			return _click;
		}

		public function set click(value:Boolean):void
		{
			_click = value;
		}


	}
}