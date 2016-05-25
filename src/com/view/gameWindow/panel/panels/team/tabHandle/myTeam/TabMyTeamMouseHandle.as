/**
 * Created by Administrator on 2014/11/6.
 */
package com.view.gameWindow.panel.panels.team.tabHandle.myTeam
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.business.gameService.socketManager.ClientSocketManager;
    import com.model.consts.StringConst;
    import com.view.gameWindow.panel.panels.friend.ContactDataManager;
    import com.view.gameWindow.panel.panels.friend.ContactType;
    import com.view.gameWindow.panel.panels.team.TeamDataManager;
    import com.view.gameWindow.panel.panels.team.data.TeamInfoVo;
    import com.view.gameWindow.panel.panels.team.tab.McTabMySub;
    import com.view.gameWindow.panel.panels.team.tab.TabMyTeam;
    import com.view.gameWindow.tips.rollTip.RollTipMediator;
    import com.view.gameWindow.tips.rollTip.RollTipType;
    import com.view.selectRole.SelectRoleDataManager;

    import flash.events.MouseEvent;
    import flash.utils.ByteArray;
    import flash.utils.Endian;

    import mx.utils.StringUtil;

    public class TabMyTeamMouseHandle
{
    public function TabMyTeamMouseHandle(tab:TabMyTeam)
    {
        this._tabMyteam = tab;
        _skin = _tabMyteam.skin as McTabMySub;
        _skin.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
    }

    private var _tabMyteam:TabMyTeam;
    private var _skin:McTabMySub;

    public function destroy():void
    {
        if (_skin)
        {
            _skin.removeEventListener(MouseEvent.CLICK, onClick);
            _skin = null;
        }
        _tabMyteam = null;
    }

    /**设置队长请求*/
    private function sendSetLeader():void
    {
        var vo:TeamInfoVo = TeamDataManager.instance.selectTeamInfo;
        if (vo == null)
        {
            showErrorMsg(StringConst.TEAM_ERROR_00019);
            return;
        }
        if (vo.cid == TeamDataManager.instance.headerCid && vo.sid == TeamDataManager.instance.headerSid)
        {
            showErrorMsg(StringConst.TEAM_ERROR_0004);
            return;
        }
        var data:ByteArray = new ByteArray();
        data.endian = Endian.LITTLE_ENDIAN;
        var cid:int = vo.cid;
        var sid:int = vo.sid;
        data.writeInt(cid);//cid
        data.writeInt(sid);//sid
        ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_SET_TEAM_LEADER, data);
        RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringUtil.substitute(StringConst.TEAM_PANEL_00037, vo.name));
    }

    /**离开队伍*/
    private function leaveTeam():void
    {
        var data:ByteArray = new ByteArray();
        data.endian = Endian.LITTLE_ENDIAN;
        data.writeInt(SelectRoleDataManager.getInstance().selectCid);//cid
        data.writeInt(SelectRoleDataManager.getInstance().selectSid);//sid
        ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_LEAVE_TEAM, data);
    }

    /**移除队友*/
    private function removeTeamMember():void
    {
        var vo:TeamInfoVo = TeamDataManager.instance.selectTeamInfo;
        if (vo == null)
        {
            showErrorMsg(StringConst.TEAM_ERROR_00018);
            return;
        }
        if (vo.cid == TeamDataManager.instance.headerCid && vo.sid == TeamDataManager.instance.headerSid)
        {
            showErrorMsg(StringConst.TEAM_ERROR_0005);
            return;
        }
        var cid:int = TeamDataManager.instance.selectTeamInfo.cid;
        var sid:int = TeamDataManager.instance.selectTeamInfo.sid;
        var data:ByteArray = new ByteArray();
        data.endian = Endian.LITTLE_ENDIAN;
        data.writeInt(cid);//cid
        data.writeInt(sid);//sid
        ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_KICK_FROM_TEAM, data);
    }

    private function addFriend():void
    {
        var vo:TeamInfoVo = TeamDataManager.instance.selectTeamInfo;
        if (vo == null)
        {
            showErrorMsg(StringConst.TEAM_ERROR_00017);
            return;
        }
        if (vo.cid == SelectRoleDataManager.getInstance().selectCid && vo.sid == SelectRoleDataManager.getInstance().selectSid)
        {
            showErrorMsg(StringConst.TEAM_ERROR_0007);
            return;
        }
        ContactDataManager.instance.requestAddContact(vo.sid, vo.cid, ContactType.FRIEND);
    }

    /**自动允许组队*/
    private function autoAllowSetting():void
    {
        if (_skin)
        {
            var data:ByteArray = new ByteArray();
            data.endian = Endian.LITTLE_ENDIAN;
            var check1:int = int(_skin.check1.selected);
            var check2:int = int(_skin.check2.selected);
            data.writeByte(check1);
            data.writeByte(check2);
            ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_CHANGE_OTHER_SETTING, data);
        }
    }

    private function sendCreateTeam():void
    {
        var data:ByteArray = new ByteArray();
        data.endian = Endian.LITTLE_ENDIAN;
        ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_CREATE_TEAM, data);
    }

    private function showErrorMsg(msg:String):void
    {
        RollTipMediator.instance.showRollTip(RollTipType.ERROR, msg);
    }

    private function onClick(event:MouseEvent):void
    {
        switch (event.target)
        {
            default :
                break;
            case _skin.btnCreate://创建队伍
                sendCreateTeam();
                break;
            case _skin.btnAdd://添加好友
                addFriend();
                break;
            case _skin.btnRemove://移除队友
                removeTeamMember();
                break;
            case _skin.btnPromote://提升队友
                sendSetLeader();
                break;
            case _skin.btnLeave://离开队伍
                leaveTeam();
                break;
            case _skin.check1://自动允许组队
            case _skin.check2://自动允许进组
                autoAllowSetting();
                break;
        }
    }
}
}
