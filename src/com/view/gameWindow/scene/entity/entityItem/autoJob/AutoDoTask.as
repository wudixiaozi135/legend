package com.view.gameWindow.scene.entity.entityItem.autoJob
{
	import com.view.gameWindow.mainUi.MainUiMediator;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.IPanelBase;
	import com.view.gameWindow.panel.panels.guideSystem.GuideSystem;
	import com.view.gameWindow.panel.panels.onhook.AutoSystem;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.specialRing.SpecialRingDataManager;
	import com.view.gameWindow.panel.panels.task.TaskAutoHandoverData;
	import com.view.gameWindow.panel.panels.task.TaskDataManager;
	import com.view.gameWindow.panel.panels.task.constants.TaskTypes;
	import com.view.gameWindow.scene.entity.EntityLayerManager;
	import com.view.gameWindow.scene.entity.constants.ActionTypes;
	
	import flash.utils.getTimer;

	public class AutoDoTask
	{
		public function AutoDoTask()
		{
		}
		
		public function resetIdleTime():void
		{
			lastIdleTime = 0;
		}
		
		private var lastIdleTime:int = 0;
		internal function doTask():void
		{
			var autoTask:Boolean = TaskDataManager.instance.autoTask;
			var isInAuto:Boolean = MainUiMediator.getInstance().autoSign ? MainUiMediator.getInstance().autoSign.isInAuto() : false;
			var isAuto:Boolean = AutoSystem.instance.isAuto();
			var roleLv:int = RoleDataManager.instance.lv;
			var reLv:int = RoleDataManager.instance.reincarn;
			var isDoingOther:Boolean = 
					EntityLayerManager.getInstance().firstPlayer ? EntityLayerManager.getInstance().firstPlayer.currentAcionId == ActionTypes.GATHER : false;//其实没什么用
			var isSelectingHero:Boolean = PanelMediator.instance.openedPanel(PanelConst.TYPE_HERO_CREATE) != null
											|| PanelMediator.instance.openedPanel(PanelConst.TYPE_HERO_WAKEUP) != null;
			var isSpecialRingPrompt:Boolean = PanelMediator.instance.openedPanel(PanelConst.TYPE_SPECIAL_RING_PROMPT) || SpecialRingDataManager.instance.isFlying;
			var isWelcome:Boolean = PanelMediator.instance.openedPanel(PanelConst.TYPE_WELCOME) != null;
			//增加 50级 以下  空闲玩家30秒自动开启任务
			if(reLv == 0 && roleLv < 60)
			{
				var isPlayerIdle:Boolean =
					EntityLayerManager.getInstance().firstPlayer ? 
					EntityLayerManager.getInstance().firstPlayer.currentAcionId == ActionTypes.IDLE || 
					EntityLayerManager.getInstance().firstPlayer.currentAcionId == ActionTypes.HURT: false;
				if(!isAuto && !isTaskPanelOpened && !isSpecialRingPrompt && !isSelectingHero && isPlayerIdle)
				{
//					if(!autoTask)
//					{
						if(lastIdleTime == 0)
						{
							lastIdleTime = getTimer();
						}
						var curTime:int = getTimer();
						if(curTime - lastIdleTime > 30000)
						{
							MainUiMediator.getInstance().taskTrace.resetAutoTaskInfo();
							TaskDataManager.instance.setAutoTask(true,"AutoDoTask::doTask0");
							autoTask = true;
						}
//					}
				}
				else
				{
					resetIdleTime();
				}
			}
			
			var hasTask:Boolean = TaskAutoHandoverData.hasTask();
			
			if(hasTask && autoTask && !isInAuto && !isAuto && !isTaskPanelOpened && !isSpecialRingPrompt && !isDoingOther && !isSelectingHero && !isWelcome)
			{
				TaskDataManager.instance.doAutoTask();
				resetIdleTime();
			}
		}
		
		private function get isTaskPanelOpened():Boolean
		{
			var manager:PanelMediator = PanelMediator.instance;
			var openedPanel:IPanelBase = null;
			var taskType:int = TaskAutoHandoverData.taskType();
			switch(taskType)
			{
				default:
					break;
				case TaskTypes.TT_MAIN:
					openedPanel = manager.openedPanel(PanelConst.TYPE_TASK_ACCEPT_COMPLETE);
					break;
				case TaskTypes.TT_ROOTLE:
				case TaskTypes.TT_MINING:
				case TaskTypes.TT_EXORCISM:
					openedPanel = manager.openedPanel(PanelConst.TYPE_TASK_STAR) || manager.openedPanel(PanelConst.TYPE_TASK_STAR_OVER);
					break;
				case TaskTypes.TT_REWARD:
					openedPanel = manager.openedPanel(PanelConst.TYPE_TASK_BOSS);
					break;
			}
			return Boolean(openedPanel);
		}
	}
}