package com.view.gameWindow.panel.panels.task.npctask
{
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.NpcCfgData;
    import com.model.configData.cfgdata.TaskCfgData;
    import com.model.consts.EffectConst;
    import com.model.consts.ItemType;
    import com.model.consts.SexConst;
    import com.model.consts.SlotType;
    import com.model.consts.StringConst;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.flyEffect.FlyEffectMediator;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panelbase.PanelBase;
    import com.view.gameWindow.panel.panels.bag.BagDataManager;
    import com.view.gameWindow.panel.panels.guideSystem.InterObjCollector;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
    import com.view.gameWindow.panel.panels.task.McTaskPanel;
    import com.view.gameWindow.panel.panels.task.TaskDataManager;
    import com.view.gameWindow.panel.panels.task.constants.TaskCondition;
    import com.view.gameWindow.panel.panels.task.constants.TaskStates;
    import com.view.gameWindow.panel.panels.task.constants.TaskTypes;
    import com.view.gameWindow.panel.panels.task.item.TaskItem;
    import com.view.gameWindow.panel.panels.task.linkText.LinkText;
    import com.view.gameWindow.scene.entity.EntityLayerManager;
    import com.view.gameWindow.scene.entity.entityItem.interf.IFirstPlayer;
    import com.view.gameWindow.tips.rollTip.RollTipMediator;
    import com.view.gameWindow.tips.rollTip.RollTipType;
    import com.view.gameWindow.util.UIEffectLoader;
    import com.view.newMir.NewMirMediator;
    
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;

    public class NpcTaskPanel extends PanelBase implements INpcTaskPanel
	{
		private var _effectLoader:UIEffectLoader;
		private var _awradsNum:int = 0;
		private var _cellDataList:Vector.<NpcTaskItemInfo>;
		private var _cells:Vector.<NpcTaskRewardCell>;
		private var _isExistRewardItem:Boolean;
		
		public function get cellDataList():Vector.<NpcTaskItemInfo>
		{
			return _cellDataList;
		}
		
		public function NpcTaskPanel()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			_skin = new McTaskPanel();
			addChild(_skin);
			setTitleBar((_skin as McTaskPanel).mcTitleBar);
			addEventListener(MouseEvent.CLICK,clickHandle);
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var mcTaskPanel:McTaskPanel = _skin as McTaskPanel;
			rsrLoader.addCallBack(mcTaskPanel.taskBtn,function (mc:MovieClip):void
			{
				refreshAcceptBtn();
				
				InterObjCollector.instance.add(mcTaskPanel.taskBtn);
			});
		}
		
		override protected function initData():void
		{
			var mcTaskPanel:McTaskPanel = _skin as McTaskPanel;
            var theX:int = mcTaskPanel.taskBtn.x + mcTaskPanel.taskBtn.width / 2;
            var theY:int = mcTaskPanel.taskBtn.y + mcTaskPanel.taskBtn.height / 2;
			_effectLoader = new UIEffectLoader(mcTaskPanel,theX,theY,1,1,EffectConst.RES_BTN_NPCTASKPANEL);
			//
			_cellDataList = new Vector.<NpcTaskItemInfo>();
		}
		
		override public function update(proc:int = 0):void
		{
			var mcNpcTaskPanel:McTaskPanel = _skin as McTaskPanel;
			var npcId:int = NpcTaskPanelData.npcId;
			var taskId:int = NpcTaskPanelData.taskId;
			var npcCfgData:NpcCfgData = ConfigDataManager.instance.npcCfgData(npcId);
			if(npcCfgData)
				mcNpcTaskPanel.npcName.text = npcCfgData.name;
			else
				mcNpcTaskPanel.npcName.text = "";
			var taskName : String,taskDesc : String,taskStartDialog : String,taskEndDialog : String,taskAwardExp : int,taskMoney : int,taskMoneyBind : int,taskGold : int,taskGoldBind : int,
				taskRepute : int,taskNeiGong : int,taskAwardItems:String,taskAwardOptional : String,displayStr : String;
			var taskType:int,linkText:LinkText,awardItemInfo : NpcTaskItemInfo;
			var taskConfigData : TaskCfgData = ConfigDataManager.instance.taskCfgData(taskId);
			if(taskConfigData)
			{
				taskType = taskConfigData.type;
				if (taskType == TaskTypes.TT_MAIN)
				{
					taskName = taskConfigData.name;
					taskDesc = taskConfigData.desc;
					taskStartDialog = taskConfigData.start_dialog;
					taskEndDialog = taskConfigData.end_dialog;
					taskAwardExp = taskConfigData.exp;
					taskMoney = taskConfigData.coin_unbind;
					taskMoneyBind = taskConfigData.coin_bind;
					taskGold = taskConfigData.gold_unbind;
					taskGoldBind = taskConfigData.gold_bind;
					taskRepute = taskConfigData.shengwang;
					taskNeiGong = taskConfigData.neigong;
					taskAwardItems = taskConfigData.reward_items;
					taskAwardOptional = taskConfigData.reward_optional;
				}
				
				linkText = new LinkText();
				var state : int = getTaskState();
				if(state == TaskStates.TS_RECEIVABLE)
				{
					displayStr = taskStartDialog;
				}
				else if(state == TaskStates.TS_CAN_SUBMIT)
				{
					displayStr = taskEndDialog;
				}
				else
				{
					displayStr = taskDesc;
				}
				var playerName : String = RoleDataManager.instance.name;
				displayStr = displayStr.replace(/<p\/>/g,"<font color='#00FF00'>" + playerName + "</font>");			
				var matches:Array = displayStr.match(/<p(.*?)\/>/g);
				var firstPlayer:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
				for each (var matchString:String in matches)
				{
					var matchXML:XML = new XML(matchString);
					var replaceString:String = "";
					if (firstPlayer.sex == SexConst.TYPE_MALE)
					{
						replaceString = matchXML.@m;
					}
					else
					{
						replaceString = matchXML.@f;
					}
					displayStr = displayStr.replace(matchString, replaceString);
				}
				linkText.init(displayStr);
				
				mcNpcTaskPanel.taskContent.htmlText = linkText.htmlText;
				
				if(taskAwardExp > 0)
				{
					awardItemInfo = new NpcTaskItemInfo();
					awardItemInfo.type = SlotType.IT_ITEM;
					awardItemInfo.id = ItemType.IT_EXP;
					awardItemInfo.count = taskAwardExp;
					_cellDataList.push(awardItemInfo);
				}
				if(taskMoney > 0)
				{
					awardItemInfo = new NpcTaskItemInfo();
					awardItemInfo.type = SlotType.IT_ITEM;
					awardItemInfo.id = ItemType.IT_MONEY;
					awardItemInfo.count = taskMoney;
					_cellDataList.push(awardItemInfo);
				}
				if(taskMoneyBind > 0)
				{
					awardItemInfo = new NpcTaskItemInfo();
					awardItemInfo.type = SlotType.IT_ITEM;
					awardItemInfo.id = ItemType.IT_MONEY_BIND;
					awardItemInfo.count = taskMoneyBind;
					_cellDataList.push(awardItemInfo);
				}
				if(taskGold > 0)
				{
					awardItemInfo = new NpcTaskItemInfo();
					awardItemInfo.type = SlotType.IT_ITEM;
					awardItemInfo.id = ItemType.IT_GOLD;
					awardItemInfo.count = taskGold;
					_cellDataList.push(awardItemInfo);
				}				
				if(taskGoldBind > 0)
				{
					awardItemInfo = new NpcTaskItemInfo();
					awardItemInfo.type = SlotType.IT_ITEM;
					awardItemInfo.id = ItemType.IT_GOLD_BIND;
					awardItemInfo.count = taskGoldBind;
					_cellDataList.push(awardItemInfo);
				}
				if(taskRepute > 0)
				{
					awardItemInfo = new NpcTaskItemInfo();
					awardItemInfo.type = SlotType.IT_ITEM;
					awardItemInfo.id = ItemType.IT_REPUTE;
					awardItemInfo.count = taskRepute;
					_cellDataList.push(awardItemInfo);
				}
				if(taskNeiGong > 0)
				{
					awardItemInfo = new NpcTaskItemInfo();
					awardItemInfo.type = SlotType.IT_ITEM;
					awardItemInfo.id = ItemType.IT_NEIGONG;
					awardItemInfo.count = taskNeiGong;
					_cellDataList.push(awardItemInfo);
				}
				if(taskAwardItems)
				{
					var itemsReceive:Array = taskAwardItems.split("|");
					var itemString:String;
					for each (itemString in itemsReceive)
					{
						var itemArray : Array = itemString.split(":");
						if(itemArray.length >= 3)
						{
							awardItemInfo = new NpcTaskItemInfo();
							awardItemInfo.id = parseInt(itemArray[0]);
							awardItemInfo.type = parseInt(itemArray[1]);
							awardItemInfo.count = parseInt(itemArray[2]);
							awardItemInfo.barFlyKey = itemArray.length >= 4 ? (parseInt(itemArray[3]) - 1) : -1;
							_cellDataList.push(awardItemInfo);
							_isExistRewardItem = true;
						}
					}
				}
				if(taskAwardOptional)
				{
					itemsReceive = taskAwardOptional.split("|");
					for each (itemString in itemsReceive)
					{
						var subItemStrings:Array = itemString.split(":");
						if (subItemStrings.length >= 5)
						{
							var job : int = parseInt(subItemStrings[3]);
							if(job == 0 || job == RoleDataManager.instance.job)
							{
								var sex:Number = parseInt(subItemStrings[4]);
								if(sex == 0 || sex == RoleDataManager.instance.sex)
								{
									awardItemInfo = new NpcTaskItemInfo();
									awardItemInfo.id = parseInt(subItemStrings[0]);
									awardItemInfo.type = parseInt(subItemStrings[1]);
									awardItemInfo.count = parseInt(subItemStrings[2]);
									awardItemInfo.barFlyKey = subItemStrings.length >= 6 ? (parseInt(subItemStrings[5]) - 1) : -1;
									_cellDataList.push(awardItemInfo);
									_isExistRewardItem = true;
								}
							}
						}
					}
				}
				if(!_cells)
				{
					_cells = new Vector.<NpcTaskRewardCell>(4,true);
				}
				for(var i : int = 0; i < 4; ++i)
				{
					if(i < _cellDataList.length)
					{
						var npcTaskRewardCell:NpcTaskRewardCell = new NpcTaskRewardCell();
						var layer:MovieClip = mcNpcTaskPanel["mcReward"+i];
						npcTaskRewardCell.load(layer,_cellDataList[i],onLoadComplete);
						_cells[i] = npcTaskRewardCell;
					}
				}
			}
			refreshAcceptBtn();
		}
		
		private function onLoadComplete():void
		{
			_awradsNum++;
		}
		
		override public function setPostion():void
		{
			var rect:Rectangle = getPanelRect();
            var newMirMediator:NewMirMediator = NewMirMediator.getInstance();
			var newX:int = 250;
			x != newX ? x = newX : null;
			var newY:int = int((newMirMediator.height - rect.height)*.5);
			y != newY ? y = newY : null;
		}
		/**刷新交接任务按钮文本*/
		private function refreshAcceptBtn():void
		{
			var mcNpcTaskPanel:McTaskPanel = _skin as McTaskPanel;
			if(!mcNpcTaskPanel)
			{
				return;
			}
			var state : int = getTaskState();
			if(!mcNpcTaskPanel)
			{
				return;
			}
			switch(state)
			{
				case TaskStates.TS_NOT_RECEIVABLE:
					break;
				case TaskStates.TS_RECEIVABLE:
					if(mcNpcTaskPanel.taskBtn.txt)
					{
						mcNpcTaskPanel.taskBtn.txt.text = StringConst.NPC_TASK_PANEL_0001;
						TaskDataManager.instance.startTimer();
					}
					break;
				case TaskStates.TS_DOING:
					break;
				case TaskStates.TS_CAN_SUBMIT:
					if(mcNpcTaskPanel.taskBtn.txt)
					{
						mcNpcTaskPanel.taskBtn.txt.text = StringConst.NPC_TASK_PANEL_0002;
						TaskDataManager.instance.startTimer();
					}
					break;
				case TaskStates.TS_DONE:
					break;
				case TaskStates.TS_UNKNOWN:
					break;
				default:
					break;
			}
		}
		
		private function getTaskState():int
		{
			var taskId:int,state:int,taskConfig:TaskCfgData;
			taskId = NpcTaskPanelData.taskId;
			taskConfig = ConfigDataManager.instance.taskCfgData(taskId);
			if(taskConfig)
			{
				if(taskConfig.type == TaskTypes.TT_MAIN)
				{
					state = TaskDataManager.instance.getTaskState(taskId);
				}
			}
			return state;
		}
		
		private function clickHandle(evt:MouseEvent):void
		{
			var mc:MovieClip = evt.target as MovieClip;
			var _McTaskPanel:McTaskPanel = _skin as McTaskPanel;
			var taskId:int;
			var taskCfg : TaskCfgData;
			switch(mc)
			{
				case _McTaskPanel.closeBtn:
					PanelMediator.instance.closePanel(PanelConst.TYPE_TASK_ACCEPT_COMPLETE);
					TaskDataManager.instance.stopTimer();
					break;
				case _McTaskPanel.taskBtn:
					TaskDataManager.instance.setAutoTask(false,"NpcTaskPanel::_McTaskPanel.taskBtn");
					var taskState:int = getTaskState();
					if(taskState == TaskStates.TS_RECEIVABLE)
					{
						receiveHandle();
					}
					else if(taskState == TaskStates.TS_CAN_SUBMIT)
					{
						completeHandle();
					}
					PanelMediator.instance.closePanel(PanelConst.TYPE_TASK_ACCEPT_COMPLETE,0);
					TaskDataManager.instance.stopTimer();
					break;
			}
		}
		
		private function receiveHandle():void
		{
			var taskId:int = NpcTaskPanelData.taskId;
			var taskCfg : TaskCfgData = ConfigDataManager.instance.taskCfgData(taskId);
			if(taskCfg && taskCfg.condition == TaskCondition.TC_PROTECT_CLIENT)
			{
				if(TaskDataManager.instance.getClientTaskItem())
				{
					//SystemAlertManager.getInstance().showAlert(InternationalConstants.getGameString(41078),true,true);
					trace("类NpcTaskPanel方法receiveHandle");
					return;
				}
			}						
			if (taskCfg.type == TaskTypes.TT_MAIN)
			{
				var taskPanelDataManager:TaskDataManager = TaskDataManager.instance;
				taskPanelDataManager.receiveTask(taskId);
			}
		}
		
		private function completeHandle():void
		{
			var taskId:int = NpcTaskPanelData.taskId;
			var taskCfg : TaskCfgData = ConfigDataManager.instance.taskCfgData(taskId);
			if (taskCfg.type == TaskTypes.TT_MAIN)
			{
				var taskPanelDataManager:TaskDataManager = TaskDataManager.instance;
				var taskItem:TaskItem = taskPanelDataManager.onDoingTasks[taskId];
				if (taskItem.completed)
				{
					if(_isExistRewardItem && BagDataManager.instance.remainCellNum == 0)
					{
						RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.BAG_PANEL_0029);	
						return;
					}
					taskPanelDataManager.submitTask(taskId);
					doTaskSubmitFlyEffectT();
				}
			}
		}
		
		public function doTaskSubmitFlyEffectT():void
		{
			if(_awradsNum == _cellDataList.length)
			{
				FlyEffectMediator.instance.doFlyReceiveThings(PanelConst.TYPE_TASK_ACCEPT_COMPLETE,0,_awradsNum);
			}
		}
		
		override public function destroy():void
		{
			var mcTaskPanel:McTaskPanel = _skin as McTaskPanel;
			InterObjCollector.instance.remove(mcTaskPanel.taskBtn);
			var cell:NpcTaskRewardCell;
			for each (cell in _cells)
			{
				if(cell)
				{
					cell.destory();
				}
			}
			_cells = null;
			//
			if(_effectLoader)
			{
				_effectLoader.destroy();
				_effectLoader = null;
			}
			NpcTaskPanelData.npcId = 0;
			removeEventListener(MouseEvent.CLICK,clickHandle);
			_cellDataList = null;
			_awradsNum = 0;
			super.destroy();
		}
	}
}