package com.view.gameWindow.common
{
	
	/**
	 * @author wqhk
	 * 2014-9-3
	 */
	public class CountCallback
	{
		private var _needNum:int;
		private var _count:int;
		private var _callback:Function;
		
		public function CountCallback(callback:Function,needNum:int)
		{
			_needNum = needNum;
			_count = 0;
			_callback = callback
		}
		
		public function call(...args):*
		{
			if(++_count == _needNum)
			{
				return _callback.apply(null,args);	
			}
		}
		
		public function reset():void
		{
			_count = 0;
		}
		
		public function destroy():void
		{
			reset();
			_callback = null;
		}
	}
}