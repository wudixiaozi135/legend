package com.view.gameWindow.panel.panels.school.complex.member.auditList
{
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.menus.MenuMediator;
	import com.view.gameWindow.panel.panels.menus.SchoolItemMenu;
	import com.view.gameWindow.panel.panels.menus.handlers.SchoolMemberItemHandler;
	import com.view.gameWindow.panel.panels.school.complex.SchoolElseDataManager;
	import com.view.gameWindow.panel.panels.school.complex.member.MCAuditList;
	import com.view.gameWindow.panel.panels.school.complex.member.SchoolMemberData;
	import com.view.gameWindow.panel.panels.school.complex.member.auditList.item.SchoolAuditListItem;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.events.Request;

	public class SchoolAuditListMouseHandler	{

		private var panel:SchoolAuditListPanel;
		private var skin:MCAuditList;
		private var itemMenu:SchoolItemMenu;
		public function SchoolAuditListMouseHandler(panel:SchoolAuditListPanel)
		{
			this.panel = panel;
			skin = panel.skin as MCAuditList;
			skin.addEventListener(MouseEvent.CLICK,onClickFunc);
			skin.addEventListener(MouseEvent.MOUSE_OVER,onOverFunc);
		}
		
		protected function onOverFunc(event:MouseEvent):void
		{
			var item:SchoolAuditListItem=event.target.parent as SchoolAuditListItem;
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
		
		protected function onClickFunc(event:MouseEvent):void
		{
			var item:SchoolAuditListItem=event.target.parent as SchoolAuditListItem;
			if(item)
			{
				skin.mcSelectBuf.y=item.y-3.35;
				skin.mcSelectBuf.visible=true;
				if(event.target==item.txt5)
				{
					SchoolElseDataManager.getInstance().sendAuditResult(1,item.data.cid,item.data.sid);
					return;
				}
				if(event.target==item.txt6)
				{
					SchoolElseDataManager.getInstance().sendAuditResult(2,item.data.cid,item.data.sid);
					return;
				}
				if(!itemMenu)
				{
					event.stopImmediatePropagation();
					var sch:SchoolMemberData=item.data;
					itemMenu = new SchoolItemMenu(new SchoolMemberItemHandler(sch));
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
					if(SchoolElseDataManager.getInstance().schoolApplyListPage.prev())
					{
						panel.updatePanel();
						return;
					}
					break;
				case skin.btnDown:
					if(SchoolElseDataManager.getInstance().schoolApplyListPage.next())
					{
						panel.updatePanel();
						return;
					}
					break;
				case skin.btnClose:
					PanelMediator.instance.switchPanel(PanelConst.TYPE_SCHOOL_APPLY);
					break;
				case skin.check1:
					onCheckFunc();
					break;
			}
		}		
		
		private function onCheckFunc():void
		{
			var selected:Boolean= skin.check1.selected;
			if(selected==true)
			{
				var type:int=SchoolElseDataManager.getInstance().selectApplyType+1;
				SchoolElseDataManager.getInstance().setAutoAuditRequest(type);
			}else
			{
				SchoolElseDataManager.getInstance().setAutoAuditRequest(0);
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
		}
	}
}