package com.view.gameWindow.panel.panels.guideSystem.action
{
	import com.view.gameWindow.panel.panels.task.TaskDataManager;
	import com.view.gameWindow.panel.panels.task.constants.TaskStates;
	
	import flash.geom.Rectangle;
	
	
	/**
	 * @author wqhk
	 * 2014-10-31
	 */
	public class AttachIgnorePanelAction extends AttachPanelAction
	{
		private var _taskId:int;
		private var _taskState:int;
		public function AttachIgnorePanelAction(taskId:int,taskState:int,panelName:String="", tabIndex:int=-1, hitAreaType:int=0, hitArea:Rectangle=null, arrowRotation:int=0,hitAreaShow:int = 0)
		{
			_taskId = taskId;
			_taskState = taskState;
			
			super(panelName, tabIndex, hitAreaType, hitArea, arrowRotation,hitAreaShow);
		}
		
		override public function isIgnore():Boolean
		{
			var curState:int = TaskDataManager.instance.getTaskState(_taskId);
			if(curState == TaskStates.TS_DONE &&  curState != _taskState)
			{
				_isIgnore = true;
			}
			
			return _isIgnore;
		}
	}
}