package com.view.gameWindow.panel.panels.menus
{
	import com.view.gameWindow.panel.panels.menus.handlers.MenuHandler;
	
	/**
	 * @author wqhk
	 * 2014-8-15
	 */
	public class SchoolItemMenu extends MenuBase
	{
		public function SchoolItemMenu(handler:MenuHandler = null)
		{
			super(handler);
		}
		
		override protected function initSkin():void
		{
			_skin = new McSchoolItemMenu();
		}
	}
}