package com.model.business.fileService
{
	import com.core.bind_t;
	
	import flash.utils.Dictionary;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;

	/**
	 * 同时只有一个在执行。调用complete后，才执行下一步。
	 */
	public class ThreadCall
	{
		private static const INTERVAL:int = 16;//16 20 50;
		
		private var _dict:Dictionary;
		private var _queue:Array;
		private var _doingKey:Object;
		private var _lastCallTime:int;
		private var _timeOutId:int = 0;
		
		public function ThreadCall()
		{
			_dict = new Dictionary(true);
			_queue = [];
		}
		
		public function complete(key:Object):void
		{
			destroy(key,true);
			traverseCall();
		}
		
		public function call(key:Object,func:Function,...args):void
		{
			var isExist:Boolean = Boolean(_dict[key]);
			
			var b:bind_t = new bind_t(func);
			if(args.length)
			{
				b.push.apply(null,args);
			}
			
			_dict[key] = b;
			
			if(!isExist)
			{
				_queue.push(key);
			}
			
			if(_queue.length == 1)
			{
				traverseCall();
			}
		}
		
		public function destroy(key:Object,silence:Boolean = false):void
		{
			var index:int = _queue.indexOf(key);
			
			if(index != -1)
			{
				_queue.splice(index,1);
			}
			
			delete _dict[key];
			
			if(!silence)
			{
				if(_doingKey == key)
				{
					traverseCall();
				}
			}
			
			if(_doingKey == key)
			{
				_doingKey = null;
			}
		}
		
		private function traverseCall():void
		{
			if(_queue.length)
			{
				if(isTooFast())
				{
					callLater();
					return;
				}
				
				var key:Object = _queue[0];
				if(key)
				{
					var b:bind_t = _dict[key];
					if(b)
					{
						_doingKey = key;
						clearCallLater();
						
//						trace("-------------------");
//						trace(getTimer() - testT);
//						testT = getTimer();
						
						b.call();
					}
				}
			}
		}
		
//		private var testT:int;
		
		private function callLater():void
		{
			if(_timeOutId == 0)
			{
				_timeOutId = setTimeout(traverseCall,INTERVAL);
			}
		}
		
		private function clearCallLater():void
		{
			if(_timeOutId)
			{
				clearTimeout(_timeOutId);
				_timeOutId = 0;
			}
			
			_lastCallTime = getTimer();
		}
		
		private function isTooFast():Boolean
		{
			var time:int = getTimer();
			
			return time - _lastCallTime < INTERVAL;
		}
	}
}