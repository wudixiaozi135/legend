package com.view.gameWindow.panel.panels.guideSystem.unlock
{
	import com.core.toArray;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.TaskCfgData;
	import com.model.configData.cfgdata.UnlockCfgData;
	import com.model.consts.StringConst;
	import com.pattern.Observer.Observe;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.guideSystem.GuideSystem;
	import com.view.gameWindow.panel.panels.guideSystem.UICenter;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.unlock.IFuncInfoPanel;
	import com.view.gameWindow.panel.panels.unlock.IUnlockPanel;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;
	
	import flash.utils.Dictionary;
	
	import mx.utils.StringUtil;
	
	/**
	 * 功能解锁
	 * 
	 * @author wqhk
	 * 2014-10-29
	 */
	public class UnlockManager
	{
		private var _unlockDict:Dictionary;
		private var _cfgList:Array;
		private var _stateNotice:Observe;
		private var _animNotice:Observe;//用户点击确定后
		
		public function UnlockManager()
		{
			init();
		}
		
		public function isUnlock(id:int):Boolean
		{
			return _unlockDict[id];
		}
		
		public function init():void
		{
			_unlockDict = new Dictionary();
			
			stateNotice = new UnlockNotice;
			animNotice = new UnlockNotice();
		}
		
		public function get animNotice():Observe
		{
			return _animNotice;
		}

		public function set animNotice(value:Observe):void
		{
			_animNotice = value;
		}

		public function set stateNotice(value:Observe):void
		{
			_stateNotice = value;
		}
		
		public function get stateNotice():Observe
		{
			return _stateNotice;
		}
		
		public function getCfgList():Array
		{
			if(!_cfgList)
			{
				_cfgList = [];
				
				toArray(ConfigDataManager.instance.unlockCfgDatas(),_cfgList);
			}
			
			return _cfgList;
		}
		
		public function executeUnlockData(data:UnlockCfgData):void
		{
			if(data.lock_state == 0)
			{
				//解锁
				trace("解锁 func_id:"+data.func_id);
				
				if(data.panel_id == 1)
				{
					PanelMediator.instance.openPanel(PanelConst.TYPE_COVER);
					PanelMediator.instance.openPanel(PanelConst.TYPE_UNLOCK);
					
					var panel:IUnlockPanel = PanelMediator.instance.openedPanel(PanelConst.TYPE_UNLOCK) as IUnlockPanel;
					
					if(panel)
					{
						panel.setFuncId(data.func_id);
						panel.setTxt(CfgDataParse.pareseDesToStr(data.panel_txt,0xffcc00));
						panel.setIcon(data.panel_icon);
					}
				}
			}
		}
		
		public function resetUnloclState():void
		{
			for(var id:String in _unlockDict)
			{
				_unlockDict[id] = false;
			}
		}
		
		private function checkFuncIdPanel(funcId:int):void
		{
			var f:IFuncInfoPanel = UICenter.getUI(PanelConst.TYPE_MAIN_FUNCINFO) as IFuncInfoPanel;
			if(f)
			{
				f.checkFuncId(funcId);
			}
		}
		
		public function setUnlockState(data:UnlockCfgData):void
		{
			if(data.lock_state == 0)//unlock
			{
				_unlockDict[data.func_id] = true;
				trace("设置解锁状态 func_id:"+data.func_id);
				
				if(_stateNotice)
				{
					_stateNotice.notify(data.func_id);
				}
				
				checkFuncIdPanel(data.func_id);
			}
		}
		
		/**
		 * 打开 注意有顺序 （根据配置表的先后）
		 */
		public function openUnlockInfo(data:UnlockCfgData):void
		{
			if(data.lock_state == UnlockFuncId.STATE_NONE)
			{
				var panel:IFuncInfoPanel = UICenter.getUI(PanelConst.TYPE_MAIN_FUNCINFO) as IFuncInfoPanel;
				
				if(panel)
				{
					var un:UnlockCfgData = GuideSystem.instance.getUnlock(data.func_id);
					
					if(RoleDataManager.instance.reincarn == 0 && un && un.lv > 0)
					{
						var lv:int = un.lv - RoleDataManager.instance.lv;
						if(lv < 0)
						{
							lv = 0;
						}
						panel.setFuncId(data.func_id);
						panel.setTxt(HtmlUtils.createHtmlStr(0xffff00,lv.toString(),20,true));
						panel.setIcon(data.panel_icon);
						panel.show(true);
					}
				}
			}
		}
		
		public function checkUnlockState(data:UnlockCfgData):Boolean
		{
			return _unlockDict[data.func_id];
		}
		
		public function getUnlockTip(func_id:int):String
		{
//			for each(var un:UnlockCfgData in _cfgList)
//			{
//				if(un.func_id == func_id && un.lock_state == 0)//解锁
//				{
//					if(un.task_id > 0)
//					{
//						var taskCfg:TaskCfgData = ConfigDataManager.instance.taskCfgData(un.task_id);
//						return StringUtil.substitute(StringConst.TIP_COMP,taskCfg.name) + StringConst.TIP_UNLOCK;
//					}
//					else if(un.lv != 0)//没判断转生
//					{
//						if(!RoleDataManager.instance.checkReincarnLevel(0,un.lv))
//						{
//							return un.lv + StringConst.TIP_LV + StringConst.TIP_UNLOCK;
//						}
//					}
//				}
//			}
			
			var un:UnlockCfgData = getUnlock(func_id);
			
			if(un)
			{
				if(un.task_id > 0)
				{
					var taskCfg:TaskCfgData = ConfigDataManager.instance.taskCfgData(un.task_id);
					return StringUtil.substitute(StringConst.TIP_COMP,taskCfg.name) + StringConst.TIP_UNLOCK;
				}
				else if(un.lv != 0)//没判断转生
				{
					if(!RoleDataManager.instance.checkReincarnLevel(0,un.lv))
					{
						return un.lv + StringConst.TIP_LV + StringConst.TIP_UNLOCK;
					}
				}
			}
			
			return StringConst.TIP_LOCK;
		}
		
		public function getUnlock(func_id:int):UnlockCfgData
		{
			for each(var un:UnlockCfgData in _cfgList)
			{
				if(un.func_id == func_id && un.lock_state == 0)//解锁
				{
					return un;
				}
			}
			
			return null;
		}
	}
}