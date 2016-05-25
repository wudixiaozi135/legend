package com.view.gameWindow.panel.panels.daily.taskdungeon
{
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;

	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	/**
	 * 任务副本页鼠标相关处理类
	 * @author Administrator
	 */
	internal class TabDailyTaskDgnMouseHandle
	{
		private var _tab:TabDailyTaskDgn;
		private var _skin:McDailyTaskDungeon1;
		
		public function TabDailyTaskDgnMouseHandle(tab:TabDailyTaskDgn)
		{
			_tab = tab;
			_skin = _tab.skin as McDailyTaskDungeon1;
			init();
		}
		
		private function init():void
		{
			_skin.addEventListener(MouseEvent.CLICK,onClick);
			_skin.addEventListener(MouseEvent.ROLL_OVER,onOver,true);
			_skin.addEventListener(MouseEvent.ROLL_OUT,onOut,true);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			switch(event.target)
			{
				default:
					dealItemBtn(event);
					break;
				case _skin.btnLeft:
					dealLeft();
					break;
				case _skin.btnRight:
					dealRight();
					break;
			}
		}
		
		private function dealItemBtn(event:MouseEvent):void
		{
			if (RoleDataManager.instance.stallStatue)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.STALL_PANEL_0019);
				return;
			}
			var btn:MovieClip = event.target as MovieClip;
			if(!btn)
			{
				return;
			}
			var item:TabDailyTaskDgnItem = btn.dgnItem as TabDailyTaskDgnItem;
			if(!item)
			{
				return;
			}
			item.onClick(btn);
		}
		
		private function dealLeft():void
		{
			var page:int = _tab.viewHandle.page;
			if(page > 1)
			{
				page--;
				_tab.viewHandle.page = page;
				_tab.viewHandle.refresh();
			}
		}
		
		private function dealRight():void
		{
			var page:int = _tab.viewHandle.page;
			var totalPage:int = _tab.viewHandle.totalPage;
			if(page < totalPage)
			{
				page++;
				_tab.viewHandle.page = page;
				_tab.viewHandle.refresh();
			}
		}
		
		protected function onOver(event:MouseEvent):void
		{
			/*trace("TabDailyTaskDgnMouseHandle.onOver"+event.target);*/
			var mc:MovieClip = event.target as MovieClip;
			if(!mc)
			{
				return;
			}
			/*trace("TabDailyTaskDgnMouseHandle.onOver"+mc.dgnItem);*/
			var item:TabDailyTaskDgnItem = mc.dgnItem as TabDailyTaskDgnItem;
			if(!item)
			{
				return;
			}
			item.onOverOut(true);
		}
		
		protected function onOut(event:MouseEvent):void
		{
			/*trace("TabDailyTaskDgnMouseHandle.onOut"+event.target);*/
			var mc:MovieClip = event.target as MovieClip;
			if(!mc)
			{
				return;
			}
			var item:TabDailyTaskDgnItem = mc.dgnItem as TabDailyTaskDgnItem;
			if(!item)
			{
				return;
			}
			if(item.isMouseOn())
			{
				return;
			}
			item.onOverOut(false);
		}
		
		internal function destroy():void
		{
			_skin.removeEventListener(MouseEvent.ROLL_OUT,onOut,true);
			_skin.removeEventListener(MouseEvent.ROLL_OVER,onOver,true);
			_skin.removeEventListener(MouseEvent.CLICK,onClick);
			_skin = null;
			_tab = null;
		}
	}
}