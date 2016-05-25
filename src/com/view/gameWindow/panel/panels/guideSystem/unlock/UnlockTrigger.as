package com.view.gameWindow.panel.panels.guideSystem.unlock
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.TaskCfgData;
	import com.model.configData.cfgdata.UnlockCfgData;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.task.constants.TaskStates;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	
	import flash.utils.Dictionary;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	/**
	 * @author wqhk
	 * 2014-10-29
	 */
	public class UnlockTrigger implements IUnlockTrigger
	{
		private var list:Array;
		private var executeCallback:Function; //负责刚到某条件时执行
		private var setStateCallback:Function; //设置
		private var checkUnlockCallback:Function;//
		private var multiConditionList:Array;//
		private var completeTaskList:Array;
		
		private var curTaskId:int = 0;
		private var curTaskState:int;
		private var curLv:int = 0;
		private var isTaskFirstIn:Boolean = true; //登录的那次 不触发execute
		
		//有改动 改成 如果 execute 的情况则需要等待用户响应才会变状态！
		private var waitingUserOperationRecord:Dictionary;
		
		private var setOpenInfoPanelCallback:Function;
		public function UnlockTrigger(list:Array,executeCallback:Function,setStateCallback:Function,checkUnlockCallback:Function,setOpenInfoPanelCallback:Function = null)
		{
			this.list = list.concat();
			this.executeCallback = executeCallback;
			this.setStateCallback = setStateCallback;
			this.checkUnlockCallback = checkUnlockCallback;
			this.setOpenInfoPanelCallback = setOpenInfoPanelCallback;
			multiConditionList = [];
			waitingUserOperationRecord = new Dictionary();
		}
		
		
		private var equipTypeState:Dictionary = new Dictionary();
		public function updateEquipType(type:int,isOnFirstInit:Boolean = false):void
		{
			if(!equipTypeState[type])
			{
				equipTypeState[type] = 1;
				
				for each(var item:UnlockCfgData in list)
				{
					if(item.equip_type == 0)
					{
						continue;
					}
					if(checkUnlockCallback(item))
					{
						continue;
					}
					
					if(item.equip_type > 0 && item.equip_type == type)
					{
						if(!isOnFirstInit)
						{
							execute(item);
						}
						setState(item);
					}
				}
			}
		}
		
		public function updateTaskState(tid:int, tstate:int):void
		{
			if(tstate == TaskStates.TS_DOING || tstate == TaskStates.TS_CAN_SUBMIT || tstate == TaskStates.TS_DONE)
			{
				curTaskId = tid;
				curTaskState = tstate;
				
				var taskCfg:TaskCfgData = ConfigDataManager.instance.taskCfgData(tid);
				
				if(!taskCfg)
				{
					isTaskFirstIn = false;
					return;
				}
				
				//收集所有完成的任务，注意当任务很长会有性能消耗 之后要加判断
				//还有 不知道 星级任务之类的 有没影响
				completeTaskList = [];
				
				if(tstate == TaskStates.TS_DONE)
				{
					completeTaskList.push(tid);
				}
				
				if(hasPreTask(taskCfg))
				{
					var preTask:TaskCfgData = ConfigDataManager.instance.taskCfgData(taskCfg.pretask);
					
					while(hasPreTask(preTask))
					{
						completeTaskList.push(preTask.id);
						
						preTask = ConfigDataManager.instance.taskCfgData(preTask.pretask);
					}
				}
				
				for each(var item:UnlockCfgData in list)
				{
					if(item.equip_type > 0)
					{
						continue;
					}
					
					if(checkUnlockCallback(item))
					{
						continue;
					}
					
					if(item.task_id>=0)//有任务条件的情况
					{
						if(!isTaskFirstIn && item.task_id == curTaskId && item.task_state == curTaskState)//触发当前
						{
							if(item.lv <= roleLv)
							{
								execute(item);
							}
							else
							{
								pushLater(item);
							}
						}
						
						if(isAllConditionHit(item))
						{
							setState(item);
						}
					}
				}
				
				checkMultiCondition();
			}
			
			isTaskFirstIn = false;
		}
		
		private function execute(item:UnlockCfgData):void
		{
			if(item.lock_state == UnlockFuncId.STATE_UNLOCK && item.panel_id == UnlockFuncId.PANEL_ID_UNLOCK)
			{
				if(waitingUserOperationRecord[item.func_id])
				{
					return;
				}
				
				waitingUserOperationRecord[item.func_id] = item;
			}
			
			executeCallback(item);
		}
		
		private var timeId:int = 0;
		private function setState(item:UnlockCfgData):void
		{
			if(item.lock_state == UnlockFuncId.STATE_UNLOCK)
			{
				if(!waitingUserOperationRecord[item.func_id])
				{
					setStateCallback(item);
				}
			}
			else if(item.lock_state == UnlockFuncId.STATE_NONE)
			{
				if(item.panel_id == UnlockFuncId.PANEL_ID_INFO)
				{
					if(timeId != 0)
					{
						clearTimeout(timeId);
						timeId = 0;
					}
					
					timeId = setTimeout(callLaterAfterSetState,500,item);
				}
			}
		}
		
		private function callLaterAfterSetState(item:UnlockCfgData):void
		{
			if(timeId != 0)
			{
				clearTimeout(timeId);
				timeId = 0;
			}
			
			if(checkUnlockCallback(item))
			{
				return;
			}
			
			if(setOpenInfoPanelCallback!=null)
			{
				setOpenInfoPanelCallback(item);
			}
		}
		
		public function checkMultiCondition():void
		{
			if(curTaskId > 0 && curLv > 0)
			{
				var deleteList:Array = [];
				var index:int = 0;
				for each(var item:UnlockCfgData in multiConditionList)
				{
					if(isAllConditionHit(item))
					{
						execute(item);
						setState(item);
						deleteList.push(index);
					}
					
					++index;
				}
				
				for(var i:int = deleteList.length - 1; i >= 0; --i)
				{
					multiConditionList.splice(deleteList[i],1);
				}
			}
		}
		
		public function updateUserUnlockOperation(func_id:int):void//用户的解锁操作
		{
			var data:UnlockCfgData = waitingUserOperationRecord[func_id];
			if(data)
			{
				delete waitingUserOperationRecord[func_id];
				setState(data);
			}
		}
		
		public function updateLevelState(roleType:int, roleLevel:int, roleRe:int =0, isFirst:Boolean = true):void
		{
			if(roleType == EntityTypes.ET_PLAYER)
			{
				curLv = roleLevel;
				for each(var item:UnlockCfgData in list)
				{
					if(item.equip_type > 0)
					{
						continue;
					}
					
					if(checkUnlockCallback(item))
					{
						continue;
					}
					
					if(item.lv>0)//有等级条件的情况
					{
						if(isFirst && roleRe == 0 && item.lv == curLv)//触发当前
						{
							if(item.task_id>0)
							{
								if(isTaskHit(item))
								{
									execute(item);
								}
								else
								{
									pushLater(item);
								}
							}
							else
							{
								execute(item);
							}
						}
						
						if(isAllConditionHit(item))
						{
							setState(item);
						}
					}
				}
				
				checkMultiCondition();
			}
		}
		
		private function pushLater(item:UnlockCfgData):void
		{
			multiConditionList.push(item);
		}
		
		private function hasPreTask(cfg:TaskCfgData):Boolean
		{
			return cfg && cfg.pretask > 0 && cfg.pretask != cfg.id;
		}
		
		private function get roleLv():int
		{
			return RoleDataManager.instance.lv;
		}
		
		//现在不考虑转生
		private function get roleRe():int
		{
			return RoleDataManager.instance.reincarn;
		}
		
		private function isEnoughLv(value:int):Boolean
		{
			if(roleRe != 0)
			{
				return true;
			}
			return curLv > 0 ? value <= curLv : value <= roleLv;
		}
		
		private function isCompleteTask(taskId:int):Boolean
		{
			if(completeTaskList && completeTaskList.indexOf(taskId) != -1)
			{
				return true;
			}
			
			return false;
		}
		
		private function isTaskHit(item:UnlockCfgData):Boolean
		{
			return item.task_id == 0 || isCompleteTask(item.task_id) || (item.task_id == curTaskId && item.task_state >= curTaskState);
		}
		
		private function isAllConditionHit(item:UnlockCfgData):Boolean
		{
			return isTaskHit(item) && isEnoughLv(item.lv)
		}
	}
}