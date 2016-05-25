package com.view.gameWindow.panel.panels.onhook.states.quest
{
	import com.pattern.state.IIntention;
	import com.pattern.state.IState;
	import com.view.gameWindow.panel.panels.onhook.states.common.AxFuncs;
	import com.view.gameWindow.panel.panels.onhook.states.common.WaitingState;
	import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
	
	
	/**
	 * @author wqhk
	 * 2015-1-10
	 */
	public class DoQuestState implements IState
	{
		public function DoQuestState()
		{
		}
		
		public function next(i:IIntention=null):IState
		{
			AxFuncs.startAutoTask();
			return new WaitingState();
		}
	}
}