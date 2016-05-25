package com.view.gameWindow.panel.panels.guideSystem.trigger
{
	import com.model.configData.cfgdata.GuideCfgData;
	import com.view.gameWindow.panel.panels.guideSystem.constants.GuideCondTypes;
	import com.view.gameWindow.panel.panels.task.constants.TaskStates;
	
	import mx.utils.StringUtil;
	
	/**
	 * @author wqhk
	 * 2014-12-12
	 */
	public class GuideTrigger2 implements IGuideTrigger
	{
//		protected var list:Array = null;
		protected var taskCondList:Array;
		protected var sceneCondList:Array;
		protected var nextCondList:Array;
		protected var lvCondList:Array;
		protected var firstDeadList:Array;
		protected var jointAttackList:Array;
		protected var expStoneList:Array;
		protected var heroModeList:Array;
		
		protected var excuteCallback:Function = null;
		public function GuideTrigger2(taskCondList:Array,sceneCondList:Array,nextCondList:Array,
									  lvCondList:Array,
									  firstDeadList:Array,
									  jointAttackList:Array,
									  expStoneList:Array,
									  heroModeList:Array,
									  executeCallback:Function)
		{
//			this.list = list.concat();
			
			this.taskCondList = taskCondList ? taskCondList.concat() : null;
			this.sceneCondList = sceneCondList ? sceneCondList.concat() : null;
			this.nextCondList = nextCondList ? nextCondList.concat() : null;
			this.lvCondList = lvCondList ? lvCondList.concat() : null;
			this.firstDeadList = firstDeadList ? firstDeadList.concat() : null;
			this.jointAttackList = jointAttackList ? jointAttackList.concat() : null;
			this.expStoneList = expStoneList ? expStoneList.concat() : null;
			this.heroModeList = heroModeList ? heroModeList.concat() : null;
			this.excuteCallback = executeCallback;
		}
		
		public function updateLoginState():void
		{
			if(excuteCallback == null)
			{
				return;
			}
			
//			for each(var cfg : GuideCfgData in list)
//			{
//				if(cfg.cond_type == GuideCondTypes.GCT_LOGIN)
//				{
//					excuteCallback(cfg);
//				}
//			}
		}
		
		public function updateHeroHoldMode():void
		{
			if(excuteCallback == null)
			{
				return;
			}
			
			var list:Array = [];
			for each(var cfg:GuideCfgData in heroModeList)
			{
				var p:int = parseInt(cfg.cond_param);
				if(cfg.cond_type == GuideCondTypes.GCT_HEROMODE_HOLD)
				{
					list.push(cfg);
				}
			}
			
			excuteCallback(list);
		}
		
		
		/**
		 * 经验玉 经验满
		 */
		public function updateExpStone(times:int):void
		{
			if(excuteCallback == null)
			{
				return;
			}
			
			var list:Array = [];
			for each(var cfg:GuideCfgData in expStoneList)
			{
				var p:int = parseInt(cfg.cond_param);
				if(cfg.cond_type == GuideCondTypes.GCT_EXPSTONE && (p == 0 || p == times))
				{
					list.push(cfg);
				}
			}
			
			excuteCallback(list);
		}
		
		public function updateJointAttack():void
		{
			if(excuteCallback == null)
			{
				return;
			}
			
			var list:Array = [];
			for each(var cfg:GuideCfgData in jointAttackList)
			{
				if(cfg.cond_type == GuideCondTypes.GCT_JOINTATTACK)
				{
					list.push(cfg);
				}
			}
			
			excuteCallback(list);
		}
		
		public function updateFirstDead(type:int):void
		{
			if(excuteCallback == null)
			{
				return;
			}
			
			var list:Array = [];
			for each(var cfg:GuideCfgData in firstDeadList)
			{
				var p:int = parseInt(cfg.cond_param);
				
				if(cfg.cond_type == GuideCondTypes.GCT_DEAD && (type == 3 || type == p))
				{
					list.push(cfg);
				}
			}
			
			excuteCallback(list);
		}
		
		
		public function updateTaskState(tid:int, tstate:int):void
		{
			if(excuteCallback == null)
			{
				return;
			}
			
			var list:Array = [];
			
			var clear:GuideCfgData = new GuideCfgData();
			clear.id = 0;
			clear.cond_type = GuideCondTypes.GCT_TASK;
			
			var stateValue:String = tid + ":" + tstate;
			clear.cond_param = stateValue;
			list.push(clear);
			
			for each(var cfg:GuideCfgData in taskCondList)
			{
//				if(cfg.cond_type == GuideCondTypes.GCT_TASK 
//					&& StringUtil.trim(cfg.cond_param) == stateValue)
				//出于性能考虑
				if(cfg.cond_type == GuideCondTypes.GCT_TASK 
					&& cfg.cond_param == stateValue)
				{
					list.push(cfg);
				}
			}
			
			excuteCallback(list);
		}
		
		public function updateEnterSceneState(mid:int):void
		{
			if(excuteCallback == null)
			{
				return;
			}
			
			var list:Array = [];
			
			var clear:GuideCfgData = new GuideCfgData();
			clear.id = 0;
			clear.cond_type = GuideCondTypes.GCT_ENTER_SCENE;
			clear.cond_param = mid.toString();
			list.push(clear);
			
			for each(var cfg:GuideCfgData in sceneCondList)
			{
				if(cfg.cond_type == GuideCondTypes.GCT_ENTER_SCENE && parseInt(cfg.cond_param) == mid)
				{
					list.push(cfg);
				}
			}
			
			excuteCallback(list);
		}
		
		public function updateGuideState(gid:int):void
		{
			if(excuteCallback == null)
			{
				return;
			}
			
			var list:Array = [];
			
			var clear:GuideCfgData = new GuideCfgData();
			clear.id = 0;
			clear.cond_type = GuideCondTypes.GCT_GUIDE_FINISH;
			clear.cond_param = gid.toString();
			list.push(clear);
			
			for each(var cfg:GuideCfgData in nextCondList)
			{
				if(cfg.cond_type == GuideCondTypes.GCT_GUIDE_FINISH && parseInt(cfg.cond_param) == gid)
				{
					list.push(cfg);
				}
			}
			
			excuteCallback(list);
		}
		
		public function updateLevelState(roleType:int, roleLevel:int, roleRe:int = 0,isFirst:Boolean = true):void
		{
			if(roleRe != 0)
			{
				return;
			}
			
			if(excuteCallback == null || !isFirst)
			{
				return;
			}
			
			var list:Array = [];
			var cond:String = roleType+":"+roleLevel;
			var clear:GuideCfgData = new GuideCfgData();
			clear.id = 0;
			clear.cond_type = GuideCondTypes.GCT_LEVEL;
			clear.cond_param = cond;
			list.push(clear);
			
			
			for each(var cfg:GuideCfgData in lvCondList)
			{
				if(cfg.cond_type == GuideCondTypes.GCT_LEVEL && cfg.cond_param == cond)
				{
					list.push(cfg);
				}
			}
			
			excuteCallback(list);
		}
	}
}