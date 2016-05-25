package com.view.gameWindow.panel.panels.menus
{
	import com.view.gameWindow.panel.panels.menus.handlers.MenuHandler;
	
	/**
	 * @author wqhk
	 * 2014-11-7
	 */
	public class EnemyMenu extends MenuBase
	{
		public function EnemyMenu(handler:MenuHandler = null)
		{
			super(handler);
		}
		
		override protected function initSkin():void
		{
			_skin = new McEnemyMenu();
		}
	}
}