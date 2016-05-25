package com.view.gameWindow.panel.panels.onhook.states.pickUp
{
	import com.pattern.state.StateTimeMachine;
	
	
	/**
	 * 负责拾取 拾取完后继续自动战斗
	 * @author wqhk
	 * 2014-9-29
	 */
	public class AutoPickUp extends StateTimeMachine
	{
		public function AutoPickUp()
		{
			super();
			interval = 500;
		}
	}
}