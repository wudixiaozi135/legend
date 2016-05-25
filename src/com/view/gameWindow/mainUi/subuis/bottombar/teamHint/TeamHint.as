package com.view.gameWindow.mainUi.subuis.bottombar.teamHint
{
    import com.model.business.fileService.UrlSwfLoader;
    import com.model.business.fileService.constants.ResourcePathConstants;
    import com.model.business.fileService.interf.IUrlSwfLoaderReceiver;
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.business.gameService.socketManager.ClientSocketManager;
    import com.model.consts.JobConst;
    import com.model.consts.StringConst;
    import com.view.gameWindow.mainUi.subuis.bottombar.teamHint.data.ApplyData;
    import com.view.gameWindow.mainUi.subuis.bottombar.teamHint.data.InviteData;
    import com.view.gameWindow.mainUi.subuis.bottombar.teamHint.data.InviteJoin;
    import com.view.gameWindow.mainUi.subuis.bottombar.teamHint.data.LeaderData;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panels.team.prompt.TeamPromptData;
    import com.view.gameWindow.tips.toolTip.TipVO;
    import com.view.gameWindow.util.HtmlUtils;
    import com.view.gameWindow.util.ObjectUtils;
    import com.view.gameWindow.util.UrlPic;

    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.filters.GlowFilter;
    import flash.utils.ByteArray;
    import flash.utils.Endian;

    import mx.utils.StringUtil;

    /**
 * Created by Administrator on 2014/11/8.
 * 组队提示按钮
 */
public class TeamHint extends Sprite implements IUrlSwfLoaderReceiver
{
    public function TeamHint()
    {
        buttonMode = true;
    }
    private var _urlSwfLoader:UrlSwfLoader;
    private var _urlPicLoader:UrlPic;
    private var _container:DisplayObjectContainer;

    private var _attachData:InviteData;

    public function get attachData():InviteData
    {
        return _attachData;
    }

    public function set attachData(value:InviteData):void
    {
        _attachData = value;
    }

    private var _leaderData:LeaderData;

    public function get leaderData():LeaderData
    {
        return _leaderData;
    }

    public function set leaderData(value:LeaderData):void
    {
        _leaderData = value;
    }

    private var _applyData:ApplyData;

    public function get applyData():ApplyData
    {
        return _applyData;
    }

    public function set applyData(value:ApplyData):void
    {
        _applyData = value;
    }

    private var _inviteJoinData:InviteJoin;

    public function get inviteJoinData():InviteJoin
    {
        return _inviteJoinData;
    }

    public function set inviteJoinData(value:InviteJoin):void
    {
        _inviteJoinData = value;
    }

    public function switchShow(show:Boolean):void
    {
        destroy();
        if (show == true)
        {
            setContainer(this);
        }
    }

    public function setPosition(x:Number = 0, y:Number = 0):void
    {
        this.x = x;
        this.y = y;
    }

    public function swfReceive(url:String, swf:Sprite, info:Object):void
    {

    }

    public function swfProgress(url:String, progress:Number, info:Object):void
    {
    }

    public function swfError(url:String, info:Object):void
    {
    }

    public function destroy():void
    {
        if (hasEventListener(MouseEvent.CLICK))
            removeEventListener(MouseEvent.CLICK, onClick);
        if (hasEventListener(MouseEvent.ROLL_OUT))
            removeEventListener(MouseEvent.ROLL_OUT, onRollHandler);
        if (hasEventListener(MouseEvent.ROLL_OVER))
            removeEventListener(MouseEvent.ROLL_OVER, onRollHandler);
        if (_urlSwfLoader)
        {
            _urlSwfLoader.destroy();
            _urlSwfLoader = null;
        }

        if (_urlPicLoader)
        {
            _urlPicLoader.destroy();
            _urlPicLoader = null;
        }
        if (_container)
        {
            while (_container.numChildren > 0)
            {
                _container.removeChildAt(0);
            }
            _container = null;
        }
    }

    private function setContainer(container:DisplayObjectContainer = null):void
    {
        _container = container;
        _urlPicLoader = new UrlPic(container);
        var url:String = ResourcePathConstants.IMAGE_PANEL_TEAM_LOAD + "teamTips" + ResourcePathConstants.POSTFIX_PNG;
        _urlPicLoader.load(url);
        addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        addEventListener(MouseEvent.ROLL_OVER, onRollHandler);
        addEventListener(MouseEvent.ROLL_OUT, onRollHandler);
    }

    private function onRollHandler(event:MouseEvent):void
    {
        var target:DisplayObject = event.target as DisplayObject;
        if (event.type == MouseEvent.ROLL_OUT)
        {
            ObjectUtils.clearFilter(target, GlowFilter);
        } else if (event.type == MouseEvent.ROLL_OVER)
        {
            ObjectUtils.addFilter(target, ObjectUtils.glowFilter1);
        }
    }

    private function onClick(event:MouseEvent):void
    {
        var data:ByteArray = new ByteArray();
        data.endian = Endian.LITTLE_ENDIAN;
        TeamPromptData.destroy();
        var tipVo:TipVO = new TipVO();
        if (_attachData)
        {//邀请组队
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
                switchShow(false);
                _attachData = null;
            };
            TeamPromptData.cancelFunction = function ():void
            {
                data.writeByte(0);//拒绝
                ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_CREATE_TEAM_AGREE, data);
                PanelMediator.instance.closePanel(PanelConst.TYPE_TEAM_HINT);
                switchShow(false);
                _attachData = null;
            };
            PanelMediator.instance.openPanel(PanelConst.TYPE_TEAM_HINT);
        } else if (_leaderData)
        {//设置队长
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
                switchShow(false);
                _leaderData = null;
            };
            TeamPromptData.cancelFunction = function ():void
            {
                data.writeByte(0);//拒绝
                ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_SET_TEAM_LEADER_AGREE, data);
                PanelMediator.instance.closePanel(PanelConst.TYPE_TEAM_HINT);
                switchShow(false);
                _leaderData = null;
            };
            PanelMediator.instance.openPanel(PanelConst.TYPE_TEAM_HINT);
        } else if (_applyData)
        {//申请加入
            TeamPromptData.TXT_LINE_1 = StringUtil.substitute(StringConst.TEAM_PANEL_00029, _applyData.name);
            TeamPromptData.TXT_LINE_2 = StringUtil.substitute(StringConst.TEAM_PANEL_00030, JobConst.jobName(_applyData.job), _applyData.level);
            TeamPromptData.TXT_LINE_3 = StringConst.TEAM_PANEL_00040;
            TeamPromptData.TXT_LINE_4 = StringConst.TEAM_PANEL_00032;

            TeamPromptData.BUTTON_TXT_1 = StringConst.TEAM_PANEL_00033;
            TeamPromptData.BUTTON_TXT_2 = StringConst.TEAM_PANEL_00034;

            tipVo = new TipVO();
            tipVo.tipData = HtmlUtils.createHtmlStr(0xd4a460, StringConst.TEAM_TIP_0007);
            TeamPromptData.TIP_VO = tipVo;

            data.writeInt(_applyData.cid);
            data.writeInt(_applyData.sid);
            TeamPromptData.okFunction = function ():void
            {
                data.writeByte(1);//同意
                ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_APPLY_INTO_TEAM_AGREE, data);
                PanelMediator.instance.closePanel(PanelConst.TYPE_TEAM_HINT);
                switchShow(false);
                _applyData = null;
            };
            TeamPromptData.cancelFunction = function ():void
            {
                data.writeByte(0);//拒绝
                ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_APPLY_INTO_TEAM_AGREE, data);
                PanelMediator.instance.closePanel(PanelConst.TYPE_TEAM_HINT);
                switchShow(false);
                _applyData = null;
            };
            PanelMediator.instance.openPanel(PanelConst.TYPE_TEAM_HINT);
        } else if (_inviteJoinData)
        {//邀请他人入组
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
                switchShow(false);
                _inviteJoinData = null;
            };
            TeamPromptData.cancelFunction = function ():void
            {
                data.writeByte(0);//拒绝
                ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_INVITE_INTO_TEAM_AGREE, data);
                PanelMediator.instance.closePanel(PanelConst.TYPE_TEAM_HINT);
                switchShow(false);
                _inviteJoinData = null;
            };
            PanelMediator.instance.openPanel(PanelConst.TYPE_TEAM_HINT);
        }
    }
}
}
