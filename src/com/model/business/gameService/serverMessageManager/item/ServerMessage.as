package com.model.business.gameService.serverMessageManager.item
{
	import flash.utils.ByteArray;

	public class ServerMessage
	{
		private var _type:int;
		private var _proc:int;
		private var _data:ByteArray;
		
		public function ServerMessage(type:int, proc:int, data:ByteArray)
		{
			_type = type;
			_proc = proc;
			_data = data;
		}
		
		public function get type():int
		{
			return _type;
		}
		
		public function get proc():int
		{
			return _proc;
		}
		
		public function get data():ByteArray
		{
			return _data;
		}
	}
}