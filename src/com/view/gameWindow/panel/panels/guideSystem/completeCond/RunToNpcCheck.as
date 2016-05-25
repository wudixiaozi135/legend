package com.view.gameWindow.panel.panels.guideSystem.completeCond
{
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.panels.guideSystem.UICenter;
	import com.view.gameWindow.panel.panels.task.npctask.NpcTaskPanelData;
	import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
	
	/**
	 * @author wqhk
	 * 2014-12-10
	 */
	public class RunToNpcCheck implements ICheckCondition
	{
		private var _npc:int;
		public function RunToNpcCheck(npc:int)
		{
			_npc = npc;
		}
		
		public function toDo():void
		{
			
		}
		
		public function isDoing():Boolean
		{
			var isRunning:Boolean = AutoJobManager.getInstance().isRunningToNpc(_npc);
			
			var p:* = UICenter.getUI(PanelConst.TYPE_TASK_ACCEPT_COMPLETE);
			var isNpcOpen:Boolean = p && NpcTaskPanelData.npcId == _npc;
			
			return isRunning || isNpcOpen;
		}
		
		public function isComplete():Boolean
		{
			return false;
		}
		
		
		
		
	}
}