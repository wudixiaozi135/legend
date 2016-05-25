package com.view.gameWindow.panel.panels.onhook.states.pickUp
{
	import com.pattern.state.IIntention;
	import com.pattern.state.IState;
	import com.view.gameWindow.panel.panels.onhook.states.common.AxFuncs;
	import com.view.gameWindow.panel.panels.onhook.states.common.WaitingState;
	import com.view.gameWindow.scene.entity.entityItem.interf.IFirstPlayer;
	
	/**
	 * 动作打断的检测（如挖矿）
	 */
	public class CheckActionBreak implements IState
	{
		private var _action:int;
		private var _nextState:IState;
		public function CheckActionBreak(action:int,nextState:IState)
		{
			_action = action;
			_nextState = nextState ? nextState : new WaitingState();
		}
		
		public function next(i:IIntention=null):IState
		{
			var p:IFirstPlayer = AxFuncs.firstPlayer;
			
			if(p)
			{
				if(p.currentAcionId != _action)
				{
					return _nextState;
				}
			}
			
			return this;
		}
	}
}