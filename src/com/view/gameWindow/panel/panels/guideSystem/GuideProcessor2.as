package com.view.gameWindow.panel.panels.guideSystem
{
	import com.core.bind_t;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.GuideCfgData;
	import com.model.configData.cfgdata.TaskCfgData;
	import com.view.gameWindow.mainUi.subuis.chatframe.ChatDataManager;
	import com.view.gameWindow.panel.panels.guideSystem.action.ActionFactory2;
	import com.view.gameWindow.panel.panels.guideSystem.action.ClosePanelAction;
	import com.view.gameWindow.panel.panels.guideSystem.action.GuideAction;
	import com.view.gameWindow.panel.panels.guideSystem.action.IActionFactory;
	import com.view.gameWindow.panel.panels.guideSystem.constants.GuideCondTypes;
	import com.view.gameWindow.panel.panels.guideSystem.constants.GuidesID;
	import com.view.gameWindow.panel.panels.guideSystem.trigger.GuideTrigger2;
	import com.view.gameWindow.panel.panels.guideSystem.trigger.IGuideTrigger;
	import com.view.gameWindow.panel.panels.task.constants.TaskTypes;
	
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	/**
	 * @author wqhk
	 * 2014-12-12
	 */
	public class GuideProcessor2 implements IGuideTrigger,IGuideSystem
	{
		private static const INTERVAL:int = 100;
		private var time:int = 0;
	
		private var doingGuides:Dictionary;
		private var _cfgList:Array = [];
		private var _actionFactory:IActionFactory;
		private var _trigger:IGuideTrigger;
//		private var _isNeedStopAutoTask:Boolean = false;
		
		public function get isNeedStopAutoTask():Boolean
		{
			var ids:String = "";
			for(var id:String in doingGuides)
			{
				var cfg:GuideCfgData = getCfgData(id);
				var action:GuideAction = doingGuides[id] as GuideAction;
				
				if(!action)
				{
					continue;
				}
				
				if(cfg && cfg.auto_task_state == 1)
				{
					//不考虑多个同时存在的情况
					if(cfg.stop_dura > 0)
					{
						if(action.isBreak() && !action.isComplete())
						{
							continue;
						}
						else
						{
							var time:int = getTimer();
							if(time - action.time < cfg.stop_dura*1000 + INTERVAL*4)//增加 延迟
							{
//								trace("停止自动任务的引导id:"+id);
//								ChatDataManager.instance.sendSystemNotice("停止自动任务的引导id:"+id);
								return true;
							}
						}
					}
					else
					{
//						trace("停止自动任务的引导id:"+id);
//						ChatDataManager.instance.sendSystemNotice("停止自动任务的引导id:"+id);
						return true;
					}
				}
				
//				ids += id + ",";
			}
			
//			ChatDataManager.instance.sendSystemNotice("开始自动任务 正进行着的引导:"+ids);
			
			return false;
		}
		
		public function isNeedExecuteTimeOut(id:String):Boolean
		{
			var cfg:GuideCfgData = getCfgData(id);
			if(cfg && cfg.auto_task_state == 1)
			{
				if(cfg.stop_dura > 0)
				{
					var action:GuideAction = doingGuides[id] as GuideAction;
					if(action)
					{
						var time:int = getTimer();
						if(time - action.time >= cfg.stop_dura*1000)
						{
							return true;
						}
					}
				}
			}
			
			return false;
		}
		
		public function isNeedDisappear(id:String):Boolean
		{
			var cfg:GuideCfgData = getCfgData(id);
			if(cfg && cfg.disappear_time > 0)
			{
				var action:GuideAction = doingGuides[id] as GuideAction;
				if(action)
				{
					var time:int = getTimer();
					if(time - action.time >= cfg.disappear_time*1000)
					{
						return true;
					}
				}
			}
			
			return false;
		}
		
		private var _dataMgr:GuideDataManager;
		
		public function GuideProcessor2()
		{
			_dataMgr = GuideDataManager.instance;
			_actionFactory = new ActionFactory2();
			doingGuides = new Dictionary();
			
			_cfgList = [];
			var t:Array = _dataMgr.getList(GuideCondTypes.GCT_TASK);
			var s:Array = _dataMgr.getList(GuideCondTypes.GCT_ENTER_SCENE);
			var n:Array = _dataMgr.getList(GuideCondTypes.GCT_GUIDE_FINISH);
			var l:Array = _dataMgr.getList(GuideCondTypes.GCT_LEVEL);
			var d:Array = _dataMgr.getList(GuideCondTypes.GCT_DEAD);
			var a:Array = _dataMgr.getList(GuideCondTypes.GCT_JOINTATTACK);
			var e:Array = _dataMgr.getList(GuideCondTypes.GCT_EXPSTONE);
			var h:Array = _dataMgr.getList(GuideCondTypes.GCT_HEROMODE_HOLD);
			
			_trigger = new GuideTrigger2(t,s,n,l,d,a,e,h,executeGuideData);
		}
		
		public function updateLoginState():void //caused by login
		{
			if(_trigger)
			{
				_trigger.updateLoginState();
			}
		}
		
		public function updateHeroHoldMode():void
		{
			if(_trigger)
			{
				if(!doingGuides[GuidesID.HERO_HOLD_MODE_FIRST])
				{
					_trigger.updateHeroHoldMode();
				}
			}
		}
		
		private var curTaskId:int;
		private var curTaskState:int;
		
		public function updateTaskState(tid:int, tstate:int):void //caused by task
		{
			if(_trigger)
			{
				_trigger.updateTaskState(tid,tstate);
			}
		}
		
		public function updateExpStone(times:int):void
		{
			if(_trigger)
			{
				_trigger.updateExpStone(times);
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
		
		public function updateLevelState(roleType:int,roleLevel:int,roleRe:int = 0,isFirst:Boolean = true):void //caused by level change
		{
			if(_trigger)
			{
				_trigger.updateLevelState(roleType,roleLevel,roleRe,isFirst);
			}
		}
		
		protected function getCfgData(id:String):GuideCfgData
		{
			return ConfigDataManager.instance.guideCfgData(int(id));
		}
		
		//清理同类型的
		private function clearConflictingGuide(guideId:int,condType:int,condParam:String):void
		{
			var deleteList:Array = [];
			var isSame:Boolean;
			
			for(var id:String in doingGuides)
			{
				var g:GuideCfgData = getCfgData(id);
				
				if(g.cond_type == GuideCondTypes.GCT_GUIDE_FINISH)
				{
					var root:GuideCfgData = _dataMgr.getSerialGuideRoot(g.id);
					if(root && root.cond_type == condType)
					{
						isSame = isSameCond(root.cond_type,root.cond_param,condType,condParam);
						if(isSame)
						{
							deleteList.push(g.id);
						}
					}
					else if(g.id == guideId)
					{
						deleteList.push(g.id);
					}
				}
				else if(g.cond_type == condType)
				{
					isSame = isSameCond(g.cond_type,g.cond_param,condType,condParam);
					if(isSame)
					{
						deleteList.push(g.id);
					}
				}
			}
			
			for each(var deleteId:int in deleteList)
			{
				var action:GuideAction = doingGuides[deleteId] as GuideAction;
				
				if(action)
				{
					if(action is ClosePanelAction)
					{
						action.act();//有可能操作完成 刚好完成任务，然后被清除。 但不知道为什么会这样。
					}
					action.destroy();
					delete doingGuides[deleteId];
				}
			}
		}
		
		public static function isSameCond(leftCond:int,leftParam:String,rightCond:int,rightParam:String):Boolean
		{
			if(leftCond != rightCond)
			{
				return false;
			}
			
			if(leftCond == GuideCondTypes.GCT_TASK)
			{
				var p1:Array = leftParam.split(":");
				var p2:Array = rightParam.split(":");
				
				var isSame:Boolean = isSameTaskType(parseInt(p1[0]),parseInt(p2[0]));
				
				return isSame;
			}
			else if(leftCond == GuideCondTypes.GCT_DEAD)
			{
				var d1:int = parseInt(leftParam);
				var d2:int = parseInt(rightParam);
				
				return d1 == d2;
			}
			else if(leftCond == GuideCondTypes.GCT_LEVEL)
			{
				var l1:Array = leftParam.split(":");
				var l2:Array = rightParam.split(":");
				
				if(l1.length == 2 && l2.length == 2)
				{
					if(parseInt(l1[0]) == parseInt(l2[0]))
					{
						return true;
					}
				}
				return false;
			}
			
			return true;
		}
		
		//都是星级任务
		private static var START_TASKS:Array =[TaskTypes.TT_EXORCISM,TaskTypes.TT_MINING,TaskTypes.TT_ROOTLE];
		
		public static function isSameTaskType(left:int,right:int):Boolean
		{
			var lt:TaskCfgData = ConfigDataManager.instance.taskCfgData(left);
			var rt:TaskCfgData = ConfigDataManager.instance.taskCfgData(right);
			
			if(!lt || !rt)//配置出错
			{
				return false;
			}
			
			if(START_TASKS.indexOf(lt.type) != -1)
			{
				return START_TASKS.indexOf(rt.type) != -1;
			}
			else
			{
				return lt.type == rt.type;
			}
		}
		
		//改为list是代表同一时间触发的同一类型的
		protected function executeGuideData(list:Array):void
		{
			if(!list || list.length == 0)
			{
				return;
			}
			
			var guide:GuideCfgData;
			
			for each(guide in list)
			{
				clearConflictingGuide(guide.id,guide.cond_type,guide.cond_param);
			}
			
			for each(guide in list)
			{
//				//已经有的不做处理 （任务的GameServiceConstants.SM_TASK_PROGRESS消息 打怪时会很频繁下发）
//				if(doingGuides[guide.id])
//				{
//					continue;
//				}
				
				if(guide.id == 0) //0 只为上面的清理：clearConflictingGuide
				{
					continue;
				}
				
				var guideBehavior:GuideAction = createAction(guide.id);
				
				if(guideBehavior)
				{
					guideBehavior.init();
					guideBehavior.act();
					guideBehavior.check();
					doingGuides[guide.id] = guideBehavior;
					
//					trace("进入引导 id:"+guide.id);
//					ChatDataManager.instance.sendSystemNotice("进入引导 id:"+guide.id);
//					checkNeedStopAutoTask(guide);
				}
			}
		}
		
		public function createAction(guideId:int):GuideAction
		{
			var guide:GuideCfgData = ConfigDataManager.instance.guideCfgData(guideId);
			if(!guide)
			{
				return null;
			}
			return _actionFactory.getAction(guide);
		}
		
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
//			_isNeedStopAutoTask = false;
			var g:GuideCfgData
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
					
//					g = getCfgData(id);
//					checkNeedStopAutoTask(g);
				}
				else if(isNeedExecuteTimeOut(id))
				{
//					action.destroy();
//					delete doingGuides[id];
					action.executeAfterTimeOut();
				}
				else if(isNeedDisappear(id))
				{
					action.destroy();
					delete doingGuides[id];
				}
//				else
//				{
//					g = getCfgData(id);
//					checkNeedStopAutoTask(g);
//				}
				
				
				
			}
			
			for each(id in completeList)
			{
				updateGuideState(int(id));
			}
		}
		
//		private function checkNeedStopAutoTask(g:GuideCfgData):void
//		{
//			if(g && g.auto_task_state == 1)
//			{
//				_isNeedStopAutoTask = true;
//			}
//		}
		
		public function updateFirstDead(type:int):void
		{
			if(_trigger)
			{
				_trigger.updateFirstDead(type);
			}
		}
		
		public function updateJointAttack():void
		{
			if(_trigger)
			{
				_trigger.updateJointAttack();
			}
		}
		
		public function some(filter:bind_t):Boolean
		{
			for(var id:String in doingGuides)
			{
				var act:GuideAction = doingGuides[id];
				var cfg:GuideCfgData = getCfgData(id);
				filter.push(cfg);
				filter.push(act);
				if(filter.call())
				{
					return true;
				}
				filter.pop();
				filter.pop();
			}
			
			return false;
		}
		
		public function get doingList():Array
		{
			var re:Array = [];
			for(var id:String in doingGuides)
			{
				re.push(id);
			}
			
			return re;
		}
		
	}
}