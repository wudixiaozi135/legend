package com.view.gameWindow.scene.shake
{
	import com.view.gameWindow.scene.shake.interf.IShaker;
	
	import flash.utils.clearInterval;
	import flash.utils.clearTimeout;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;

	public class ShakingManager
	{
		private static const _instance:ShakingManager= new ShakingManager();
		private var _target:IShaker;
		private var _maxDis:Number;
		private var _count:int=-1;
		private var _totlaCount:int=-1;
		private var _timeGap:Number;
		private var timer:uint;
		
		public static function getInstance():ShakingManager
		{
			return _instance;
		}
		
		public function shakeObj(target:IShaker,delay:int, maxDis:Number=30,count:Number=9,timeGap:Number=60):void
		{
			if(timer)
			{
				endShake();
			}
			
			_target=target;
			if(_target)
			{
				_maxDis=maxDis;
				_totlaCount=count;
				_count=count;
				_timeGap=timeGap;
				timer=setTimeout(startShake,delay);
			}
		}
		
		private function startShake():void
		{
			clearTimeout(timer);
			timer = setInterval(shaking, _timeGap);
		}
		
		private function shaking():void
		{
			var percent:Number=Math.sin(Math.PI*0.5*(_count/_totlaCount));
			if(_count%2==0)
			{
				percent=-1*percent;
			}
			_target.shake(percent*_maxDis*0.2, percent*_maxDis);
			_count--;
			if(_count<0)
			{
				endShake();
			}
		}
		
		private function endShake():void
		{
			clearInterval(timer);
			timer=0;
			_target.resetShake();
			_target=null;
			_maxDis=0;
			_count=-1;
			_totlaCount=-1;
			_timeGap=0;
		}
	}
}