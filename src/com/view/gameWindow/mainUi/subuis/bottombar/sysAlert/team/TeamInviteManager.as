package com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.team
{
    import com.view.gameWindow.mainUi.subuis.bottombar.teamHint.data.InviteJoin;

    /**
     * Created by Administrator on 2014/12/19.
     * 管理交易请求
     */
    public class TeamInviteManager
    {
        private var _requestDataVec:Vector.<InviteJoin>;

        public function TeamInviteManager()
        {
            _requestDataVec = new Vector.<InviteJoin>();
        }

        /**添加一项请求*/
        public function addInviteBuildTeamData(data:InviteJoin):void
        {
            if (exist(data)) return;
            _requestDataVec.push(data);

        }

        public function exist(data:InviteJoin):Boolean
        {
            for each(var it:InviteJoin in _requestDataVec)
            {
                if (data == it)
                {
                    return true;
                }
            }
            return false;
        }

        public function getLastData():InviteJoin
        {
            return size ? _requestDataVec[size - 1] : null;
        }

        public function deleteLastData():void
        {
            var data:InviteJoin = getLastData();
            if (data)
            {
                var index:int = 0;
                for (var i:int = 0, len:int = size; i < len; i++)
                {
                    if (_requestDataVec[i] == data)
                    {
                        index = i;
                        break;
                    }
                }
                _requestDataVec.splice(index, 1);
            }
        }

        public function get size():int
        {
            return _requestDataVec ? _requestDataVec.length : 0;
        }

        private static var _instance:TeamInviteManager = null;
        public static function get instance():TeamInviteManager
        {
            if (_instance == null)
            {
                _instance = new TeamInviteManager();
            }
            return _instance;
        }
    }
}
