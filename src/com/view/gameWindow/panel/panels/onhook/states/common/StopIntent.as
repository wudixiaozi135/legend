package com.view.gameWindow.panel.panels.onhook.states.common
{
	import com.pattern.state.IIntention;
	import com.pattern.state.IState;
	
	
	/**
	 * @author wqhk
	 * 2014-9-28
	 */
	public class StopIntent implements IIntention
	{
		public function StopIntent()
		{
		}
		
		public function check(state:IState):IState
		{
			if(state is WaitingState)
			{
				return state;
			}
			else
			{
				return new WaitingState;
			}
			
//			else if(state is WaitingMoveStopState)
//			{
//				return state;
//			}
//			else
//			{
//				return new WaitingMoveStopState();
//			}
		}
	}
}