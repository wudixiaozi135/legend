package com.view.gameWindow.mainUi.subuis.tasktrace
{
	import com.greensock.TweenLite;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.ActivityCfgData;
	import com.model.configData.cfgdata.TaskCfgData;
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.pattern.Observer.IObserver;
	import com.view.gameWindow.common.ButtonSelectWithLoad;
	import com.view.gameWindow.common.ModelEvents;
	import com.view.gameWindow.mainUi.MainUi;
	import com.view.gameWindow.mainUi.MainUiMediator;
	import com.view.gameWindow.mainUi.subclass.McTaskBar;
	import com.view.gameWindow.mainUi.subuis.activityTrace.ActivityDataManager;
	import com.view.gameWindow.mainUi.subuis.activityTrace.ActivityTrace;
	import com.view.gameWindow.mainUi.subuis.activityTrace.constants.ActivityFuncTypes;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.IPanelTab;
	import com.view.gameWindow.panel.panels.dungeon.DgnDataManager;
	import com.view.gameWindow.panel.panels.guideSystem.GuideSystem;
	import com.view.gameWindow.panel.panels.guideSystem.unlock.UIUnlockHandler;
	import com.view.gameWindow.panel.panels.guideSystem.unlock.UnlockFuncId;
	import com.view.gameWindow.panel.panels.guideSystem.view.IPanelNano;
	import com.view.gameWindow.panel.panels.onhook.AutoSystem;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.task.TaskAutoHandoverData;
	import com.view.gameWindow.panel.panels.task.TaskDataManager;
	import com.view.gameWindow.panel.panels.task.constants.TaskStates;
	import com.view.gameWindow.panel.panels.task.constants.TaskTypes;
	import com.view.gameWindow.panel.panels.task.item.TaskItem;
	import com.view.gameWindow.panel.panels.task.linkText.ILinkText;
	import com.view.gameWindow.panel.panels.taskBoss.TaskBossDataManager;
	import com.view.gameWindow.panel.panels.taskStar.data.PanelTaskStarDataManager;
	import com.view.gameWindow.panel.panels.trailer.TrailerDataManager;
	import com.view.gameWindow.util.scrollBar.IScrollee;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	
	import mx.utils.StringUtil;
	
	public class TaskTrace extends MainUi implements ITaskTrace, IScrollee, IObserver, IPanelTab, IPanelNano
	{
		public static const ALPHA:Number = 0.15;
		public static const TWEEN_TIME:Number = 1;
		private var _items:Vector.<TaskTraceItem>;
		private var _itemContainer : Sprite;
		private var _guideContainer : Sprite;
		/*private var _scrollBar : ScrollBar;
		private var _scrollRect:Rectangle;*/
		private var _contentHeight : int;
		
		private var _autoStartTimer : uint;
		private var _autoStart : Boolean;
		private var _itemIconVisible:Boolean=false;
//		private var instructionItems:Vector.<InstructionItem>;
		private var line:DelimiterLines;
		private var	_tab:ButtonSelectWithLoad;
		private var _activity:ActivityTrace;
		private var _tabIndex:int = -1;
		private var _unlock:UIUnlockHandler;
		
		private var deleteTaskList:Array = [];
		private var newTaskList:Array = [];
		private var nanoDict:Dictionary = new Dictionary();
		
		public function TaskTrace()
		{
			TaskDataManager.instance.attach(this);
			TaskBossDataManager.instance.attach(this);
			PanelTaskStarDataManager.instance.attach(this);
			RoleDataManager.instance.attach(this);
			TrailerDataManager.getInstance().attach(this);
		}
		
		public function resetAutoTaskInfo(taskId:int = 0):void
		{
			var re:TaskTraceItem = null;
			if(taskId != 0)
			{
				for each(var item:TaskTraceItem in _items)
				{
					if(item.taskId == taskId)
					{
						re = item;
						break;
					}
				}
			}
			else
			{
				if(_items.length > 0)
				{
					re = _items[0];
				}
			}
			if(re)
			{
				TaskAutoHandoverData.link = re.linkText;
				TaskAutoHandoverData.taskId = re.taskId;
				TaskAutoHandoverData.equipWareLink = re.equipWearLink;
			}
		}
		
		override public function initView():void
		{
			_skin = new McTaskBar();
			_skin.mcMask.mouseEnabled = false;
			var bg:MovieClip = _skin.mcBg as MovieClip;
			addChild(_skin);
			super.initView();
			addEventListener(MouseEvent.CLICK,clickHandle);
			
			if(!_itemContainer)
			{
				_itemContainer = new Sprite();
				_itemContainer.x = bg.x;
				_itemContainer.y = bg.y;
			}
			
			if(!_guideContainer)
			{
				_guideContainer = new Sprite();
				_guideContainer.mouseEnabled = false;
				_guideContainer.x = bg.x;
				_guideContainer.y = bg.y;
			}
			/*if(!_scrollRect)
			{
				_scrollRect = new Rectangle(0,0,bg.width,bg.height);
			}
			_itemContainer.scrollRect = _scrollRect;*/
			if(!_itemContainer.parent)
			{
				_skin.addChild(_itemContainer);
			}
			
			_activity = new ActivityTrace((_skin as McTaskBar).mcBg.width);
			_activity.x = bg.x;
			_activity.y = bg.y;
			_skin.addChild(_activity);
			
//			createInstructionItems();
			
			if(!_guideContainer.parent)
			{
				_skin.addChild(_guideContainer);
			}
			
			update();
			update(ModelEvents.UPDATE_MAP_ACTIVITY);
			
			addEventListener(MouseEvent.ROLL_OVER,rollOverHandler);
			addEventListener(MouseEvent.ROLL_OUT,rollOutHandler);
			
//			ExpStoneDataManager.instance.attach(this);
			DgnDataManager.instance.attach(this);
//			DailyDataManager.instance.attach(this);
			ActivityDataManager.instance.attach(this);
			hideBg();
		}
		
		private function createAutoGameItem():void
		{
			if(RoleDataManager.instance.lv<=0)return;
			if(autoGameItem)
			{
//				autoGameItem.parent&&autoGameItem.parent.removeChild(autoGameItem);
//				autoGameItem.destroy();
//				autoGameItem=null;
//				autoGameItem.updateText(RoleDataManager.instance.lv);
				autoGameItem.updateLv();
			}else
			{
				autoGameItem = new AutoGameItem();
			}
		}
		
		protected function rollOutHandler(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			hideBg();
		}
		
		protected function rollOverHandler(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			showBg();
		}
		private var _isBgShown:Boolean = true;
		private var _visionTween:TweenLite;
		public function showBg():void
		{
			if(_isBgShown)
			{
				return;
			}
			
			if(_visionTween )
			{
				_visionTween.kill();
			}
			
			_visionTween = TweenLite.to(_skin.mcBg,TWEEN_TIME,{alpha:1});
			_isBgShown = true;
			
		}
		
		public function hideBg():void
		{
			if(!_isBgShown)
			{
				return;
			}
			
			if(_visionTween )
			{
				_visionTween.kill();
			}
			_visionTween = TweenLite.to(_skin.mcBg,TWEEN_TIME,{alpha:ALPHA});
			_isBgShown = false;
			
		}
		
		private function updateUnlockState(id:int):void
		{
			if(id == UnlockFuncId.EXP_STONE 
				|| id == UnlockFuncId.BODYGUARD_TASK
				|| id == UnlockFuncId.DUNGEON_EQUIP 
				|| id == UnlockFuncId.DAILY_VIT)
			{
				updateInstructionItemsPos(_itemContainer,7,_contentHeight);
				/*if(_scrollBar)
				{
					_scrollBar.resetScroll();
				}*/
				updateBg();
			}
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var mcTaskBar:McTaskBar = _skin as McTaskBar;
			mcTaskBar.mcScrollBar.visible = false;//要去掉滚动条
			/*rsrLoader.addCallBack(mcTaskBar.mcScrollBar,function (mc:MovieClip):void//滚动条资源加载完成后构造滚动条控制类
			{
				if(!_scrollBar)
				{
					_scrollBar = new ScrollBar(_skin.parent as IScrollee,mc);
					_scrollBar.resetHeight(mcTaskBar.mcBg.height);
				}
			});*/
			
			rsrLoader.addCallBack(mcTaskBar.btnTask,function (mc:MovieClip):void
			{
				mcTaskBar.btnTask.mouseChildren = false;
				mcTaskBar.btnTask.mouseEnabled = false;
			});
			_tab = new ButtonSelectWithLoad(rsrLoader,mcTaskBar,["tabBtn0","tabBtn1"]);
			_tab.resetHandler = tabResetHandler;
			_tab.setLabelHandler = tabSetLableHandler;
			_tab.selectHandler = tabSelectHandler;
		}
		
		private function tabSetLableHandler(index:int,btn:*):void
		{
			btn.txt.text = index == 0 ? StringConst.TASK_TITLE0 : StringConst.TASK_TITLE1;
			_skin.addChild(btn);
		}
		
		private function tabResetHandler(btn:MovieClip):void
		{
			if(btn.hasOwnProperty("txt"))
			{
				TextField(btn.txt).textColor = 0x675138;
			}
		}
		
		private function tabSelectHandler(btn:MovieClip):void
		{
			var index:int = _tab.selectedIndex;
			var mcTaskBar:McTaskBar = _skin as McTaskBar;
			
			_activity.visible = index == 1 ? true : false;
			_itemContainer.visible = index == 0 ? true:false;
			
			if(btn.hasOwnProperty("txt"))
			{
				TextField(btn.txt).textColor = 0xffe1aa;
			}
			
			_tabIndex = index;
			
			updateBg();
		}
		
		private function updateBg():void
		{
			var mc:MovieClip = _skin.mcBg as MovieClip;
			mc.height = _tabIndex == 1 ? _activity.contentHeight : _contentHeight;
		}
		
		private function clickHandle(evt:MouseEvent):void
		{
			var mc:MovieClip = evt.target as MovieClip;
			var mcTask:McTaskBar = _skin as McTaskBar;
			var panelMediator:PanelMediator = PanelMediator.instance;
			switch(mc)
			{
				case mcTask.btnPickUp:
					pickUp();
					break;
				case mcTask.btnTask:
					panelMediator.switchPanel(PanelConst.TYPE_TASK_MAIN);
					break;
				case _activity.btn:
					ActivityDataManager.instance.cmLeaveActivityMap();
					break;
			}
            if(stage && stage.focus != stage)
			{
				stage.focus = stage;
            }
		}
		
		private function pickUp():void
		{
			/*var i:int,l:int,displayObject:DisplayObject;
			l = _skin.numChildren;
			for(i=0;i<l;i++)
			{
				displayObject = _skin.getChildAt(i);
				if(displayObject != _skin.btnPickUp && displayObject)
				{
					displayObject.visible = !_skin.btnPickUp.selected;
				}
			}*/
			_skin.mask = _skin.mask ? null : _skin.mcMask;
		}
		
		public function showHide(show:Boolean = true):void
		{
			this.visible = show;
		}
		
		public function get isShow():Boolean
		{
			return this.visible;
		}
		
		//今日玩法提示
//		private function createInstructionItems():void
//		{
//			instructionItems = new Vector.<InstructionItem>();
//			for(var i:int = 0; i < 5; ++i)
//			{
//				if(i == 2)
//				{
//					instructionItems.push(null);
//				}
//				else
//				{
//					var item:InstructionItem = InstructionItem.create(i+1);
//					instructionItems.push(item);
//					item.addEventListener(TextEvent.LINK,instructionLinkHandler,false,0,true);
//					item.addEventListener("cloudClick",cloudClickHandler,false,0,true);
//				}
//			}
//		}
		
		//今日玩法提示
//		private function cloudClickHandler(e:Event):void
//		{
//			var index:int = instructionItems.indexOf(e.target);
//			
//			if(index >= 0)
//			{
//				InstructionItem.cloudHandler(index+1);
//			}
//		}
		
//		//今日玩法提示
//		private function instructionLinkHandler(e:TextEvent):void
//		{
//			var index:int = instructionItems.indexOf(e.target);
//			
//			if(index >= 0)
//			{
//				InstructionItem.linkHandler(index+1);
//			}
//		}
		
//		private function updateInstructionItemPosAfterChange(item:InstructionItem):void
//		{
//			if(_separatePos != -1 && item.isVisibleChange)
//			{
//				updateInstructionItemsPos(_itemContainer,7,_separatePos);
//				updateBg();
//			}
//		}
		
		//今日玩法提示
		private function updateInstructionItemsPos(ctner:DisplayObjectContainer,startX:int,startY:int):void
		{
			var h:int = startY;
//			var count:int = 0;
			
//			for(var i:int = 0; i < instructionItems.length; ++i)
//			{
//				var item:InstructionItem = instructionItems[i];
//				
//				if(!item)
//				{
//					continue;
//				}
//				
//				if(item.isUnlock() && item.visible)
//				{
//					if(count == 0)
//					{
						if(!line)
						{
							line = new DelimiterLines();
							line.width = 173;
							var rsrLoader:RsrLoader = new RsrLoader();
							rsrLoader.load(line,ResourcePathConstants.IMAGE_TOOLTIP_FOLDER_LOAD,true);
							ctner.addChild(line);
						}
						
						line.x = startX;
						line.y = startY + 2;
						h += 14;
//						h = startY;
//					}
//					
//					item.x = startX;
//					item.y = startY + count*item.height;
//					
//					h = item.y + item.height;
//					item.updateFlyVisible();
//					
//					item.isVisibleChange = true;
//					ctner.addChild(item);
//					
//					++count;
//				}
//			}
			if(autoGameItem)
			{
				autoGameItem.x = startX;
				autoGameItem.y = h ;
//				autoGameItem.y = startY + count*item.height;
				h = autoGameItem.y + autoGameItem.height;
				if(autoGameItem.parent!=ctner)
				{
					autoGameItem.parent&&autoGameItem.parent.removeChild(autoGameItem);
					ctner.addChild(autoGameItem);
				}
			}
			_contentHeight = h + 5;
		}
		
		public function checkActivity():void
		{
			var mcTaskBar:McTaskBar = _skin as McTaskBar;
			var actvCfgDt:ActivityCfgData = ActivityDataManager.instance.currentActvCfgDtAtMap;
			var checkReincarnLevel:Boolean = actvCfgDt ? RoleDataManager.instance.checkReincarnLevel(actvCfgDt.reincarn,actvCfgDt.level) : false;
			var isUnlock:Boolean = GuideSystem.instance.isUnlock(UnlockFuncId.ACT_TIP);
			if(actvCfgDt && checkReincarnLevel)
			{
				mcTaskBar.tabBtn0.visible = true;
				mcTaskBar.tabBtn1.visible = true;
				mcTaskBar.headTxt.visible = false;
				if(isUnlock)
				{
					setTabIndex(1);
				}
			}
			else
			{
				if(!StringUtil.trim(mcTaskBar.headTxt.text))
				{
					mcTaskBar.headTxt.text = StringConst.TASK_TITLE0;
				}
				/*trace("TaskTrace.checkActivity() mcTaskBar.headTxt.text"+mcTaskBar.headTxt.text);*/
				
				mcTaskBar.headTxt.visible = true;
				mcTaskBar.tabBtn0.visible = false;
				mcTaskBar.tabBtn1.visible = false;
				setTabIndex(0);
			}
			//
			showExtraUI(actvCfgDt);
		}
		
		private function showExtraUI(cfgDt:ActivityCfgData):void
		{
			if(cfgDt)
			{
				switch(cfgDt.func_type)
				{
					case ActivityFuncTypes.AFT_SEA_SIDE:
						AutoSystem.instance.pause();
						PanelMediator.instance.openPanel(PanelConst.TYPE_SEA_FEAST_BTNS);
						(MainUiMediator.getInstance().heroHead as DisplayObject).visible = false;
						break;
					default:
						outUI();
						break;
				}
			}
			else
			{
				outUI();
			}
			function outUI():void
			{
				AutoSystem.instance.resume();
				PanelMediator.instance.closePanel(PanelConst.TYPE_SEA_FEAST_BTNS);
				(MainUiMediator.getInstance().heroHead as DisplayObject).visible = true;
			}
		}
		
		private var _lastAutoTaskId:int = 0; //前一次自动引导的任务
		private var _lastAutoState:int = 0;
		private var _lastAutoTaskType:int = 0;
		//会触发多次,需要修改

		private var autoGameItem:AutoGameItem;
		public function update(proc:int = 0):void
		{
			if(proc == ModelEvents.UPDATE_MAP_ACTIVITY)
			{
				checkActivity();
				return;
			}
			
			if(proc == GameServiceConstants.SM_ENTER_DUNGEON 
				|| proc == GameServiceConstants.SM_LEAVE_DUNGEON
				|| proc==GameServiceConstants.SM_TASK_TRAILER_INFO)
			{
				return;
			}
			
			//经验玉 次数
//			if(proc == GameServiceConstants.SM_DAILY_USE_EXPYU_NUM 
//				|| proc == GameServiceConstants.CM_USE_EXPYU)
//			{
//				instructionItems[0].setNum(ExpStoneDataManager.instance.numUse,ExpStoneDataManager.instance.numTotal);
//				updateInstructionItemPosAfterChange(instructionItems[0]);
//				return;
//			}
			
//			if(proc==GameServiceConstants.SM_TASK_TRAILER_INFO)
//			{	
//				var trailerData:TrailerData = TrailerDataManager.getInstance().trailerData;	
//				if(trailerData.state!=TaskStates.TS_DOING&&trailerData.state!=TaskStates.TS_CAN_SUBMIT)
//				{
//					instructionItems[1].updateText(StringConst.GOLD_COIN,"",StringConst.INSTRUCTION_1);
//					instructionItems[1].isFly=true;
//					instructionItems[1].updateFlyVisible();
//				}
//				else
//				{
//					var cfgData:TaskCfgData = TrailerDataManager.getInstance().getTasktrailerCfg();
//					var npcCfgData:NpcCfgData = ConfigDataManager.instance.npcCfgData(cfgData.end_npc);
//					instructionItems[1].updateText(StringConst.TRAILER_HINT_STRING_010,"",npcCfgData.name);
//					instructionItems[1].isFly=false;
//					instructionItems[1].updateFlyVisible();
//				}
//				instructionItems[1].setNum(trailerData.count,trailerData.totalCount);
//				updateInstructionItemPosAfterChange(instructionItems[1]);
//				return;
//			}
			
//			if(proc == GameServiceConstants.SM_CHR_DUNGEON_INFO 
//				|| proc == GameServiceConstants.SM_ENTER_DUNGEON 
//				|| proc == GameServiceConstants.SM_LEAVE_DUNGEON
//				|| proc == GameServiceConstants.SM_CHR_INFO)
//			{
//				if(proc == GameServiceConstants.SM_CHR_DUNGEON_INFO || proc == GameServiceConstants.SM_CHR_INFO)
//				{
////					var dgn:Object = DgnDataManager.instance.getDgnInfo(DungeonConst.FUNC_TYPE_NORMAL);
////					instructionItems[2].setNum(dgn.num,dgn.curMax);
//					var dgn:Object = DgnDataManager.instance.getDgnInfo(DungeonConst.FUNC_TYPE_TOWER);
//					instructionItems[4].setNum(dgn.num,dgn.curMax);
////					updateInstructionItemPosAfterChange(instructionItems[2]);
//					updateInstructionItemPosAfterChange(instructionItems[4]);
//				}
//				else if(proc == GameServiceConstants.SM_ENTER_DUNGEON)
//				{
//					DgnDataManager.instance.queryChrDungeonInfo();
//				}
//				
//				if(proc != GameServiceConstants.SM_CHR_INFO)
//				{
//					return;
//				}
//			}
			
//			if(proc == GameServiceConstants.SM_DAILY_INFO 
//				|| proc == GameServiceConstants.CM_GET_DAILY_VIT_REWARD)
//			{
//				if(proc == GameServiceConstants.SM_DAILY_INFO)
//				{
//					var daily:DailyVitRewardCfgData = DailyDataManager.instance.getDailyVitRewardCfgData(4);
//					if(daily)
//					{
//						instructionItems[3].setNum(DailyDataManager.instance.player_vit_daily_reward/*vit_today_total*/,daily.daily_vit);
//						updateInstructionItemPosAfterChange(instructionItems[3]);
//					}
//				}
//				return;
//			}
			
			if(proc==GameServiceConstants.SM_CHR_INFO)
			{
				itemIconVisible = RoleDataManager.instance.isCanFly as Boolean;
			}
			var taskPanelDataManager:TaskDataManager = TaskDataManager.instance;
			var configDataManager:ConfigDataManager = ConfigDataManager.instance;
			var tasks : Vector.<TaskTraceItemInfo> = new Vector.<TaskTraceItemInfo>();
			var cycleTasks : Vector.<int> = new Vector.<int>();
			var taskTraceItem : TaskTraceItem;
			var yPos:int = 0;
			var taskItem : TaskItem;
			var taskConfig : TaskCfgData;
			var taskTraceItemInfo : TaskTraceItemInfo;
			
			for each(taskItem in taskPanelDataManager.onDoingTasks)
			{
				taskConfig = configDataManager.taskCfgData(taskItem.id);
				if(taskConfig && taskItem.isCanShow)
				{
					taskTraceItemInfo = new TaskTraceItemInfo();
					taskTraceItemInfo.taskId = taskItem.id;
					taskTraceItemInfo.taskType = taskConfig.type;
					taskTraceItemInfo.state = taskPanelDataManager.getTaskState(taskItem.id);
					tasks.push(taskTraceItemInfo);
				}				
			}
			
			for each(taskItem in taskPanelDataManager.canReceiveTasks)
			{
				taskConfig = configDataManager.taskCfgData(taskItem.id);
				if(taskConfig && taskItem.isCanShow)
				{
					if(taskPanelDataManager.isExpTaskOrigin(taskConfig.id))
					{
						//如果当日次数已用完不显示
						if(taskPanelDataManager.isTaskNumEnough(taskConfig.id))
						{
							continue;
						}
					}
					taskTraceItemInfo = new TaskTraceItemInfo();
					taskTraceItemInfo.taskId = taskItem.id;
					taskTraceItemInfo.taskType = taskConfig.type;
					taskTraceItemInfo.state = taskPanelDataManager.getTaskState(taskItem.id);
					
					taskTraceItemInfo.isLocked = !TaskDataManager.instance.isTaskReincarnLevelEnough(taskItem.id);
					tasks.push(taskTraceItemInfo);
				}
			}
			
			for each(taskItem in taskPanelDataManager.virtualTasks)
			{
				taskConfig = configDataManager.taskCfgData(taskItem.id);
				taskTraceItemInfo = new TaskTraceItemInfo();
				taskTraceItemInfo.taskId = taskItem.id;
				taskTraceItemInfo.taskType = taskConfig.type;
				taskTraceItemInfo.state = TaskStates.TS_RECEIVABLE;
				tasks.push(taskTraceItemInfo);
			}
			
			if(tasks.length > 1)
			{
				_isMainDoingRewardType = TaskDataManager.instance.isMainDoingOtherTypeTask(TaskTypes.TT_REWARD);
				_isMainDoingStarType = TaskDataManager.instance.isMainDoingOtherTypeTask(TaskTypes.TT_MINING);
				tasks.sort(sortTaskItem);
			}
			var nsize:int = tasks.length;
			_contentHeight = 0;
			for(var i : int = 0 ; i < nsize;++i)
			{
				taskTraceItemInfo  = tasks[i];
				taskConfig = configDataManager.taskCfgData(taskTraceItemInfo.taskId);
				var newItem:Boolean = true;
				if(taskConfig && _items && _items.length > i)
				{
					taskTraceItem = _items[i];
					if(taskTraceItem.taskType != taskConfig.type || taskTraceItem.taskId != taskTraceItemInfo.taskId)
					{
						deleteTaskList.push(taskTraceItem.taskId);
						taskTraceItem.destroy();
						if(_itemContainer.contains(taskTraceItem))
						{
							_itemContainer.removeChild(taskTraceItem);
						}
					}
					else
					{
						newItem = false;
					}
				}
				if (newItem && taskConfig)
				{
					newTaskList.push(taskConfig.id);
					taskTraceItem = new TaskTraceItem(taskConfig.id, taskConfig.type);
					taskTraceItem.init();
					_itemContainer.addChild(taskTraceItem);
					if (!_items)
					{
						_items = new Vector.<TaskTraceItem>();
					}
					_items[ i ] = taskTraceItem;
				}
				taskTraceItem.x = 0;
				taskTraceItem.y = yPos;
				taskTraceItem.refresh();
				yPos += taskTraceItem.itemHeight;
				_contentHeight = yPos;
			}
			
			
			if(_items && _items.length >= 1)
			{
				var autoTaskItem:TaskTraceItem = _items[0];
				var autoTaskState:int = TaskDataManager.instance.getTaskState(autoTaskItem.taskId);
				var autoTaskCfg:TaskCfgData = configDataManager.taskCfgData(autoTaskItem.taskId);
				if(proc == GameServiceConstants.SM_TASK_RECEIVED || 
							(taskPanelDataManager.lastProgressUpdateTaskId == autoTaskItem.taskId && proc == GameServiceConstants.SM_TASK_PROGRESS) || 
							proc == GameServiceConstants.SM_TASK_LIST)
				{
					trace("======记录自动任务progress=======");
					trace("id:"+autoTaskItem.taskId);
					trace("state:"+autoTaskState);
					trace("========================");
					TaskAutoHandoverData.link = autoTaskItem.linkText;
					TaskAutoHandoverData.taskId = autoTaskItem.taskId;
					TaskAutoHandoverData.equipWareLink = autoTaskItem.equipWearLink;
					taskPanelDataManager.lastProgressUpdateTaskId = 0;
					_lastAutoTaskId = autoTaskItem.taskId;
					_lastAutoState = autoTaskState;
				}
//				else if(_lastAutoTaskId != autoTaskItem.taskId || TaskDataManager.instance.isValidateTaskState(autoTaskState) && _lastAutoState != autoTaskState)
//				else if(proc == GameServiceConstants.SM_CHR_INFO && RoleDataManager.instance.isLvChange && _lastAutoTaskId != autoTaskItem.taskId)
				else if(_lastAutoTaskType != 0 && !taskPanelDataManager.isSameTaskType(_lastAutoTaskType,autoTaskCfg.type))//首任务变更后
				{
					trace("======记录自动任务=======");
					trace("id:"+autoTaskItem.taskId);
					trace("state:"+autoTaskState);
					trace("========================");
					TaskAutoHandoverData.link = autoTaskItem.linkText;
					TaskAutoHandoverData.taskId = autoTaskItem.taskId;
					TaskAutoHandoverData.equipWareLink = autoTaskItem.equipWearLink;
					taskPanelDataManager.lastProgressUpdateTaskId = 0;
					if(_lastAutoTaskId != 0)
					{
						taskPanelDataManager.restartAutoTask();
					}
					_lastAutoTaskId = autoTaskItem.taskId;
					_lastAutoState = autoTaskState;
				}
				
				_lastAutoTaskType = autoTaskCfg.type;
			}
//			RoleDataManager.instance.isLvChange = false;
			
			if (_items)
			{
				nsize =_items.length;
				for (; i <nsize; i++)
				{
					taskTraceItem = _items[ i ];
					deleteTaskList.push(taskTraceItem.taskId);
					taskTraceItem.destroy();
					_itemContainer.removeChild(taskTraceItem);
				}
				_items.length = tasks.length;
			}
			
//			if(TaskDataManager.instance.getMainTaskId()==0)
			if(RoleDataManager.instance.reincarn > 0 || RoleDataManager.instance.lv >= 0)
			{
				createAutoGameItem();
			}
			else
			{
				if(autoGameItem)
				{
					autoGameItem.parent&&autoGameItem.parent.removeChild(autoGameItem);
					autoGameItem.destroy();
				}
				autoGameItem=null;
			}
			
			_separatePos = _contentHeight;
			updateInstructionItemsPos(_itemContainer,7,_separatePos);
			
			if(!_unlock)
			{
				_unlock = new UIUnlockHandler(null,0,updateUnlockState);
			}
			
			/*if(_scrollBar)
			{
				_scrollBar.resetScroll();
			}*/
			
			/*if(proc == GameServiceConstants.SM_TASK_RECEIVED)
			{
				TaskDataManager.instance.doAutoTask();
			}*/
			
			initNano();
			updateBg();
			
			
			if(proc == GameServiceConstants.SM_TASK_LIST)
			{
				TaskDataManager.instance.processGuideTask(GameServiceConstants.SM_TASK_LIST);
			}
		}
		
		private var _isMainDoingRewardType:Boolean = false;
		private var _isMainDoingStarType:Boolean = false;
		private var _separatePos:int = -1;
		
		public function updateAutoAfterLvUp():void
		{
			if(_items && _items.length >= 1)
			{
				var autoTaskItem:TaskTraceItem = _items[0];
				
				TaskAutoHandoverData.link = autoTaskItem.linkText;
				TaskAutoHandoverData.taskId = autoTaskItem.taskId;
				TaskAutoHandoverData.equipWareLink = autoTaskItem.equipWearLink;
				TaskDataManager.instance.lastProgressUpdateTaskId = 0;
			}
		}
		
		private function initNano():void
		{
			var id:*;
			var n:Sprite = null;
			
			for each(id in deleteTaskList)
			{
				n = nanoDict[id];
				if(n)
				{
					if(n.parent)
					{
						n.parent.removeChild(n);
					}
					delete nanoDict[id];
				}
			}
			
			for each(id in newTaskList)
			{
				n = nanoDict[id];
				if(n)
				{
					if(n.parent)
					{
						n.parent.removeChild(n);
					}
					nanoDict[id] = null;
				}
				
				n = new Sprite();
				n.mouseEnabled = false;
				nanoDict[id] = n;
			}
			
			deleteTaskList = [];
			newTaskList = [];
			
			for each(var item:TaskTraceItem in _items)
			{
				n = nanoDict[item.taskId];
				if(n)
				{
					n.x = item.x;
					n.y = item.y;
					_guideContainer.addChild(n);
				}
			}
		}
		
		public function getNano(id:String):DisplayObjectContainer
		{
			for each(var item:TaskTraceItem in _items)
			{
				if(item.taskId == parseInt(id))
				{
					var n:Sprite = nanoDict[id];
					return n;
				}
			}
			
			return null;
		}
		
		public function resetAutoMainTaskInfo():void
		{
			for each(var item:TaskTraceItem in _items)
			{
				if(item.taskType == TaskTypes.TT_MAIN)
				{
					TaskAutoHandoverData.link = item.linkText;
					TaskAutoHandoverData.taskId = item.taskId;
				}
			}
		}
		
		private static var priorityTypes:Array = [TaskTypes.TT_MAIN,TaskTypes.TT_ROOTLE,TaskTypes.TT_MINING,TaskTypes.TT_EXORCISM,TaskTypes.TT_TOWNER,TaskTypes.TT_REWARD,TaskTypes.TT_DGN];
		private function sortTaskItem(a:TaskTraceItemInfo,b:TaskTraceItemInfo):int
		{
			if(a.isLocked && !b.isLocked)
			{
				return 1;
			}
			else if(!a.isLocked && b.isLocked)
			{
				return -1;
			}
			
			var isAReward:Boolean = TaskTypes.isTypeReward(a.taskType) && a.taskId != TaskDataManager._typeRewardTaskId;
			var isBReward:Boolean = TaskTypes.isTypeReward(b.taskType) && b.taskId != TaskDataManager._typeRewardTaskId;
			
			if(isAReward || isBReward)
			{
				if(_isMainDoingRewardType)
				{
					if(isAReward)
					{
						return -1;
					}
					else
					{
						return 1;
					}
				}
			}
			else
			{
				var isAStar:Boolean = TaskTypes.isTypeStar(a.taskType) && a.taskId != TaskDataManager._typeStarTaskId;
				var isBStar:Boolean = TaskTypes.isTypeStar(b.taskType) && b.taskId != TaskDataManager._typeStarTaskId;
				
				if(isAStar || isBStar)
				{
					if(_isMainDoingStarType)
					{
						if(isAStar)
						{
							return -1;
						}
						else
						{
							return 1;
						}
					}
				}
			}
			
			if(TaskTypes.isTypeStar(a.taskType))
			{
				if(!Boolean(PanelTaskStarDataManager.instance.isFree))
				{
					return 1;
				}
			}
			else if(TaskTypes.isTypeStar(b.taskType))
			{
				if(!Boolean(PanelTaskStarDataManager.instance.isFree))
				{
					return -1;
				}
			}
			
			var index0:int = priorityTypes.indexOf(a.taskType);
			var index1:int = priorityTypes.indexOf(b.taskType);
			
			if(index0 < index1)
			{
				return -1;
			}
			else if(index0 > index1)
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
		/**
		 * 为了不影响新手引导的位置
		 */
		public function get innerWidth():int
		{
			var mcTaskBar:McTaskBar = _skin as McTaskBar;
			return mcTaskBar.mcBg.width;
		}
		
		public function scrollTo(pos:int):void
		{
			/*_scrollRect.y = pos;
			_itemContainer.scrollRect = _scrollRect;*/
		}
		
		public function get contentHeight():int
		{
			return _contentHeight;
		}
		
		public function get scrollRectHeight():int
		{
			/*return _scrollRect.height;*/
			return 0;
		}
		
		public function get scrollRectY():int
		{
			/*return _scrollRect.y;*/
			return 0;
		}
		
		public function getX():Number
		{
			return this.x;
		}
		
		public function getY():Number
		{
			return this.y;       
		}
		
		public function destroy():void
		{
			if(_tab)
			{
				_tab.destroy();
				_tab = null;
			}
			if(_skin)
			{
				/*if(_scrollBar)
					_scrollBar.destroy();
				_scrollBar = null;*/
				if (_skin.parent)
					removeChild(_skin);
				_skin = null;
			}
		}		

		public function get itemIconVisible():Boolean
		{
			return _itemIconVisible;
		}

		public function set itemIconVisible(value:Boolean):void
		{
			_itemIconVisible = value;
			for each(var item:TaskTraceItem in _items)
			{
				item.icon.visible=value;
			}
		}

		public function get items():Vector.<TaskTraceItem>
		{
			return _items;
		}
		
		public function getLinkText(taskId:int):ILinkText
		{
			var item:TaskTraceItem;
			for each (item in _items) 
			{
				if(item.taskId == taskId)
				{
					return item.linkText;
				}
			}
			return null;
		}
		
		public function getTabIndex():int
		{
			return _tabIndex;
		}
		
		public function setTabIndex(index:int):void
		{
			if(_tabIndex != index)
			{
				_tabIndex = index;
				
				updateTabIndex();
			}
		}
		
		public function updateTabIndex():void
		{
			if(_tab && _tabIndex != -1  && _tab.selectedIndex != _tabIndex)
			{
				_tab.selectedIndex = _tabIndex;
			}
		}
	}
}