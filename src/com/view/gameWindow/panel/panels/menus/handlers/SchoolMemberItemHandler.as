package com.view.gameWindow.panel.panels.menus.handlers
{
	import com.view.gameWindow.panel.panels.friend.ContactDataManager;
	import com.view.gameWindow.panel.panels.school.complex.member.SchoolMemberData;

	public class SchoolMemberItemHandler extends MenuHandler
	{

		private var _data:SchoolMemberData;
		public function SchoolMemberItemHandler(data:SchoolMemberData)
		{
			super();
			this._data = data;
		}
		
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
			}
		}
	}
}