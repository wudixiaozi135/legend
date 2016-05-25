package com.view.gameWindow.panel.panels.guideSystem
{
	import com.core.toArray;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.GuideCfgData;
	import com.view.gameWindow.panel.panels.guideSystem.action.ActionFactory;
	import com.view.gameWindow.panel.panels.guideSystem.action.ActionType;
	import com.view.gameWindow.panel.panels.guideSystem.action.GuideAction;
	import com.view.gameWindow.panel.panels.guideSystem.action.IActionFactory;
	import com.view.gameWindow.panel.panels.guideSystem.trigger.GuideTrigger;
	import com.view.gameWindow.panel.panels.guideSystem.trigger.IGuideTrigger;
	
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	/**
	 * @author wqhk
	 * 2014-12-12
	 */
	public class GuideProcessor implements IGuideTrigger,IGuideSystem
	{
		private var doingGuides:Dictionary;
		private var _cfgList:Array = [];
		private var _actionFactory:IActionFactory;
		private var _trigger:IGuideTrigger;
		
		public function GuideProcessor()
		{
			_actionFactory = new ActionFactory();
			doingGuides = new Dictionary();
			
			_cfgList = [];
			toArray(ConfigDataManager.instance.guideCfgDatas(),_cfgList);
			_trigger = new GuideTrigger(getCfgList(),executeGuideData);
		}
		
		public function updateLoginState():void //caused by login
		{
			if(_trigger)
			{
				_trigger.updateLoginState();
			}
		}
		
		public function updateTaskState(tid:int, tstate:int):void //caused by task
		{
			if(_trigger)
			{
				_trigger.updateTaskState(tid,tstate);
			}
		}
		
		public function updateEnterSceneState(mid:int):void//caused by enterscene
		{
			if(_trigger)
			{
				_trigger.updateEnterSceneState(mid);
			}
		}
		
		public function updateGuideState(gid:int):void //caused by guide finish
		{
			if(_trigger)
			{
				_trigger.updateGuideState(gid);
			}
		}
		
		public function updateLevelState(roleType:int,roleLevel:int,isFirst:Boolean = true):void //caused by level change
		{
			if(_trigger)
			{
				_trigger.updateLevelState(roleType,roleLevel,isFirst);
			}
		}
		
		protected function getCfgList():Array
		{
			return _cfgList;
		}
		
		protected function getCfgData(id:String):GuideCfgData
		{
			return ConfigDataManager.instance.guideCfgData(int(id));
		}
		
		protected function executeGuideData(guide:GuideCfgData):void
		{
			var guideBehavior:GuideAction = _actionFactory.getAction(guide);
			
			if(guideBehavior)
			{
				guideBehavior.init();
				guideBehavior.act();
				
				if(doingGuides[guide.id])
				{
					doingGuides[guide.id].destroy();
					delete doingGuides[guide.id];
				}
				
				
				for(var id:String in doingGuides)
				{
					var cfg:GuideCfgData = getCfgData(id);
					
					//相同界面只有一个在执行，只有一个箭头
					if(cfg.action_type == ActionType.ATTACH && cfg.target_panel == guide.target_panel)
					{
						doingGuides[id].destroy();
						delete doingGuides[id];
						continue;
					}
				}
				
				doingGuides[guide.id] = guideBehavior;
			}
			else
			{
				//异常情况 未处理的
				//updateGuideState(guide.id);
			}
		}
		
		private var time:int = 0;
		private static const INTERVAL:int = 100;
		
		//目前 attach类型如果没完成会一直在doingGuides中,这点比较危险
		public function checkDoingGuides():void
		{
			if(getTimer() - time < INTERVAL)
			{
				return;
			}
			
			time = getTimer();
			
			var completeList:Array = [];
			var id:*;
			for(id in doingGuides)
			{
				var action:GuideAction = doingGuides[id];
				action.check();
				
				if(action.isComplete())
				{
					action.destroy();
					completeList.push(id);
					delete doingGuides[id];
				}
				else if(action.isIgnore())
				{
					action.destroy();
					delete doingGuides[id];
				}
				else if(action.isBreak())
				{
					action.init();
					action.act();
				}
				
			}
			
			for each(id in completeList)
			{
				updateGuideState(int(id));
			}
		}
	}
}