package com.view.gameWindow.panel.panels.menus.handlers
{
	
	
	/**
	 * @author wqhk
	 * 2014-11-11
	 */
	public class BlackHandler extends MenuHandler
	{
		private var _sid:int;
		private var _cid:int;
		private var _name:String;
		public function BlackHandler(sid:int,cid:int,name:String)
		{
			_sid = sid;
			_cid = cid;
			_name = name;
			super();
		}
		
		override public function selected(index:int):void
		{
			switch(index)
			{
				case 0:
					MenuFuncs.dealLook(_sid,_cid);
					break;
				case 1:
					MenuFuncs.removeBlack(_sid,_cid);
					break;
			}
		}
	}
}