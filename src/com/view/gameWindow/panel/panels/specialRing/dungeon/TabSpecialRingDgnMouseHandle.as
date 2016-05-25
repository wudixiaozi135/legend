package com.view.gameWindow.panel.panels.specialRing.dungeon
{
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.daily.DailyDataManager;
	import com.view.gameWindow.panel.panels.guideSystem.GuideSystem;
	import com.view.gameWindow.panel.panels.guideSystem.unlock.UnlockFuncId;
	import com.view.gameWindow.panel.panels.specialRing.SpecialRingDataManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	/**
	 * 特戒副本页鼠标相关处理类
	 * @author Administrator
	 */	
	public class TabSpecialRingDgnMouseHandle
	{
		private var _tab:TabSpecialRingDungeon;
		private var _skin:McSpecialRingDungeon;
		
		public function TabSpecialRingDgnMouseHandle(tab:TabSpecialRingDungeon)
		{
			_tab = tab;
			_skin = _tab.skin as McSpecialRingDungeon;
			init();
		}
		
		private function init():void
		{
			_skin.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			if(event.target is MovieClip && _skin.btn.contains((event.target as MovieClip)))
			{
				var manager:SpecialRingDataManager = SpecialRingDataManager.instance;
				var isCanEnter:Boolean = manager.isCanEnter();
				var isVitEnough:Boolean = _tab.viewHandle.isVitEnough();
				if(!isVitEnough)
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,isCanEnter ? StringConst.SPECIAL_RING_PANEL_0026 : StringConst.SPECIAL_RING_PANEL_0025);
					return;
				}
				if(isCanEnter)
				{
					manager.enterRingDungeon();
					PanelMediator.instance.closePanel(PanelConst.TYPE_SPECIAL_RING);
				}
				else
				{
					manager.randomRingDungeon();
				}
			}
			else if(event.target == _skin.txtWantVit)
			{
				var isOpen:Boolean = GuideSystem.instance.isUnlock(UnlockFuncId.DAILY_VIT);
				if (!isOpen)
				{
					var tip:String = GuideSystem.instance.getUnlockTip(UnlockFuncId.DAILY_VIT);
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,tip);
					return;
				}
				DailyDataManager.instance.dealSwitchPanelDaily();
			}
		}
		
		internal function destroy():void
		{
			if(_skin)
			{
				_skin.removeEventListener(MouseEvent.CLICK,onClick);
				_skin = null;
			}
			_tab = null;
		}
	}
}