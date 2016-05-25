package com.view.gameWindow.panel.panels.menus.handlers
{
	
	import com.view.gameWindow.panel.panels.menus.MenuMediator;
	import com.view.gameWindow.panel.panels.menus.RoleMenu;
	import com.view.selectRole.SelectRoleDataManager;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.events.Request;

	/**
	 * 弹出角色菜单处理类
	 * @author Administrator
	 */	
	public class RoleMenuHandle
	{
		private var _roleMenu:RoleMenu;
		
		public function RoleMenuHandle()
		{
			
		}
		
		public function onClick(event:MouseEvent,cid:int,sid:int,name:String):void
		{
			if(SelectRoleDataManager.getInstance().isSelf(cid,sid))
			{
				return;
			}
			
			var object:Object = new Object();
			object.cid = cid;
			object.sid = sid;
			object.name = name;
			_roleMenu = new RoleMenu(new ChatHandler(object));
			_roleMenu.addEventListener(Event.SELECT,roleMenuSelectHandler);
			MenuMediator.instance.showMenu(_roleMenu);
			
			_roleMenu.x = event.stageX + 10;
			_roleMenu.y = event.stageY - _roleMenu.height - 10;
		}
		
		private function roleMenuSelectHandler(e:Request):void
		{
			_roleMenu.removeEventListener(Event.SELECT,roleMenuSelectHandler);
			MenuMediator.instance.hideMenu(_roleMenu);
			_roleMenu = null;
		}
	}
}