package com.view.gameWindow.mainUi.subuis.tasktrace
{
	import com.model.business.fileService.UrlSwfLoader;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.business.fileService.interf.IUrlSwfLoaderReceiver;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.TaskCfgData;
	import com.model.consts.DungeonConst;
	import com.model.consts.FontFamily;
	import com.model.consts.StringConst;
	import com.model.dataManager.TeleportDatamanager;
	import com.view.gameWindow.flyEffect.FlyEffectMediator;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.panels.dungeon.DgnDataManager;
	import com.view.gameWindow.panel.panels.dungeon.DgnGoalsDataManager;
	import com.view.gameWindow.panel.panels.guideSystem.GuideSystem;
	import com.view.gameWindow.panel.panels.guideSystem.InterObjCollector;
	import com.view.gameWindow.panel.panels.guideSystem.unlock.UnlockFuncId;
	import com.view.gameWindow.panel.panels.onhook.AutoSystem;
	import com.view.gameWindow.panel.panels.onhook.states.common.FightPlace;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.task.TaskAutoHandoverData;
	import com.view.gameWindow.panel.panels.task.TaskDataManager;
	import com.view.gameWindow.panel.panels.task.constants.TaskCondition;
	import com.view.gameWindow.panel.panels.task.constants.TaskStates;
	import com.view.gameWindow.panel.panels.task.constants.TaskTypes;
	import com.view.gameWindow.panel.panels.task.item.TaskItem;
	import com.view.gameWindow.panel.panels.task.linkText.LinkText;
	import com.view.gameWindow.panel.panels.task.linkText.item.LinkTextItem;
	import com.view.gameWindow.panel.panels.taskStar.data.PanelTaskStarDataManager;
	import com.view.gameWindow.scene.GameFlyManager;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
	import com.view.gameWindow.scene.map.SceneMapManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.util.UtilGetStrLv;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import flash.utils.clearInterval;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	public class TaskTraceItem extends Sprite implements IUrlSwfLoaderReceiver
	{
		public static const WIDTH:int = 220;
		public static const COLOR_PREFIX:String = "#00b0f0";
		public static const COLOR_NORMAL:String = "#ffc000";
		public static const COLOR_WARNING:String = "#C00000";
		public static const COLOR_TIP:String = "#bfbfbf";
		public static const COLOR_TARGET:String = "#00ff00";
		
		private var _taskId:int;
		private var _taskType:int;
		private var _cycType:int;
		
		protected static const _filter:GlowFilter = new GlowFilter(0x000000,1,2,2,10);
		private var _titleText:TextField;
		private var _contentText:TextField;
		private var _appendItem:EquipWearItem;
		private var _icon:Sprite;

		private var _linkText:LinkText;
		private var _timer:int;
		private var _state : int;
		private var _npcid : int;
		
		public function TaskTraceItem(taskId:int, taskType:int, cyctype:int = 0)
		{
			_taskId = taskId;
			_taskType = taskType;
			_cycType = cyctype;
			_timer = 0;
		}

		public function get linkText():LinkText
		{
			return _linkText;
		}
		
		public function get equipWearLink():EquipWearItem
		{
			if(_appendItem && _appendItem.parent)
			{
				return _appendItem;
			}
			else
			{
				return null;
			}
		}
		
		public function get taskId():int
		{
			return _taskId;
		}
		
		public function get taskType():int
		{
			return _taskType;
		}
		
		public function init():void
		{
			_titleText = new TextField();
			_titleText.textColor = 0xffff00;
			_titleText.width = WIDTH;
			_titleText.selectable = false;
			_titleText.x = 6;
			_titleText.y = 3;
			_titleText.addEventListener(TextEvent.LINK,tileLinkClickHandle,false,0,true);
			_titleText.filters = [_filter];
			_titleText.selectable = false;
			var defaultTextFormat:TextFormat = _titleText.defaultTextFormat;
			defaultTextFormat.font = FontFamily.FONT_NAME;
			defaultTextFormat.size = 12;
			_titleText.defaultTextFormat = defaultTextFormat;
			_titleText.setTextFormat(defaultTextFormat);
			addChild(_titleText);
			
			_contentText = new TextField();
			_contentText.textColor = 0xffffff;
			_contentText.x = 6;
			_contentText.y = _titleText.y + 18;
			_contentText.width = 200;
			_contentText.multiline = true;
			_contentText.wordWrap = true;
			_contentText.addEventListener(TextEvent.LINK, linkClickHandle, false, 0, true);
			_contentText.filters = [_filter];
			_contentText.selectable = false;
			defaultTextFormat = _contentText.defaultTextFormat;
			defaultTextFormat.font = FontFamily.FONT_NAME;
			defaultTextFormat.size = 12;
			defaultTextFormat.leading = 2;
			_contentText.defaultTextFormat = defaultTextFormat;
			_contentText.setTextFormat(defaultTextFormat);
			addChild(_contentText);
			
			_icon = new Sprite();
			_icon.buttonMode = true;
			var swfLoader:UrlSwfLoader = new UrlSwfLoader(this);//小飞鞋资源
			swfLoader.loadSwf(ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD + "common/flyShoe" + ResourcePathConstants.POSTFIX_SWF);
			_icon.addEventListener(MouseEvent.CLICK, cloudClickHandle, false, 0, true);
			addChild(_icon);
		}
		
		public function get itemHeight():int
		{
//			return _titleText.textHeight + _contentText.textHeight + 6;
			
			if(_appendItem && _appendItem.parent)
			{
				return _titleText.textHeight + _contentText.textHeight + _appendItem.height + 13;
			}
			else
			{
				return _titleText.textHeight + _contentText.textHeight + 13;
			}
		}
		
		
		public static var EQUIP_WARE_0:Array = [10990,11090,11250];//恶魔广场
		public static var EQUIP_WARE_1:Array = [/*11250*/];//神舰//BOSS之家
//		public static var EQUIP_WARE_2:Array = [10780,10910,10990,11090]; //装备进阶
		public static var EQUIP_WARE_3:Array = [11090,11250];//轻松获取
		public static var EQUIP_WARE_4:Array = [10910];//挑战个人BOSS
		
		public static var EQUIP_WARE_OPEN:Object = {11090:PanelConst.TYPE_CHARGE_PANEL,11250:PanelConst.TYPE_OPEN_GIFT_PANEL};
		private function checkEquipWearTip(show:Boolean):void
		{
			var cfg:TaskCfgData = ConfigDataManager.instance.taskCfgData(_taskId);
			
			if(show && cfg &&
				(cfg.condition == TaskCondition.TC_EQUIP_WEAR
					|| cfg.condition == TaskCondition.TC_EQUIP_WEAR_HERO
					|| cfg.condition == TaskCondition.TC_EQUIP_GET))
			{
				if(!_appendItem)
				{
					_appendItem = new EquipWearItem();
				}
				
				var openPanel:String = EQUIP_WARE_OPEN[_taskId] ? EQUIP_WARE_OPEN[_taskId] : PanelConst.TYPE_DRAGON_TREASURE;
				
				_appendItem.setData(cfg.exp,GuideSystem.instance.isUnlock(UnlockFuncId.TASK_STAR) ? 1 : 0,
									EQUIP_WARE_0.indexOf(_taskId)!=-1,
									EQUIP_WARE_1.indexOf(_taskId)!=-1,
									true,
									EQUIP_WARE_3.indexOf(_taskId)!=-1,
									EQUIP_WARE_4.indexOf(_taskId)!=-1,openPanel);
				
				_appendItem.x = _contentText.x;
				_appendItem.y = _contentText.y + _contentText.height;
				
				if(!_appendItem.parent)
				{
					addChild(_appendItem);
				}
			}
			else
			{
				if(_appendItem)
				{
					_appendItem.destroy();
					if(_appendItem.parent)
					{
						_appendItem.parent.removeChild(_appendItem);
					}
					
					_appendItem = null;
				}
			}
		}
			
		
		public function refresh():void
		{
			var taskPanelDataManager:TaskDataManager = TaskDataManager.instance;
			var taskTypeString:String = "";
			var taskDoneCountString:String = "";
			if (_taskType == TaskTypes.TT_MAIN)
			{
				taskTypeString = StringConst.TASK_0001;
			}
			else if (_taskType == TaskTypes.TT_ROOTLE)
			{
				taskTypeString = StringConst.TASK_0018;//StringConst.TASK_0002;
			}
			else if (_taskType == TaskTypes.TT_MINING)
			{
				taskTypeString =  StringConst.TASK_0018;//StringConst.TASK_0003;
			}
			else if (_taskType == TaskTypes.TT_EXORCISM)
			{
				taskTypeString =  StringConst.TASK_0018;//StringConst.TASK_0004;
			}
			else if (_taskType == TaskTypes.TT_REWARD)
			{
				taskTypeString =  StringConst.TASK_0019;//StringConst.TASK_0005;
			}
			else
			{
				taskTypeString = StringConst.TIP_EXP;
			}
			
			var taskName:String = "";
			var taskConfig:TaskCfgData;
			var taskItem:TaskItem;
			var isShowQuickFinishBtn:Boolean = false;
			var stateStr : String = "";
			_npcid = 0;
			var noTime : Boolean = false;//任务次数是否用完
			var state:int;
			if (_taskType == TaskTypes.TT_MAIN || _taskType == TaskTypes.TT_ROOTLE || _taskType == TaskTypes.TT_EXORCISM || _taskType == TaskTypes.TT_MINING || _taskType == TaskTypes.TT_REWARD
				||TaskDataManager.instance.isVirtualType(_taskType))
			{
				taskConfig = ConfigDataManager.instance.taskCfgData(_taskId);
				taskName = taskConfig.name;
				taskItem = taskPanelDataManager.canReceiveTasks[_taskId];
				_linkText = new LinkText();
				if (taskItem)
				{
					var lv:int = _taskType == TaskTypes.TT_MAIN ? taskConfig.level : (_taskType == TaskTypes.TT_REWARD ? taskPanelDataManager.lvReward : taskPanelDataManager.lvStar);
					var reincarn:int = _taskType == TaskTypes.TT_MAIN ? taskConfig.reincarn : (_taskType == TaskTypes.TT_REWARD ? taskPanelDataManager.reincarnReward : taskPanelDataManager.reincarnStar);
					var strReincarnLevel:String = UtilGetStrLv.strReincarnLevel(reincarn,lv);
					var isTaskReincarnLevelEnough:Boolean = TaskDataManager.instance.isTaskReincarnLevelEnough(_taskId);
					if(isTaskReincarnLevelEnough)
					{
						stateStr = "<font color='"+COLOR_NORMAL+"'>【" + StringConst.TASK_0007 + "】</font>";
					}
					else
					{
						stateStr = "<font color='"+COLOR_WARNING+"'>【" + strReincarnLevel + StringConst.TASK_0006 + "】</font>";
					}
					
					/*if (taskConfig.start_npc > 0)
					{
						_npcid = taskConfig.start_npc;
						if(RoleDataManager.instance.lv < taskConfig.level)
						{
							_linkText.init("<font color='#FFFFFF'>" + StringConst.TASK_0008 + "</font>" + "<font color='#FF0000'>" + taskConfig.level.toString() + "</font>" +
								"<font color='#FFFFFF'>" + StringConst.TASK_0009 + "</font>" +
								"(" + "<font color='#00FF00'><u><a href='event:exp'>" + StringConst.TASK_0010 + "</a></u></font>" + ")");
						}
						else
						{
							_linkText.init(StringConst.TASK_0011 + "<l><n>" + taskConfig.start_npc + "</n></l>" );
						}
						
						_contentText.htmlText = "<font color='#bfbfbf'>" + _linkText.htmlText + "</font>";
					}*/
					
					var currentNum:int,needNum:int;
					_linkText.init(taskConfig.desc);
					var isNeedShowNum:Boolean = true;
					if(taskConfig.type == TaskTypes.TT_MINING || taskConfig.type == TaskTypes.TT_ROOTLE || taskConfig.type == TaskTypes.TT_EXORCISM)
					{
						currentNum = PanelTaskStarDataManager.instance.count;
						needNum = PanelTaskStarDataManager.instance.isReal ? PanelTaskStarDataManager.instance.totalCount : 5;
						if(!PanelTaskStarDataManager.instance.isReal || PanelTaskStarDataManager.instance.isFree != 1)
						{
							isNeedShowNum = false;
						}
						
						if(currentNum >= needNum)
						{
							currentNum = needNum;
						}
					}
					else
					{
						currentNum = taskItem.currentNum;
						needNum = taskItem.needNum;
					}
					var color:String = COLOR_TIP;//currentNum >= needNum ? COLOR_NORMAL : COLOR_WARNING;
					state = TaskStates.TS_RECEIVABLE;
					var numDes:String = "";
					if(isNeedShowNum)
					{
						numDes = "<font color='"+color+"'> " + currentNum + "/" + needNum + " </font>";
					}
					setHtmlTextValue(_contentText,getTargetPrefix(taskConfig.type,state,taskConfig.condition)+"<font color='#ffffff'>" + _linkText.htmlText.replace("<c/>", numDes) + "</font>");
				}
				else
				{
					if(_taskType == TaskTypes.TT_MAIN || _taskType == TaskTypes.TT_ROOTLE || _taskType == TaskTypes.TT_EXORCISM || _taskType == TaskTypes.TT_MINING || _taskType == TaskTypes.TT_REWARD)
					{
						taskItem = taskPanelDataManager.onDoingTasks[_taskId];
						if(taskItem)
						{
							if(taskItem.completed)
							{
								stateStr = "<font color='"+COLOR_NORMAL+"'>【" + StringConst.TASK_0012 + "】</font>";
							}
						}
					}
					else if(taskPanelDataManager.isVirtualType(_taskType))
					{
						taskItem = taskPanelDataManager.getTaskItem(_taskId);
					}
					
					if (taskItem)
					{
						if (taskItem.completed)
						{
							_linkText.init(taskConfig.post_hint);
						}
						else
						{
							_linkText.init(taskConfig.pre_hint);
						}
						
						state = taskItem.completed ? TaskStates.TS_CAN_SUBMIT:TaskStates.TS_DOING;
						setHtmlTextValue(_contentText,getTargetPrefix(taskConfig.type,state,taskConfig.condition) + "<font color='#ffffff'>" + _linkText.htmlText.replace("<c/>", "<font color='"+COLOR_TIP+"'> " + taskItem.currentNum + "/" + taskItem.needNum + "</font>") + "</font>");
					}
					else
					{
						_npcid = taskConfig.start_npc;
						_linkText.init("<l><n>" + taskConfig.start_npc + "</n></l>" + StringConst.TASK_0013);
						setHtmlTextValue(_contentText,"<font color='#ffffff'>" + _linkText.htmlText + "</font>");
						state = TaskStates.TS_RECEIVABLE;
					}
					
					noTime = taskPanelDataManager.checkNoCount(_taskType);
					if(noTime)
					{
						setHtmlTextValue(_contentText,"<font color='#808080'>" + StringConst.TASK_0014 + "</font>");
						state = TaskStates.TS_UNKNOWN;
					}
				}
				setHtmlTextValue(_titleText,"<font color='"+COLOR_PREFIX+"'>[" + taskTypeString + "]</font> " + "<font color='"+COLOR_NORMAL+"'>" + taskName + "</font>" + stateStr);
			}
			
			_titleText.height = _titleText.textHeight + 5;
			_contentText.height = _contentText.textHeight + 5;
			var rec:Rectangle = _contentText.getCharBoundaries(_contentText.text.length-1);
			if(rec)
			{
				_icon.x = _contentText.x + rec.x + rec.width + 5;
				_icon.y = _contentText.y + rec.y - 8;  //为了保证小飞鞋居中对齐，
				_icon.visible = RoleDataManager.instance.isCanFly > 0 && 
							FlyEffectMediator.instance.isDoFiy == false && 
							(!taskConfig
							|| (taskConfig.condition != TaskCondition.TC_EQUIP_WEAR
								&& taskConfig.condition != TaskCondition.TC_EQUIP_WEAR_HERO
								&& taskConfig.condition != TaskCondition.TC_EQUIP_GET
								&& taskConfig.condition != TaskCondition.TC_KILL_PLAYER) || 
							state == TaskStates.TS_RECEIVABLE || state == TaskStates.TS_CAN_SUBMIT);
			}
			
			checkEquipWearTip(state == TaskStates.TS_DOING);
			
			//需要先清理一遍
			InterObjCollector.instance.remove(_contentText);
			InterObjCollector.instance.remove(_icon);
			
			if(callLaterId)
			{
				clearTimeout(callLaterId);
				callLaterId = 0;
			}
			
			callLaterId = setTimeout(refreshCallLater,500);
			
			remainNum = taskItem ? taskItem.needNum - taskItem.currentNum : 0;
		}
		
		private var _oldTextValue:Dictionary = new Dictionary();
		
		private function setHtmlTextValue(text:TextField,value:String):void
		{
			var oldValue:String = _oldTextValue[text];
			if(oldValue != value)
			{
				_oldTextValue[text] = value;
				text.htmlText = value;
			}
		}
		
		private var remainNum:int;
		
		private function refreshCallLater():void
		{
			InterObjCollector.instance.add(_contentText);
			InterObjCollector.instance.add(_icon);
			
			if(callLaterId)
			{
				clearTimeout(callLaterId);
				callLaterId = 0;
			}
		}
		
		private var callLaterId:int = 0;
		
		private function getTargetPrefix(type:int,state:int,condition:int):String
		{
			var txt:String = "";
			
			if(state == TaskStates.TS_CAN_SUBMIT)
			{
				txt = StringConst.TIP_TASK_PREFIX_0;
			}
			else if(state == TaskStates.TS_RECEIVABLE)
			{
				txt = StringConst.TIP_TASK_PREFIX_11;
			}
			else
			{
				if(type != TaskTypes.TT_REWARD || condition == TaskCondition.TC_KILL_PLAYER)
				{
					txt = TaskCondition.getDes(condition);
				}
				else
				{
					txt = StringConst.TASK_0005;
				}
			}
			
			return txt ? "<font color='"+COLOR_TIP+"'>- " + txt + "</font> " : txt;
		}
		
		private function tileLinkClickHandle(event:TextEvent):void
		{
			if (RoleDataManager.instance.stallStatue)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.STALL_PANEL_0019);
				return;
			}
			if(event)
			{
				if(event.text == "quick")
				{
					quickDoneClickHandle();
				}
			}
		}
		
		private function quickDoneClickHandle():void
		{
			/*var itemId : int = ConfigDataManager.instance.getItemIdByTypeAndGrade(ItemTypes.IET_JISULING);
			var itemNum : int = 1;
			var obj : Object = new Object();
			obj.taskId = _taskId;
			obj.taskType = _taskType;
			UseAndBuyPanelDataManager.getInstance().useAndBuyItem(itemId,itemNum,UseAndBuyPanelType.TASK_QUICK_DONE,InternationalConstants.getGameString(45127),InternationalConstants.getGameString(45120),true,obj);*/
		}
		
		public static function executeLink(linkText:LinkText,taskId:int,eventId:String):void
		{
			if(!linkText)
			{
				return;
			}
			
			var linkItem:LinkTextItem = linkText.getItemById(int(eventId));
			var taskItem:TaskItem;
			
			if(!linkItem)
			{
				return;
			}
			
			if(linkItem.type == LinkTextItem.TYPE_TO_OPEN_PANEL)
			{
				/*PanelContainerMediator.getInstance().openPanelByName(linkItem.panelName,linkItem.panelPage);*/
				trace("打开面板 in TaskTarceItem.linkClickHandle");
			}
			else
			{
				AutoJobManager.getInstance().reset();
				AutoSystem.instance.stopAuto();
				
				TaskAutoHandoverData.clear();
				TaskDataManager.instance.setAutoTask(true,"TaskTraceItem::executeLink");
				var tskCfg:TaskCfgData = ConfigDataManager.instance.taskCfgData(taskId);
				if(tskCfg)
				{
					TaskDataManager.instance.autoTaskType = tskCfg.type;
				}
				TaskDataManager.instance.resetAutoTaskFailFlag(taskId);
				
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
					//						var mapRegionCfgData:MapRegionCfgData = ConfigDataManager.instance.mapRegionCfgData(linkItem.regionId);
					//						if(!mapRegionCfgData)
					//						{
					//							trace("TaskAutoHandover.doAutoTask() mapRegionCfgData:"+mapRegionCfgData);
					//							return;
					//						}
					//						AutoJobManager.getInstance().setAutoFindPathPos(mapRegionCfgData.randomPoint,mapRegionCfgData.map_id);
					taskItem = TaskDataManager.instance.onDoingTasks[taskId];
					var remainNum:int = taskItem ? taskItem.needNum - taskItem.currentNum : 0;
					AutoSystem.instance.setTarget(linkItem.regionId,EntityTypes.ET_MINE,remainNum);
				}
				else if(linkItem.type == LinkTextItem.TYPE_TO_DUNGEON)
				{
					if(!SceneMapManager.getInstance().isDungeon)
					{
						DgnGoalsDataManager.instance.requestTaskDungeon(taskId);
					}
				}
				else if(linkItem.type == LinkTextItem.TYPE_TO_TELEPORT)
				{
					taskItem = TaskDataManager.instance.onDoingTasks[taskId];
					var taskCfg:TaskCfgData = ConfigDataManager.instance.taskCfgData(taskId);
					
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
		
		private function linkClickHandle(event:TextEvent):void
		{
			if (RoleDataManager.instance.stallStatue)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.STALL_PANEL_0019);
				return;
			}
			stage.focus = stage;
			if(event)
			{
				var linkItemId:int = int(event.text);
//				var linkItem:LinkTextItem = _linkText.getItemById(linkItemId);
				if(event.text == "exp")
				{
					/*PanelContainerMediator.getInstance().showDailyPanel(true, 4, CollectionType.EXP);*/
					trace("经验文本点击 in TaskTarceItem.linkClickHandle")
				}
				else
				{
					executeLink(_linkText,_taskId,event.text);
				}
			}
		}
		
		public static const REWARD_NPC:int = 10451;
		public static const EQUIP_NPC:int = 10450;
		public static const EQUIP_NPC_BOSS:int = 10451;// 10461;
		private function cloudClickHandle(event:MouseEvent):void
		{
			if(DgnDataManager.instance.dungeonId && DgnDataManager.instance.dungeonFunc == DungeonConst.FUNC_TYPE_MAIN)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.DGN_NO_FLY_MAIN);
				return;
			}
			
			if (RoleDataManager.instance.stallStatue)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.STALL_PANEL_0019);
				return;
			}
			var linkItem:LinkTextItem = _linkText.getItemById(1);
			if(!linkItem)
			{
				return;
			}
			
			TaskDataManager.instance.setAutoTask(false,"TaskTraceItem::cloudClickHandle");//防止在传送前  自动任务开始寻怪
			//设置自动执行的任务
			TaskAutoHandoverData.equipWareLink = _appendItem;
			TaskAutoHandoverData.link = _linkText;
			TaskAutoHandoverData.taskId = _taskId;
			
			if(linkItem.type == LinkTextItem.TYPE_TO_NPC)
			{
				TeleportDatamanager.instance.setTargetEntity(linkItem.npcId,EntityTypes.ET_NPC,0,true);
				GameFlyManager.getInstance().flyToMapByNPC(linkItem.npcId);
			}
			else if(linkItem.type == LinkTextItem.TYPE_TO_MONSTER)
			{
//				var taskConfig:TaskCfgData = ConfigDataManager.instance.taskCfgData(_taskId);
//				if(taskConfig.type == TaskTypes.TT_REWARD)//悬赏任务要特殊处理
//				{
//					TeleportDatamanager.instance.setTargetEntity(REWARD_NPC,EntityTypes.ET_NPC);//这样设置了后 autoTask 有可能断掉 
//					GameFlyManager.getInstance().flyToMapByNPC(/*taskConfig.start_npc*/REWARD_NPC);//
//				}
//				else
//				{
					GameFlyManager.getInstance().flyToMapByMonster(linkItem.monsterId);
//				}
			}
			else if(linkItem.type == LinkTextItem.TYPE_TO_PLANT)
			{
				GameFlyManager.getInstance().flyToMapByPlant(linkItem.plantId);
			}
			else if(linkItem.type==LinkTextItem.TYPE_TO_MAP_MINE)
			{
				GameFlyManager.getInstance().flyToMapByRegId(linkItem.regionId);
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
				GameFlyManager.getInstance().flyToMapByTeleport(linkItem.teleportId);
			}
		}
		
		public function destroy():void
		{
			if(callLaterId)
			{
				clearTimeout(callLaterId);
				callLaterId = 0;
			}
			
			InterObjCollector.instance.remove(_contentText);
			InterObjCollector.instance.remove(_icon);
			
			_contentText.removeEventListener(TextEvent.LINK, linkClickHandle);
			_titleText.removeEventListener(TextEvent.LINK,tileLinkClickHandle);
			_icon.removeEventListener(MouseEvent.CLICK, cloudClickHandle);
			
			clearInterval(_timer);
		}
		
		public function get icon():Sprite
		{
			return _icon;
		}

		public function set icon(value:Sprite):void
		{
			_icon = value;
		}

		public function swfReceive(url:String, swf:Sprite, info:Object):void
		{
			if (_icon && !_icon.contains(swf))
			{
				_icon.addChild(swf);
			}
		}

		public function swfProgress(url:String, progress:Number, info:Object):void
		{
		}

		public function swfError(url:String, info:Object):void
		{
		}
	}
}