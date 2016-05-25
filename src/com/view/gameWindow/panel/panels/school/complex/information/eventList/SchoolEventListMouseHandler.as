package com.view.gameWindow.panel.panels.school.complex.information.eventList
{
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.school.complex.SchoolElseDataManager;
	import com.view.gameWindow.panel.panels.school.complex.information.eventList.item.SchoolEventListItem;
	
	import flash.events.MouseEvent;

	public class SchoolEventListMouseHandler	{

		private var panel:SchoolEventListPanel;
		private var skin:McEventPanel;
//		private var itemMenu:SchoolItemMenu;
		public function SchoolEventListMouseHandler(panel:SchoolEventListPanel)
		{
			this.panel = panel;
			skin = panel.skin as McEventPanel;
			skin.addEventListener(MouseEvent.CLICK,onClickFunc);
			skin.addEventListener(MouseEvent.MOUSE_OVER,onOverFunc);
//			skin.txt7.addEventListener(Event.CHANGE,onRemoveText);
		}
		
		protected function onOverFunc(event:MouseEvent):void
		{
			var item:SchoolEventListItem=event.target.parent as SchoolEventListItem;
			if(item)
			{
				skin.mcMouseBuf.y=item.y-3.35;
				skin.mcMouseBuf.visible=true;
				event.stopPropagation();
			}else
			{
				skin.mcMouseBuf.visible=false;
			}
		}
		
//		protected function onRemoveText(event:Event):void
//		{
//			skin.txt7.removeEventListener(Event.CHANGE,onRemoveText);
//			skin.txt7.text="";
//			skin.txt7.textColor=0xd4a480;
//			skin.txt7.maxChars=14;
//		}
		
		protected function onClickFunc(event:MouseEvent):void
		{
			var item:SchoolEventListItem=event.target.parent as SchoolEventListItem;
			if(item)
			{
				skin.mcSelectBuf.y=item.y-3.35;
				skin.mcSelectBuf.visible=true;
//				if(event.target==item.txt6)return;
//				if(!itemMenu)
//				{
//					event.stopImmediatePropagation();
//					var sch:SchoolData=item.data;
//					itemMenu = new SchoolItemMenu(new SchoolItemHandler(sch));
//					itemMenu.addEventListener(Event.SELECT,itemMenuSelectHandler);
//					MenuMediator.instance.showMenu(itemMenu);
//					
//					itemMenu.x = event.stageX + 10;
//					itemMenu.y = event.stageY - itemMenu.height - 10;
//				}
				return;
			}
			switch(event.target)
			{
				case skin.btnUp:
					if(SchoolElseDataManager.getInstance().schoolEventListPage.prev())
					{
						panel.updateList();
						return;
					}
					break;
				case skin.btnDown:
					if(SchoolElseDataManager.getInstance().schoolEventListPage.next())
					{
						panel.updateList();
						return;
					}
					break;
				case skin.btnClose:
					PanelMediator.instance.switchPanel(PanelConst.TYPE_SCHOOL_EVENT);
					break;
			}
		}		
		
//		private function itemMenuSelectHandler(e:Request):void
//		{
//			itemMenu.removeEventListener(Event.SELECT,itemMenuSelectHandler);
//			MenuMediator.instance.hideMenu(itemMenu);
//			itemMenu = null;
//		}
		
		public function destroy():void
		{
//			if(itemMenu)
//			{
//				itemMenu.removeEventListener(Event.SELECT,itemMenuSelectHandler);
//				MenuMediator.instance.hideMenu(itemMenu);
//			}
//			itemMenu = null;
			skin.removeEventListener(MouseEvent.MOUSE_OVER,onOverFunc);
			skin.removeEventListener(MouseEvent.CLICK,onClickFunc);
//			skin.txt7.removeEventListener(Event.CHANGE,onRemoveText);
		}
	}
}