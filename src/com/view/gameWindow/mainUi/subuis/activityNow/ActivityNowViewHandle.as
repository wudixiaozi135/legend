package com.view.gameWindow.mainUi.subuis.activityNow
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.ActivityCfgData;
	import com.model.dataManager.LoginDataManager;
	import com.pattern.Observer.IObserver;
	import com.view.gameWindow.mainUi.subclass.McActivityNow;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.IPanelBase;
	import com.view.gameWindow.panel.panels.activityNow.PanelActivityNow;
	import com.view.gameWindow.panel.panels.guideSystem.GuideSystem;
	import com.view.gameWindow.panel.panels.guideSystem.unlock.UIUnlockHandler;
	import com.view.gameWindow.panel.panels.guideSystem.unlock.UnlockFuncId;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.util.TimeUtils;
	
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	public class ActivityNowViewHandle implements IObserver
	{
		private var _ui:ActivityNow;
		private var _skin:McActivityNow;
		private var _cfgDt:ActivityCfgData;
		private var _timer:Timer;
		private var _lastTime:int;
		private var _secondTimeId:uint;
		internal var nextCfgDt:ActivityCfgData;
		internal var lastActvCfgDt:ActivityCfgData;
		private var func:Function;
		private var lastActivity:ActivityCfgData;
		private var emptytime:int;
		private var _unlock:UIUnlockHandler;
		public function ActivityNowViewHandle(ui:ActivityNow)
		{
			_ui = ui;
			_skin = ui.skin as McActivityNow;
			LoginDataManager.instance.attach(this);
			_ui.visible = false;
			_skin.btn.alpha = 0;
		}
		
		public function initialize(callback:Function):void
		{
			func = callback;
			_timer = new Timer(1000);
			_timer.addEventListener(TimerEvent.TIMER,onTimer);
//			_timer.start();
			_unlock = new UIUnlockHandler(getUnlockUI,1,showUi);
			_unlock.updateUIStates([UnlockFuncId.ACT_TIP]);
		}
		
		private function showUi(id:int):void
		{
			// TODO Auto Generated method stub
			if(id == UnlockFuncId.ACT_TIP)
			{
				update();
			}
		}
		
		private function getUnlockUI(id:int):*
		{
			// TODO Auto Generated method stub
			if(id == UnlockFuncId.ACT_TIP)
			{
				return _ui;
			}	
		}
		
		protected function onTimer(event:TimerEvent):void
		{
//			var nowTime:int = getTimer();
//			if(nowTime - _lastTime < 60000)
//			{
//				return;
//			}
			/*trace("``````````````````\nnextCfgDt.secondToStart"+nextCfgDt.secondToStart+"\n``````````````````_lastTime:"+_lastTime);
			trace("``````````````````nowTime:"+nowTime+"\n``````````````````````");*/
//			_lastTime = nowTime;
			update();
		}
		
		public function update(proc:int=0):void
		{
			var isUnlock:Boolean = GuideSystem.instance.isUnlock(UnlockFuncId.ACT_TIP);
			if(!_timer.running && proc == GameServiceConstants.SM_SERVER_TIME)
			{
				_timer.start();
				getNextCfgDt();
				if(nextCfgDt&&nextCfgDt.isInActv&&isUnlock){
					PanelMediator.instance.openPanel(PanelConst.TYPE_ACTIVITY_NOW);
				}
			}
			/*trace("ActvEnterViewHandle.update 执行了一次刷新");*/
			getNextCfgDt();
			//
			//			ToolTipManager.getInstance().detach(_skin.mcBtns.mcLayer.txt);
			if(nextCfgDt&&isUnlock)
			{
				if(lastActivity!=nextCfgDt){
					func(nextCfgDt);
					lastActivity = nextCfgDt;
				}
				_ui.visible = true;
				if(nextCfgDt.secondToEnter == 0 && isUnlock)
				{
					PanelMediator.instance.openPanel(PanelConst.TYPE_ACTIVITY_NOW);
				}
				refreshTxt();
			}
			else
			{
				_ui.visible = false;
				var panel:IPanelBase = PanelMediator.instance.openedPanel(PanelConst.TYPE_ACTIVITY_NOW);
				if(panel)
					(panel as PanelActivityNow).closeHandler();
			}			
		}
		
		private function getNextCfgDt():void
		{
			var actvCfgDts:Dictionary = ConfigDataManager.instance.activityCfgDatas();
			var actvCfgDt:ActivityCfgData;
			lastActvCfgDt = nextCfgDt;
			if((nextCfgDt && nextCfgDt.secondToEnter <= 0)||emptytime>0)
			{
				if(emptytime>0)
				{
					emptytime--;
				}
				return;
			}
			for each(actvCfgDt in actvCfgDts)
			{
				var boolean:Boolean = actvCfgDt.secondToEnter != int.MIN_VALUE && actvCfgDt.secondToEnter != int.MAX_VALUE;
				if(!boolean)
				{
					continue;
				}
				if(actvCfgDt.isEnterOpen)
				{
					nextCfgDt = actvCfgDt;
					if(nextCfgDt&&!checkLv())
						nextCfgDt = null;
					return;
				}
				else
				{
					if(!nextCfgDt || actvCfgDt.secondToEnter < nextCfgDt.secondToEnter)
					{
						nextCfgDt = actvCfgDt;
					}
				}
			}
			if(lastActvCfgDt!=nextCfgDt){
				var panel:IPanelBase = PanelMediator.instance.openedPanel(PanelConst.TYPE_ACTIVITY_NOW);
				if(panel)
					(panel as PanelActivityNow).closeHandler();
				lastActvCfgDt = nextCfgDt;
			}
			if(nextCfgDt && nextCfgDt.secondToEnter > 4*60)
			{
				emptytime = nextCfgDt.secondToEnter - 5*60;
				nextCfgDt = null;
			}
			if(nextCfgDt&&!checkLv())
				nextCfgDt = null;
		}
		
		private function refreshTxt():void
		{
			if(nextCfgDt.secondToEnter > 0)
			{
				var timeDuration:Date;
				var string:String;
				var obj:Object =  TimeUtils.calcTime3(nextCfgDt.secondToEnter);
				obj.hour = obj.hour<10?"0"+obj.hour:obj.hour;
				obj.min = obj.min<10?"0"+obj.min:obj.min;
				obj.sec =  obj.sec<10?"0"+obj.sec:obj.sec;
				string = obj.hour+":"+obj.min+":"+obj.sec;
				_skin.txtTime.text = string;
				_skin.txtTime.visible = true;
				_skin.countdown.visible = true;
				
			}
			else if(nextCfgDt.secondToEnter <= 0 && nextCfgDt.secondToEnter!=int.MIN_VALUE)
			{
				_skin.txtTime.text = "";
				_skin.txtTime.visible = false;
				_skin.countdown.visible = false;
			}else{
				_ui.visible = false;
				var panel:IPanelBase = PanelMediator.instance.openedPanel(PanelConst.TYPE_ACTIVITY_NOW);
				if(panel)
					(panel as PanelActivityNow).closeHandler();
			}
			_skin.txtActivityName.text = nextCfgDt.name;
			
		}
		
		private function checkLv():Boolean
		{
			var checkReincarnLevel:Boolean = RoleDataManager.instance.checkReincarnLevel(nextCfgDt.reincarn,nextCfgDt.level);
//			trace("ActvEnterViewHandle.checkLv() checkReincarnLevel:"+checkReincarnLevel);
			return checkReincarnLevel;
		}
	}
}