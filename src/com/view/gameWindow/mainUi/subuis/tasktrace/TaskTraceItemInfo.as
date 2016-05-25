package com.view.gameWindow.mainUi.subuis.tasktrace
{
	public class TaskTraceItemInfo
	{
		public var isLocked:Boolean = false;
		
		private var _taskId : int;
		private var _taskType : int;
		private var _cycleType : int;
		private var _state : int;
		public function get taskId():int
		{
			return _taskId;
		}

		public function set taskId(value:int):void
		{
			_taskId = value;
		}

		public function get taskType():int
		{
			return _taskType;
		}

		public function set taskType(value:int):void
		{
			_taskType = value;
		}

		public function get cycleType():int
		{
			return _cycleType;
		}

		public function set cycleType(value:int):void
		{
			_cycleType = value;
		}

		public function get state():int
		{
			return _state;
		}

		public function set state(value:int):void
		{
			_state = value;
		}
	}
}