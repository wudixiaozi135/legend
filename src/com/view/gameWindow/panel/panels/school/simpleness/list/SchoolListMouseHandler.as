package com.view.gameWindow.panel.panels.school.simpleness.list
{
	import com.view.gameWindow.panel.panels.menus.MenuMediator;
	import com.view.gameWindow.panel.panels.menus.SchoolItemMenu;
	import com.view.gameWindow.panel.panels.menus.handlers.SchoolItemHandler;
	import com.view.gameWindow.panel.panels.school.McListPanel;
	import com.view.gameWindow.panel.panels.school.simpleness.SchoolDataManager;
	import com.view.gameWindow.panel.panels.school.simpleness.list.item.SchoolData;
	import com.view.gameWindow.panel.panels.school.simpleness.list.item.SchoolListItem;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.events.Request;

	public class SchoolListMouseHandler
	{

		private var panel:SchoolListPanel;
		private var skin:McListPanel;
		private var itemMenu:SchoolItemMenu;
		public function SchoolListMouseHandler(panel:SchoolListPanel)
		{
			this.panel = panel;
			skin = panel.skin as McListPanel;
			skin.addEventListener(MouseEvent.CLICK,onClickFunc);
			skin.addEventListener(MouseEvent.MOUSE_OVER,onOverFunc);
			skin.txt7.addEventListener(Event.CHANGE,onRemoveText);
		}
		
		protected function onOverFunc(event:MouseEvent):void
		{
			var item:SchoolListItem=event.target.parent as SchoolListItem;
			if(item)
			{
				skin.mcMouseBuf.y=item.y-7.8;
				skin.mcMouseBuf.visible=true;
				event.stopPropagation();
			}else
			{
				skin.mcMouseBuf.visible=false;
			}
		}
		
		protected function onRemoveText(event:Event):void
		{
			skin.txt7.removeEventListener(Event.CHANGE,onRemoveText);
			skin.txt7.text="";
			skin.txt7.textColor=0xd4a480;
			skin.txt7.maxChars=14;
		}
		
		protected function onClickFunc(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			var item:SchoolListItem=event.target.parent as SchoolListItem;
			if(item)
			{
				skin.mcSelectBuf.y=item.y-7.8;
				skin.mcSelectBuf.visible=true;
				if(event.target==item.txt6)return;
				if(!itemMenu)
				{
					event.stopImmediatePropagation();
					var sch:SchoolData=item.data;
					itemMenu = new SchoolItemMenu(new SchoolItemHandler(sch));
					itemMenu.addEventListener(Event.SELECT,itemMenuSelectHandler);
					MenuMediator.instance.showMenu(itemMenu);
					
					itemMenu.x = event.stageX + 10;
					itemMenu.y = event.stageY - itemMenu.height - 10;
				}
				return;
			}
			switch(event.target)
			{
				case skin.btnUp:
					if(SchoolDataManager.getInstance().schoolListPage.prev())
					{
						panel.updateList();
						return;
					}
					break;
				case skin.btnDown:
					if(SchoolDataManager.getInstance().schoolListPage.next())
					{
						panel.updateList();
						return;
					}
					break;
				case skin.mcSeach:
					SchoolDataManager.getInstance().getSchoolListByName(skin.txt7.text);
					panel.updateList();
					return;
					break;
				case skin.btnCreate:
					SchoolDataManager.getInstance().setTabIndex(0);
					return;
					break;
			}
		}		
		
		private function itemMenuSelectHandler(e:Request):void
		{
			itemMenu.removeEventListener(Event.SELECT,itemMenuSelectHandler);
			MenuMediator.instance.hideMenu(itemMenu);
			itemMenu = null;
		}
		
		public function destroy():void
		{
			if(itemMenu)
			{
				itemMenu.removeEventListener(Event.SELECT,itemMenuSelectHandler);
				MenuMediator.instance.hideMenu(itemMenu);
			}
			itemMenu = null;
			skin.removeEventListener(MouseEvent.MOUSE_OVER,onOverFunc);
			skin.removeEventListener(MouseEvent.CLICK,onClickFunc);
			skin.txt7.removeEventListener(Event.CHANGE,onRemoveText);
		}
	}
}