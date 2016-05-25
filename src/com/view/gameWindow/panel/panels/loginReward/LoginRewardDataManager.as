package com.view.gameWindow.panel.panels.loginReward
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
    import com.model.business.gameService.serverMessageManager.subManages.SuccessMessageManager;
    import com.model.business.gameService.socketManager.ClientSocketManager;
    import com.model.configData.ConfigDataManager;
    import com.model.consts.StringConst;
    import com.model.dataManager.DataManagerBase;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
    import com.view.gameWindow.tips.rollTip.RollTipMediator;
    import com.view.gameWindow.tips.rollTip.RollTipType;
    import com.view.gameWindow.util.UtilItemParse;

    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    import flash.utils.Endian;

    /**
     * Created by Administrator on 2015/2/26.
     */
    public class LoginRewardDataManager extends DataManagerBase
    {
        public static var currentPage:int = 1;
        public static var totalPage:int = 3;
        public static var pageNum:int = 5;//一页四个
        public static const totalDays:int = 15;//总天数

        public static var selectDay:int = 0;

        public static var flagDay:int = 0;//标志第一个可以领取的天数   (-1全部领取完毕)
        public static const openLevel:int = 40;//开放等级


        public var loginDays:int = 0;//登陆天数
        public var getCount:int = 0;
        //已经领取次数

        public var dayRecords:Array = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1];
        //记录服务端领取奖励的天数、0未领取 1已领取 -1 未达到条件
        public function LoginRewardDataManager()
        {
            super();
            SuccessMessageManager.getInstance().register(GameServiceConstants.CM_FIFTEEN_REWARD_GET, this);
            DistributionManager.getInstance().register(GameServiceConstants.SM_FIFTEEN_REWARD_GET, this);
        }

        override public function resolveData(proc:int, data:ByteArray):void
        {
            switch (proc)
            {
                case GameServiceConstants.SM_FIFTEEN_REWARD_GET:
                    handlerSM_FIFTEEN_REWARD_GET(data);
                    break;
                case GameServiceConstants.CM_FIFTEEN_REWARD_GET:
                    RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.LOGIN_REWARD_TIP_001);
                    break;
            }
            super.resolveData(proc, data);
        }

        private function handlerSM_FIFTEEN_REWARD_GET(data:ByteArray):void
        {
            loginDays = data.readInt();
            loginDays = loginDays >= totalDays ? totalDays : loginDays;//累计天数不能多于15天
            getCount = data.readInt();

            var binaryStr:String = getCount.toString(2);
            binaryStr = binaryStr.split("").reverse().join("");
            for (var i:int = 0; i < totalDays; i++)
            {
                if (i < binaryStr.length)
                {
                    dayRecords[i] = parseInt(binaryStr.charAt(i));
                    continue;
                }
                if (i < loginDays)
                {
                    dayRecords[i] = 0;
                }
            }
            binaryStr = null;
            var index:int = dayRecords.indexOf(0);
            if (index != -1)
            {
                LoginRewardDataManager.flagDay = index + 1;
            } else
            {
                index = dayRecords.indexOf(-1);
                if (index != -1)
                {
                    LoginRewardDataManager.flagDay = index + 1;
                } else
                {
                    LoginRewardDataManager.flagDay = -1;//全部领取完毕
                }
            }
//            trace("recorder: >>  " + dayRecords);
        }

        public function checkHasReward():Boolean
        {
            return dayRecords.indexOf(0) != -1;
        }

        public function dealPanel():void
        {
            var panel:PanelLoginReward = PanelMediator.instance.openedPanel(PanelConst.TYPE_LOGIN_REWARD_PANEL) as PanelLoginReward;
            if (panel)
            {
                PanelMediator.instance.closePanel(PanelConst.TYPE_LOGIN_REWARD_PANEL);
            } else
            {
                PanelMediator.instance.openPanel(PanelConst.TYPE_LOGIN_REWARD_PANEL);
            }
        }

        public function getTotalRewards():Array
        {
            var rewards:Array = [];
            var dic:Dictionary = ConfigDataManager.instance.loginReward();
            for (var key:String in dic)
            {
                rewards.push(getReward(int(key)));
            }
            return rewards;
        }

        public function getReward(day:int):Array
        {
            var rewardStr:String = ConfigDataManager.instance.loginRewardCfg(day).show_reward;
            var arr:Array = rewardStr.split("|");
            var item:Array;
            var job:int = RoleDataManager.instance.job;
            var sex:int = RoleDataManager.instance.sex;
            var temp:Array = [];
            for (var i:int = 0, len:int = arr.length; i < len; i++)
            {
                item = UtilItemParse.getLoginReward(arr[i]);
                if ((item[3] != 0 && item[3] != job) || (item[4] != 0 && item[4] != sex))
                {
                    continue;
                }
                temp.push(item);
            }
            return temp;
        }

        public function sendCM_FIFTEEN_REWARD_GET(day:int):void
        {
            var byte:ByteArray = new ByteArray();
            byte.endian = Endian.LITTLE_ENDIAN;
            byte.writeByte(day);
            ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_FIFTEEN_REWARD_GET, byte);
            byte = null;
        }

        override public function clearDataManager():void
        {
            _instance = null;
        }

        private static var _instance:LoginRewardDataManager = null;
        public static function get instance():LoginRewardDataManager
        {
            if (_instance == null)
            {
                _instance = new LoginRewardDataManager();
            }
            return _instance;
        }
    }
}
