package com.view.gameWindow.panel.panels.deadRevive
{
	import com.view.gameWindow.mainUi.subuis.activityTrace.ActivityDataManager;
	import com.view.gameWindow.mainUi.subuis.activityTrace.constants.ActivityFuncTypes;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.onhook.AutoSystem;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	public class DeadReviveClickHandler
	{
		public var mcDeadRevive:McDeadRevive;
		private var _skin:PanelBase;
		public var deadRevivePanel:DeadRevivePanel;
		
		public function DeadReviveClickHandler()
		{
		}
		
		public function addEvent(eventDispatcher:EventDispatcher):void
		{
			eventDispatcher.addEventListener(MouseEvent.CLICK,onClick);
			AutoSystem.instance.addEventListener("revive",autoSystemReviveHandler);
		}
		
		protected function autoSystemReviveHandler(e:Event):void
		{
			var manager:ActivityDataManager = ActivityDataManager.instance;
			var isEqual:Boolean = manager.isAcitivtyTypeEqualValue(ActivityFuncTypes.AFT_LOONG_WAR);
			if(isEqual)
			{
				var isInActv:Boolean = manager.currentActvCfgDtAtMap ? manager.currentActvCfgDtAtMap.isInActv : false;
				if(isInActv)
				{
					return;
				}
			}
			deadRevivePanel.changeBtnStatus();
		}
		
		protected function onClick(event:MouseEvent):void
		{
			switch(event.target)
			{
				//回城复活
				case mcDeadRevive.backHomeRevive:
					deadRevivePanel.sendReviveData(1);
					deadRevivePanel.removeMaskAndSelf();
					break;
				//原地复活
				case mcDeadRevive.revive:
					deadRevivePanel.changeBtnStatus();
					break;
				//购买玫瑰
				case mcDeadRevive.purchaseRose:
					deadRevivePanel.purchaseRose();
					break;
			}
		}
		
		public function removeEvent(eventDispatcher:EventDispatcher):void
		{
			AutoSystem.instance.removeEventListener("revive",autoSystemReviveHandler);
			eventDispatcher.removeEventListener(MouseEvent.CLICK,onClick);
			mcDeadRevive = null;
		}
	}
}