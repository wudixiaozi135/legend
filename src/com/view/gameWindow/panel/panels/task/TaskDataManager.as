package com.view.gameWindow.panel.panels.task
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
	import com.model.business.gameService.serverMessageManager.subManages.SuccessMessageManager;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.TaskCfgData;
	import com.model.consts.DungeonConst;
	import com.model.consts.StringConst;
	import com.model.dataManager.DataManagerBase;
	import com.model.dataManager.TeleportDatamanager;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.mainUi.subuis.chatframe.ChatDataManager;
	import com.view.gameWindow.mainUi.subuis.chatframe.MessageCfg;
	import com.view.gameWindow.mainUi.subuis.tasktrace.ITaskTrace;
	import com.view.gameWindow.mainUi.subuis.tasktrace.TaskTraceItemInfo;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.dungeon.DgnDataManager;
	import com.view.gameWindow.panel.panels.guideSystem.GuideSystem;
	import com.view.gameWindow.panel.panels.guideSystem.unlock.UnlockFuncId;
	import com.view.gameWindow.panel.panels.onhook.AutoSystem;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.task.constants.TaskCondition;
	import com.view.gameWindow.panel.panels.task.constants.TaskStates;
	import com.view.gameWindow.panel.panels.task.constants.TaskTypes;
	import com.view.gameWindow.panel.panels.task.item.AutoTaskItem;
	import com.view.gameWindow.panel.panels.task.item.TaskItem;
	import com.view.gameWindow.panel.panels.taskBoss.TaskBossDataManager;
	import com.view.gameWindow.panel.panels.taskStar.data.PanelTaskStarDataManager;
	import com.view.gameWindow.panel.panels.taskTrans.TaskTransData;
	import com.view.gameWindow.panel.panels.trailer.TrailerData;
	import com.view.gameWindow.panel.panels.trailer.TrailerDataManager;
	import com.view.gameWindow.scene.GameFlyManager;
	import com.view.gameWindow.scene.entity.EntityLayerManager;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.scene.stateAlert.TaskAlert;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;
	import com.view.newMir.NewMirMediator;
	
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	
	import mx.utils.StringUtil;

	public class TaskDataManager extends DataManagerBase
	{
		private static var _instance:TaskDataManager;
		
		public static function get instance():TaskDataManager
		{
			if(!_instance)
				_instance = new TaskDataManager(hideFun);
			return _instance;
		}
		private static function hideFun():void{}
		
		public function TaskDataManager(fun:Function)
		{
			super();
			if(fun != hideFun)
				throw new Error("该类使用单例模式");
			DistributionManager.getInstance().register(GameServiceConstants.SM_TASK_LIST, this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_TASK_PROGRESS, this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_TASK_RECEIVED, this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_TASK_SUBMITTED, this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_RECEIVE_TASK,this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_SUBMIT_TASK,this);
			
			_lastDoneMainTaskId = 0;
			_lastDoingMainTask = null;
			_autoTask = false;//默认不启动自动游戏
			_canReceiveTasks = new Dictionary();
			_autoTaskHandover = new TaskAutoHandover();
			virtualTasks = [];
		}
		
		public function clearInstance():void
		{
			_instance = null;
		}
		/**星级任务可接等级*/
		public var lvStar:int;
		/**星级任务可接转生次数*/
		public var reincarnStar:int;
		/**奖励任务可接等级*/
		public var lvReward:int;
		/**奖励任务可接转生次数*/
		public var reincarnReward:int;
		
		/**任务种类区分配置数据id*/
		public static const _typeMianTaskId:int = 10000,_typeStarTaskId:int = 20000,_typeRewardTaskId:int = 30000,_typeTDTaskId:int = 70000,_typeFBTaskId:int = 80000;
		public static const TYPE_VIRTUAL_TOWNER:int = 70000;
		public static const TYPE_VIRTUAL_DGN:int = 80000;
		/**解锁id*/
		private const _taskStarUnlockId:int = 115,_taskRewardUnlockId:int = 116;
		
		private var _currentTaksType:int ;//设置当前类别
		
		private var _onDoingTasks:Dictionary;//正在做的任务，元素是TaskItem
		private var _canReceiveTasks:Dictionary;//可接的任务，元素是TaskCfgData
		public var virtualTasks:Array;//非真实任务
		
		private var _doneTasks:Dictionary;//完成的任务
		private var _cannotReceiveTasks:Dictionary;//还不可接的任务
		private var _lastDoneMainTaskId:int;//当前主线任务，
		private var _lastDoingMainTask:TaskItem;//当前正在做的主线任务
		
		private var _taskCfg:TaskCfgData;//接收和完成当前任务配置
		
		private var _taskList : Vector.<TaskTraceItemInfo>;
		private var _autoTraceTaskId : int;
		private var _autoTraceTaskComplete : Boolean;
		
		private var _autoTask : Boolean;
		private var _autoTaskList : Vector.<AutoTaskItem>;
		private var _autoTaskType : int = 0;
		private var _autoTaskHandover:TaskAutoHandover;
		
		public var _hasReceiveTask:Boolean;
		public var _hasSubmitTask:Boolean;
		private var guideTaskList:Array = [];
		
		public function isVirtualType(type:int):Boolean
		{
			return type == TaskTypes.TT_DGN || type == TaskTypes.TT_TOWNER;
		}
		
		private var _isReceived:Boolean = false;
		private var _isProgress:Boolean = false;
		override public function resolveData(proc:int, data:ByteArray):void
		{
			switch (proc)
			{
				case GameServiceConstants.SM_TASK_LIST:
				{
					resolveInitData(data);
					resetTaskAutoTrace();
					break;
				}
				case GameServiceConstants.SM_TASK_PROGRESS:
				{
					_isProgress = true;
					resolveProgress(data);
					/*resetTaskAutoTrace();*/
					break;
				}
				case GameServiceConstants.SM_TASK_RECEIVED:
				{
					_isReceived = true;
					resolveReceiveTask(data);
					resetTaskAutoTrace();
					break;
				}
				case GameServiceConstants.SM_TASK_SUBMITTED:
				{
					resolveSubmitTask(data);
					resetTaskAutoTrace();
					break;
				}
				case GameServiceConstants.CM_RECEIVE_TASK:
					dealReceiveTask();
					trace("接受任务成功");
					break;
				case GameServiceConstants.CM_SUBMIT_TASK:
					dealSubmitTask();
					trace("提交任务成功");
					break;
			}
			EntityLayerManager.getInstance().refreshStaticNpcTaskEffect();
			super.resolveData(proc,data);
		}
		
		private function dealReceiveTask():void
		{
			_hasReceiveTask = true;
			if(_taskCfg && _taskCfg.receive_alert)
			{
				TaskAlert.getInstance().showMSG(CfgDataParse.pareseDesToStr(_taskCfg.receive_alert,0xfef5e3,3,24));
			}
		}
		
		private function dealSubmitTask():void
		{
			_hasSubmitTask = true;
			if(_taskCfg && _taskCfg.submit_alert)
			{
				TaskAlert.getInstance().showMSG(CfgDataParse.pareseDesToStr(_taskCfg.submit_alert,0xfef5e3,3,24));
			}
		}
		
		private function resolveInitData(data:ByteArray):void
		{
			var taskConfig:TaskCfgData;
			_cannotReceiveTasks = new Dictionary();
			_doneTasks = new Dictionary();
			
			var oldOnDoingTasks:Dictionary = _onDoingTasks;
			_onDoingTasks = new Dictionary();
			
			var allTaskCfgData:Dictionary = ConfigDataManager.instance.allTaskCfgData();
			for each (taskConfig in allTaskCfgData)
			{
				if(taskConfig.id != _typeMianTaskId && taskConfig.id != _typeStarTaskId && taskConfig.id != _typeRewardTaskId)
				{
					_cannotReceiveTasks[taskConfig.id] = taskConfig;
				}
			}
			var size:int = data.readShort();
			var lastDoneMainTaskId:int;
			_lastDoingMainTask = null;
			while (size-- > 0)
			{
				var taskId:int = data.readInt();
				var state:int = data.readByte();
				var progress:int = data.readShort();//刷新任务进度
				
				taskConfig = _cannotReceiveTasks[taskId];
				if(!taskConfig.pretask)
				{
					PanelMediator.instance.openPanel(PanelConst.TYPE_WELCOME);
				}
				if (taskConfig && state == TaskStates.TS_DOING || state == TaskStates.TS_CAN_SUBMIT)
				{
					var taskItem:TaskItem = null;
					if (oldOnDoingTasks)
					{
						taskItem = oldOnDoingTasks[taskId];
					}
					if (!taskItem)
					{
						taskItem = new TaskItem(taskId);
						taskItem.init();
					}
					else if (state == TaskStates.TS_CAN_SUBMIT)
					{
						taskItem.setCompleted(true, oldOnDoingTasks != null);
					}
					_onDoingTasks[taskId] = taskItem;
					if(taskConfig.id == TaskTypes.TT_MAIN)
					{
						delete _cannotReceiveTasks[taskId];
					}
					if (taskItem.completed && taskConfig.end_npc == 0)
					{
						submitTask(taskId);
					}
					if (taskConfig.type == TaskTypes.TT_MAIN)
					{
						_lastDoingMainTask = taskItem;
					}
					if (taskConfig.condition == TaskCondition.TC_PROTECT_CLIENT)
					{
						//SceneManager.getInstance().addSimulateFirstDartCar();
					}
				}
				else if (taskConfig && state == TaskStates.TS_DONE)
				{
					_doneTasks[taskId] = taskId;
					if (taskConfig.type == TaskTypes.TT_MAIN)
					{
						delete _cannotReceiveTasks[taskId];
						_lastDoneMainTaskId = taskId;
					}
				}
				
				taskItem = _onDoingTasks[taskId];
				
				if (taskItem)
				{
					taskItem.setProgressCount(progress);
					if (taskItem.completed)
					{
						taskConfig = ConfigDataManager.instance.taskCfgData(taskItem.id);
						if (taskConfig.end_npc == 0)//没有结束npc,完成直接交掉
						{
							submitTask(taskItem.id);
						}
					}
				}
				
				addGuideTask(taskId,taskItem && taskItem.completed ? TaskStates.TS_CAN_SUBMIT : state);
				
			}
			
			//放入了taskTrace中
//			processGuideTask(GameServiceConstants.SM_TASK_LIST);
			
			refreshCanReceiveTask(false);
			refreshTaskList();
			
			TaskDataManager.instance.setAutoTask(true,"task::init");
		}
		
		/**
		 * @return 长度是否更新
		 */
		public function refreshVirtualTasks():Boolean
		{
			var lastLen:int = 0;
			if(virtualTasks)
			{
				lastLen = virtualTasks.length;
			}
			virtualTasks.length = 0;
			
			var isUnlock:Boolean = GuideSystem.instance.isUnlock(UnlockFuncId.DUNGEON_TOWER);
			var dgnInfo:Object;
			if(isUnlock)
			{
				dgnInfo = DgnDataManager.instance.getDgnInfo(DungeonConst.FUNC_TYPE_TOWER);
				if(dgnInfo.num < dgnInfo.curMax)
				{
					var towner:TaskItem = new TaskItem(TYPE_VIRTUAL_TOWNER);
					towner.currentNum = dgnInfo.num;
					towner.needNum = dgnInfo.curMax
					virtualTasks.push(towner);
				}
			}
			
			isUnlock = GuideSystem.instance.isUnlock(UnlockFuncId.DUNGEON_EQUIP);
			if(isUnlock)
			{
				dgnInfo = DgnDataManager.instance.getDgnInfo(DungeonConst.FUNC_TYPE_NORMAL);
				if(dgnInfo.num < dgnInfo.curMax)
				{
					var dgn:TaskItem = new TaskItem(TYPE_VIRTUAL_DGN);
					dgn.currentNum = dgnInfo.num;
					dgn.needNum = dgnInfo.curMax
					virtualTasks.push(dgn);
				}
			}
			
			return virtualTasks.length != lastLen;
		}
		
		public function quickDoneHandle(taskId:int,taskType:int,pos:Array):void
		{
			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			data.writeInt(taskId);
			data.writeInt(taskType);
			if(pos)
			{
				data.writeInt(pos.length);
				for each(var p : Point in pos)
				{
					data.writeInt(p.x);
					data.writeInt(p.y);
				}
			}
			else
			{
				data.writeInt(0);
			}
		}
		
		public function isValidateTaskState(state:int):Boolean
		{
			if(state == TaskStates.TS_CAN_SUBMIT
				|| state == TaskStates.TS_DOING 
				|| state == TaskStates.TS_RECEIVABLE)
			{
				return true;
			}
			
			return false;
		}
		
		public function getTaskState(tid:int):int
		{
			//太多toString
//			if(_doneTasks.hasOwnProperty(tid.toString()))
//			{
//				return TaskStates.TS_DONE;
//			}
//			else if(_onDoingTasks.hasOwnProperty(tid.toString()))
//			{
//				return _onDoingTasks[tid].completed ? TaskStates.TS_CAN_SUBMIT : TaskStates.TS_DOING;
//			}
//			else if (_canReceiveTasks.hasOwnProperty(tid.toString()))
//			{
//				return TaskStates.TS_RECEIVABLE;
//			}
			
			if(_doneTasks && _doneTasks[tid])
			{
				return TaskStates.TS_DONE;
			}
			else if(_onDoingTasks && _onDoingTasks[tid])
			{
				return _onDoingTasks[tid].completed ? TaskStates.TS_CAN_SUBMIT : TaskStates.TS_DOING;
			}
			else if (_canReceiveTasks && _canReceiveTasks[tid])
			{
				return TaskStates.TS_RECEIVABLE;
			}
			else if(virtualTasks.length > 0)
			{
				for each(var item:TaskItem in virtualTasks)
				{
					if(item.id == tid)
					{
						return TaskStates.TS_RECEIVABLE;
					}
				}
			}
			
			return TaskStates.TS_NOT_RECEIVABLE;
		}
		
		public function get onDoingTasks():Dictionary
		{
			return _onDoingTasks;
		}
		
		public function get canReceiveTasks():Dictionary
		{
			return _canReceiveTasks;
		}
		
		public function refreshOnDoingTasks(showAlert:Boolean):void
		{
			for each (var taskItem:TaskItem in _onDoingTasks)
			{
				var complete:Boolean = taskItem.completed;
				taskItem.refresh(showAlert);
				
				if (taskItem.completed != complete)
				{
					var taskConfig:TaskCfgData = ConfigDataManager.instance.taskCfgData(taskItem.id);
					if (taskConfig.end_npc == 0)//没有结束npc,完成直接交掉
					{
						submitTask(taskItem.id);
					}
				}
			}
		}
		
		public var lastProgressUpdateTaskId:int = 0;//为自动任务增加判断条件。现在的任务是杀个任务怪就会下发所有正在做的任务进度， 如果多个task同时改变progress值时，会有误。
		private function resolveProgress(data:ByteArray):void
		{
			var size:int = data.readInt();
			while (size-- > 0)
			{
				var taskId:int = data.readInt();
				var count:int = data.readInt();
				
				var taskItem:TaskItem = _onDoingTasks[taskId];
				if (taskItem)
				{
					var completedTemp:Boolean = taskItem.completed;
					var progressTemp:int = taskItem.getProgressCount();
					
					taskItem.setProgressCount(count);
					
					if(progressTemp != count)
					{
						if(!completedTemp)
						{
							lastProgressUpdateTaskId = taskId;
						}
					}
					
				
					if(taskItem.completed && completedTemp != taskItem.completed)
					{
						var isPickUp:Boolean = AutoSystem.instance.isAutoPickUp();//在拾取时 ，不能打断
						AutoSystem.instance.stopAuto(!isPickUp);
//						AutoSystem.instance.stopAutoFight(FightPlace.FIGHT_PLACE_TASK);
					}
					
					//
					if (taskItem.completed)
					{
						trace("TaskDataManager.resolveProgress(data) taskId:"+taskId+" count:"+count);
						
						var taskConfig:TaskCfgData = ConfigDataManager.instance.taskCfgData(taskItem.id);
						if (taskConfig.end_npc == 0)//没有结束npc,完成直接交掉
						{
							submitTask(taskItem.id);
							addGuideTask(taskId,TaskStates.TS_DONE);
						}
						else
						{
							if(completedTemp != taskItem.completed)
							{
								addGuideTask(taskId,TaskStates.TS_CAN_SUBMIT);
							}
						}
					}
				}
			}
			
			processGuideTask(GameServiceConstants.SM_TASK_PROGRESS);
//			updateGuide();
		}
		
		
		private function resolveReceiveTask(data:ByteArray):void
		{
			var tid:int = data.readInt();
			var taskConfigs:Dictionary = ConfigDataManager.instance.allTaskCfgData();
			var taskConfig:TaskCfgData = taskConfigs[tid];
			_taskCfg = taskConfig;
			
			if(_taskCfg && _taskCfg.type == TaskTypes.TT_INSTRUCTION)
			{
				//押镖
				return;
			}
			var taskItem:TaskItem = _canReceiveTasks[tid];
			if (!taskItem)
			{
				taskItem = new TaskItem(tid);
			}
			delete _canReceiveTasks[tid];
			if(taskConfig.type == TaskTypes.TT_MAIN)
			{
				delete _cannotReceiveTasks[tid];
			}
			taskItem.init();
			_onDoingTasks[tid] = taskItem;
			if (taskConfig)
			{
				if (taskConfig.type == TaskTypes.TT_MAIN)
				{
					if(taskConfig.condition == TaskCondition.TC_PLAYER_LEVEL || taskConfig.condition == TaskCondition.TC_HERO_LEVEL)
					{
						taskItem.refresh(false);
					}
					_lastDoingMainTask = taskItem;
				}
				else if(taskConfig.type == TaskTypes.TT_REWARD)
				{
					delete _canReceiveTasks[_typeRewardTaskId];
				}
				else if(taskConfig.type == TaskTypes.TT_ROOTLE || taskConfig.type == TaskTypes.TT_MINING || taskConfig.type == TaskTypes.TT_EXORCISM)
				{
					delete _canReceiveTasks[_typeStarTaskId];
				}
			}
			if(_taskCfg && _taskCfg.transport_map != 0)
			{
				TaskTransData.taskId = _taskCfg.id;
				PanelMediator.instance.switchPanel(PanelConst.TYPE_TASK_TRANS);
				TaskDataManager.instance.setAutoTask(false,"task receive");
			}
			else
			{
				TaskDataManager.instance.setAutoTask(true,"task receive");
			}
			addGuideTask(tid,taskItem.completed ? TaskStates.TS_CAN_SUBMIT : TaskStates.TS_DOING);
			processGuideTask(GameServiceConstants.SM_TASK_RECEIVED);
			
//			restartAutoTask();
		}
		
		public function restartAutoTask():void
		{
			if(!isTransportMap)//只有没有自动传送的时候才开始自动任务
			{
				TaskDataManager.instance.setAutoTask(true,"task::restarAutoTask");
			}
			else
			{
				TaskDataManager.instance.setAutoTask(false,"task::restarAutoTask");
			}
		}
		
		public function get isTransportMap():Boolean
		{
			if(_taskCfg && _taskCfg.transport_map != 0)//只有没有自动传送的时候才开始自动任务
			{
				var state:int = getTaskState(_taskCfg.id);
				if(state == TaskStates.TS_DOING)
				{
					return true;
				}
			}
			
			return false;
		}
		
		private static var TYPE_STAR:Array = [TaskTypes.TT_EXORCISM,TaskTypes.TT_MINING,TaskTypes.TT_ROOTLE];
		
		public function isSameTaskType(type0:int,type1:int):Boolean
		{
			
			if(TYPE_STAR.indexOf(type0) != -1)
			{
				return TYPE_STAR.indexOf(type1) != -1;
			}
			else
			{
				return type0 == type1;
			}
			
			return true;
		}
		
		private function resolveSubmitTask(data:ByteArray):void
		{
			var tid:int = data.readInt();
			var trailerData:TrailerData = TrailerDataManager.getInstance().trailerData;
			if(trailerData.tid==tid)
			{
				var count:Number = trailerData.totalCount-trailerData.count;
				if(count>0)
				{
					Alert.show2(StringUtil.substitute(StringConst.TRAILER_STRING_38,count),function ():void
					{
						var tcfg:TaskCfgData=TrailerDataManager.getInstance().getTasktrailerCfg();
						if(tcfg)
						{
							TeleportDatamanager.instance.setTargetEntity(tcfg.start_npc,EntityTypes.ET_NPC);//这样设置了后 autoTask 有可能断掉 
							GameFlyManager.getInstance().flyToMapByNPC(tcfg.start_npc);//
						}
					},null,StringConst.TRAILER_HINT_STRING_003,StringConst.TRANS_PANEL_0031);
				}
			}
			var size:int;
			var taskItem:TaskItem = _onDoingTasks[tid];
			delete _onDoingTasks[tid];
			var taskConfig:TaskCfgData = ConfigDataManager.instance.taskCfgData(tid);
			_taskCfg = taskConfig;
			_doneTasks[tid] = tid;
			var submitTaskType:int = taskConfig.type;
			if (submitTaskType == TaskTypes.TT_MAIN)
			{
				_lastDoneMainTaskId = tid;
			}
			if (_lastDoingMainTask && _lastDoingMainTask.id == tid)
			{
				_lastDoingMainTask = null;
			}
			addGuideTask(tid,TaskStates.TS_DONE);
			processGuideTask(GameServiceConstants.SM_TASK_SUBMITTED);
			
			refreshCanReceiveTask();
			refreshTaskList();
		}
		
		public function resolveGiveUpTask(tid:int):void
		{
			var taskItem:TaskItem = _onDoingTasks[tid];
			delete _onDoingTasks[tid];
			var taskConfigs:Dictionary = ConfigDataManager.instance.allTaskCfgData();
			var taskConfig:TaskCfgData = taskConfigs[tid];
			_cannotReceiveTasks[tid] = taskConfig;
			
			addGuideTask(tid,TaskStates.TS_RECEIVABLE);
			processGuideTask(GameServiceConstants.SM_TASK_GIVEUPED);
			refreshCanReceiveTask();
		}
		
		public function refreshTaskList():void
		{
			var taskItem : TaskItem;
			var taskIds : Array;
			var tid : int;
			var taskConfig : TaskCfgData;
			var taskTraceItemInfo : TaskTraceItemInfo;
			var configDataManager : ConfigDataManager = ConfigDataManager.instance;
			_taskList = new Vector.<TaskTraceItemInfo>();
			for each(taskItem in _onDoingTasks)
			{
				taskConfig = configDataManager.taskCfgData(taskItem.id);
				if(taskConfig)
				{
					taskTraceItemInfo = new TaskTraceItemInfo();
					taskTraceItemInfo.taskId = taskItem.id;
					taskTraceItemInfo.taskType = taskConfig.type;
					taskTraceItemInfo.state = getTaskState(taskItem.id);
					_taskList.push(taskTraceItemInfo);
				}
			}
			
			for each(taskItem in canReceiveTasks)
			{
				taskConfig = configDataManager.taskCfgData(taskItem.id);
				if(taskConfig)
				{
					taskTraceItemInfo = new TaskTraceItemInfo();
					taskTraceItemInfo.taskId = taskItem.id;
					taskTraceItemInfo.taskType = taskConfig.type;
					taskTraceItemInfo.state = getTaskState(taskItem.id);
					_taskList.push(taskTraceItemInfo);
				}
			}
			
			if(_taskList.length > 1)
			{
				_taskList.sort(sortTaskItem);
			}
			/*if(PanelMediator.instance.taskPanel)
			{
				PanelMediator.instance.taskPanel.taskPanel.refreshData();
			}*/
			
//			updateGuide();
		}
		
		private function sortTaskItem(a:TaskTraceItemInfo,b:TaskTraceItemInfo):int
		{
			if(a.state >= TaskStates.TS_CAN_SUBMIT && b.state >= TaskStates.TS_CAN_SUBMIT)
			{
				if(a.taskType < b.taskType)
				{
					return -1;
				}
				else if(a.taskType > b.taskType)
				{
					return 1;
				}
				else if(a.taskId < b.taskId)
				{
					return -1;
				}
				else
				{
					return 1;
				}
			}
			else if(a.state >= TaskStates.TS_CAN_SUBMIT)
			{
				return -1;
			}
			else if(b.state >= TaskStates.TS_CAN_SUBMIT)
			{
				return 1;
			}			
			else if(a.taskType < b.taskType)
			{
				return -1;
			}
			else if(a.taskType > b.taskType)
			{
				return 1;
			}
			else if(a.state > b.state)
			{
				return -1;
			}
			else if(a.state < b.state)
			{
				return 1;
			}
			else if(a.taskId < b.taskId)
			{
				return -1;
			}
			else
			{
				return 1;
			}
		}
		
		public function getMainTaskId():int
		{
			for each(var info : TaskTraceItemInfo in _taskList)
			{
				if(info.taskType == TaskTypes.TT_MAIN)
				{
					return info.taskId;
				}
			}
			return 0;
		}
		/**判断转生次数及等级确定任务是否能接受*/
		public function isTaskReincarnLevelEnough(taskId:int):Boolean
		{
			var taskCfgData:TaskCfgData = ConfigDataManager.instance.taskCfgData(taskId);
			if(!taskCfgData)
			{
				return false;
			}
			var taskType:int = taskCfgData.type;
			var lv:int = taskType == TaskTypes.TT_MAIN ? taskCfgData.level : (taskType == TaskTypes.TT_REWARD ? lvReward : lvStar);
			var reincarn:int = taskType == TaskTypes.TT_MAIN ? taskCfgData.reincarn : (taskType == TaskTypes.TT_REWARD ? reincarnReward : reincarnStar);
			var checkReincarnLevel:Boolean = RoleDataManager.instance.checkReincarnLevel(reincarn,lv);
			return checkReincarnLevel;
		}
		
		public function checkNoCount(type:int):Boolean
		{
			switch(type)
			{
				case TaskTypes.TT_MINING:
					//return CycleTaskDataManager.getInstance().cycleTaskCount >= CycleTaskDataManager.TASK_CYCLE_DAILY_COUNT && CycleTaskDataManager.getInstance().buyRemainCount <= 0;
				default:
					return false;
			}
		}
		
		public function receiveTask(taskId:int):void
		{
			var data:ByteArray=new ByteArray();
			data.endian=Endian.LITTLE_ENDIAN;
			data.writeInt(taskId);
			data.writeInt(0);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_RECEIVE_TASK, data);
		}
		
		public function submitTask(taskId:int):void
		{
			var data:ByteArray=new ByteArray();
			data.endian=Endian.LITTLE_ENDIAN;
			data.writeInt(taskId);
			data.writeByte(0);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_SUBMIT_TASK, data);
		}
		
		public function giveupTask(taskId:int):void
		{
			var data:ByteArray=new ByteArray();
			data.endian=Endian.LITTLE_ENDIAN;
			data.writeInt(taskId);
		}
		
		public function setTaskCanSubmit(taskId:int):void
		{
			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			data.writeInt(taskId);
		}
		
		public function isItemNeed(itemId:int):Boolean
		{
			for each (var taskItem:TaskItem in _onDoingTasks)
			{
				var taskCfg:TaskCfgData = ConfigDataManager.instance.taskCfgData(taskItem.id);
				if(taskCfg.condition == 2)
				{
					var str:Array = taskCfg.request.split(':');
					if(str[0] == itemId.toString())
					{
						return true;
					}
				}
			}
			return false;
		}

		public function refreshCanReceiveTask(isUpdateGuide:Boolean = true):void
		{
			var roleDataManager:RoleDataManager = RoleDataManager.instance;
			var level:int = roleDataManager.lv;
			var job:int = roleDataManager.job;
			var configDataManager:ConfigDataManager = ConfigDataManager.instance;
			
			var lastDonemain_order:int = 0;
			var lastDoingmain_order:int = 0;
			if (_lastDoneMainTaskId > 0)
			{
				var lastDoneMainTaskConfig:TaskCfgData = configDataManager.taskCfgData(_lastDoneMainTaskId);
				lastDonemain_order = lastDoneMainTaskConfig.main_order;
			}
			else if (_lastDoingMainTask)
			{
				var lastDoingMainTaskConfig:TaskCfgData = configDataManager.taskCfgData(_lastDoingMainTask.id);
				lastDoingmain_order = lastDoingMainTaskConfig.main_order;
			}
			var taskItem:TaskItem;
			var taskConfig:TaskCfgData;
			var taskIdString:String;
			for (taskIdString in _canReceiveTasks)//删除过等级的可接任务
			{
				taskItem = _canReceiveTasks[taskIdString];
				delete _canReceiveTasks[taskIdString];
				taskConfig = configDataManager.taskCfgData(taskItem.id);
				_cannotReceiveTasks[taskIdString] = taskConfig;
			}
			var checkJobOther:Boolean,checkPreTask:Boolean,checkLv:Boolean;
			var doneDoingTaskStar:Boolean,minMaxLvCfgStar:TaskCfgData;
			var doneDoingTaskReward:Boolean,minMaxLvCfgReward:TaskCfgData;
			
			var isDoingStarTask:Boolean = PanelTaskStarDataManager.instance.isDoing;
			var isDoingRewardTask:Boolean = TaskBossDataManager.instance.doingTask != null;
			for each (taskConfig in _cannotReceiveTasks)
			{
				var preTaskConfig:TaskCfgData = ConfigDataManager.instance.taskCfgData(taskConfig.pretask);
				if (taskConfig.type == TaskTypes.TT_MAIN && !_lastDoingMainTask)
				{
					var checkJob : Boolean = (taskConfig.job == job || taskConfig.job == 0 || taskConfig.job == 100);
					if ((taskConfig.pretask == 0 && _lastDoneMainTaskId == 0 || _lastDoneMainTaskId > 0 && 
						(preTaskConfig && preTaskConfig.main_order <= lastDonemain_order) && taskConfig.main_order > lastDonemain_order) && checkJob && taskConfig.start_npc > 0)
					{
						taskItem = new TaskItem(taskConfig.id);
						_canReceiveTasks[taskConfig.id] = taskItem;
						delete _cannotReceiveTasks[taskConfig.id];
					}
				}
				else if(taskConfig.type == TaskTypes.TT_ROOTLE || taskConfig.type == TaskTypes.TT_MINING || taskConfig.type == TaskTypes.TT_EXORCISM)
				{
					if(!isDoingStarTask && isUnlockStar && !doneDoingTaskStar)
					{
						doneDoingTaskStar = /*_doneTasks[taskConfig.id] || */_onDoingTasks[taskConfig.id];
						checkJobOther = (taskConfig.job == job || taskConfig.job == 0 || taskConfig.job == 100);
						checkPreTask = (taskConfig.pretask == 0 || preTaskConfig && preTaskConfig.type == TaskTypes.TT_MAIN && 
							(preTaskConfig.main_order <= lastDonemain_order || preTaskConfig.main_order < lastDoingmain_order) || 
							preTaskConfig && preTaskConfig.type == taskConfig.type && _doneTasks[preTaskConfig.id]);
						checkLv = /*level >= taskConfig.level && */level <= taskConfig.max_level && (!minMaxLvCfgStar || minMaxLvCfgStar.max_level > taskConfig.max_level);
						if (checkPreTask && checkJobOther && taskConfig.start_npc > 0 && checkLv)
						{
							if(!_canReceiveTasks[_typeStarTaskId])
							{
								taskItem = new TaskItem(_typeStarTaskId);
								_canReceiveTasks[_typeStarTaskId] = taskItem;
								
								addGuideTask(_typeStarTaskId,TaskStates.TS_RECEIVABLE);
							}
							minMaxLvCfgStar = taskConfig;
							/*delete _cannotReceiveTasks[taskConfig.id];*/
						}
					}
					else
					{
						if(_canReceiveTasks[_typeStarTaskId])
						{
							delete _canReceiveTasks[_typeStarTaskId];
						}
					}
				}
				else if (taskConfig.type == TaskTypes.TT_REWARD)
				{
					if(isUnlockReward && !doneDoingTaskReward)
					{
						doneDoingTaskReward = /*_doneTasks[taskConfig.id] || */_onDoingTasks[taskConfig.id];
						checkJobOther = (taskConfig.job == job || taskConfig.job == 0 || taskConfig.job == 100);
						checkPreTask = (taskConfig.pretask == 0 || preTaskConfig && preTaskConfig.type == TaskTypes.TT_MAIN && 
							(preTaskConfig.main_order <= lastDonemain_order || preTaskConfig.main_order < lastDoingmain_order) || 
							preTaskConfig && preTaskConfig.type == TaskTypes.TT_REWARD && _doneTasks[preTaskConfig.id]);
						checkLv = /*level >= taskConfig.level && */level <= taskConfig.max_level && (!minMaxLvCfgReward || minMaxLvCfgReward.max_level > taskConfig.max_level);
						if (!isDoingRewardTask && checkPreTask && checkJobOther && taskConfig.start_npc > 0 && checkLv)
						{
							if(!_canReceiveTasks[_typeRewardTaskId])
							{
								taskItem = new TaskItem(_typeRewardTaskId);
								_canReceiveTasks[_typeRewardTaskId] = taskItem;
								
								addGuideTask(_typeRewardTaskId,TaskStates.TS_RECEIVABLE);
							}
							minMaxLvCfgReward = taskConfig;
							/*delete _cannotReceiveTasks[taskConfig.id];*/
						}
					}
					else
					{
						if(_canReceiveTasks[_typeRewardTaskId])
						{
							delete _canReceiveTasks[_typeRewardTaskId];
						}
					}
				}
			}
			lvStar = minMaxLvCfgStar ? minMaxLvCfgStar.level : 0;
			reincarnStar = minMaxLvCfgStar ? minMaxLvCfgStar.reincarn : 0;
			lvReward = minMaxLvCfgReward ? minMaxLvCfgReward.level : 0;
			reincarnReward = minMaxLvCfgReward ? minMaxLvCfgReward.reincarn : 0;
			
			if(isUpdateGuide)
			{
				processGuideTask(GameServiceConstants.SM_TASK_SUBMITTED);
			}
			
		}
		
		public function get taskList():Vector.<TaskTraceItemInfo>
		{
			if(!_taskList)
			{
				_taskList = new Vector.<TaskTraceItemInfo>();
			}
			return _taskList;
		}
		
		public function get taskItemStar():TaskItem
		{
			if(_canReceiveTasks[_typeStarTaskId])
			{
				return _canReceiveTasks[_typeStarTaskId];
			}
			return null;
		}
		
		public function get taskItemReward():TaskItem
		{
			if(_canReceiveTasks[_typeRewardTaskId])
			{
				return _canReceiveTasks[_typeRewardTaskId];
			}
			return null;
		}
		
		public function get isUnlockStar():Boolean
		{
			var isUnlock:Boolean = GuideSystem.instance.isUnlock(_taskStarUnlockId);
			return isUnlock;
		}
		
		public function get isUnlockReward():Boolean
		{
			var isUnlock:Boolean = GuideSystem.instance.isUnlock(_taskRewardUnlockId);
			return isUnlock;
		}
		
		public function taskAutoTrace(tid:int = 0, complete:Boolean=false):void
		{
		}
		
		public function refreshAutoTaskList(tid : int = 0):void
		{
			var oldList : Vector.<AutoTaskItem> = _autoTaskList;
			_autoTaskList = new Vector.<AutoTaskItem>();
			var taskItem : TaskItem;
			var autoTaskItem : AutoTaskItem;
			var taskConfig : TaskCfgData;
			var autoTask : AutoTaskItem;
			var oldItem : Boolean;
			for each(taskItem in _onDoingTasks)
			{
				taskConfig = ConfigDataManager.instance.taskCfgData(taskItem.id);
				if(taskConfig)
				{
					autoTaskItem = new AutoTaskItem();
					autoTaskItem.taskId = taskItem.id;
					autoTaskItem.state = getTaskState(taskItem.id);
					autoTaskItem.type = taskConfig.type;
					autoTaskItem.fail = false;
					if(autoTaskItem.taskId == tid)
					{
						autoTaskItem.click = true;
					}
					else
					{
						autoTaskItem.click = false;
					}
					
					for each(autoTask in oldList)
					{
						if(autoTask.taskId == taskItem.id)
						{
							autoTaskItem.fail = autoTask.fail;
						}
					}					
					_autoTaskList.push(autoTaskItem);
				}
			}
			
			for each(taskItem in _canReceiveTasks)
			{
				taskConfig = ConfigDataManager.instance.taskCfgData(taskItem.id);
				if(taskConfig)
				{
					autoTaskItem = new AutoTaskItem();
					autoTaskItem.taskId = taskItem.id;
					autoTaskItem.state = getTaskState(taskItem.id);
					autoTaskItem.type = taskConfig.type;
					autoTaskItem.fail = false;
					if(autoTaskItem.taskId == tid)
					{
						autoTaskItem.click = true;
					}
					else
					{
						autoTaskItem.click = false;
					}
					for each(autoTask in oldList)
					{
						if(autoTask.taskId == taskItem.id)
						{
							autoTaskItem.fail = autoTask.fail;
						}
					}		
					_autoTaskList.push(autoTaskItem);
				}
			}
			
			if(_autoTaskList.length > 1)
			{
				_autoTaskList.sort(sortAutoTaskList);
			}
			
			if(_autoTaskList.length > 0)
			{
				if(_autoTraceTaskId != _autoTaskList[0].taskId)
				{
					_autoTraceTaskId = _autoTaskList[0].taskId;
					
				}
				
				if(!_autoTaskList[0].fail)
				{
					taskAutoTrace(_autoTaskList[0].taskId);
				}
				else
				{
					_autoTraceTaskId = 0;
				}				
			}
			else
			{
			}
		}
		
		private function sortAutoTaskList(a:AutoTaskItem,b:AutoTaskItem):int
		{
			if(a.click)
			{
				return -1;
			}
			else if(b.click)
			{
				return 1;
			}
			else if(a.fail == true)
			{
				return 1;
			}
			else if(b.fail == true)
			{
				return -1;
			}
			else if((a.type == _autoTaskType) && (b.type == _autoTaskType))
			{
				if(a.state > b.state)
				{
					return -1;
				}
				else if(a.state < b.state)
				{
					return 1;
				}
				else if(a.taskId < b.taskId)
				{
					return -1;
				}
				else
				{
					return 1;
				}
			}
			else if(a.type == _autoTaskType)
			{
				return -1;
			}
			else if(b.type == _autoTaskType)
			{
				return 1;
			}
			else if(a.type < b.type)
			{
				return -1;
			}
			else if(a.type > b.type)
			{
				return 1;
			}
			else if(a.state > b.state)
			{
				return -1;
			}
			else if(a.state < b.state)
			{
				return 1;
			}
			else if(a.taskId < b.taskId)
			{
				return -1;
			}
			else
			{
				return 1;
			}
		}
		
		public function setAutoTaskFailFlag(tid:int):void
		{
			for each(var autoTaskItem : AutoTaskItem in _autoTaskList)
			{
				if(autoTaskItem.taskId == tid)
				{
					autoTaskItem.fail = true;
					autoTaskItem.click = false;
				}
			}
			
			if(_autoTaskList && _autoTaskList.length > 1)
			{
				_autoTaskList.sort(sortAutoTaskList);
			}
			
			if(_autoTaskList && _autoTaskList.length > 0)
			{
				if(_autoTraceTaskId != _autoTaskList[0].taskId)
				{
					_autoTraceTaskId = _autoTaskList[0].taskId;
					
				}
				
				if(!_autoTaskList[0].fail)
				{
					taskAutoTrace(_autoTaskList[0].taskId);
				}
				else
				{
					_autoTraceTaskId = 0;
				}				
			}
		}
		
		public function checkMainTaskDone(taskId : int):Boolean
		{
			var taskItem : TaskItem;
			var taskCfg : TaskCfgData;
			var taskConfig : TaskCfgData = ConfigDataManager.instance.taskCfgData(taskId);
			if(!taskConfig)
			{
				return false;
			}
			var order : int = taskConfig.main_order;
			
			var lastDoneTaskCfg : TaskCfgData = ConfigDataManager.instance.taskCfgData(_lastDoneMainTaskId);
			if(lastDoneTaskCfg && lastDoneTaskCfg.main_order >= order)
			{
				return true;
			}
			
			if(_lastDoingMainTask)
			{
				taskCfg = ConfigDataManager.instance.taskCfgData(_lastDoingMainTask.id);
				if(taskCfg && taskCfg.main_order > order)
				{
					return true;
				}
			}
			
			for each(taskItem in _canReceiveTasks)
			{
				taskCfg = ConfigDataManager.instance.taskCfgData(taskItem.id);
				if(taskCfg && taskCfg.type == TaskTypes.TT_MAIN)
				{
					taskConfig = ConfigDataManager.instance.taskCfgData(taskCfg.pretask);
					if(taskConfig && order <= taskConfig.main_order)
					{
						return true;
					}
					else
					{
						return false;
					}
				}
			}			
			return false;
		}
		
		public function resetAutoTaskFailFlag(tid : int = 0):void
		{
			_autoTaskList = null;
			refreshAutoTaskList(tid);
		}
		
		public function jumpTask():void
		{
			
		}		
		
		public function getCompleteCountByTaskType(type:int):int
		{
			switch(type)
			{
				case TaskTypes.TT_MINING:
					//return CycleTaskDataManager.getInstance().cycleTaskCount + 1;//完成协议先于任务列表协议接收，所以完成数量需+1
				case TaskTypes.TT_EXORCISM:
					//return KingdomTaskDataManager.getInstance().kingdomTaskCount + 1;
				case TaskTypes.TT_REWARD:
					//return FactionTaskDataManager.getInstance().factionTaskCount + 1;
				default:
					return 0;
			}
			return 0;
		}
		
		/**
		 * 当前正在做的任务信息
		 */
		public function getTaskItem(id:int):TaskItem
		{
			var re:TaskItem = _onDoingTasks ? _onDoingTasks[id] : null;
			if(!re)
			{
				re = _canReceiveTasks ? _canReceiveTasks[id] : null;
			}
			
			if(!re)
			{
				for each(var item:TaskItem in virtualTasks)
				{
					if(item.id == id)
					{
						re = item;
						break;
					}
				}
			}
			return re;
		}
		
		public function getClientTaskItem():TaskItem
		{
			var taskConfig : TaskCfgData;
			var configDataManager : ConfigDataManager = ConfigDataManager.instance;
			for each (var taskItem:TaskItem in _onDoingTasks)
			{
				taskConfig = configDataManager.taskCfgData(taskItem.id);
				if (taskConfig.condition == TaskCondition.TC_PROTECT_CLIENT)
				{
					return taskItem;
				}
			}
			
			return null;
		}
		
		public function isExpTaskOrigin(taskId:int):Boolean
		{
			if(taskId == _typeStarTaskId || taskId == _typeRewardTaskId)
			{
				return true;
			}
			
			return false;
		}
		
		public function isTaskNumEnough(taskId:int):Boolean
		{
			var currentNum:int;
			var needNum:int;
			
			var taskConfig:TaskCfgData = ConfigDataManager.instance.taskCfgData(taskId);
			
			if(taskConfig.type == TaskTypes.TT_MINING || taskConfig.type == TaskTypes.TT_ROOTLE || taskConfig.type == TaskTypes.TT_EXORCISM)
			{
//				currentNum = PanelTaskStarDataManager.instance.count;
//				needNum = PanelTaskStarDataManager.NUM_TOTAL;
//				
//				return needNum && currentNum >= needNum;
				
				return PanelTaskStarDataManager.instance.isNumUseUp;
			}
			else
			{
				var taskItem:TaskItem = getTaskItem(taskId);
				if(taskItem)
				{
					currentNum = taskItem.currentNum;
					needNum = taskItem.needNum;
					return needNum && currentNum >= needNum;
				}
			}
			
			return false;
		}
		
		public function get autoTraceTaskComplete():Boolean
		{
			return _autoTraceTaskComplete;
		}
		
		public function set autoTraceTaskComplete(value:Boolean):void
		{
			_autoTraceTaskComplete = value;
		}
		
		public function get autoTask():Boolean
		{
			return _autoTask;
		}
		
		public function setAutoTask(value:Boolean,caller:Object = null):void
		{
			//for test
//			var tip:String = caller + " set TaskDataManager::autoTask to "+value;
//			ChatDataManager.instance.sendNativeNotice(MessageCfg.CHANNEL_WOLD,tip);
			_autoTask = value;
		}
		
		public function get autoTaskList():Vector.<AutoTaskItem>
		{
			return _autoTaskList;
		}
		
		public function get autoTaskType():int
		{
			return _autoTaskType;
		}
		
		public function set autoTaskType(value:int):void
		{
			_autoTaskType = value;
		}
		
		public function doAutoTask():void
		{
			_autoTaskHandover.doAutoTask();
		}
		
		public function startTimer():void
		{
			_autoTaskHandover.startTimer();
		}
		/**
		 * 停止交接任务面板启动的定时器
		 */		
		public function stopTimer():void
		{
			_autoTaskHandover.stopTimer();
		}
		
		public function get lastDoneMainTaskId():int
		{
			return _lastDoneMainTaskId;
		}
		
		public function set lastDoneMainTaskId(value:int):void
		{
			_lastDoneMainTaskId = value;
		}
		
		public function get lastDoingMainTask():TaskItem
		{
			return _lastDoingMainTask;
		}
		
		public function set lastDoingMainTask(value:TaskItem):void
		{
			_lastDoingMainTask = value;
		}
		
		public function get currentTaksType():int
		{
			return _currentTaksType;
		}
		
		public function set currentTaksType(value:int):void
		{
			_currentTaksType = value;
		}
		
		public function addTask(type:int):void
		{
			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			data.writeInt(type);
			//DistributionManager.getInstance().sendData(GameServiceConstants.CM_BUY_TASK_COUNT, data);
		}
		
		private function resetTaskAutoTrace():void
		{
			var taskTrace:ITaskTrace = NewMirMediator.getInstance().gameWindow.mainUiMediator.taskTrace;
			if(taskTrace && TaskDataManager.instance.autoTask)
			{
				refreshAutoTaskList();
			}
		}
		
		public function addGuideTask(taskId:int,state:int):void
		{
			var data:AutoTaskItem = new AutoTaskItem();
			data.taskId = taskId;
			data.state = state;
			guideTaskList.push(data);
		}
		
		public function processGuideTask(proc:int):void
		{
			notifyData(proc,guideTaskList.concat());
			guideTaskList = [];
		}

		public function get taskCfg():TaskCfgData
		{
			return _taskCfg;
		}
		
		public function get isFirstInit():Boolean
		{
			return !_isReceived && !_isProgress;
		}
		
		public function get doingMainTask():TaskItem
		{
			var configDataManager:ConfigDataManager = ConfigDataManager.instance;
			var taskCfg:TaskCfgData;
			for each(var item:TaskItem in onDoingTasks)
			{
				taskCfg = configDataManager.taskCfgData(item.id);
				if(TaskTypes.isTypeMain(taskCfg.type))
				{
					return item;
				}
			}
			
			return null;
		}
		
		/**
		 * 主线任务是否在做其他类型的任务
		 */
		public function isMainDoingOtherTypeTask(type:int):Boolean
		{
			var main:TaskItem;
			var configDataManager:ConfigDataManager = ConfigDataManager.instance;
			var taskCfg:TaskCfgData;
			
			if(TaskTypes.isTypeReward(type))
			{
				if(doingMainTask)
				{
					taskCfg = configDataManager.taskCfgData(doingMainTask.id);
					if(taskCfg && taskCfg.condition == TaskCondition.TC_REWARD_TASK)
					{
						return true;
					}
				}
			}
			else if(TaskTypes.isTypeStar(type))
			{
				if(doingMainTask)
				{
					taskCfg = configDataManager.taskCfgData(doingMainTask.id);
					if(taskCfg && taskCfg.condition == TaskCondition.TC_STAR_TASK)
					{
						return true;
					}
				}
			}
			
			return false;
		}

	}
}