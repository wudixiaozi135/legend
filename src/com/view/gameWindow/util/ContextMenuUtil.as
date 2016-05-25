package com.view.gameWindow.util {
	import com.model.consts.StringConst;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	public class ContextMenuUtil {

		private var display:DisplayObjectContainer;

		private var contextMenuItem1:ContextMenuItem;

		private var contextMenuItem2:ContextMenuItem;

		private var contextMenuItem3:ContextMenuItem;

		private var contextMenuItem4:ContextMenuItem;

		
		public function ContextMenuUtil(display:DisplayObjectContainer) 
		{
			this.display = display;
			initMyItems();
		}
		
		private function initMyItems():void
		{
			// TODO Auto Generated method stub
			var myContextMenu:ContextMenu = new ContextMenu();
			
			contextMenuItem1 = new ContextMenuItem(StringConst.CONTEXT_MENU_ITEM_001);
			contextMenuItem1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,onMenuSelect);
			contextMenuItem2 = new ContextMenuItem(StringConst.CONTEXT_MENU_ITEM_002);
			contextMenuItem2.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,onMenuSelect);
			contextMenuItem3 = new ContextMenuItem(StringConst.CONTEXT_MENU_ITEM_003);
			contextMenuItem3.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,onMenuSelect);
			contextMenuItem4 = new ContextMenuItem(StringConst.CONTEXT_MENU_ITEM_004);
			contextMenuItem4.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,onMenuSelect);
			
			myContextMenu.customItems.push(contextMenuItem1,contextMenuItem2,contextMenuItem3,contextMenuItem4);
			myContextMenu.hideBuiltInItems();
			display.contextMenu=myContextMenu;
		}
		
		protected function onMenuSelect(event:ContextMenuEvent):void
		{
			switch(event.currentTarget)
			{
				case contextMenuItem1:
				{
					break;
				}
				case contextMenuItem2:
				{
					break;
				}
				case contextMenuItem3:
				{
					break;
				}
				case contextMenuItem4:
				{
					break;
				}
				default:
				{
					break;
				}
			}
		}
	}
}