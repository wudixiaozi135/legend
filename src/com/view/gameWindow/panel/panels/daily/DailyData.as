package com.view.gameWindow.panel.panels.daily
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.ActivityCfgData;
	import com.model.configData.cfgdata.DailyCfgData;
	import com.model.configData.cfgdata.DungeonCfgData;
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.panels.dungeon.DgnDataManager;
	import com.view.gameWindow.panel.panels.dungeon.DungeonData;
	import com.view.gameWindow.panel.panels.guideSystem.GuideSystem;
	import com.view.gameWindow.panel.panels.guideSystem.unlock.UnlockFuncId;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.taskBoss.TaskBossDataManager;
	import com.view.gameWindow.panel.panels.taskStar.data.PanelTaskStarDataManager;
	import com.view.gameWindow.panel.panels.trailer.TrailerDataManager;
	
	import flash.utils.Dictionary;

	public class DailyData
	{
		public static const TYPE_ACTIVITY:int = 1;
		public static const TYPE_TASK:int = 2;
		public static const TYPE_DUNGEON:int = 3;
		public static const TYPE_SIGN_IN:int = 4;
		public static const TYPE_MICRO_LOGIN:int = 5;
		public static const TYPE_EXP_STONE:int = 6;
		public static const TYPE_PRAY:int = 7;
		public static const TYPE_EQUIP_STRENGTHEN:int = 8;
		public static const TYPE_EQUIP_DEGREE:int = 9;
		public static const TYPE_RUNE_COMPOUND:int = 10;
		public static const TYPE_KILL_BOSS:int = 11;
		public static const TYPE_SPECIAL_RING_DUNGEON:int = 12;
		public static const TYPE_EQUIP_DUNGEON:int = 13;
		
		/**daily表id*/
		public var id:int;
		/**1表示已领取，0表示未领取*/
		public var isGet:int;

		public function get dailyCfgData():DailyCfgData
		{
			var cfgDt:DailyCfgData = ConfigDataManager.instance.dailyCfgData(id);
			return cfgDt;
		}
		
		public function get type():int
		{
			if(!dailyCfgData)
			{
				trace("DailyData.type dailyCfgData == null");
				return 0;
			}
			return dailyCfgData.type;
		}
		
		public function get order():int
		{
			if(!dailyCfgData)
			{
				trace("DailyData.order dailyCfgData == null");
				return 0;
			}
			return dailyCfgData.order;
		}
		
		public function get actCfgData():ActivityCfgData
		{
			var activity_id:int = dailyCfgData.activity_id;
			var actCfgData:ActivityCfgData = ConfigDataManager.instance.activityCfgData(activity_id);
			return actCfgData;
		}
		
		public function get taskNpc():int
		{
			var npcId:int;
			if(dailyCfgData.task_type == 1)//星级任务
			{
				npcId = npcId ? npcId : PanelTaskStarDataManager.instance.npcId;
			}
			else if(dailyCfgData.task_type == 2)//悬赏任务
			{
				npcId = npcId ? npcId : TaskBossDataManager.instance.npcId;
			}
			else if(dailyCfgData.task_type == 3)//押镖任务
			{
				npcId = npcId ? npcId : TrailerDataManager.getInstance().getTasktrailerCfg().start_npc;
			}
			return npcId;
		}
		
		public function get taskRemainCount():int
		{
			var done:int,total:int;
			if(dailyCfgData.task_type == 1)//星级任务
			{
				total = PanelTaskStarDataManager.instance.totalCount;
				done = PanelTaskStarDataManager.instance.count;
			}
			else if(dailyCfgData.task_type == 2)//悬赏任务
			{
				total = TaskBossDataManager.instance.num;
				done = TaskBossDataManager.instance.numDone;
			}
			else if(dailyCfgData.task_type == 3)//押镖任务
			{
				total = TrailerDataManager.getInstance().trailerData.totalCount;
				done = TrailerDataManager.getInstance().trailerData.count;
			}
			var remain:int = total - done;
			remain = remain < 0 ? 0 : remain;
			return remain;
		}
		
		public function get taskTitleName():String
		{
			var name:String;
			if(dailyCfgData.task_type == 1)//星级任务
			{
				name = StringConst.NPC_FUNC_PANEL_0006;
			}
			else if(dailyCfgData.task_type == 2)//悬赏任务
			{
				name = StringConst.NPC_FUNC_PANEL_0009;
			}
			else if(dailyCfgData.task_type == 3)//押镖任务
			{
				name = StringConst.NPC_FUNC_PANEL_0007;
			}
			return name;
		}
		
		public function get dgnCfgData():DungeonCfgData
		{
			var dungeon_id:int = dailyCfgData.dungeon_id;
			var cfgDt:DungeonCfgData = ConfigDataManager.instance.dungeonCfgDataId(dungeon_id);
			return cfgDt;
		}
		
		public function get dgnRemainCount():int
		{
			var total:int,done:int;
			var cfgDt:DungeonCfgData = dgnCfgData;
			total = cfgDt.free_count + cfgDt.toll_count;
			var dungeon_id:int = dailyCfgData.dungeon_id;
			var dgnDt:DungeonData = DgnDataManager.instance.datas[dungeon_id] as DungeonData;
			done = dgnDt ? dgnDt.daily_enter_count : 0;
			var remain:int = total - done;
			remain = remain < 0 ? 0 : remain;
			return remain;
		}
		
		public function get dgnTitleName():String
		{
			var name:String = dgnCfgData.name;
			return name;
		}
		private var _countDone:int;
		/**完成的次数<br>有上限*/
		public function get countDone():int
		{
			var count:int;
			var cfgDt:DailyCfgData = dailyCfgData;
			if(type == DailyData.TYPE_TASK)
			{
				if(cfgDt.task_type == 1)//星级任务
				{
					count = PanelTaskStarDataManager.instance.count;
				}
				else if(cfgDt.task_type == 2)//悬赏任务
				{
					count = TaskBossDataManager.instance.numDone;
				}
				else if(cfgDt.task_type == 3)//押镖任务
				{
					count = TrailerDataManager.getInstance().trailerData.count;
				}
			}
			else if(type == DailyData.TYPE_DUNGEON)
			{
				var dgnId:int = cfgDt.dungeon_id;
				var dgnDts:Dictionary = DgnDataManager.instance.datas;
				var dgnDt:DungeonData = dgnDts[dgnId] as DungeonData;
				count = dgnDt ? dgnDt.daily_complete_count : 0;
			}
			else
			{
				count = _countDone;
			}
			return count <= cfgDt.count ? count : cfgDt.count;
		}
		/**
		 * @private
		 */
		public function set countDone(value:int):void
		{
			_countDone = value;
		}
		/**任务或副本解锁*/
		public function get isUnlock():Boolean
		{
			if(type == DailyData.TYPE_TASK)
			{
				var isUnlock:Boolean;
				var cfgDt:DailyCfgData = dailyCfgData;
				if(cfgDt.task_type == 1)//星级任务
				{
					isUnlock = GuideSystem.instance.isUnlock(UnlockFuncId.TASK_STAR);
				}
				else if(cfgDt.task_type == 2)//悬赏任务
				{
					isUnlock = GuideSystem.instance.isUnlock(UnlockFuncId.TASK_BOSS);
				}
				else if(cfgDt.task_type == 3)//押镖任务
				{
					isUnlock = GuideSystem.instance.isUnlock(UnlockFuncId.BODYGUARD_TASK);
				}
				return isUnlock;
			}
			else if(type == DailyData.TYPE_DUNGEON)
			{
				var dgnCfgDt:DungeonCfgData = dgnCfgData;
				if(!dgnCfgDt)
				{
					return true;
				}
				var checkReincarnLevel:Boolean = RoleDataManager.instance.checkReincarnLevel(dgnCfgDt.reincarn,dgnCfgDt.level);
				return checkReincarnLevel;
			}
			else
			{
				return true;
			}
		}
		
		public function DailyData(id:int = -1,isGet:int = -1)
		{
			this.id = id;
			this.isGet = isGet;
		}
	}
}