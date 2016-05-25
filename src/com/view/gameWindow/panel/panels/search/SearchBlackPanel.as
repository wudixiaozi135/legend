package com.view.gameWindow.panel.panels.search
{
	import com.model.consts.StringConst;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.panels.friend.ContactDataManager;
	import com.view.gameWindow.panel.panels.friend.ContactType;
	import com.view.gameWindow.panel.panels.menus.handlers.MenuFuncs;
	
	import flash.events.MouseEvent;
	
	/**
	 * @author wqhk
	 * 2014-11-11
	 */
	public class SearchBlackPanel extends SearchPanel
	{
		public function SearchBlackPanel()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			super.initSkin();
			_mc.btn0.visible = false;
			_mc.btn3.visible = false;
			
			_mc.btnLabel1.text = "查看";
			_mc.btnLabel1.mouseEnabled = false;
			_mc.btnLabel2.text = "加黑";
			_mc.btnLabel2.mouseEnabled = false;
			
			_name = PanelConst.TYPE_SEARCH_FOR_BLACK;
		}
		
		override protected function clickHandler(e:MouseEvent):void
		{
			super.clickHandler(e);
			if(e.target == _mc.btn2)
			{
				if(_list.selectedIndex>=0)
				{
					var data:Object = _list.selectedItem;
					
					var dataMgr:ContactDataManager = ContactDataManager.instance;
					
					if(!dataMgr.checkInList(data.serverId,data.roleId))
					{
						dataMgr.requestAddContact(data.serverId,data.roleId,ContactType.BLACK)
					}
					
				}
			}
			else if(e.target == _mc.btn1)
			{
				if(_list.selectedIndex>=0)
				{
					MenuFuncs.dealLook(_list.selectedItem.serverId,_list.selectedItem.roleId);
				}
			}
		}
	}
}