package com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.team
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.business.gameService.socketManager.ClientSocketManager;
    import com.model.consts.JobConst;
    import com.model.consts.StringConst;
    import com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.AlertCellBase;
    import com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.SysAlert;
    import com.view.gameWindow.mainUi.subuis.bottombar.teamHint.TeamHintDataManager;
    import com.view.gameWindow.mainUi.subuis.bottombar.teamHint.data.ApplyData;
    import com.view.gameWindow.mainUi.subuis.bottombar.teamHint.data.InviteData;
    import com.view.gameWindow.mainUi.subuis.bottombar.teamHint.data.InviteJoin;
    import com.view.gameWindow.mainUi.subuis.bottombar.teamHint.data.LeaderData;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panels.team.prompt.TeamPromptData;
    import com.view.gameWindow.tips.toolTip.TipVO;
    import com.view.gameWindow.util.HtmlUtils;

    import flash.utils.ByteArray;
    import flash.utils.Endian;

    import mx.utils.StringUtil;

    /**
     * Created by Administrator on 2015/1/27.
     * 只处理组队相关的事件
     */
    public class TeamAlertMouseHandler
    {
        private var _skin:SysAlert;

        public function TeamAlertMouseHandler(skin:SysAlert)
        {
            _skin = skin;
        }

        /**处理邀请组队*/
        public function handlerInviteBuildTeam(cell:AlertCellBase):void
        {
            var inviteBuildTeamAlert:InviteBuildTeamAlert = cell as InviteBuildTeamAlert;
            var cellId:int = cell.id;
            var requestManager:InviteBuildTeamManager = InviteBuildTeamManager.instance;
            var size:int = requestManager.size;
            if (size > 0)
            {
                var data:ByteArray = new ByteArray();
                data.endian = Endian.LITTLE_ENDIAN;
                var tipVo:TipVO = new TipVO();
                var _attachData:InviteData = requestManager.getLastData();
                TeamPromptData.TXT_LINE_1 = StringUtil.substitute(StringConst.TEAM_PANEL_00029, _attachData.name);
                TeamPromptData.TXT_LINE_2 = StringUtil.substitute(StringConst.TEAM_PANEL_00030, JobConst.jobName(_attachData.job), _attachData.level);
                TeamPromptData.TXT_LINE_3 = StringConst.TEAM_PANEL_00031;
                TeamPromptData.TXT_LINE_4 = StringConst.TEAM_PANEL_00032;
                TeamPromptData.BUTTON_TXT_1 = StringConst.TEAM_PANEL_00033;
                TeamPromptData.BUTTON_TXT_2 = StringConst.TEAM_PANEL_00034;


                tipVo.tipData = HtmlUtils.createHtmlStr(0xd4a460, StringConst.TEAM_TIP_0006);
                TeamPromptData.TIP_VO = tipVo;
                data.writeInt(_attachData.cid);
                data.writeInt(_attachData.sid);
                TeamPromptData.okFunction = function ():void
                {
                    data.writeByte(1);//同意
                    ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_CREATE_TEAM_AGREE, data);
                    PanelMediator.instance.closePanel(PanelConst.TYPE_TEAM_HINT);

                    requestManager.deleteLastData();
                    if (requestManager.size <= 0)
                    {
                        _skin.removeItemById(cellId);
                    }
                    inviteBuildTeamAlert.refreshNum(requestManager.size);
                    _attachData = null;
                };
                TeamPromptData.cancelFunction = function ():void
                {
                    data.writeByte(0);//拒绝
                    ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_CREATE_TEAM_AGREE, data);
                    PanelMediator.instance.closePanel(PanelConst.TYPE_TEAM_HINT);

                    requestManager.deleteLastData();
                    if (requestManager.size <= 0)
                    {
                        _skin.removeItemById(cellId);
                    }
                    inviteBuildTeamAlert.refreshNum(requestManager.size);
                    _attachData = null;
                };
                PanelMediator.instance.openPanel(PanelConst.TYPE_TEAM_HINT);
            } else
            {
                _skin.removeItemById(cellId);
            }
        }

        /**设置队长*/
        public function handlerSetTeamLeader(cell:AlertCellBase):void
        {
            var data:ByteArray = new ByteArray();
            data.endian = Endian.LITTLE_ENDIAN;
            var tipVo:TipVO = new TipVO();
            var _leaderData:LeaderData = TeamHintDataManager.instance.dataLeader;
            TeamPromptData.TXT_LINE_1 = StringUtil.substitute(StringConst.TEAM_PANEL_00029, _leaderData.name);
            TeamPromptData.TXT_LINE_2 = StringUtil.substitute(StringConst.TEAM_PANEL_00030, JobConst.jobName(_leaderData.job), _leaderData.level);
            TeamPromptData.TXT_LINE_3 = StringConst.TEAM_PANEL_00038;
            TeamPromptData.TXT_LINE_4 = StringConst.TEAM_PANEL_00032;

            TeamPromptData.BUTTON_TXT_1 = StringConst.TEAM_PANEL_00033;
            TeamPromptData.BUTTON_TXT_2 = StringConst.TEAM_PANEL_00034;

            TeamPromptData.okFunction = function ():void
            {
                data.writeByte(1);//同意
                ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_SET_TEAM_LEADER_AGREE, data);
                PanelMediator.instance.closePanel(PanelConst.TYPE_TEAM_HINT);
                _skin.removeItemById(cell.id);
                _leaderData = null;
            };
            TeamPromptData.cancelFunction = function ():void
            {
                data.writeByte(0);//拒绝
                ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_SET_TEAM_LEADER_AGREE, data);
                PanelMediator.instance.closePanel(PanelConst.TYPE_TEAM_HINT);
                _skin.removeItemById(cell.id);
                _leaderData = null;
            };
            PanelMediator.instance.openPanel(PanelConst.TYPE_TEAM_HINT);
        }

        public function handlerOthersApply(cell:AlertCellBase):void
        {
            var othersApplyAlert:OthersApplyAlert = cell as OthersApplyAlert;
            var cellId:int = cell.id;
            var requestManager:OthersApplyTeamManager = OthersApplyTeamManager.instance;
            var size:int = requestManager.size;
            if (size > 0)
            {
                var data:ByteArray = new ByteArray();
                data.endian = Endian.LITTLE_ENDIAN;
                var tipVo:TipVO = new TipVO();
                var _applyData:ApplyData = requestManager.getLastData();

                TeamPromptData.TXT_LINE_1 = StringUtil.substitute(StringConst.TEAM_PANEL_00029, _applyData.name);
                TeamPromptData.TXT_LINE_2 = StringUtil.substitute(StringConst.TEAM_PANEL_00030, JobConst.jobName(_applyData.job), _applyData.level);
                TeamPromptData.TXT_LINE_3 = StringConst.TEAM_PANEL_00040;
                TeamPromptData.TXT_LINE_4 = StringConst.TEAM_PANEL_00032;

                TeamPromptData.BUTTON_TXT_1 = StringConst.TEAM_PANEL_00033;
                TeamPromptData.BUTTON_TXT_2 = StringConst.TEAM_PANEL_00034;

                tipVo.tipData = HtmlUtils.createHtmlStr(0xd4a460, StringConst.TEAM_TIP_0007);
                TeamPromptData.TIP_VO = tipVo;

                data.writeInt(_applyData.cid);
                data.writeInt(_applyData.sid);
                TeamPromptData.okFunction = function ():void
                {
                    data.writeByte(1);//同意
                    ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_APPLY_INTO_TEAM_AGREE, data);
                    PanelMediator.instance.closePanel(PanelConst.TYPE_TEAM_HINT);

                    requestManager.deleteLastData();
                    if (requestManager.size <= 0)
                    {
                        _skin.removeItemById(cellId);
                    }
                    othersApplyAlert.refreshNum(requestManager.size);

                    _applyData = null;
                };
                TeamPromptData.cancelFunction = function ():void
                {
                    data.writeByte(0);//拒绝
                    ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_APPLY_INTO_TEAM_AGREE, data);
                    PanelMediator.instance.closePanel(PanelConst.TYPE_TEAM_HINT);

                    requestManager.deleteLastData();
                    if (requestManager.size <= 0)
                    {
                        _skin.removeItemById(cellId);
                    }
                    othersApplyAlert.refreshNum(requestManager.size);
                    _applyData = null;
                };
                PanelMediator.instance.openPanel(PanelConst.TYPE_TEAM_HINT);

            } else
            {
                _skin.removeItemById(cellId);
            }
        }

        public function handlerInviteOtherJoin(cell:AlertCellBase):void
        {
            var teamInviteAlert:TeamInviteAlert = cell as TeamInviteAlert;
            var cellId:int = cell.id;
            var requestManager:TeamInviteManager = TeamInviteManager.instance;
            var size:int = requestManager.size;
            if (size > 0)
            {
                var data:ByteArray = new ByteArray();
                data.endian = Endian.LITTLE_ENDIAN;
                var tipVo:TipVO = new TipVO();
                var _inviteJoinData:InviteJoin = requestManager.getLastData();

                TeamPromptData.TXT_LINE_1 = StringUtil.substitute(StringConst.TEAM_PANEL_00029, _inviteJoinData.name);
                TeamPromptData.TXT_LINE_2 = StringUtil.substitute(StringConst.TEAM_PANEL_00030, JobConst.jobName(_inviteJoinData.job), _inviteJoinData.level);
                TeamPromptData.TXT_LINE_3 = StringConst.TEAM_PANEL_00039;
                TeamPromptData.TXT_LINE_4 = StringConst.TEAM_PANEL_00032;

                TeamPromptData.BUTTON_TXT_1 = StringConst.TEAM_PANEL_00033;
                TeamPromptData.BUTTON_TXT_2 = StringConst.TEAM_PANEL_00034;

                data.writeInt(_inviteJoinData.cid);
                data.writeInt(_inviteJoinData.sid);
                TeamPromptData.okFunction = function ():void
                {
                    data.writeByte(1);//同意
                    ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_INVITE_INTO_TEAM_AGREE, data);
                    PanelMediator.instance.closePanel(PanelConst.TYPE_TEAM_HINT);
                    requestManager.deleteLastData();
                    if (requestManager.size <= 0)
                    {
                        _skin.removeItemById(cellId);
                    }
                    teamInviteAlert.refreshNum(requestManager.size);

                    _inviteJoinData = null;
                };
                TeamPromptData.cancelFunction = function ():void
                {
                    data.writeByte(0);//拒绝
                    ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_INVITE_INTO_TEAM_AGREE, data);
                    PanelMediator.instance.closePanel(PanelConst.TYPE_TEAM_HINT);

                    requestManager.deleteLastData();
                    if (requestManager.size <= 0)
                    {
                        _skin.removeItemById(cellId);
                    }
                    teamInviteAlert.refreshNum(requestManager.size);

                    _inviteJoinData = null;
                };
                PanelMediator.instance.openPanel(PanelConst.TYPE_TEAM_HINT);
            } else
            {
                _skin.removeItemById(cellId);
            }
        }
    }
}
