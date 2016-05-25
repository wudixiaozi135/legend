package com.view.gameWindow.panel.panels.menus.handlers
{
	import com.view.gameWindow.panel.panels.friend.ContactDataManager;
	import com.view.gameWindow.panel.panels.school.simpleness.SchoolDataManager;
	import com.view.gameWindow.panel.panels.team.TeamDataManager;

	/**
	 * @author wqhk
	 * 2014-11-10
	 */
	public class ChatHandler extends MenuHandler
	{
		public function ChatHandler(data:Object)
		{
			_data = data;
			super();
		}

		private var _data:Object;
		
		override public function selected(index:int):void
		{
			var dataMgr:ContactDataManager = ContactDataManager.instance;
			switch(index)
			{
				case 0:
					MenuFuncs.toPrivateTalk(_data.sid,_data.cid,_data.name);
					break;
				case 1:
					MenuFuncs.dealLook(_data.sid,_data.cid);
					break;
				case 2:
					MenuFuncs.addFriend(_data.sid,_data.cid);
					break;
				case 3:
					MenuFuncs.inviteToTeam(_data.sid,_data.cid);
//					buildTeam();
					break;
				case 4:
					MenuFuncs.applyToTeam(_data.sid,_data.cid);
					break;
				case 5:
//					invite(_data.sid,_data.cid);
					MenuFuncs.inviteToSchool(_data.sid,_data.cid);
					break;
				case 6:
					MenuFuncs.addBlack(_data.sid,_data.cid);
					break;
			}
		}
		
//		private function invite(sid:int,cid:int):void
//		{
//			SchoolDataManager.getInstance().inviteSchoolRequest(cid,sid);
//		}
		
//		private function buildTeam():void
//		{
//			if (_data) {
//				var cid:int = parseInt(_data.cid);
//				var sid:int = parseInt(_data.sid);
//				TeamDataManager.instance.inviteBuildTeam(cid, sid);
//			}
//		}
	}
}