package com.view.gameWindow.panel.panels.everydayReward
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
    import com.model.business.gameService.serverMessageManager.subManages.SuccessMessageManager;
    import com.model.business.gameService.socketManager.ClientSocketManager;
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.EveryDayRewardCfgData;
    import com.model.consts.StringConst;
    import com.model.dataManager.DataManagerBase;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.tips.rollTip.RollTipMediator;
    import com.view.gameWindow.tips.rollTip.RollTipType;

    import flash.utils.ByteArray;
    import flash.utils.Endian;

    /**
     * Created by Administrator on 2015/2/28.
     */
    public class EveryDayRewardDataManager extends DataManagerBase
    {
        public static var currentProgress:int = 0;

        public static var selectRewardIndex:int = -1;

        ///服务端
        public var pay_count:int;//充值数目
        public var get_count:int;//已经领取次数

        public function EveryDayRewardDataManager()
        {
            super();
            DistributionManager.getInstance().register(GameServiceConstants.SM_DAILY_PAY_REWARD_GET, this);
            SuccessMessageManager.getInstance().register(GameServiceConstants.CM_DAILY_PAY_REWARD_GET, this);
        }

        public function dealPanel():void
        {
            var panel:PanelEverydayReward = PanelMediator.instance.openedPanel(PanelConst.TYPE_EVERYDAY_REWARD_PANEL) as PanelEverydayReward;
            if (panel)
            {
                PanelMediator.instance.closePanel(PanelConst.TYPE_EVERYDAY_REWARD_PANEL);
            } else
            {
                PanelMediator.instance.openPanel(PanelConst.TYPE_EVERYDAY_REWARD_PANEL);
            }
        }

        override public function resolveData(proc:int, data:ByteArray):void
        {
            switch (proc)
            {
                case GameServiceConstants.SM_DAILY_PAY_REWARD_GET:
                    handlerSM_DAILY_PAY_REWARD_GET(data);
                    break;
                case GameServiceConstants.CM_DAILY_PAY_REWARD_GET:
                    RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.PANEL_EVERY_DAY_REWARD_003);
                    break;
            }
            super.resolveData(proc, data);
        }

        private function handlerSM_DAILY_PAY_REWARD_GET(data:ByteArray):void
        {
            pay_count = data.readInt();
            get_count = data.readInt();
        }

        public function sendGetReward(step:int, index:int):void
        {
            var byte:ByteArray = new ByteArray();
            byte.endian = Endian.LITTLE_ENDIAN;
            byte.writeByte(step);
            byte.writeByte(index);
            ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_DAILY_PAY_REWARD_GET, byte);
            byte = null;
        }

        /**判断今日是否已经领完*/
        public function todayHas():Boolean
        {
            var chargeCount:int = EveryDayRewardDataManager.instance.pay_count;
            var getCount:int = EveryDayRewardDataManager.instance.get_count;//已经领取的次数
            var cfg:EveryDayRewardCfgData = ConfigDataManager.instance.everydayRewardCfg(getCount + 1);
            if (!cfg)
            {
                return false;
            }
            return true;
        }

        public function checkHasReward():Boolean
        {
            var chargeCount:int = EveryDayRewardDataManager.instance.pay_count;
            var getCount:int = EveryDayRewardDataManager.instance.get_count;//已经领取的次数
            var cfg:EveryDayRewardCfgData = ConfigDataManager.instance.everydayRewardCfg(getCount + 1);
            if (!cfg)
            {
                return false;
            }
            if (cfg.pay_count > chargeCount)
            {
                return false;
            }
            return true;
        }
        
        override public function clearDataManager():void
        {
            _instance = null;
        }

        private static var _instance:EveryDayRewardDataManager = null;
        public static function get instance():EveryDayRewardDataManager
        {
            if (_instance == null)
            {
                _instance = new EveryDayRewardDataManager();
            }
            return _instance;
        }
    }
}
