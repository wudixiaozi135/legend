package com.view.gameWindow.panel.panels.team.data
{
    import com.view.gameWindow.scene.entity.entityItem.Player;
    import com.view.gameWindow.scene.entity.entityItem.interf.IPlayer;

    /**
     * Created by Administrator on 2015/1/6.
     * 组队所需要的玩家部分数据
     */
    public class PlayerInfoVo
    {
        public var vip:int;
        public var teamStatus:int;
        public var entityName:String;
        public var reincarn:int;
        public var level:int;
        public var job:int;
        public var teamMemberCount:int;
        public var familyId:int;
        public var familyName:String;
        public var cid:int;
        public var sid:int;

        public function PlayerInfoVo(player:IPlayer)
        {
            cid = player.cid;
            sid = player.sid;
            vip = player.vip;
            teamStatus = player.teamStatus;
            entityName = (player as Player).entityName;
            reincarn = player.reincarn;
            level = player.level;
            job = player.job;
            teamMemberCount = player.teamMemberCount;
            familyId = player.familyId;
            familyName = player.familyName;
        }

        public function destory():void
        {
            entityName = null;
            familyName = null;
        }
    }
}
