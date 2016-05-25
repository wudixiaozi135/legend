package com.view.gameWindow.panel.panels.menus
{
	import com.view.gameWindow.panel.panels.menus.handlers.MenuHandler;
	
	/**
	 * @author wqhk
	 * 2014-8-15
	 */
	public class RoleHeadMenu extends MenuBase
	{
		public function RoleHeadMenu(handler:MenuHandler = null)
		{
			super(handler);
		}
		
		override protected function initSkin():void
		{
			_skin = new McRoleHeadMenu();
		}
		
		public function setItem():void
		{
			
		}
	}
}