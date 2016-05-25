package com.view.gameWindow.panel.panels.taskStar.data
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.TaskCfgData;
	import com.model.configData.cfgdata.TaskStarCostCfgData;
	import com.model.configData.cfgdata.VipCfgData;
	import com.model.consts.StringConst;
	import com.model.dataManager.DataManagerBase;
	import com.pattern.Observer.IObserver;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.task.TaskDataManager;
	import com.view.gameWindow.panel.panels.task.constants.TaskStates;
	import com.view.gameWindow.panel.panels.task.constants.TaskTypes;
	import com.view.gameWindow.panel.panels.task.item.AutoTaskItem;
	import com.view.gameWindow.panel.panels.task.item.TaskItem;
	import com.view.gameWindow.panel.panels.vip.VipDataManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.util.UtilNumChange;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	
	import mx.utils.StringUtil;

	/**
	 * 星级任务数据管理者类
	 * @author Administrator
	 */	
	public class PanelTaskStarDataManager extends DataManagerBase implements IObserver
	{
		private static var _instance:PanelTaskStarDataManager;
		public static function get instance():PanelTaskStarDataManager
		{
			if(!_instance)
			{
				_instance = new PanelTaskStarDataManager(new PrivateClass());
			}
			return _instance;
		}
		
		public function clearInstance():void
		{
			_instance = null;
		}
		
//		public static const NO_VIP_ADD:int = 2;
		public static const NUM_TOTAL:int = 20;
		public static const UP_STAR_COST:int = 2000;
		public static const NUM_COST:int = 98;//50000;
		public var isReal:int;//1字节有符号整形，是否真实的星级任务
		public var isNotFirstDay:int; //1字节有符号整形，是否 不是第一天
//		public var isFirst:Boolean = false;
//		public var needBuyAtFirst:Boolean = false;//需要改为 第一天完成初始的次数后 直接显示购买 //现在的处理方法是： count+=totalCount
		public var wajue_star:int;//，1字节有符号整形，挖掘的星级
		public var wajue_tid:int;//，4字节有符号整形，挖掘的当前任务
		public var caikuang_star:int;//，1字节有符号整形，采矿的星级
		public var caikuang_tid:int;//，4字节有符号整形，采矿的当前任务
		public var chumo_star:int;//，1字节有符号整形，除魔的星级
		public var chumo_tid:int;//，4字节有符号整形，除魔的当前任务
		public var setting:int;//1字节有符号整形，设置值
		public var count:int;//，1字节有符号整形，当日完成任务的数量
		public var totalCount:int = 10;
		public var tid:int;//，4字节有符号整形，当前任务id，或者之前完成的最后一个任务id
		public var level:int;//，2字节有符号整形，接该任务的等级
		public var state:int;//，1字节有符号整形，任务状态
		public var progress:int;//，4字节有符号整形，任务进度
		/**请求数据返回时回调函数*/
		public var callBack:Function = null;
		public var selectStar:int;//下拉框选中的星级

		public static const FULL_STAR:int = 10;//满星级
		public static var selectTid:int = -1;//默认没有选中
		public var selected:Boolean = false;//是否不再提示
		
		public var addNumSelected:Boolean  = false;//是否不再提示 vip消耗金币增加次数

		//星级任务修改后只有一条数据的任务ID
		public var newTid:int;
		public var oldStar:int;
		public var newStar:int;
		
		public function get isCostEnough():Boolean
		{
			var gold:int = BagDataManager.instance.goldUnBind;
			return gold >= PanelTaskStarDataManager.NUM_COST;
		}
		
		public function get isNumUseUp():Boolean
		{
			if(isReal)
			{
				return count >= NUM_TOTAL;
			}
			else
			{
				return count >= totalCount;
			}
		}
		
		public function get costDes():String
		{
//			var f:UtilNumChange = new UtilNumChange();
//			return f.changeNum(NUM_COST);
			return NUM_COST.toString();
		}
		
//		public function get numFree():int
//		{
//			return NO_VIP_ADD;
//		}
		
//		public function get numAdded():int
//		{
//			var vipData:VipCfgData;
//			var vipMgr:VipDataManager = VipDataManager.instance;
//			
//			if(vipMgr.lv > 0)
//			{
//				vipData = vipMgr.vipCfgData;
//				return vipData.add_task_star_num;
//			}
//			else
//			{
//				return NO_VIP_ADD;
//			}
//		}
		
		public function get isFullStar():Boolean
		{
			return newStar ==  FULL_STAR;
		}

		public function PanelTaskStarDataManager(pc:PrivateClass)
		{
			super();
			if(!pc)
			{
				throw new Error("该类使用的单例模式");
			}
//			var cfg:VipCfgData = ConfigDataManager.instance.vipCfgData(VipDataManager.instance.lv);
//			if (cfg)
//			{
//				totalCount += cfg.add_task_star_num;
//			}
			DistributionManager.getInstance().register(GameServiceConstants.SM_TASK_STAR_INFO,this);
//			DistributionManager.getInstance().register(GameServiceConstants.SM_TASK_RECEIVED,this);
//			DistributionManager.getInstance().register(GameServiceConstants.SM_TASK_SUBMITTED,this);
//			ErrorMessageManager.getInstance().register(GameServiceConstants.ERR_TASK_FAIL,this);
			TaskDataManager.instance.attach(this);
		}
		
		public function get isDoing():Boolean
		{
			return tid != 0;
		}
		
		public function request():void
		{
			_isRequestTaskData = true;
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_QUERY_TASK_STAR,byteArray);
		}
		
		override public function resolveData(proc:int, data:ByteArray):void
		{
//			var lastAutoTask:Boolean = TaskDataManager.instance.autoTask;
			switch(proc)
			{
				case GameServiceConstants.SM_TASK_STAR_INFO:
					readData(data);
					if(callBack != null)
					{
						callBack();
						callBack = null;
					}
					break;
//				case GameServiceConstants.SM_TASK_RECEIVED:
//					readReceivedData(data);
//					break;
//				case GameServiceConstants.SM_TASK_SUBMITTED:
//					dealSubmitted(data);
//					break;
//				case GameServiceConstants.ERR_TASK_FAIL:
//					dealFail();
//					break;
			}
			super.resolveData(proc, data);
//			TaskDataManager.instance.autoTask = lastAutoTask;
		}
		
		public function get isFree():int
		{
			if(isReal)
			{
				return count < 10 ? 1 : 0;
			}
			else
			{
				return count < 5 ? 1 : 0;
			}
		}
		
		private var _isRequestTaskData:Boolean = false;
		private function readData(data:ByteArray):void
		{
			isReal = data.readByte();
			isNotFirstDay = data.readByte();//not first day
			oldStar = newStar;
			wajue_star = data.readByte();
			wajue_tid = data.readInt();
			caikuang_star = data.readByte();
			caikuang_tid = data.readInt();
			chumo_star = data.readByte();
			chumo_tid = data.readInt();
			count = data.readByte();
			setting = data.readByte();
			tid = data.readInt();
			level = data.readShort();
			state = data.readByte();
			progress = data.readInt();
			trace("PanelTaskStarDataManager.readData wajue_star："+wajue_star+",wajue_tid："+wajue_tid+
				",\ncaikuang_star："+caikuang_star+",caikuang_tid："+caikuang_tid+
				",\nchumo_star："+chumo_star+",chumo_tid："+chumo_tid);
			trace("PanelTaskStarDataManager.readData 状态："+state+"进度："+progress+"任务id："+tid+"等级："+level+"当日次数："+count);
			
//			if(isReal != 0)
//			{
//				if(isFirst)
//				{
//					needBuyAtFirst = true;
//					isFirst = false;
//				}
//			}
//			else
//			{
//				if(isNotFirstDay == 0)
//				{
//					isFirst = true;
//				}
//			}
			
//			if(needBuyAtFirst)
//			{
//				count += totalCount;
//			}

			if (wajue_tid > 0)
				newTid = wajue_tid;
			if (caikuang_tid > 0)
				newTid = caikuang_tid;
			if (chumo_tid > 0)
				newTid = chumo_tid;

			if (wajue_star > 0)
				newStar = wajue_star;
			if (caikuang_star > 0)
				newStar = caikuang_star;
			if (chumo_star > 0)
				newStar = chumo_star;
			trace("oldStar: +++++++++++++++++++++" + oldStar,"newStar: +++++++++++++++++++++" + newStar);
			if(!tid)
			{
				return;
			}
			
			
//			if(_isRequestTaskData)
//			{
//				TaskDataManager.instance.autoTask = false;
//			}
			
			setTaskTrace(tid,progress);
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
				
				
				var data:AutoTaskItem = new AutoTaskItem();
				data.taskId = taskId;
				data.state = taskItem.completed ? TaskStates.TS_CAN_SUBMIT : TaskStates.TS_DOING;
				
				notifyData(GameServiceConstants.SM_TASK_STAR_INFO,[data]);
			}
		}
		
		private function readReceivedData(/*data:ByteArray*/):void
		{
//			var id:int = data.readInt();
			
			if(TaskDataManager.instance.taskCfg)
			{
				var id:int = TaskDataManager.instance.taskCfg.id;
				var taskCfg:TaskCfgData = ConfigDataManager.instance.taskCfgData(id);
				if(taskCfg &&( taskCfg.type == TaskTypes.TT_ROOTLE || taskCfg.type == TaskTypes.TT_MINING || taskCfg.type == TaskTypes.TT_EXORCISM))
				{
					if(tid)
					{
						TaskDataManager.instance.resolveGiveUpTask(tid);
					}
					
					tid = id;
					level = RoleDataManager.instance.lv;
					state = TaskStates.TS_DOING;
					progress = 0;
					
					notify(GameServiceConstants.SM_TASK_RECEIVED);
				}
			}
			request();
		}
		
		private function dealSubmitted(/*data:ByteArray*/):void
		{
			trace("PanelTaskStarDataManager.dealSubmitted 提交成功");
			trace("PanelTaskStarDataManager.dealSubmitted 状态："+state+"进度："+progress+"任务id："+tid+"等级："+level);
//			var taskCfgData:TaskCfgData = ConfigDataManager.instance.taskCfgData(tid);
			var taskCfgData:TaskCfgData = TaskDataManager.instance.taskCfg;
			if(!taskCfgData)
			{
				return;
			}
			
			if(taskCfgData.type == TaskTypes.TT_ROOTLE && taskCfgData.type == TaskTypes.TT_MINING && taskCfgData.type == TaskTypes.TT_EXORCISM)
			{
				PanelMediator.instance.switchPanel(PanelConst.TYPE_TASK_STAR_OVER);
				notify(GameServiceConstants.SM_TASK_SUBMITTED);
			}
		}
		
		private function dealFail():void
		{
			trace("PanelTaskStarDataManager.dealFail 失败");
		}
		
		public function get maxStar():int
		{
			return Math.max(wajue_star,caikuang_star,chumo_star);
		}
		
		public function get currentTaskName():String
		{
			var taskCfgData:TaskCfgData = ConfigDataManager.instance.taskCfgData(tid);
			if(!taskCfgData)
			{
				return "";
			}
			return taskCfgData.name;
		}
		
		public function get currentStar():int
		{
			var taskCfgData:TaskCfgData = ConfigDataManager.instance.taskCfgData(tid);
			if(!taskCfgData)
			{
				return 0;
			}
			var star:int;
			switch(taskCfgData.type)
			{
				default:
				case TaskTypes.TT_ROOTLE:
					star = wajue_star;
					break;
				case TaskTypes.TT_MINING:
					star = caikuang_star;
					break;
				case TaskTypes.TT_EXORCISM:
					star = chumo_star;
					break;
			}
			return star;
		}
		
		public function getStar(type:int):int
		{
			var star:int;
			switch(type)
			{
				default:
					star = 0;
					break;
				case TaskTypes.TT_ROOTLE:
					star = wajue_star;
					break;
				case TaskTypes.TT_MINING:
					star = caikuang_star;
					break;
				case TaskTypes.TT_EXORCISM:
					star = chumo_star;
					break;
			}
			return star;
		}

		/**星级任务是否有完成的*/
		public function get isComplete():Boolean
		{
			var taskCfgData:TaskCfgData = ConfigDataManager.instance.taskCfgData(tid);
			if(!taskCfgData)
			{
				return false;
			}
			var split:Array = taskCfgData.request.split(":");
			if(progress >= int(split[1]))
			{
				return true;
			}
			else
			{
				return false;
			}
		}

		public function get npcId():int
		{
			var taskId:int = caikuang_tid || chumo_tid || wajue_tid;
			var taskCfgData:TaskCfgData = ConfigDataManager.instance.taskCfgData(taskId);
			return taskCfgData ? taskCfgData.start_npc : 0;
		}
		
		public function update(proc:int=0):void
		{
			
			if(proc == GameServiceConstants.SM_TASK_RECEIVED)
			{
				readReceivedData();
			}
			else if(proc == GameServiceConstants.SM_TASK_SUBMITTED)
			{
				dealSubmitted();
			}
			else if(proc == GameServiceConstants.SM_TASK_LIST)
			{
				if(tid != 0)
				{
					setTaskTrace(tid,progress);
				}
			}
		}
		
		public function sendSetting(setting:int):void
		{
			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			data.writeByte(setting);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_SET_TASK_STAR,data);
		}

		public function sendData(multiples:int,isForce:Boolean = false):void
		{
			var taskStarCostCfgData:TaskStarCostCfgData;

			taskStarCostCfgData = ConfigDataManager.instance.taskStarCostCfgData(multiples);

			if (VipDataManager.instance.lv < taskStarCostCfgData.vip)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringUtil.substitute(StringConst.DGN_GOALS_004, taskStarCostCfgData.vip));
				return;
			}

			if(!isForce)
			{
				var moneyBind:int = BagDataManager.instance.coinBind;
				var moneyUnBind:int = BagDataManager.instance.coinUnBind;
				if (moneyBind + moneyUnBind < taskStarCostCfgData.coin)
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.TASK_STAR_PANEL_0030);
					return;
				}
			}

			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			var tid:int = PanelTaskStarDataManager.instance.tid;
			byteArray.writeInt(tid);
			byteArray.writeByte(multiples);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_SUBMIT_TASK, byteArray);
			//领取奖励后刷新下 后端后下发 SM_TASK_STAR_INFO
		}

		public static function getFrameIndex(tid:int):int
		{
			var frame:int;
			var cfg:TaskCfgData = ConfigDataManager.instance.taskCfgData(tid);
			if (cfg)
			{
				switch (cfg.type)
				{
					case TaskTypes.TT_EXORCISM:
						frame = 1;
						break;
					case TaskTypes.TT_MINING:
						frame = 2;
						break;
					case TaskTypes.TT_ROOTLE:
						frame = 3;
						break;
					default :
						frame = 1;
						break;
				}
			}
			return frame;
		}
	}
}
class PrivateClass{}