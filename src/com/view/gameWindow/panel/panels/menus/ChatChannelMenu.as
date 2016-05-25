package com.view.gameWindow.panel.panels.menus
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.mainUi.subuis.chatframe.MessageCfg;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.events.Request;
	
	
	/**
	 * @author wqhk
	 * 2014-8-14
	 */
	public class ChatChannelMenu extends MenuBase
	{
		public function ChatChannelMenu()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			_skin = new McChatChannelMenu();
		}
		
		private static var CFG:Array = [MessageCfg.CHANNEL_WOLD_SUPER,
										MessageCfg.CHANNEL_WOLD,
										MessageCfg.CHANNEL_FAMILY,
										MessageCfg.CHANNEL_TEAM,
										MessageCfg.CHANNEL_PRIVATE,
										MessageCfg.CHANNEL_AREA];
		
		override protected function createSelectedData(index:int):Object
		{
			var re:int = -1;
			if(index != -1)
			{
				re = CFG[index];
			}
			
			return re;
		}
	}
}