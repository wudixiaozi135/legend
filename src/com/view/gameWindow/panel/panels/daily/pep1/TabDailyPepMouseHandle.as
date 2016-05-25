package com.view.gameWindow.panel.panels.daily.pep1
{
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.specialRing.SpecialRingDataManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class TabDailyPepMouseHandle
	{
		private var _tab:TabDailyPep;
		private var _skin:McDailyPep;
		
		public function TabDailyPepMouseHandle(tab:TabDailyPep)
		{
			_tab = tab;
			_skin = _tab.skin as McDailyPep;
			init();
		}
		
		private function init():void
		{
			_skin.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			var mc:MovieClip = event.target as MovieClip;
			if(mc)
			{
				var rewardItem:TabDailyPepRewardItem = mc.rewardItem as TabDailyPepRewardItem;
				if(rewardItem)
				{
					rewardItem.onClick();
					return;
				}
				var item:TabDailyPepItem = mc.pepItem as TabDailyPepItem;
				if(item)
				{
					item.onMcClick();
				}
			}
			var txt:TextField = event.target as TextField;
			if(txt)
			{
				item = _tab.viewHandle.itemsKeyTxtGet[txt] as TabDailyPepItem;
				if(item)
				{
					item.onTxtGetClick();
				}
				item = _tab.viewHandle.itemsKeyTxtNpc[txt] as TabDailyPepItem;
				if(item)
				{
					item.onTxtNpcClick();
				}
				if(txt == _skin.txtOpenVip0)
				{
					PanelMediator.instance.openPanel(PanelConst.TYPE_VIP);
				}
				else if(txt == _skin.txtRolePepGo)
				{
					SpecialRingDataManager.instance.selectTab = 1;
					PanelMediator.instance.openPanel(PanelConst.TYPE_SPECIAL_RING);
				}
				else if(txt == _skin.txtHeroPepGo)
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.PROMPT_PANEL_0007);
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