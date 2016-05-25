package com.view.gameWindow.panel.panels.onhook.states.common
{
	import com.pattern.state.IIntention;
	import com.pattern.state.IState;
	
	
	/**
	 * @author wqhk
	 * 2014-12-27
	 */
	public class EmptyState implements IState
	{
		public function EmptyState()
		{
		}
		
		public function next(i:IIntention=null):IState
		{
			return this;
		}
	}
}