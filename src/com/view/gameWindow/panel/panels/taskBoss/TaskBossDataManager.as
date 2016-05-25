package com.view.gameWindow.panel.panels.taskBoss
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
	import com.model.business.gameService.serverMessageManager.subManages.ErrorMessageManager;
	import com.model.business.gameService.serverMessageManager.subManages.SuccessMessageManager;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.MonsterCfgData;
	import com.model.configData.cfgdata.TaskCfgData;
	import com.model.configData.cfgdata.TaskWantCfgData;
	import com.model.configData.cfgdata.TaskWantedDailyRewardCfgData;
	import com.model.consts.StringConst;
	import com.model.dataManager.DataManagerBase;
	import com.pattern.Observer.IObserver;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.task.TaskDataManager;
	import com.view.gameWindow.panel.panels.task.constants.TaskStates;
	import com.view.gameWindow.panel.panels.task.item.AutoTaskItem;
	import com.view.gameWindow.panel.panels.task.item.TaskItem;
	import com.view.gameWindow.panel.panels.task.linkText.LinkText;
	import com.view.gameWindow.panel.panels.vip.VipDataManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	
	import mx.utils.StringUtil;
	
	
	/**
	 * @author wqhk
	 * 2014-8-20
	 */
	public class TaskBossDataManager extends DataManagerBase implements IObserver
	{
		private static var _instance:TaskBossDataManager;
		public static function get instance():TaskBossDataManager
		{
			if(!_instance)
			{
				_instance = new TaskBossDataManager(new PrivateClass());
			}
			return _instance;
		}
		
		/**
		 * 总任务数
		 */
		public var num:int;
		public var listData:Vector.<TaskBossData>;
		public var progress:int;
		public var reward:int;
		
		public var totalProgress:int;
		public var totalProgressNum:int;
		public var progressRewardData:Vector.<TaskBossRewardData>;
		public var currentProgressCursor:int;
		private var _isRequestTaskData:Boolean = false;
		
		/**
		 * 已完成的任务数
		 */
		public function get numDone():int
		{
			var num:int = 0;
			for each(var item:TaskBossData in listData)
			{
				if(item.state == TaskStates.TS_DONE)
				{
					++num;
				}
			}
			
			return num;
		}
		
		public function get numCanDo():int
		{
			var num:int = 0;
			for each(var item:TaskBossData in listData)
			{
				if(item.state == TaskStates.TS_DONE)
				{
					continue;
				}
				
				if(item.costCfgData)
				{
					if(item.costCfgData.vip > 0)
					{
						if(!VipDataManager.instance.isInited || item.costCfgData.vip > VipDataManager.instance.lv)
						{
							continue;
						}
					}
//					continue;
				}
				
				++num
			}
			
			return num;
		}
		
		public function TaskBossDataManager(pc:PrivateClass)
		{
			super();
			if(!pc)
			{
				throw new Error("该类使用的单例模式");
			}
			
			DistributionManager.getInstance().register(GameServiceConstants.SM_TASK_SUBMITTED,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_TASK_WANTED_INFO,this);
//			DistributionManager.getInstance().register(GameServiceConstants.SM_TASK_RECEIVED,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_TASK_GIVEUPED,this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_QUICK_DONE_TASK,this);
			ErrorMessageManager.getInstance().register(GameServiceConstants.ERR_TASK_FAIL,this);
			
			var index:int = 0;
			progressRewardData = new Vector.<TaskBossRewardData>();
			var cfg:TaskWantedDailyRewardCfgData = ConfigDataManager.instance.taskWantedDailyReward(index);
			while(cfg)
			{
				var item:TaskBossRewardData = new TaskBossRewardData;
				item.cfgData = cfg;
				progressRewardData.push(item);
				cfg = ConfigDataManager.instance.taskWantedDailyReward(++index);
			}
			totalProgressNum = index;
			
			if(totalProgressNum>0)
			{
				totalProgress = progressRewardData[totalProgressNum-1].cfgData.reward_point;
			}
			
			TaskDataManager.instance.attach(this);
		}
		
		public function requestQuickDone(taskId:int):void
		{
			if(100 > BagDataManager.instance.goldUnBind)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.TIP_GOLD_NOT_ENOUGH);
			}
			else
			{
				var data:ByteArray = new ByteArray();
				data.endian = Endian.LITTLE_ENDIAN;
				data.writeInt(taskId);
				ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_QUICK_DONE_TASK,data);
			}
		}
		
		public function requestGetDailyReward(rewardPoint:int):void
		{
			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			data.writeInt(rewardPoint);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_TASK_WANTED_GET_DAILY_REWARD,data);
		}
		
		public function requestSubmitTask(id:int):void
		{
			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			data.writeInt(id);
			data.writeByte(1);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_SUBMIT_TASK,data);
		}
		
		public function requestTaskData():void
		{
			_isRequestTaskData = true;
			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			data.writeByte(0);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_QUERY_TASK_WANTED,data);
		}
		
		public function requestAcceptTask(id:int):void
		{
			var td:TaskBossData = findListDataById(id);
			if(td.costCfgData.vip > VipDataManager.instance.lv)
			{
//				Alert.show(StringUtil.substitute(StringConst.TASK_WANT_PANEL_CONDITION_VIP,td.costCfgData.vip));
				Alert.warning(StringConst.TASK_WANT_PANEL_0010);
			}
			else if(td.costCfgData.unbind_gold > BagDataManager.instance.goldUnBind)
			{
//				Alert.show(StringUtil.substitute(StringConst.TASK_WANT_PANEL_CONDITION_GOLD,td.costCfgData.bind_gold+td.costCfgData.unbind_gold));
				Alert.warning(StringConst.TASK_WANT_PANEL_0011);
			}
			else
			{
				var data:ByteArray = new ByteArray();
				data.endian = Endian.LITTLE_ENDIAN;
				data.writeInt(id);
				data.writeInt(0);
				ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_RECEIVE_TASK,data);
			}
		}
		
		public function requestCancelTask(id:int):void
		{
			var bossData:TaskBossData = findListDataById(id);
			
			if(bossData.costCfgData.unbind_gold>0)
			{
				Alert.show2(StringUtil.substitute(StringConst.TASK_WANT_PANEL_0005,
						bossData.costCfgData.unbind_gold),confirmCancel,id);
			}
			else
			{
				confirmCancel(id);
			}
		}
		
		private function confirmCancel(id:int):void
		{
			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			data.writeInt(id);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_GIVEUP_TASK,data);
		}
		
		public var newData:TaskBossData;
		
		override public function resolveData(proc:int, data:ByteArray):void
		{
			newData = null;
//			var lastAutoTask:Boolean = TaskDataManager.instance.autoTask;
			switch (proc)
			{
				case GameServiceConstants.CM_QUICK_DONE_TASK:
					PanelMediator.instance.closePanel(PanelConst.TYPE_TASK_TRANS);
					break;
				case GameServiceConstants.SM_TASK_WANTED_INFO:
//					if(_isRequestTaskData)
//					{
//						TaskDataManager.instance.autoTask = false;
//					}
					
					resolveList(data);
					break;
//				case GameServiceConstants.SM_TASK_RECEIVED:
////					PanelMediator.instance.closePanel(PanelConst.TYPE_TASK_BOSS);
//					resolveReceive(data);
//					break;
//				case GameServiceConstants.ERR_TASK_FAIL:
//					Alert.warning(StringConst.ERROR_PANEL_0001);
//					break;
				case GameServiceConstants.SM_TASK_GIVEUPED:
					resolveGiveUp(data);
					PanelMediator.instance.closePanel(PanelConst.TYPE_TASK_TRANS);
					break;
				case GameServiceConstants.SM_TASK_SUBMITTED:
					resolveTaskSubmitted(TaskDataManager.instance.taskCfg);
					break;
				
			}
			
			super.resolveData(proc,data);
//			TaskDataManager.instance.autoTask = lastAutoTask;
		}
		
		private function resolveTaskSubmitted(taskCfg:TaskCfgData):void
		{
			if(!taskCfg)
			{
				return;
			}
			
			/*var bossData:TaskBossData = findListDataById(taskCfg.id);
			
			if(bossData && bossData.costCfgData)
			{
				var time:int = 0;
				if(bossData.costCfgData.exp > 0)
				{
					UtilsTimeOut.dealTimeOut(StringConst.TIP_EXP+StringConst.COLON+bossData.costCfgData.exp,time);
				}
				
				if(bossData.costCfgData.gongxun_point > 0)
				{
					time += 700;
					UtilsTimeOut.dealTimeOut(StringConst.TIP_ACHI+StringConst.COLON+bossData.costCfgData.gongxun_point,time);
				}
				
				if(bossData.costCfgData.reward_point > 0)
				{
					time += 700;
					UtilsTimeOut.dealTimeOut(StringConst.TASK_WANT_PANEL_0003+StringConst.COLON+bossData.costCfgData.reward_point,time);
				}
				
				
			}*/
		}
		
		public function update(proc:int=0):void
		{
			if(proc == GameServiceConstants.SM_TASK_RECEIVED)
			{
				resolveReceive();
			}
			else if(proc == GameServiceConstants.SM_TASK_LIST)
			{
				if(doingTask)
				{
					setTaskTrace(doingTask.id,doingTask.progress);
				}
			}
		}
		
		public function clearInstance():void
		{
			
		}
		
		
		protected function resolveReceive():void
		{
			if(TaskDataManager.instance.taskCfg)
			{
				var id:int = TaskDataManager.instance.taskCfg.id;
				
				var boss:TaskBossData = findListDataById(id);
				
				if(boss)
				{
					boss.state = TaskStates.TS_DOING;
					
					newData = boss;
					doingTask = boss;
					
					notify(GameServiceConstants.SM_TASK_RECEIVED);
				}
			}
		}
		
//		protected function resolveReceive(data:ByteArray):void
//		{
//			var id:int = data.readInt();
//			
//			var boss:TaskBossData = findListDataById(id);
//			
//			if(boss)
//			{
//				boss.state = TaskStates.TS_DOING;
//				
//				newData = boss;
//				doingTask = boss;
//			}
//		}
		
		protected function resolveGiveUp(data:ByteArray):void
		{
			var id:int = data.readInt();
			
			var boss:TaskBossData = findListDataById(id);
			
			if(boss)
			{
				boss.state = TaskStates.TS_UNKNOWN;
				boss.progress = 0;
				
				newData = boss;
				
				if(doingTask.id == id)
				{
					doingTask = null;
				}
			}
			
			
			if(newData)
			{
				TaskDataManager.instance.resolveGiveUpTask(newData.id)
			}
		}
		
		public function findListDataById(id:int):TaskBossData
		{
			for each(var data:TaskBossData in listData)
			{
				if(data.id == id)
				{
					return data;
				}
			}
			
			return null;
		}
		
		
		public var doingTask:TaskBossData;
		protected function resolveList(data:ByteArray):void
		{
			listData = new Vector.<TaskBossData>();
			
			num = data.readByte();
			
			doingTask = null;
			for(var i:uint = 0; i < num; ++i)
			{
				var task:TaskBossData = new TaskBossData();
				task.id = data.readInt();
				
				task.level = data.readShort();
				task.state = data.readByte();
				task.progress = data.readInt();
				
				var taskCfg:TaskCfgData = ConfigDataManager.instance.taskCfgData(task.id);
				
				var taskItem:TaskItem = new TaskItem(task.id);
				taskItem.init();
				
				var condition:int = taskCfg.condition;
//				var requests:Array = taskCfg.request.split(":");
				
				task.monsterId = taskItem.elementId;//parseInt(requests[0]);
				task.monsterNum = taskItem.needNum;//parseInt(requests[1]);
				if(taskCfg.pre_hint)
				{
					var link:LinkText = new LinkText();
					link.init(taskCfg.pre_hint,false);
					task.preHint = link.htmlText;
					task.link = link;
				}
				
//				if(task.monsterId)
//				{
//					task.iconId = task.monsterId;
//				}
//				else
//				{
					task.iconId = task.id;
//				}
				
				if((task.state == 0 || task.state == TaskStates.TS_DOING) && task.progress >= task.monsterNum)
				{
					task.state = TaskStates.TS_CAN_SUBMIT;
				}
				
				if(task.state == TaskStates.TS_DOING || task.state == TaskStates.TS_CAN_SUBMIT)
				{
					doingTask = task;
					setTaskTrace(task.id,task.progress);
				}
				
				var monsterDic:Dictionary = ConfigDataManager.instance.monsterCfgDatas(task.monsterId);
				var monster:MonsterCfgData;
				for each(monster in monsterDic)
				{
					break;
				}
				if(monster)
				{
					task.monsterName = monster.name;
				}
				
				task.costCfgData = findTaskBossCfgData(task.id,task.level);// ConfigDataManager.instance.taskWantCfgData(task.id);
				
				listData.push(task);
			}
			
			progress = data.readInt();
			reward = data.readInt();
			
			for(var index:int = 0; index < progressRewardData.length; ++index)
			{
				var pd:TaskBossRewardData = progressRewardData[index];
				pd.isRewarded = reward & (1<<index);
			}
		}
		
		private function setTaskTrace(taskId:int,progress:int):void
		{
			var onDoingTasks:Dictionary = TaskDataManager.instance.onDoingTasks;
			if(!onDoingTasks)
			{
				return;
			}
			if(!onDoingTasks[taskId])
			{
				var taskItem:TaskItem = new TaskItem(taskId);
				taskItem.init();
				TaskDataManager.instance.onDoingTasks[taskId] = taskItem;
				taskItem.setProgressCount(progress);
				TaskDataManager.instance.refreshCanReceiveTask();
				
				//因为只有一个悬赏任务进行中，所以放这没关系
				var data:AutoTaskItem = new AutoTaskItem();
				data.taskId = taskId;
				data.state = taskItem.completed ? TaskStates.TS_CAN_SUBMIT : TaskStates.TS_DOING;
				
				notifyData(GameServiceConstants.SM_TASK_WANTED_INFO,[data]);
			}
		}
		
		public function findTaskBossCfgData(taskId:int,lv:int):TaskWantCfgData
		{
			var dic:Dictionary = ConfigDataManager.instance.taskWantCfgDatas(taskId);
			
			for each(var item:TaskWantCfgData in dic)
			{
				if(item.level == lv)
				{
					return item;
				}
			}
			
			return null;
		}
		
		public function get npcId():int
		{
			for each(var item:TaskBossData in listData)
			{
				var taskCfgData:TaskCfgData = ConfigDataManager.instance.taskCfgData(item.id);
				break;
			}
			return taskCfgData ? taskCfgData.start_npc : 0;
		}
	}
}

class PrivateClass{}