package com.view.gameWindow.panel.panels.onhook.states.common
{
	import com.pattern.state.IIntention;
	import com.pattern.state.IState;
	
	import flash.utils.getTimer;
	
	
	
	/**
	 * @author wqhk
	 * 2014-9-27
	 */
	public class CDState implements IState
	{
		private var _time:int;
		private var _nextState:IState;
		private var _second:Number;
		public function CDState(second:Number,nextState:IState)
		{
			_nextState = nextState;
			_time = getTimer();
			_second = second;
		}
		
		public function next(i:IIntention = null):IState
		{
			if(getTimer() - _time >= _second*1000)
			{
				return _nextState;
			}
			else
			{
				return this;
			}
		}
	}
}