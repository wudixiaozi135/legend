package com.view.gameWindow.panel.panels.specialRing.dungeon
{
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
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
			var mc:MovieClip = event.target as MovieClip;
			if(mc && _skin.btn.contains(mc))
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