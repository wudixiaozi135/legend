package com.view.gameWindow.panel.panels.onhook.states.fight
{
	import com.pattern.state.StateTimeMachine;
	
	
	/**
	 * 释放 自动 增益技能（在非战斗状态下也能释放）
	 * @author wqhk
	 * 2014-11-18
	 */
	public class AutoSkill extends  StateTimeMachine
	{
		public function AutoSkill()
		{
			super();
			
			interval = 200;//AutoJobManager.RIGOR_TIME;
		}
	}
}