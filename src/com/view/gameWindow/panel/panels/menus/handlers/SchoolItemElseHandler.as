package com.view.gameWindow.panel.panels.menus.handlers
{
	import com.view.gameWindow.panel.panels.friend.ContactDataManager;
	import com.view.gameWindow.panel.panels.school.simpleness.list.item.SchoolData;

	/**
	 * @author wqhk
	 * 2014-11-10
	 */
	public class SchoolItemElseHandler extends MenuHandler
	{
		public function SchoolItemElseHandler(data:SchoolData)
		{
			_data = data;
			super();
		}

		private var _data:SchoolData;
		
		override public function selected(index:int):void
		{
			var dataMgr:ContactDataManager = ContactDataManager.instance;
			switch(index)
			{
				case 0:
					MenuFuncs.toPrivateTalk(_data.leaderSid,_data.leaderCid,_data.leaderName);
					break;
				case 1:
					MenuFuncs.dealLook(_data.leaderSid,_data.leaderCid);
					break;
				case 2:
					MenuFuncs.addFriend(_data.leaderSid,_data.leaderCid);
					break;
			}
		}
		
	}
}