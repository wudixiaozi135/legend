package com.view.gameWindow.mainUi.subuis.activityNow
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.ActivityCfgData;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.mainUi.subclass.McActivityNow;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.guideSystem.GuideSystem;
	import com.view.gameWindow.panel.panels.guideSystem.unlock.UnlockFuncId;
	
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	public class ActivityNowMouseHandle
	{
		private var _ui:ActivityNow;
		private var _skin:McActivityNow;
		private var nextCfgDt:ActivityCfgData;
		private var timer:Timer;
		private var lastTime:int;
		public function ActivityNowMouseHandle(ui:ActivityNow)
		{
			_ui = ui;
			_skin = ui.skin as McActivityNow;
		}
		
		public function initialize():void
		{
			_skin.addEventListener(MouseEvent.CLICK,onClick);
			_skin.btn.buttonMode = true;
//			_skin.activityIcon.buttonMode = true;
			timer = new Timer(1000);
		}
		
		protected function ontimer(event:TimerEvent):void
		{
			// TODO Auto-generated method stub
			var nowTime:int = getTimer();	
			if(nowTime -lastTime>=20*1000){
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER,ontimer);
				PanelMediator.instance.closePanel(PanelConst.TYPE_ACTIVITY_NOW);
			}
		}
		
		protected function onClick(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
//			if(event.target == _skin.btn){
			if(PanelMediator.instance.openedPanel(PanelConst.TYPE_ACTIVITY_NOW))
				return;
			
			if(timer.running){
				timer.stop();
			}
			
			if(!timer.running){
				timer.start();
				if(!timer.hasEventListener(TimerEvent.TIMER))
					timer.addEventListener(TimerEvent.TIMER,ontimer);
				lastTime = getTimer();
				
				
				PanelMediator.instance.openPanel(PanelConst.TYPE_ACTIVITY_NOW);
			}
//			}
		}
		
		private function getNextCfgDt():void
		{
			var actvCfgDts:Dictionary = ConfigDataManager.instance.activityCfgDatas();
			var actvCfgDt:ActivityCfgData;
			if(nextCfgDt && nextCfgDt.secondToStart <= 0)
			{
				nextCfgDt = null;
			}
			for each(actvCfgDt in actvCfgDts)
			{
				var boolean:Boolean = actvCfgDt.secondToStart != int.MIN_VALUE && actvCfgDt.secondToStart != int.MAX_VALUE;
				if(!boolean)
				{
					continue;
				}
				if(actvCfgDt.isInActv)
				{
					nextCfgDt = actvCfgDt;
					return;
				}
				else
				{
					if(!nextCfgDt || actvCfgDt.secondToStart < nextCfgDt.secondToStart)
					{
						nextCfgDt = actvCfgDt;
					}
				}
				if(nextCfgDt.secondToStart > 5*60)
					nextCfgDt = null;
			}
		}
		
	}
}