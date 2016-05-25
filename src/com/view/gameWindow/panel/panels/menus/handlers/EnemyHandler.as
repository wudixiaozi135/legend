package com.view.gameWindow.panel.panels.menus.handlers
{
	import com.model.consts.StringConst;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.mainUi.subuis.chatframe.MessageCfg;
	import com.view.gameWindow.panel.panels.friend.ContactDataManager;
	import com.view.gameWindow.panel.panels.friend.ContactType;
	import com.view.newMir.NewMirMediator;
	
	/**
	 * @author wqhk
	 * 2014-11-10
	 */
	public class EnemyHandler extends MenuHandler
	{
		private var _sid:int;
		private var _cid:int;
		private var _name:String;
		
		public function EnemyHandler(sid:int,cid:int,name:String)
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
					MenuFuncs.toPrivateTalk(_sid,_cid,_name);
					break;
				case 1:
					MenuFuncs.dealLook(_sid,_cid);
					break;
				case 3:
					MenuFuncs.removeEnemy(_sid,_cid);
					break;
			}
		}
	}
}