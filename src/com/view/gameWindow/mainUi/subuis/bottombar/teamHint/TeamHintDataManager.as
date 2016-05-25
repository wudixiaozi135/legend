package com.view.gameWindow.mainUi.subuis.bottombar.teamHint
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
    import com.model.consts.StringConst;
    import com.model.dataManager.DataManagerBase;
    import com.view.gameWindow.mainUi.subuis.bottombar.teamHint.data.ApplyData;
    import com.view.gameWindow.mainUi.subuis.bottombar.teamHint.data.InviteData;
    import com.view.gameWindow.mainUi.subuis.bottombar.teamHint.data.InviteJoin;
    import com.view.gameWindow.mainUi.subuis.bottombar.teamHint.data.LeaderData;
    import com.view.gameWindow.tips.rollTip.RollTipMediator;
    import com.view.gameWindow.tips.rollTip.RollTipType;

    import flash.utils.ByteArray;

    import mx.utils.StringUtil;

    /**
 * Created by Administrator on 2014/11/8.
 */
public class TeamHintDataManager extends DataManagerBase
{
    private var _dataInvite:InviteData;//邀请组队
    private var _dataLeader:LeaderData;//设置队长
    private var _dataApply:ApplyData;//申请加入
    private var _dataInviteJoin:InviteJoin;//邀请加入队伍

    public function TeamHintDataManager()
    {
        DistributionManager.getInstance().register(GameServiceConstants.SM_CREATE_TEAM_INVITE, this);//当对方未设置自动允许组队，向对方下发组队请求的协议
        DistributionManager.getInstance().register(GameServiceConstants.SM_SET_TEAM_LEADER_CHECK, this);//向对方下发设置队长请求
        DistributionManager.getInstance().register(GameServiceConstants.SM_TEAM_APPLY_CHECK, this);//当对方未设置自动允许进组，向对方下发入队请求
        DistributionManager.getInstance().register(GameServiceConstants.SM_TEAM_INVITE_CHECK, this);//当对方未设置自动允许组队，向对方下发邀请请求
    }


    override public function resolveData(proc:int, data:ByteArray):void
    {
        switch (proc)
        {
            default :
                break;
            case GameServiceConstants.SM_CREATE_TEAM_INVITE:
                handleCreateTeamInvite(data);
                break;
            case GameServiceConstants.SM_SET_TEAM_LEADER_CHECK:
                handleSetTeamLeader(data);
                break;
            case GameServiceConstants.SM_TEAM_APPLY_CHECK://当对方未设置自动允许进组，向对方下发入队请求
                handleApplyCheck(data);
                break;
            case GameServiceConstants.SM_TEAM_INVITE_CHECK://当对方未设置自动允许组队，向对方下发邀请请求
                handleInviteCheck(data);
                break;
        }

        super.resolveData(proc, data);
    }

    private function handleInviteCheck(data:ByteArray):void
    {
        _dataInviteJoin=new InviteJoin();
        _dataInviteJoin.cid = data.readInt();
        _dataInviteJoin.sid = data.readInt();
        _dataInviteJoin.name = data.readUTF();
        _dataInviteJoin.job = data.readByte();
        _dataInviteJoin.reincarn = data.readByte();
        _dataInviteJoin.level = data.readShort();
    }

    private function handleApplyCheck(data:ByteArray):void
    {
        _dataApply=new ApplyData();
        _dataApply.cid = data.readInt();
        _dataApply.sid = data.readInt();
        _dataApply.name = data.readUTF();
        _dataApply.job = data.readByte();
        _dataApply.reincarn = data.readByte();
        _dataApply.level = data.readShort();

    }

    private function handleSetTeamLeader(data:ByteArray):void
    {
        _dataLeader=new LeaderData();
        _dataLeader.cid = data.readInt();
        _dataLeader.sid = data.readInt();
        _dataLeader.name = data.readUTF();
        _dataLeader.job = data.readByte();
        _dataLeader.reincarn = data.readByte();
        _dataLeader.level = data.readShort();
    }

    /**处理对方未设置自动允许组队，向对方下发组队请求的协议*/
    private function handleCreateTeamInvite(data:ByteArray):void
    {
        _dataInvite = new InviteData();
        _dataInvite.cid = data.readInt();
        _dataInvite.sid = data.readInt();
        _dataInvite.name = data.readUTF();
        _dataInvite.job = data.readByte();
        _dataInvite.reincarn = data.readByte();
        _dataInvite.level = data.readShort();
        RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringUtil.substitute(StringConst.TEAM_TIP_0008, _dataInvite.name));
    }


    override public function clearDataManager():void
    {
        _instance = null;
    }

    private static var _instance:TeamHintDataManager = null;
    public static function get instance():TeamHintDataManager
    {
        if (_instance == null)
        {
            _instance = new TeamHintDataManager();
        }
        return _instance;
    }

    public function get dataInvite():InviteData
    {
        return _dataInvite;
    }

    public function get dataLeader():LeaderData
    {
        return _dataLeader;
    }

    public function get dataApply():ApplyData
    {
        return _dataApply;
    }

    public function get dataInviteJoin():InviteJoin
    {
        return _dataInviteJoin;
    }
}
}
