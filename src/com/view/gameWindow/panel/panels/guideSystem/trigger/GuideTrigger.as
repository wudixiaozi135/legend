package com.view.gameWindow.panel.panels.guideSystem.trigger
{
	import com.model.configData.cfgdata.GuideCfgData;
	import com.view.gameWindow.panel.panels.guideSystem.constants.GuideCondTypes;
	import com.view.gameWindow.panel.panels.task.constants.TaskStates;
	
	import mx.utils.StringUtil;
	
	/**
	 * @author wqhk
	 * 2014-10-27
	 */
	public class GuideTrigger implements IGuideTrigger
	{
		protected var list:Array = null;
		protected var excuteCallback:Function = null;
		public function GuideTrigger(list:Array,executeCallback:Function)
		{
			this.list = list.concat();
			this.excuteCallback = executeCallback;
		}
		
		public function updateLoginState():void
		{
			if(excuteCallback == null)
			{
				return;
			}
			
			for each(var cfg : GuideCfgData in list)
			{
				if(cfg.cond_type == GuideCondTypes.GCT_LOGIN)
				{
					excuteCallback(cfg);
				}
			}
		}
		
		public function updateTaskState(tid:int, tstate:int):void
		{
			if(excuteCallback == null)
			{
				return;
			}
			
			for each(var cfg:GuideCfgData in list)
			{
				if(cfg.cond_type == GuideCondTypes.GCT_TASK 
					&& StringUtil.trim(cfg.cond_param) == tid+":"+tstate)
				{
					excuteCallback(cfg);
				}
			}
		}
		
		public function updateEnterSceneState(mid:int):void
		{
			if(excuteCallback == null)
			{
				return;
			}
			
			for each(var cfg:GuideCfgData in list)
			{
				if(cfg.cond_type == GuideCondTypes.GCT_ENTER_SCENE && parseInt(cfg.cond_param) == mid)
				{
					excuteCallback(cfg);
				}
			}
		}
		
		public function updateGuideState(gid:int):void
		{
			if(excuteCallback == null)
			{
				return;
			}
			
			for each(var cfg:GuideCfgData in list)
			{
				if(cfg.cond_type == GuideCondTypes.GCT_GUIDE_FINISH && parseInt(cfg.cond_param) == gid)
				{
					excuteCallback(cfg);
				}
			}
		}
		
		public function updateLevelState(roleType:int, roleLevel:int, roleRe:int = 0,isFirst:Boolean = true):void
		{
			if(roleRe != 0)
			{
				return;
			}
			if(excuteCallback == null && !isFirst)
			{
				return;
			}
			
			for each(var cfg:GuideCfgData in list)
			{
				if(cfg.cond_type == GuideCondTypes.GCT_LEVEL && StringUtil.trim(cfg.cond_param) == roleType+":"+roleLevel)
				{
					excuteCallback(cfg);
				}
			}
		}
	}
}