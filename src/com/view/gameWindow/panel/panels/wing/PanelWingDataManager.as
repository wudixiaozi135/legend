package com.view.gameWindow.panel.panels.wing
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.business.gameService.serverMessageManager.subManages.SuccessMessageManager;
    import com.model.business.gameService.socketManager.ClientSocketManager;
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.OnlineRewardShieldCfgData;
    import com.model.consts.StringConst;
    import com.model.dataManager.DataManagerBase;
    import com.view.gameWindow.mainUi.subuis.onlineReward.OnlineRewardDataManager;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panelbase.IPanelBase;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
    import com.view.gameWindow.tips.rollTip.RollTipMediator;
    import com.view.gameWindow.tips.rollTip.RollTipType;

    import flash.utils.ByteArray;
    import flash.utils.Endian;

    import mx.utils.StringUtil;

    /**
     * Created by Administrator on 2015/3/19.
     */
    public class PanelWingDataManager extends DataManagerBase
    {
        ////
        /**天使之翼*/
        public static const WING_MIN_ID:int = 1300100;
        /**地狱流焰*/
        public static const WING_MAX_ID:int = 1300800;
        public static const WING_MAX_UPGRADE:int = 8;

        /**是否自动培养*/
        public static var isAuto:Boolean = false;

        public var nextWingId:int = -1;

        public function PanelWingDataManager()
        {
            super();
            SuccessMessageManager.getInstance().register(GameServiceConstants.CM_WING_UPGRADE, this);
        }

        override public function resolveData(proc:int, data:ByteArray):void
        {
            switch (proc)
            {
                case GameServiceConstants.CM_WING_UPGRADE:
                    handlerSuccess(data);
                    break;
                default :
                    break;
            }
            super.resolveData(proc, data);
        }

        private function handlerSuccess(data:ByteArray):void
        {
            nextWingId = data.readInt();
            RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.WING_018);
        }

        public function sendCM_WING_UPGRADE(storage:int, slot:int, useGold:int):void
        {
            var byte:ByteArray = new ByteArray();
            byte.endian = Endian.LITTLE_ENDIAN;
            byte.writeByte(storage);
            byte.writeByte(slot);
            byte.writeByte(useGold);
            ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_WING_UPGRADE, byte);
            byte = null;
        }

        public function dealPanel():void
        {
            var cfg:OnlineRewardShieldCfgData = ConfigDataManager.instance.onlineRewardShieldCfgData(OnlineRewardDataManager.WING_TYPE);
            if (RoleDataManager.instance.lv < cfg.level)
            {
                RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringUtil.substitute(StringConst.WING_017, cfg.level.toString()));
                return;
            }

            var panel:IPanelBase = PanelMediator.instance.openedPanel(PanelConst.TYPE_WING);
            if (panel)
            {
                PanelMediator.instance.closePanel(PanelConst.TYPE_WING);
            } else
            {
                PanelMediator.instance.openPanel(PanelConst.TYPE_WING);
            }
        }

        override public function clearDataManager():void
        {
            _instance = null;
        }

        private static var _instance:PanelWingDataManager = null;
        public static function get instance():PanelWingDataManager
        {
            if (_instance == null)
            {
                _instance = new PanelWingDataManager();
            }
            return _instance;
        }
    }
}
