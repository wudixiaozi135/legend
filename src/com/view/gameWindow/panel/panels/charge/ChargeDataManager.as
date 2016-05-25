package com.view.gameWindow.panel.panels.charge
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
    import com.model.business.gameService.serverMessageManager.subManages.SuccessMessageManager;
    import com.model.business.gameService.socketManager.ClientSocketManager;
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.FirstChargeRewardCfgData;
    import com.model.consts.StringConst;
    import com.model.dataManager.DataManagerBase;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panelbase.IPanelBase;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
    import com.view.gameWindow.tips.rollTip.RollTipMediator;
    import com.view.gameWindow.tips.rollTip.RollTipType;
    import com.view.gameWindow.util.UtilItemParse;

    import flash.utils.ByteArray;
    import flash.utils.Endian;

    /**
     * Created by Administrator on 2015/2/11.
     */
    public class ChargeDataManager extends DataManagerBase
    {
        //服务端下发数据
        public var alreadyChargeCount:int = 0;//已充值数量
        public var alreadyGetCount:int = 0;//已领取数量

        public function ChargeDataManager()
        {
            super();
            DistributionManager.getInstance().register(GameServiceConstants.SM_FIRST_PAY_REWARD_GET, this);
            SuccessMessageManager.getInstance().register(GameServiceConstants.CM_FIRST_PAY_REWARD_GET, this);
        }

        override public function clearDataManager():void
        {
            _instance = null;
        }

        override public function resolveData(proc:int, data:ByteArray):void
        {
            switch (proc)
            {
                case GameServiceConstants.SM_FIRST_PAY_REWARD_GET:
                    handlerSM_FIRST_PAY_REWARD_GET(data);
                    break;
                case GameServiceConstants.CM_FIRST_PAY_REWARD_GET:
                    handlerSuccess();
                    break;
                default :
                    break;
            }
            super.resolveData(proc, data);
        }

        private function handlerSuccess():void
        {
            RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.GET_REWARD_SUCCESS);
        }

        private function handlerSM_FIRST_PAY_REWARD_GET(data:ByteArray):void
        {
            alreadyChargeCount = data.readInt();
            alreadyGetCount = data.readInt();
        }

        /**领取奖励*/
        public function sendGetReward():void
        {
            var data:ByteArray = new ByteArray();
            data.endian = Endian.LITTLE_ENDIAN;
            ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_FIRST_PAY_REWARD_GET, data);
            data = null;
        }

        public function getRewardEquipArr():Array
        {
            var cfg:FirstChargeRewardCfgData = ConfigDataManager.instance.firstChargeReward(1);
            var arr:Array = cfg.option_reward.split("|");
            var temp:Array;
            var roleJob:int = RoleDataManager.instance.job;
            for (var i:int = 0, len:int = arr.length; i < len; i++)
            {
                temp = UtilItemParse.getFirstChargeReward(arr[i]);
                if (temp[3] == roleJob)
                {
                    return temp;
                }
            }
            return null;
        }

        public function getRewardItemArr():Array
        {
            var cfg:FirstChargeRewardCfgData = ConfigDataManager.instance.firstChargeReward(1);
            var arr:Array = cfg.reward.split("|");
            return arr;
        }

        public function dealPanel():void
        {
            if (alreadyGetCount > 0)
            {
                var panel:IPanelBase = PanelMediator.instance.openedPanel(PanelConst.TYPE_CHARGE_PANEL);
                if (panel)
                {
                    PanelMediator.instance.closePanel(PanelConst.TYPE_CHARGE_PANEL);
                }
                return;
            }
            PanelMediator.instance.switchPanel(PanelConst.TYPE_CHARGE_PANEL);
        }

        private static var _instance:ChargeDataManager = null;
        public static function get instance():ChargeDataManager
        {
            if (_instance == null)
            {
                _instance = new ChargeDataManager();
            }
            return _instance;
        }
    }
}
