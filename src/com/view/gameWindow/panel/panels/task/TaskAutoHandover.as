package com.view.gameWindow.panel.panels.task
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.TaskCfgData;
	import com.view.gameWindow.mainUi.subuis.tasktrace.EquipWearItem;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.IPanelBase;
	import com.view.gameWindow.panel.panels.dungeon.DgnDataManager;
	import com.view.gameWindow.panel.panels.dungeon.DgnGoalsDataManager;
	import com.view.gameWindow.panel.panels.guideSystem.GuideSystem;
	import com.view.gameWindow.panel.panels.onhook.AutoSystem;
	import com.view.gameWindow.panel.panels.onhook.states.common.FightPlace;
	import com.view.gameWindow.panel.panels.task.constants.TaskCondition;
	import com.view.gameWindow.panel.panels.task.constants.TaskStates;
	import com.view.gameWindow.panel.panels.task.constants.TaskTypes;
	import com.view.gameWindow.panel.panels.task.item.TaskItem;
	import com.view.gameWindow.panel.panels.task.linkText.LinkText;
	import com.view.gameWindow.panel.panels.task.linkText.item.LinkTextItem;
	import com.view.gameWindow.panel.panels.task.npctask.INpcTaskPanel;
	import com.view.gameWindow.panel.panels.taskBoss.TaskBossDataManager;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
	import com.view.gameWindow.scene.map.SceneMapManager;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	

	public class TaskAutoHandover
	{
		private var _timer:Timer;
		
		private var _taskId:int;
		
		public function TaskAutoHandover()
		{
			_timer = new Timer(10000);
		}
		
		public function startTimer():void
		{
			var autoTask:Boolean = TaskDataManager.instance.autoTask;
			if(!autoTask)
			{
				return;
			}
			var panel:IPanelBase = PanelMediator.instance.openedPanel(PanelConst.TYPE_TASK_ACCEPT_COMPLETE);
			if(panel)
			{
				_timer.addEventListener(TimerEvent.TIMER,timerHandle);
				_timer.start();
			}
		}
		
		private function timerHandle(evt:TimerEvent):void
		{
			stopTimer();
			
			TaskDataManager.instance.setAutoTask(false,"TaskAutoHandover::timerHandle");
			if(TaskDataManager.instance.getTaskState(_taskId) == TaskStates.TS_RECEIVABLE)
			{
				receiveHandle();
			}
			else if(TaskDataManager.instance.getTaskState(_taskId) == TaskStates.TS_CAN_SUBMIT)
			{
				completeHandle();
			}
		}
		
		private function receiveHandle():void
		{
			var taskCfg : TaskCfgData = ConfigDataManager.instance.taskCfgData(_taskId);					
			if (taskCfg.type == TaskTypes.TT_MAIN)
			{
				var taskPanelDataManager:TaskDataManager = TaskDataManager.instance;
				taskPanelDataManager.receiveTask(_taskId);
			}
			PanelMediator.instance.closePanel(PanelConst.TYPE_TASK_ACCEPT_COMPLETE);
		}
		
		private function completeHandle():void
		{
			var taskCfg : TaskCfgData = ConfigDataManager.instance.taskCfgData(_taskId);
			if (taskCfg.type == TaskTypes.TT_MAIN)
			{
				var taskPanelDataManager:TaskDataManager = TaskDataManager.instance;
				var taskItem:TaskItem = taskPanelDataManager.onDoingTasks[_taskId];
				if (taskItem.completed)
				{
					taskPanelDataManager.submitTask(_taskId);
				}
			}
			var mediator:PanelMediator = PanelMediator.instance;
			var panel:INpcTaskPanel = mediator.openedPanel(PanelConst.TYPE_TASK_ACCEPT_COMPLETE) as INpcTaskPanel;
			if(panel)
			{
				panel.doTaskSubmitFlyEffectT();
				mediator.closePanel(PanelConst.TYPE_TASK_ACCEPT_COMPLETE);
			}
		}
		
		public function stopTimer():void
		{
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER,timerHandle);
		}
		
		public function doAutoTask():void
		{
			var autoTask:Boolean = TaskDataManager.instance.autoTask;
			if(!autoTask)
			{
				return;
			}
			
//			var isInDgn:Boolean = DgnDataManager.instance.isInDgn;
//			if(isInDgn)
//			{
//				return;
//			}
			
			var isGuideStop:Boolean = GuideSystem.instance.isNeedStopAutoTask;
			if(isGuideStop)
			{
				return;
			}
			
			var link:LinkText = TaskAutoHandoverData.link;
			var taskId:int = TaskAutoHandoverData.taskId;
			var equipWear:EquipWearItem = TaskAutoHandoverData.equipWareLink;
			TaskAutoHandoverData.equipWareLink = null;
			if(equipWear && !equipWear.parent)
			{
				equipWear = null;
			}
			
			var isTaskReincarnLevelEnough:Boolean = TaskDataManager.instance.isTaskReincarnLevelEnough(taskId);
			if(!(equipWear || link) || !taskId || !isTaskReincarnLevelEnough)
			{
				return;
			}
			_taskId = taskId;
			
			if(!equipWear && link)
			{
				var linkItem:LinkTextItem = link.getItemById(1);
				if(!linkItem)
				{
					return;
				}
			}
			
			var tskCfg:TaskCfgData = ConfigDataManager.instance.taskCfgData(_taskId);
			if(tskCfg)
			{
				//如果没有可做的悬赏任务则返回。
				if(tskCfg.type == TaskTypes.TT_REWARD)
				{
					if(TaskBossDataManager.instance.numCanDo == 0)
					{
						return;
					}
				}
				
				TaskDataManager.instance.autoTaskType = tskCfg.type;
			}
			TaskDataManager.instance.resetAutoTaskFailFlag(_taskId);
			
			PanelMediator.instance.closePanel(PanelConst.TYPE_TASK_ACCEPT_COMPLETE);
			PanelMediator.instance.closePanel(PanelConst.TYPE_TASK_STAR);
			PanelMediator.instance.closePanel(PanelConst.TYPE_TASK_BOSS);
			TaskDataManager.instance.stopTimer();
			
			//穿装备的自动
			if(equipWear)
			{
				equipWear.doAuto();
				return;
			}
			if(linkItem.type == LinkTextItem.TYPE_TO_NPC)
			{
				AutoJobManager.getInstance().setAutoTargetData(linkItem.npcId,EntityTypes.ET_NPC);
			}
			else if(linkItem.type == LinkTextItem.TYPE_TO_MONSTER)
			{
				AutoSystem.instance.setTarget(linkItem.monsterId,EntityTypes.ET_MONSTER);
			}
			else if(linkItem.type == LinkTextItem.TYPE_TO_PLANT)
			{
				AutoJobManager.getInstance().setAutoTargetData(linkItem.plantId,EntityTypes.ET_PLANT);
			}
			else if(linkItem.type == LinkTextItem.TYPE_TO_MAP_MINE)
			{
//				var mapRegionCfgData:MapRegionCfgData = ConfigDataManager.instance.mapRegionCfgData(linkItem.regionId);
//				if(!mapRegionCfgData)
//				{
//					trace("TaskAutoHandover.doAutoTask() mapRegionCfgData:"+mapRegionCfgData);
//					return;
//				}
//				AutoJobManager.getInstance().setAutoFindPathPos(mapRegionCfgData.randomPoint,mapRegionCfgData.map_id);
				var mineTask:TaskItem = TaskDataManager.instance.getTaskItem(_taskId);
				if(mineTask)
				{
					var remainNum:int = mineTask.needNum - mineTask.currentNum;
					if(remainNum > 0)
					{
						AutoSystem.instance.setTarget(linkItem.regionId,EntityTypes.ET_MINE,remainNum);
					}
				}
			}
			else if(linkItem.type == LinkTextItem.TYPE_TO_DUNGEON)
			{
				if(!SceneMapManager.getInstance().isDungeon)
				{
					DgnGoalsDataManager.instance.requestTaskDungeon(_taskId);
				}
			}
			else if(linkItem.type == LinkTextItem.TYPE_TO_TELEPORT)
			{
				var taskItem:TaskItem = TaskDataManager.instance.onDoingTasks[_taskId];
				var taskCfg:TaskCfgData = ConfigDataManager.instance.taskCfgData(_taskId);
				
				//如果任务是通关副本，该任务没有完成，且玩家在该副本中，点击变成自动战斗
				if(taskItem && taskCfg && taskCfg.condition == TaskCondition.TC_DUNGEON)
				{
					if(!taskItem.completed && SceneMapManager.getInstance().isDungeon)
					{
						if(taskItem.elementId == DgnDataManager.instance.dungeonId)
						{
							if(!AutoSystem.instance.isAutoFight())
							{
								AutoSystem.instance.startAutoFight(FightPlace.FIGHT_PLACE_ALL);
							}
							
							return;
						}
					}
				}
				AutoJobManager.getInstance().setAutoTargetData(linkItem.teleportId,EntityTypes.ET_TELEPORTER);
			}
		}
	}
}