package com.core
{
	
	/**
	 * @author wqhk
	 * 2014-8-8
	 */
	public class bind_t
	{
		private var _func:Function;
		private var _params:Array;
		
		public function bind_t(func:Function,...params)
		{
			_func = func;
			_params = params;
		}
		
		public function push(param:*):void
		{
			_params.push(param);
		}
		
		public function pop():*
		{
			return _params.pop();
		}
		
		public function call():*
		{
			return _func.apply(null,_params);
		}
		
		public function destroy():void
		{
			_func = null;
			_params = null;
		}
	}
}