package com.pattern.state
{
	import flash.utils.getTimer;
	
	/**
	 * interval (millisecond)
	 * @author wqhk
	 * 2014-9-29
	 */
	public class StateTimeMachine extends StateMachine
	{
		/**
		 * milli second
		 */
		public var interval:uint = 0;
		private var _lastTime:int = 0;
		public function StateTimeMachine(interval:uint = 0)
		{
			this.interval = interval;
			super();
		}
		
		
		override public function next(i:IIntention=null):IState
		{
			if(i)
			{
				_lastTime = getTimer();
				return super.next(i);
			}
			else if(interval>0)
			{
				var curTime:int = getTimer();
				if(curTime - _lastTime >= interval)
				{
					_lastTime = curTime;
					return super.next(null);
				}
				else
				{
					return curState;
				}
			}
			
			
			return super.next(null);
		}
	}
}