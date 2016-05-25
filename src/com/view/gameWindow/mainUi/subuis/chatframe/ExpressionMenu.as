package com.view.gameWindow.mainUi.subuis.chatframe
{
	import com.view.gameWindow.panel.panels.menus.MenuBase;
	
	import flash.display.MovieClip;
	
	
	/**
	 * @author wqhk
	 * 2014-8-25
	 */
	public class ExpressionMenu extends MenuBase
	{
		private var _panel:MovieClip;
		public function ExpressionMenu(panel:MovieClip)
		{
			super();
			_panel = panel;
			_panel.x = 0;
			_panel.y = 0;
			addChild(_panel);
			isSkinLoad = false;
		}
		
		override protected function initSkin():void
		{
			_skin = _panel.exp;
		}
	}
}