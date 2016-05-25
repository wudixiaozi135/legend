package com.view.gameWindow.panel.panels.rank.position
{
	import com.view.gameWindow.panel.panels.menus.MenuMediator;
	import com.view.gameWindow.panel.panels.menus.RoleMenu;
	import com.view.gameWindow.panel.panels.menus.handlers.ChatHandler;
	import com.view.gameWindow.panel.panels.position.PositionPanel;
	import com.view.gameWindow.panel.panels.rank.RankDataManager;
	import com.view.gameWindow.panel.panels.rank.data.RankMemberData;
	import com.view.gameWindow.panel.panels.rank.position.item.McItem;
	import com.view.gameWindow.panel.panels.rank.position.item.PositionListItem;
	import com.view.gameWindow.util.PageUtil;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.events.Request;

	public class PositionListMouseHandler
	{
		private var panel:PositionListPanel;
		private var skin:McPositionlPanel;
		private var roleMenu:RoleMenu;

		public function PositionListMouseHandler(panel:PositionListPanel)
		{
			this.panel = panel;
			skin = panel.skin as McPositionlPanel;
			skin.addEventListener(MouseEvent.CLICK,onClickFunc);
			skin.addEventListener(MouseEvent.MOUSE_OVER,onOverFunc);
		}
		
		protected function onOverFunc(event:MouseEvent):void
		{
			var item:McItem=event.target.parent as McItem;
			if(item)
			{
				skin.mcMouseBuf.y=item.y-7;
				skin.mcMouseBuf.visible=true;
				event.stopPropagation();
			}else
			{
				skin.mcMouseBuf.visible=false;
			}
		}
		
		
		protected function onClickFunc(event:MouseEvent):void
		{
			var item:PositionListItem=event.target.parent as PositionListItem;
			var page:PageUtil = panel.page;
			if(item)
			{
				skin.mcSelectBuf.y=item.y-7;
				skin.mcSelectBuf.visible=true;
				if(!roleMenu)
				{
					event.stopImmediatePropagation();
					var data:RankMemberData=item.data;
					roleMenu = new RoleMenu(new ChatHandler(data));
					roleMenu.addEventListener(Event.SELECT,roleMenuSelectHandler);
					MenuMediator.instance.showMenu(roleMenu);
					
					roleMenu.x = event.stageX + 10;
					roleMenu.y = event.stageY +10;
				}
				return;
			}
			switch(event.target)
			{
				case skin.btnUp:
					if(page.setPrevPage())
					{
						var rankType:Number = RankDataManager.selectIndex+1;
						RankDataManager.getInstance().queryRankList(rankType,page.getPageStar(),page.getPageEnd());
						return;
					}
					break;
				case skin.btnDown:
					if(page.setNextPage())
					{
						var rankType1:Number = RankDataManager.selectIndex+1;
						RankDataManager.getInstance().queryRankList(rankType1,page.getPageStar(),page.getPageEnd());
						return;
					}
					break;
			}
		}	
		
		private function roleMenuSelectHandler(e:Request):void
		{
			roleMenu.removeEventListener(Event.SELECT,roleMenuSelectHandler);
			MenuMediator.instance.hideMenu(roleMenu);
			roleMenu = null;
		}
		
		public function destroy():void
		{
			if(roleMenu)
			{
				roleMenu.removeEventListener(Event.SELECT,roleMenuSelectHandler);
				MenuMediator.instance.hideMenu(roleMenu);
			}
			roleMenu = null;
			skin.removeEventListener(MouseEvent.MOUSE_OVER,onOverFunc);
			skin.removeEventListener(MouseEvent.CLICK,onClickFunc);
		}
	}
}