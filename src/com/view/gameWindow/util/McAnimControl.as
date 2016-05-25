package com.view.gameWindow.util
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;
	
	/**
	 * @author wqhk
	 * 2014-8-25
	 * 
	 * 简单控制 flash中movieclip帧率
	 */
	public class McAnimControl extends Sprite
	{
		public var queue:Array;
		private var interval:Number;
		private var elapsed:Number;
		private var lastTime:Number;
		private var running:Boolean;
		public function McAnimControl(thisframeRate:int)
		{
			interval = 1000 / thisframeRate;
			queue = []; var mc:MovieClip;
		}
		
		
		public function reset():void
		{
			for each(var item:MovieClip in queue)
			{
				item.gotoAndStop(1);
			}
			
			queue = [];
			running = false;
			removeEventListener(Event.ENTER_FRAME,enterFrameHandler);
		}
		
		private function enterFrameHandler(e:Event):void
		{
			var time:int = getTimer();
			
			elapsed += time - lastTime;
			
			if(elapsed >= interval)
			{
				for each(var item:MovieClip in queue)
				{
					if(item.stage)
					{
						item.gotoAndStop((item.currentFrame+1)%(item.totalFrames+1));
					}
				}
				elapsed = 0;
			}
			
			lastTime = time;			
		}
		
		public function push(...args):void
		{
			for each(var item:MovieClip in args)
			{
				item.gotoAndStop(1);
				queue.push(item);
			}
			
			if(!running && queue.length>0)
			{
				lastTime = getTimer();
				elapsed = 0;
				addEventListener(Event.ENTER_FRAME,enterFrameHandler);
				running = true;
			}
		}
		
	}
}