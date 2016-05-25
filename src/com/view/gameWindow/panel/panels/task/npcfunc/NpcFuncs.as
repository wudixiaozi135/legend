package com.view.gameWindow.panel.panels.task.npcfunc
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.ActivityCfgData;
	import com.model.configData.cfgdata.NpcTeleportCfgData;
	import com.model.configData.cfgdata.TaskCfgData;
	import com.model.consts.StringConst;
	import com.view.gameWindow.mainUi.subuis.activityTrace.ActivityDataManager;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.activitys.seaFeast.SeaFeastDataManager;
	import com.view.gameWindow.panel.panels.dungeon.DgnDataManager;
	import com.view.gameWindow.panel.panels.dungeonTower.DgnTowerDataManger;
	import com.view.gameWindow.panel.panels.guideSystem.GuideSystem;
	import com.view.gameWindow.panel.panels.guideSystem.action.OpenPanelAction;
	import com.view.gameWindow.panel.panels.guideSystem.unlock.UnlockFuncId;
	import com.view.gameWindow.panel.panels.npcfunc.PanelNpcFuncData;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.storage.StorageDataMannager;
	import com.view.gameWindow.panel.panels.task.TaskDataManager;
	import com.view.gameWindow.panel.panels.task.constants.TaskStates;
	import com.view.gameWindow.panel.panels.task.constants.TaskTypes;
	import com.view.gameWindow.panel.panels.task.item.TaskItem;
	import com.view.gameWindow.panel.panels.task.npctask.NpcTaskPanelData;
	import com.view.gameWindow.panel.panels.taskBoss.TaskBossData;
	import com.view.gameWindow.panel.panels.taskBoss.TaskBossDataManager;
	import com.view.gameWindow.panel.panels.taskStar.data.PanelTaskStarDataManager;
	import com.view.gameWindow.panel.panels.trailer.TrailerDataManager;
	import com.view.gameWindow.panel.panels.trans.PanelTransData;
	import com.view.gameWindow.scene.entity.EntityLayerManager;
	import com.view.gameWindow.scene.entity.entityItem.interf.IFirstPlayer;
	import com.view.gameWindow.scene.entity.entityItem.interf.INpcStatic;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	
	import flash.utils.Dictionary;

	/**
	 * npc的功能常量及点击处理类
	 * @author Administrator
	 */	
	public class NpcFuncs
	{
		public static const NF_TASK:int = 0;//任务
		public static const NF_SHOP:int = 1<<0;//商店
		public static const NF_AIRPORT:int = 1<<1;//传送
		public static const NF_DUNGEON:int = 1<<2;//副本
		public static const NF_RECYCLE:int = 1<<3;//回收
		
		public static const NF_STAR_TASK:int = 1025;//星级任务
		public static const NF_REWARD:int = 1026;//悬赏任务
		public static const NF_FORGING:int = 1027;//锻造
		public static const NF_YABIAO:int = 1028;//押镖
		public static const NF_ESCORTS:int = 1029;//护送
		public static const NF_DGN_TOWER:int = 1030;//塔防副本
		public static const NF_STORAGE:int = 1031;//仓库
		public static const NF_ACTIVITY:int = 1032;//活动
		public static const NF_WORSHIP:int = 1033;//城主膜拜
		public static const NF_VIP_GUAJI:int = 1034;//VIP挂机
		public static const NF_GOD_DEVIL:int = 1035;//神威魔域
		public static const NF_SPECIAL_TRANS:int = 1036;//特殊传送
		public static const NF_LOCK_DEMON_TOWER:int = 1037;//锁妖塔
		
		public static var clickNpcOpenPanelType:String;
		public static var clickNpcId:int,clickNpcTileX:int,clickNpcTileY:int;
		
		public static function funcName(type:int):String
		{
			var str:String;
			switch(type)
			{
				case NF_SHOP:
					str = StringConst.NPC_FUNC_PANEL_0001;
					break;
				case NF_AIRPORT:
					str = StringConst.NPC_FUNC_PANEL_0002;
					break;
				case NF_DUNGEON:
					str = StringConst.NPC_FUNC_PANEL_0003;
					break;
				case NF_RECYCLE:
					str = StringConst.NPC_FUNC_PANEL_0004;
					break;
				case NF_FORGING:
					str = StringConst.NPC_FUNC_PANEL_0005;
					break;
				case NF_STAR_TASK:
					str = StringConst.NPC_FUNC_PANEL_0006;
					break;
				case NF_YABIAO:
					str = StringConst.NPC_FUNC_PANEL_0007;
					break;
				case NF_ESCORTS:
					str = StringConst.NPC_FUNC_PANEL_0008;
					break;
				case NF_REWARD:
					str = StringConst.NPC_FUNC_PANEL_0009;
					break;
				case NF_DGN_TOWER:
					str = StringConst.NPC_FUNC_PANEL_0010;
					break;
				case NF_STORAGE:
					str = StringConst.NPC_FUNC_PANEL_0011;
					break;
				default:
					str = "";
					break;
			}
			return str;
		}
		
		public function getFuncItems(func:int, funcExtra:int, npcId:int):Vector.<NpcFuncItem>
		{
			var manager:TaskDataManager = TaskDataManager.instance;
			var items:Vector.<NpcFuncItem> = new Vector.<NpcFuncItem>();
			var item:NpcFuncItem;
			
			/*if (func & NF_TASK)
			{
				items = refreshAllTasks(npcId);
			}*/
			
			if (func & NF_SHOP)
			{
				item = new NpcFuncItem();
				item.init(NF_SHOP, npcId);
				items.push(item);
			}
			
			if (func & NF_DUNGEON)
			{
				item = new NpcFuncItem();
				item.subFunc = 1;
				item.init(NF_DUNGEON, npcId);
				items.push(item);
			}
			
			if (func & NF_AIRPORT)
			{
				item = new NpcFuncItem();
				item.init(NF_AIRPORT, npcId);
				items.push(item);
			}
			
			if (GuideSystem.instance.isUnlock(UnlockFuncId.EQUIP_RECYCLE) && (func & NF_RECYCLE))
			{
				item = new NpcFuncItem();
				item.init(NF_RECYCLE, npcId);
				items.push(item);
			}
			
			if (funcExtra == NF_FORGING)
			{
				item = new NpcFuncItem();
				item.init(NF_FORGING, npcId);
				items.push(item);
			}
			
			if (manager.isUnlockStar && funcExtra == NF_STAR_TASK)
			{
				item = new NpcFuncItem();
				item.init(NF_STAR_TASK,npcId);
				items.push(item);
			}
			
			if (manager.isUnlockReward && funcExtra == NF_REWARD)
			{
				item = new NpcFuncItem();
				item.init(NF_REWARD, npcId);
				items.push(item);
			}
			
			if (funcExtra == NF_DGN_TOWER)
			{
				item = new NpcFuncItem();
				item.init(NF_DGN_TOWER, npcId);
				items.push(item);
			}
			
			if (funcExtra == NF_YABIAO)
			{
				item = new NpcFuncItem();
				item.init(NF_YABIAO, npcId);
				items.push(item);
			}
			
			if (funcExtra == NF_ESCORTS)
			{
				item = new NpcFuncItem();
				item.init(NF_ESCORTS, npcId);
				items.push(item);
			}
			
			if (funcExtra == NF_STORAGE)
			{
				item = new NpcFuncItem();
				item.init(NF_STORAGE, npcId);
				items.push(item);
			}
			
			if (funcExtra == NF_ACTIVITY)
			{
				item = new NpcFuncItem();
				item.init(NF_ACTIVITY, npcId);
				items.push(item);
			}
			
			if (funcExtra == NF_WORSHIP)
			{
				item = new NpcFuncItem();
				item.init(NF_WORSHIP, npcId);
				items.push(item);
			}
			
			if (funcExtra == NF_VIP_GUAJI)
			{
				item = new NpcFuncItem();
				item.init(NF_VIP_GUAJI, npcId);
				items.push(item);
			}
			
			if (funcExtra == NF_GOD_DEVIL)
			{
				item = new NpcFuncItem();
				item.init(NF_GOD_DEVIL, npcId);
				items.push(item);
			}
			
			if (funcExtra == NF_SPECIAL_TRANS)
			{
				item = new NpcFuncItem();
				item.init(NF_SPECIAL_TRANS, npcId);
				items.push(item);
			}
			
			if (funcExtra == NF_LOCK_DEMON_TOWER)
			{
				item = new NpcFuncItem();
				item.init(NF_LOCK_DEMON_TOWER, npcId);
				items.push(item);
			}
			return items;
		}
		
		public function getAllTasks(npcId:int):Vector.<NpcFuncItem>
		{
			return refreshAllTasks(npcId);
		}
		
		private function refreshAllTasks(npcId:int):Vector.<NpcFuncItem>
		{
			var configDataManager:ConfigDataManager = ConfigDataManager.instance;
			var taskPanelDataManger:TaskDataManager = TaskDataManager.instance;
			
			var taskItem:TaskItem;
			var taskConfig:TaskCfgData;
			
			var tasks:Vector.<NpcFuncItem> = new Vector.<NpcFuncItem>();
			var mainTasks:Vector.<NpcFuncItem> = new Vector.<NpcFuncItem>();
			var unCompletedTasks:Vector.<NpcFuncItem> = new Vector.<NpcFuncItem>();
			
			var funcItem:NpcFuncItem;
			var firstPlayer:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
			for each(taskItem in taskPanelDataManger.onDoingTasks)
			{
				taskConfig = configDataManager.taskCfgData(taskItem.id);
				if(taskConfig && taskConfig.type == TaskTypes.TT_MAIN)
				{
					if(taskItem.completed)
					{
						if (taskConfig.end_npc == npcId)
						{
							funcItem = new NpcFuncItem();
							funcItem.init(NF_TASK, npcId, taskConfig.type, taskConfig.id);
							if (taskConfig.type == TaskTypes.TT_MAIN)
							{
								mainTasks.push(funcItem);
							}
						}
					}
					else if (taskConfig && taskConfig.end_npc == npcId)
					{
						funcItem = new NpcFuncItem();
						funcItem.init(NF_TASK, npcId, taskConfig.type, taskConfig.id);
						unCompletedTasks.push(funcItem);
					}
				}
			}
			
			if(mainTasks.length > 1)
			{
				mainTasks.sort(sortByTaskId);
			}

			tasks = mainTasks;
			
			mainTasks = new Vector.<NpcFuncItem>();
			//可接主线任务
			for each (taskItem in taskPanelDataManger.canReceiveTasks)
			{
				taskConfig = configDataManager.taskCfgData(taskItem.id);
				if (taskConfig && taskConfig.start_npc == npcId/* && taskConfig.level <= RolePanelDataManager.getInstance().level*/)
				{
					funcItem = new NpcFuncItem();
					funcItem.init(NF_TASK, npcId, taskConfig.type, taskConfig.id);
					if (taskConfig.type == TaskTypes.TT_MAIN)
					{
						mainTasks.push(funcItem);
					}
				}
			}
			
			if(mainTasks.length > 1)
			{
				mainTasks.sort(sortByTaskId);
			}
			
			tasks = tasks.concat(mainTasks).concat(unCompletedTasks);
			
			return tasks;
		}
		
		private function sortByTaskId(a:NpcFuncItem, b:NpcFuncItem):int
		{
			return a.taskId - b.taskId;
		}
		//打开NPC 面板 xiaoyu
		public function openStaticNpcPanel(staticNpc:INpcStatic):void
		{
			PanelNpcFuncData.npcId = staticNpc.entityId;
			if (staticNpc.entityId == SeaFeastDataManager.SEA_FEAST_NPC_ID)
			{
				clickNpcOpenPanelType = PanelConst.TYPE_SEA_FEAST_NPC;
			}
			else
			{
				clickNpcOpenPanelType = PanelConst.TYPE_NPC_FUNC;
			}
			PanelMediator.instance.switchPanel(clickNpcOpenPanelType);
		}
		
		public function clickFunc(items:Vector.<NpcFuncItem>,target:INpcStatic,fp:IFirstPlayer):void
		{
			var mediator:PanelMediator = PanelMediator.instance;
			var taskConfig : TaskCfgData =null;
			PanelNpcFuncData.npcId = target.entityId;
			if(items[0].func == NpcFuncs.NF_TASK)
			{
				taskConfig = ConfigDataManager.instance.taskCfgData(items[0].taskId);
				if(taskConfig)
				{
					var lv:int = RoleDataManager.instance.lv;
					if(lv < taskConfig.level)
					{
						RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.TASK_0017);
						return;
					}
					if((taskConfig.type == TaskTypes.TT_MAIN) && TaskDataManager.instance.getTaskState(items[0].taskId) != TaskStates.TS_DOING)
					{
						NpcTaskPanelData.npcId = target.entityId;
						NpcTaskPanelData.taskId = items[0].taskId;
						clickNpcOpenPanelType = PanelConst.TYPE_TASK_ACCEPT_COMPLETE;
						mediator.switchPanel(clickNpcOpenPanelType);
					}
				}
			}
			else if(items.length == 1)
			{
				switch(items[0].func)
				{
					case NpcFuncs.NF_SHOP:
						dealShop();
						break;
					case NpcFuncs.NF_AIRPORT:
						dealAirport();
						break;
					case NpcFuncs.NF_DUNGEON:
						dealDungeon();
						break;
					case NpcFuncs.NF_RECYCLE:
						dealRecycle();
						break;
					case NpcFuncs.NF_FORGING:
						dealForging();
						break;
					case NpcFuncs.NF_STAR_TASK:
						dealStarTask();
						break;
					case NpcFuncs.NF_YABIAO:
						dealYaBiao();
						break;
					case NpcFuncs.NF_ESCORTS:
						break;
					case NpcFuncs.NF_REWARD:
						dealReward();
						break;
					case NpcFuncs.NF_DGN_TOWER:
						dealDgnTower();
						break;
					case NpcFuncs.NF_STORAGE:
						dealStorage();
						break;
					case NpcFuncs.NF_ACTIVITY:
						dealActivity();
						break;
					case NpcFuncs.NF_WORSHIP:
						dealWorship();
						break;
					case NpcFuncs.NF_VIP_GUAJI:
						dealVipGuaJi();
						break;
					case NpcFuncs.NF_GOD_DEVIL:
						dealGodDevil();
						break;
					case NpcFuncs.NF_SPECIAL_TRANS:
						dealSpecialTrans();
						break;
					case NpcFuncs.NF_LOCK_DEMON_TOWER:
						dealLockDemonTower();
						break;
				}
			}
			else
			{
				PanelNpcFuncData.items = items;
				clickNpcOpenPanelType = PanelConst.TYPE_NPC_FUNC;
				mediator.switchPanel(clickNpcOpenPanelType);
			}
		}
		
		private function dealLockDemonTower():void
		{
			var npcId:int = PanelNpcFuncData.npcId;
			clickNpcOpenPanelType = PanelConst.TYPE_DEMON_TOWER;
			PanelMediator.instance.openPanel(clickNpcOpenPanelType,true,npcId);
		}
		
		private function dealSpecialTrans():void
		{
			var npcId:int = PanelNpcFuncData.npcId;
			clickNpcOpenPanelType = PanelConst.TYPE_SPECIAL_TRANS;
			PanelMediator.instance.openPanel(clickNpcOpenPanelType,true,npcId);
		}
		
		private function dealGodDevil():void
		{
			var npcId:int = PanelNpcFuncData.npcId;
			clickNpcOpenPanelType = PanelConst.TYPE_GOD_DEVIL;
			PanelMediator.instance.openPanel(clickNpcOpenPanelType,true,npcId);
		}
		
		private function dealVipGuaJi():void
		{
			clickNpcOpenPanelType = PanelConst.TYPE_VIP_GUAJI;
			PanelMediator.instance.switchPanel(clickNpcOpenPanelType);
		}
		
		private function dealYaBiao():void
		{
			var cfgData:TaskCfgData = TrailerDataManager.getInstance().getTasktrailerCfg();
			var npcId:int = PanelNpcFuncData.npcId;
			if(cfgData.start_npc==npcId)
			{
				clickNpcOpenPanelType = PanelConst.TYPE_TRAILER_IN;
				PanelMediator.instance.switchPanel(clickNpcOpenPanelType);
			}else
			{
				clickNpcOpenPanelType = PanelConst.TYPE_TRAILER_COMPLETE;
				PanelMediator.instance.switchPanel(clickNpcOpenPanelType);
			}
		}
		
		private function dealActivity():void
		{
			var npcId:int = PanelNpcFuncData.npcId;
			var activityCfgData1:ActivityCfgData = ConfigDataManager.instance.activityCfgData1(npcId);
			if(!activityCfgData1)
			{
				trace("NpcFuncs.dealActivity() 该NPC对应的活动配置不存在");
				return;
			}
			clickNpcOpenPanelType = PanelConst.TYPE_ACTIVITY_ENTER;
			PanelMediator.instance.openPanel(clickNpcOpenPanelType,true,npcId);
		}
		
		private function dealWorship():void
		{
			ActivityDataManager.instance.worshipDataManager.cmQueryMasterWorship();
			clickNpcOpenPanelType = PanelConst.TYPE_WORSHIP;
			PanelMediator.instance.switchPanel(clickNpcOpenPanelType);
		}
		
		private function dealDgnTower():void
		{
			var npcId:int = PanelNpcFuncData.npcId;
			var dic:Dictionary = ConfigDataManager.instance.taskCfgDatas(npcId);
			if(!dic)
			{
				trace("PanelNpcFuncItem.onClick 该NPC对应的塔防副本配置不存在");
				return;
			}
			DgnDataManager.instance.queryChrDungeonInfo();
			DgnTowerDataManger.instance.cmQueryTowerDungeonExp();
			clickNpcOpenPanelType = PanelConst.TYPE_DUNGEON_TOWER_ENTER;
			PanelMediator.instance.switchPanel(clickNpcOpenPanelType);
		}
		
		private function dealReward():void
		{
			var dic:Dictionary = ConfigDataManager.instance.taskCfgDatas(PanelNpcFuncData.npcId);
			if(!dic)
			{
				trace("PanelNpcFuncItem.onClick 该NPC对应的悬赏任务配置不存在");
				return;
			}
			var doingTask:TaskBossData = TaskBossDataManager.instance.doingTask;
			var id:int = doingTask ? doingTask.id : 0;
			var cfgDt:TaskCfgData = ConfigDataManager.instance.taskCfgData(id);
			var lvReward:int = TaskDataManager.instance.lvReward;
			var reincarnReward:int = TaskDataManager.instance.reincarnReward;
			var reincarnValue:int = cfgDt ? cfgDt.reincarn : reincarnReward;
			var levelValue:int = cfgDt ? cfgDt.level : lvReward;
			var checkReincarnLevel:Boolean = RoleDataManager.instance.checkReincarnLevel(reincarnValue,levelValue);
			if(!checkReincarnLevel)
			{
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.TASK_0017);
				return;
			}
			clickNpcOpenPanelType = PanelConst.TYPE_TASK_BOSS;
			PanelMediator.instance.switchPanel(clickNpcOpenPanelType);
		}
		
		private function dealStarTask():void
		{
			var dic:Dictionary = ConfigDataManager.instance.taskCfgDatas(PanelNpcFuncData.npcId);
			if(!dic)
			{
				trace("PanelNpcFuncItem.onClick 该NPC对应的星级任务配置不存在");
				return;
			}
			var tid:int = PanelTaskStarDataManager.instance.tid;
			var cfgDt:TaskCfgData = ConfigDataManager.instance.taskCfgData(tid);
			var lvStar:int = TaskDataManager.instance.lvStar;
			var reincarnStar:int = TaskDataManager.instance.reincarnStar;
			var reincarnValue:int = cfgDt ? cfgDt.reincarn : reincarnStar;
			var levelValue:int = cfgDt ? cfgDt.level : lvStar;
			var checkReincarnLevel:Boolean = RoleDataManager.instance.checkReincarnLevel(reincarnValue,levelValue);
			if(!checkReincarnLevel)
			{
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.TASK_0017);
				return;
			}
			PanelTaskStarDataManager.instance.request();
			PanelTaskStarDataManager.instance.callBack = function ():void
			{
				clickNpcOpenPanelType = PanelConst.TYPE_TASK_STAR;
				PanelMediator.instance.switchPanel(clickNpcOpenPanelType);
				/*var isComplete:Boolean = PanelTaskStarDataManager.instance.isComplete;
				if(isComplete)
				{
					clickNpcOpenPanelType = PanelConst.TYPE_TASK_STAR_OVER;
					PanelMediator.instance.switchPanel(clickNpcOpenPanelType);
				}
				else
				{
					clickNpcOpenPanelType = PanelConst.TYPE_TASK_STAR;
					PanelMediator.instance.switchPanel(clickNpcOpenPanelType);
				}*/
			};
		}
		
		private function dealRecycle():void
		{
			//RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.PROMPT_PANEL_0007);
			clickNpcOpenPanelType = PanelConst.TYPE_EQUIP_RECYCLE;
			PanelMediator.instance.switchPanel(clickNpcOpenPanelType);
		}
		
		private function dealForging():void
		{
			clickNpcOpenPanelType = PanelConst.TYPE_FORGE;
			var open:OpenPanelAction = new OpenPanelAction(clickNpcOpenPanelType,0);
			open.act();
		}
		
		private function dealDungeon():void
		{
			var dic:Dictionary = ConfigDataManager.instance.dungeonCfgData(PanelNpcFuncData.npcId);
			if(!dic)
			{
				trace("PanelNpcFuncItem.onClick 该NPC对应的副本配置不存在");
				return;
			}
			clickNpcOpenPanelType = PanelConst.TYPE_DUNGEON;
			PanelMediator.instance.switchPanel(clickNpcOpenPanelType);
		}
		
		private function dealAirport():void
		{
			var dic:Dictionary = ConfigDataManager.instance.npcTeleportCfgDatas(PanelNpcFuncData.npcId);
			var npcTeleportCfgData:NpcTeleportCfgData;
			var leng:int = 0;
			if(!dic)
			{
				trace("PanelNpcFuncItem.onClick 该NPC对应的传送配置不存在");
				return;
			}
			for each(var npcTeleportCfg:NpcTeleportCfgData in dic)
			{
				leng++;
				npcTeleportCfgData = npcTeleportCfg;
			}
			clickNpcOpenPanelType = PanelConst.TYPE_TRANS;
			if(leng == 1)
			{
				PanelTransData.npcId = npcTeleportCfgData.npc;
				PanelTransData.npcTeleportId = npcTeleportCfgData.id;
				PanelTransData.name = npcTeleportCfgData.name;
//				PanelTransData.normal_monster_drop = PanelTransData.getMapCfgData(npcTeleportCfgData.npc,npcTeleportCfgData.id).normal_monster_drop;
//				PanelTransData.elite_monster_drop =  PanelTransData.getMapCfgData(npcTeleportCfgData.npc,npcTeleportCfgData.id).elite_monster_drop;
				PanelTransData.boss_drop = PanelTransData.getMapCfgData(npcTeleportCfgData.npc,npcTeleportCfgData.id).boss_drop;
				PanelTransData.coin = PanelTransData.getCoin(npcTeleportCfgData);
				PanelTransData.desc = PanelTransData.getMapCfgData(npcTeleportCfgData.npc,npcTeleportCfgData.id).desc;
				clickNpcOpenPanelType = PanelConst.TYPE_MAP_TRANS;
			}
			PanelMediator.instance.switchPanel(clickNpcOpenPanelType);
		}
		
		private function dealShop():void
		{
			var dic:Dictionary = ConfigDataManager.instance.npcShopCfgDatas(PanelNpcFuncData.npcId);
			if(!dic)
			{
				trace("PanelNpcFuncItem.onClick 该NPC对应的商店配置不存在");
				return;
			}
			clickNpcOpenPanelType = PanelConst.TYPE_NPC_SHOP;
			PanelMediator.instance.openPanel(clickNpcOpenPanelType);
			PanelMediator.instance.openPanel(PanelConst.TYPE_BAG);
		}
		
		private function dealStorage():void
		{
			clickNpcOpenPanelType = PanelConst.TYPE_STORAGE;
			//PanelMediator.instance.switchPanel(PanelConst.TYPE_STORAGE);
			StorageDataMannager.instance.queryStoreitems(0);
		}
		
	}
}