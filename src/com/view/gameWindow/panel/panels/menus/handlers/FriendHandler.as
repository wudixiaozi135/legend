package com.view.gameWindow.panel.panels.menus.handlers
{
	import com.model.consts.StringConst;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.mainUi.subuis.chatframe.MessageCfg;
	import com.view.gameWindow.panel.panels.friend.ContactDataManager;
	import com.view.gameWindow.panel.panels.friend.ContactType;
	import com.view.newMir.NewMirMediator;
	
	/**
	 * 挺不好的, 有空再想想
	 * @author wqhk
	 * 2014-11-10
	 */
	public class FriendHandler extends MenuHandler
	{
		private var _sid:int;
		private var _cid:int;
		private var _name:String;
		private var _type:int;
		
		public function FriendHandler(sid:int,cid:int,name:String,type:int)
		{
			_sid = sid;
			_cid = cid;
			_name = name;
			_type = type;
			
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
				case 2:
					MenuFuncs.inviteToTeam(_sid,_cid);
					break;
				case 3:
					MenuFuncs.applyToTeam(_sid,_cid);
					break;
				case 4:
					MenuFuncs.inviteToSchool(_sid,_cid);
					break;
				case 5:
					if(_type == ContactType.LATEST)
					{
						MenuFuncs.removeLatest(_sid,_cid);
					}
					else if(_type == ContactType.FRIEND)
					{
						MenuFuncs.removeFriend(_sid,_cid);
					}
					break;
			}
		}
	}
}