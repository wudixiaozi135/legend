package com.view.gameWindow.panel.panels.school.complex.list
{
	import com.model.consts.StringConst;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.menus.MenuMediator;
	import com.view.gameWindow.panel.panels.menus.SchoolItemMenu;
	import com.view.gameWindow.panel.panels.menus.handlers.SchoolItemElseHandler;
	import com.view.gameWindow.panel.panels.prompt.SelectPromptBtnManager;
	import com.view.gameWindow.panel.panels.prompt.SelectPromptType;
	import com.view.gameWindow.panel.panels.school.complex.SchoolElseDataManager;
	import com.view.gameWindow.panel.panels.school.complex.list.item.SchoolListItem;
	import com.view.gameWindow.panel.panels.school.simpleness.SchoolDataManager;
	import com.view.gameWindow.panel.panels.school.simpleness.list.item.SchoolData;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.events.Request;
	import mx.utils.StringUtil;

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
			skin.txt8.addEventListener(Event.CHANGE,onRemoveText);
		}
		
		protected function onOverFunc(event:MouseEvent):void
		{
			var item:SchoolListItem=event.target.parent as SchoolListItem;
			if(item)
			{
				skin.mcMouseBuf.y=item.y-10;
				skin.mcMouseBuf.visible=true;
				event.stopPropagation();
			}else
			{
				skin.mcMouseBuf.visible=false;
			}
		}
		
		protected function onRemoveText(event:Event):void
		{
			skin.txt8.removeEventListener(Event.CHANGE,onRemoveText);
			skin.txt8.text="";
			skin.txt8.textColor=0xd4a480;
			skin.txt8.maxChars=14;
		}
		
		protected function onClickFunc(event:MouseEvent):void
		{
			var item:SchoolListItem=event.target.parent as SchoolListItem;
			if(item)
			{
				skin.mcSelectBuf.y=item.y-10;
				skin.mcSelectBuf.visible=true;
				if(event.target==item.txt7||event.target==item.txt8)return;
				if(!itemMenu)
				{
					event.stopImmediatePropagation();
					var sch:SchoolData=item.data;
					itemMenu = new SchoolItemMenu(new SchoolItemElseHandler(sch));
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
					SchoolDataManager.getInstance().getSchoolListByName(skin.txt8.text);
					panel.updateList();
					return;
					break;
				case skin.btnAuction:
					onCLickAuction();
					break;
			}
		}	
		
		private function onCLickAuction():void
		{
			var getSelect:Boolean = SelectPromptBtnManager.getSelect(SelectPromptType.SELECT_AUCTION_TICKET);
			if(getSelect)
			{
				if(BagDataManager.instance.goldUnBind<50)
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.DGN_GOALS_026);	
					return;
				}
				SchoolElseDataManager.getInstance().sendAuctionReq();
			}else
			{
				Alert.show3(StringUtil.substitute(StringConst.SCHOOL_PANEL_0123,50),yesAuction,null,selectAuction,getSelect,StringConst.PROMPT_PANEL_0033,"","",null,"left");
			}
		}
		
		private function selectAuction(boolean:Boolean):void
		{
			SelectPromptBtnManager.setSelect(SelectPromptType.SELECT_AUCTION_TICKET,boolean);
		}
		
		private function yesAuction():void
		{
			if(BagDataManager.instance.goldUnBind<50)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.DGN_GOALS_026);	
				return;
			}
			SchoolElseDataManager.getInstance().sendAuctionReq();
			RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.SCHOOL_PANEL_0124);
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
			skin.txt8.removeEventListener(Event.CHANGE,onRemoveText);
		}
	}
}