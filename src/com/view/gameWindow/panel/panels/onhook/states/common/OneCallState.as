package com.view.gameWindow.panel.panels.onhook.states.common
{
	import com.pattern.state.IIntention;
	import com.pattern.state.IState;
	
	import flash.utils.getTimer;
	
	
	/**
	 * @author wqhk
	 * 2015-2-15
	 */
	public class OneCallState implements IState
	{
		private var callback:Function;
		private var callbackParam:Array;
		private var nextState:IState;
		private var delayTime:int;
		private var time:int;
		public function OneCallState(callback:Function,callbackParam:Array,nextState:IState,delayTime:int)
		{
			this.callback = callback;
			this.callbackParam = callbackParam;
			this.nextState = nextState;
			this.delayTime = delayTime;
			
			time = getTimer();
		}
		
		public function next(i:IIntention=null):IState
		{
			var curT:int = getTimer();
			if(curT - time < delayTime)
			{
				return this;
			}
			if(callback != null)
			{
				callback.apply(null,callbackParam);
			}
			
			return nextState;
		}
	}
}