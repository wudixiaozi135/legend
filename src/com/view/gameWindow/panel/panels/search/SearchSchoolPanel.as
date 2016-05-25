package com.view.gameWindow.panel.panels.search
{
	import com.model.consts.StringConst;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.panels.friend.ContactDataManager;
	import com.view.gameWindow.panel.panels.friend.ContactType;
	import com.view.gameWindow.panel.panels.menus.handlers.MenuFuncs;
	import com.view.gameWindow.panel.panels.school.complex.SchoolElseDataManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	
	import flash.events.MouseEvent;
	
	/**
	 * @author wqhk
	 * 2014-11-11
	 */
	public class SearchSchoolPanel extends SearchPanel
	{
		public function SearchSchoolPanel()
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
			_mc.btnLabel2.text = "发送邀请";
			_mc.btnLabel2.mouseEnabled = false;
			
			_name = PanelConst.TYPE_SEARCH_FOR_SCHOOL;
		}
		
		override protected function clickHandler(e:MouseEvent):void
		{
			super.clickHandler(e);
			if(e.target == _mc.btn2)
			{
				if(_list.selectedIndex>=0)
				{
					var data:Object = _list.selectedItem;
					if(data.lv<40)
					{
						Alert.warning(StringConst.SCHOOL_PANEL_5021);
						return;
					}
					Alert.message(StringConst.SCHOOL_PANEL_5010);
					SchoolElseDataManager.getInstance().sendInviteAction(data.roleId,data.serverId);
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