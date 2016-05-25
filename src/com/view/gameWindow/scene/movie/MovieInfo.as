package  com.view.gameWindow.scene.movie
{
	public class MovieInfo
	{
		public var id:int;
		private var _data:String;
		private var _waitTime:int;
		private var _type:int;
			
		public function get data():String
		{
			return _data;
		}
		
		public function set data(value:String):void
		{
			_data = value;
		}
		
		public function get waitTime():int
		{
			return _waitTime;
		}
		
		public function set waitTime(value:int):void
		{
			_waitTime = value;
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