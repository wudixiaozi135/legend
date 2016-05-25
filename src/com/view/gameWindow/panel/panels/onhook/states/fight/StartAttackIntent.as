package com.view.gameWindow.panel.panels.onhook.states.fight
{
	import com.pattern.state.IIntention;
	import com.pattern.state.IState;
	
	
	/**
	 * @author wqhk
	 * 2014-9-29
	 */
	public class StartAttackIntent implements IIntention
	{
		private var isConsideRange:Boolean;
		
		public function StartAttackIntent(isConsideRange:Boolean = true)
		{
			this.isConsideRange = isConsideRange;
		}
		
		public function check(state:IState):IState
		{
			if(state is SelectEnemyState)
			{
				SelectEnemyState(state).isConsideRange = isConsideRange;
				return state;
			}
			else
			{
				return new SelectEnemyState(isConsideRange);
			}
		}
	}
}