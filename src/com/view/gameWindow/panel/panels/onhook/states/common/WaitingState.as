package com.view.gameWindow.panel.panels.onhook.states.common
{
	import com.pattern.state.IIntention;
	import com.pattern.state.IState;
	
	
	/**
	 * @author wqhk
	 * 2014-9-28
	 */
	public class WaitingState implements IState
	{
		public function WaitingState()
		{
		}
		
		public function next(i:IIntention=null):IState
		{
			if(i)
			{
				return i.check(this);
			}
			else
			{
				return this;
			}
		}
	}
}