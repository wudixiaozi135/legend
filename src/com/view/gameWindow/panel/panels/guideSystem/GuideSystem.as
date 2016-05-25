package com.view.gameWindow.panel.panels.guideSystem
{
	import com.core.bind_t;
	import com.model.configData.cfgdata.GuideCfgData;
	import com.model.configData.cfgdata.UnlockCfgData;
	import com.pattern.Observer.Observe;
	import com.view.gameWindow.panel.panels.guideSystem.action.AttachPanelAction;
	import com.view.gameWindow.panel.panels.guideSystem.action.GuideAction;
	import com.view.gameWindow.panel.panels.guideSystem.trigger.IGuideTrigger;
	import com.view.gameWindow.panel.panels.guideSystem.unlock.IUnlock;
	import com.view.gameWindow.panel.panels.guideSystem.unlock.IUnlockTrigger;
	import com.view.gameWindow.panel.panels.guideSystem.unlock.UnlockManager;
	import com.view.gameWindow.panel.panels.guideSystem.unlock.UnlockTrigger;
	
	
	
	/**
	 *  @author wqhk
	 * 	2014-10-24
	 */
	public class GuideSystem implements IGuideSystem,IUnlock,IUnlockTrigger
	{
		private static var _instance:GuideSystem;
		public static function get instance():GuideSystem
		{
			if(!_instance)
			{
				_instance = new GuideSystem();
			}
			
			return _instance;
		}
		
		//解锁相关
		private var _unlockTrigger:IUnlockTrigger;
		private var _unlockMgr:UnlockManager;
		private var _trigger:IGuideTrigger;
		private var _processor:IGuideSystem;
		
		public function GuideSystem()
		{
			init();
		}
		
		public function updateEquipType(type:int, isOnFirstInit:Boolean=false):void
		{
			_unlockTrigger.updateEquipType(type,isOnFirstInit);
		}
		
		public function isUnlock(id:int):Boolean
		{
			return _unlockMgr.isUnlock(id);
		}
		
		public function getUnlockTip(id:int):String
		{
			return _unlockMgr.getUnlockTip(id);
		}
		
		public function getUnlock(id:int):UnlockCfgData
		{
			return _unlockMgr.getUnlock(id);
		}
		
		public function get unlockStateNotice():Observe
		{
			return _unlockMgr.stateNotice;
		}
		
		public function get unlockAnimNotice():Observe
		{
			return _unlockMgr.animNotice;
		}
		
		public function init():void
		{
			var p:GuideProcessor2 = new GuideProcessor2();
			_trigger = p;
			_processor = p;
			_unlockMgr = new UnlockManager();
			_unlockTrigger = new UnlockTrigger(_unlockMgr.getCfgList(),_unlockMgr.executeUnlockData,_unlockMgr.setUnlockState,_unlockMgr.checkUnlockState,_unlockMgr.openUnlockInfo);
		}
		
		public function updateUserUnlockOperation(func_id:int):void
		{
			if(_unlockTrigger)
			{
				_unlockTrigger.updateUserUnlockOperation(func_id);
			}
		}
		
		public function updateHeroHoldMode():void
		{
			if(_trigger)
			{
				_trigger.updateHeroHoldMode();
			}
		}
		
		public function updateExpStone(times:int):void
		{
			if(_trigger)
			{
				_trigger.updateExpStone(times);
			}
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
			
			if(_unlockTrigger)
			{
				_unlockTrigger.updateTaskState(tid,tstate);
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
			
			if(_unlockTrigger)
			{
				_unlockTrigger.updateLevelState(roleType,roleLevel,roleRe,isFirst);
			}
		}
		
		public function get doingList():Array
		{
			return _processor.doingList;
		}
		
		
		public function checkDoingGuides():void
		{
			_processor.checkDoingGuides();
		}
		
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
		
		public function get isNeedStopAutoTask():Boolean
		{
			return _processor.isNeedStopAutoTask;
		}
		
		/**
		 * 用作外部单独处理action
		 */
		public function createAction(guideId:int):GuideAction
		{
			return _processor.createAction(guideId);
		}
		
		//会+ cfg:GuideCfgData,act:GuideAction
		public function some(filter:bind_t):Boolean
		{
			return _processor.some(filter);
		}
		
		public static function getPanelNameFilter(panelName:String):bind_t
		{
			return new bind_t(checkPanelName,panelName);
		}
		
		public static function checkPanelName(panelName:String,cfg:GuideCfgData,act:GuideAction):Boolean
		{
			var a:AttachPanelAction = act as AttachPanelAction;
			
			if(!a)
			{
				return false;
			}
			
			//如果都不显示
			if(cfg.arrow_rotation == 0 && cfg.hit_area_show == 1)
			{
				return false;
			}
			
			return a.panelName == panelName;
		}
	}
}