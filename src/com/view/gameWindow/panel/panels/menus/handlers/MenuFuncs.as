package com.view.gameWindow.panel.panels.menus.handlers
{
    import com.view.gameWindow.mainUi.subuis.chatframe.MessageCfg;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panels.friend.ContactDataManager;
    import com.view.gameWindow.panel.panels.friend.ContactType;
    import com.view.gameWindow.panel.panels.roleProperty.otherRole.IOtherRolePanel;
    import com.view.gameWindow.panel.panels.roleProperty.otherRole.OtherPlayerDataManager;
    import com.view.gameWindow.panel.panels.school.simpleness.SchoolDataManager;
    import com.view.gameWindow.panel.panels.team.TeamDataManager;
    import com.view.gameWindow.panel.panels.trade.TradeDataManager;
    import com.view.newMir.NewMirMediator;

    /**
	 * @author wqhk
	 * 2014-11-12
	 */
	public class MenuFuncs
	{
		public static function toPrivateTalk(sid:int, cid:int, name:String):void
		{
			var dataMgr:ContactDataManager = ContactDataManager.instance;

			if (dataMgr.checkSelf(sid, cid))
			{
				return;
			}

			NewMirMediator.getInstance().gameWindow.mainUiMediator.chatFrame.setInputFocus();
			NewMirMediator.getInstance().gameWindow.mainUiMediator.chatFrame.changeInputChannel(MessageCfg.CHANNEL_PRIVATE);
			NewMirMediator.getInstance().gameWindow.mainUiMediator.chatFrame.input.setPrivateTarget({sid: sid, cid: cid, name: name});
		}

		public static function dealLook(sid:int, cid:int):void
		{
			OtherPlayerDataManager.instance.sendData(cid, sid);
			PanelMediator.instance.openPanel(PanelConst.TYPE_OTHER_PLAYER);
			var IPanel:IOtherRolePanel = PanelMediator.instance.openedPanel(PanelConst.TYPE_OTHER_PLAYER) as IOtherRolePanel;
			IPanel.cid = cid;
			IPanel.sid = sid;
		}

		public static function removeEnemy(sid:int, cid:int):void
		{
			var dataMgr:ContactDataManager = ContactDataManager.instance;
			dataMgr.requestRemoveContact(sid, cid, ContactType.ENEMY);
		}

		public static function inviteToSchool(sid:int, cid:int):void
		{
			SchoolDataManager.getInstance().inviteSchoolRequest(cid, sid);
		}

        /**自己不是队长邀请组队，自己是队长邀请他人加入自己的队伍*/
		public static function inviteToTeam(sid:int, cid:int):void
		{
            if (TeamDataManager.instance.isHeader)
            {
                TeamDataManager.instance.inviteJoinTeam(cid, sid);
            } else
            {
                TeamDataManager.instance.inviteBuildTeam(cid, sid);
            }
		}

		public static function applyToTeam(sid:int, cid:int):void
		{
			TeamDataManager.instance.applyJoinTeam(cid, sid);
		}

		public static function addFriend(sid:int, cid:int):void
		{
			var dataMgr:ContactDataManager = ContactDataManager.instance;

			if (dataMgr.checkSelf(sid, cid))
			{
				return;
			}

			if (!dataMgr.checkInList(sid, cid))
			{
				dataMgr.requestAddContact(sid, cid, ContactType.FRIEND)
			}
		}

		public static function removeFriend(sid:int, cid:int):void
		{
			var dataMgr:ContactDataManager = ContactDataManager.instance;
			dataMgr.requestRemoveContact(sid, cid, ContactType.FRIEND)
		}

		public static function removeBlack(sid:int, cid:int):void
		{
			var dataMgr:ContactDataManager = ContactDataManager.instance;
			dataMgr.requestRemoveContact(sid, cid, ContactType.BLACK)
		}

		public static function addBlack(sid:int, cid:int):void
		{
			var dataMgr:ContactDataManager = ContactDataManager.instance;

			if (dataMgr.checkSelf(sid, cid))
			{
				return;
			}

			if (!dataMgr.checkInList(sid, cid))
			{
				dataMgr.requestAddContact(sid, cid, ContactType.BLACK)
			}
		}

		public static function addLatest(sid:int, cid:int):void
		{
			var dataMgr:ContactDataManager = ContactDataManager.instance;
			dataMgr.requestAddContact(sid, cid, ContactType.LATEST);
		}

		public static function removeLatest(sid:int, cid:int):void
		{
			var dataMgr:ContactDataManager = ContactDataManager.instance;
			dataMgr.requestRemoveContact(sid, cid, ContactType.LATEST)
		}

		public static function trade(sid:int, cid:int):void
		{
			TradeDataManager.instance.sendTradeQuest(cid, sid);
		}
	}
}