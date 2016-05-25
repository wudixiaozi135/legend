package com.view.gameWindow.panel.panels.team.tabHandle.nearPlayer
{
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.panels.team.TeamDataManager;
	import com.view.gameWindow.panel.panels.team.tab.McTabNear;
	import com.view.gameWindow.panel.panels.team.tab.TabNearPlayer;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;

	import flash.events.MouseEvent;

	/**
	 * Created by Administrator on 2014/11/10.
	 */
	public class TabNearMouseHandle
	{
		public function TabNearMouseHandle(tab:TabNearPlayer)
		{
			this._tab = tab;
			this._skin = _tab.skin as McTabNear;
			_skin.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
		}

		private var _tab:TabNearPlayer;
		private var _skin:McTabNear;

		public function destroy():void
		{
			if (_skin)
			{
				_skin.removeEventListener(MouseEvent.CLICK, onClick);
				_skin = null;
			}
			if (_tab)
			{
				_tab = null;
			}
		}

		/**入组邀请*/
		private function sendInviteJoin():void
		{
			if (_tab.viewHandle.selectPlayer)
			{
				if (TeamDataManager.instance.isHeader)
				{
					var cid:int = _tab.viewHandle.selectPlayer.cid;
					var sid:int = _tab.viewHandle.selectPlayer.sid;
					TeamDataManager.instance.inviteJoinTeam(cid, sid);
				} else
				{
					showErrorMsg(StringConst.TEAM_ERROR_00016);
				}
			} else
			{
				showErrorMsg(StringConst.TEAM_ERROR_0002);

			}
		}

		/**申请入组*/
		private function sendApply():void
		{
			if (_tab.viewHandle.selectPlayer)
			{
				var manager:TeamDataManager = TeamDataManager.instance;
				if (manager.teamInfoVec.length == TeamDataManager.TOTAL_MEMBER)
				{
					showErrorMsg(StringConst.TEAM_ERROR_0003);
					return;
				}
				var cid:int = _tab.viewHandle.selectPlayer.cid;
				var sid:int = _tab.viewHandle.selectPlayer.sid;
				TeamDataManager.instance.applyJoinTeam(cid, sid);
			}
		}

		private function refreshHandle():void
		{
			if (_tab)
			{
				_tab.viewHandle.update();
			}
		}

		/**邀请组队*/
		private function sendInvite():void
		{
			if (_tab.viewHandle.selectPlayer)
			{
				var cid:int = _tab.viewHandle.selectPlayer.cid;
				var sid:int = _tab.viewHandle.selectPlayer.sid;
				TeamDataManager.instance.inviteBuildTeam(cid, sid);
			} else
			{
				showErrorMsg(StringConst.TEAM_ERROR_0002);

			}
		}

		private function showErrorMsg(msg:String):void
		{
			RollTipMediator.instance.showRollTip(RollTipType.ERROR, msg);
		}

		private function onClick(event:MouseEvent):void
		{
			switch (event.target)
			{
				case _skin.inviteBtn://邀请组队
					sendInvite();
					break;
				case _skin.inviteJoinBtn://邀请入组
					sendInviteJoin();
					break;
				case _skin.applyBtn://申请入组
					sendApply();
					break;
				case _skin.refreshBtn:
					refreshHandle();
					break;
				case _skin.viewBtn:
					viewOtherInfo();
					break;
				default :
					break;
			}
		}

		private function viewOtherInfo():void
		{
			if (_tab.viewHandle.selectPlayer)
			{
				var cid:int = _tab.viewHandle.selectPlayer.cid;
				var sid:int = _tab.viewHandle.selectPlayer.sid;
				TeamDataManager.instance.viewOtherPlayerInfo(cid, sid);
			} else
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.TEAM_ERROR_00022);
			}
		}
	}
}
