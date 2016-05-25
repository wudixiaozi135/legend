package com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.team
{
    import com.view.gameWindow.mainUi.subuis.bottombar.teamHint.data.ApplyData;

    /**
     * Created by Administrator on 2014/12/19.
     * 管理交易请求
     */
    public class OthersApplyTeamManager
    {
        private var _requestDataVec:Vector.<ApplyData>;

        public function OthersApplyTeamManager()
        {
            _requestDataVec = new Vector.<ApplyData>();
        }

        /**添加一项请求*/
        public function addInviteBuildTeamData(data:ApplyData):void
        {
            if (exist(data)) return;
            _requestDataVec.push(data);

        }

        public function exist(data:ApplyData):Boolean
        {
            for each(var it:ApplyData in _requestDataVec)
            {
                if (data == it)
                {
                    return true;
                }
            }
            return false;
        }

        public function getLastData():ApplyData
        {
            return size ? _requestDataVec[size - 1] : null;
        }

        public function deleteLastData():void
        {
            var data:ApplyData = getLastData();
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

        private static var _instance:OthersApplyTeamManager = null;
        public static function get instance():OthersApplyTeamManager
        {
            if (_instance == null)
            {
                _instance = new OthersApplyTeamManager();
            }
            return _instance;
        }
    }
}
