package com.view.gameWindow.panel.panels.activitys.loongWar.tabApply
{
	import com.view.gameWindow.mainUi.subuis.activityTrace.ActivityDataManager;
	import com.view.gameWindow.panel.panels.activitys.loongWar.LoongWarDataManager;
	
	import flash.events.MouseEvent;
	import flash.text.TextField;

	internal class TabLoongWarApplyMousehandle
	{
		private var _tab:TabLoongWarApply;
		private var _skin:McLoongWarApply;
		
		public function TabLoongWarApplyMousehandle(tab:TabLoongWarApply)
		{
			_tab = tab;
			_skin = _tab.skin as McLoongWarApply;
		}
		
		public function initialize():void
		{
			_skin.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			switch(event.target)
			{
				case _skin.btnSelect:
					dealBtnSelect();
					break;
				case _skin.btnApply:
					dealBtnApply();
					break;
				default:
					dealDefault(event);
					break;
			}
		}
		
		private function dealBtnSelect():void
		{
			
		}
		
		private function dealBtnApply():void
		{
			var manager:LoongWarDataManager = ActivityDataManager.instance.loongWarDataManager;
			manager.cmFamilyLongchengApply();
		}
		
		private function dealDefault(event:MouseEvent):void
		{
			if(event.target is TextField)
			{
				var item:TabLoongWarApplyGuildItem = event.target.parent.item as TabLoongWarApplyGuildItem;
				if(item)
				{
					item.onClick();
				}
			}
		}
		
		public function destroy():void
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