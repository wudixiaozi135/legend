package com.view.gameWindow.panel.panels.menus
{
	import com.view.gameWindow.panel.panels.menus.handlers.MenuHandler;
	
	/**
	 * @author wqhk
	 * 2014-11-7
	 */
	public class BlackMenu extends MenuBase
	{
		public function BlackMenu(handler:MenuHandler = null)
		{
			super(handler);
		}
		
		override protected function initSkin():void
		{
			_skin = new McBlackMenu();
		}
	}
}