package com.view.gameWindow.panel.panels.guideSystem.action
{
	import com.view.gameWindow.panel.panels.task.TaskDataManager;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
	
	/**
	 * @author wqhk
	 * 2015-3-3
	 */
	public class RunNpcAction extends GuideAction
	{
		private var _npc:int;
		public function RunNpcAction(npcId:int)
		{
			_npc = npcId;
			super();
		}
		
		override public function act():void
		{
			super.act();
			
			if(TaskDataManager.instance.isFirstInit)
			{
				_isComplete = true;
			}
			else
			{
				AutoJobManager.getInstance().setAutoTargetData(_npc,EntityTypes.ET_NPC);
				_isComplete = true;
			}
		}
	}
}