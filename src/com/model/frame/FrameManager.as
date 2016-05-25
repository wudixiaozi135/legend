package com.model.frame
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	
	/**
	 *  帧管理
	 * @author jhj
	 */
	public class FrameManager
	{
		private static var _instance:FrameManager;
		
		private var _sprite:Sprite;
		
		private var _list:Vector.<IFrame>;
		
		private var _lastTime:int;
		
		public static function get instance():FrameManager
		{
			return _instance ||= new FrameManager();
		}
		
		public function FrameManager()
		{
			_sprite = new Sprite();
			_list = new Vector.<IFrame>();
		}
		
		public function addObj(frameObj:IFrame):void
		{
			if(_list.length == 0)
			{
				_lastTime = getTimer();
				_sprite.addEventListener(Event.ENTER_FRAME,onFrameHandler);
			}
				
			if(_list.indexOf(frameObj)>-1)
			{
				return;
			}
			
			_list.push(frameObj);
		}
		
		public function removeObj(frameObj:IFrame):void
		{
			var indexOf:int = _list.indexOf(frameObj);
			if(indexOf>-1)
			{
				_list.splice(indexOf,1);
			}
			
			if(_list.length == 0)
			{
				_sprite.removeEventListener(Event.ENTER_FRAME,onFrameHandler);
			}
		}
		
		private function onFrameHandler(event:Event):void
		{
			var nowTime:int = getTimer();
			var timeDiff:int = getTimer()-_lastTime;
			_lastTime = nowTime;
			
			for each(var obj:IFrame in _list)
			{
				obj.updateTime(timeDiff);
			}
		}
	}
}